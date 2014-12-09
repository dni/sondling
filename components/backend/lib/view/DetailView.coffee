define [
  'cs!App'
  'cs!Publish'
  'cs!lib/model/Collection'
  'cs!Utils'
  'cs!Router'
  'marionette'
  'tpl!lib/templates/detail.html'
  'cs!modules/files/view/RelatedFileView'
], (App, Publish, Collection, Utils, Router, Marionette, Template, RelatedFileView) ->
  class DetailView extends Marionette.ItemView
    template: Template
    initialize:(args)->
      @model = args.model
      @notpublishable = unless args.Config.notpublishable? then false else true
      @ui = {}
      @ui[key] = "[name="+key+"]" for key, arg of @model.get "fields"
      @bindUIElements()
      @on "render", @afterRender, @

    afterRender:->
      @changePublishButton()
      @renderRelatedViews()
      @$el.find('[data-toggle=tooltip]').tooltip
        placement: 'right'
        container: 'body'

    templateHelpers: ->
      vhs: Utils.Viewhelpers
      notpublishable: @notpublishable
      Config: @options.Config
      t: @options.i18n
      checkCondition: (condition)->
        @[condition]()
      isPrint:->
        setting = App.Settings.findSetting "MagazineModule"
        setting.getValue 'print'
      getOptions:(attribute)->
        options = {}
        if attribute.collection
          App[attribute.collection].forEach (model)->
            options[model.get("_id")] = model.getValue("title")
          return options
        if attribute.setting
          setting = App.Settings.findSetting @Config.moduleName
          values = setting.getValue(attribute.setting).split(',')
          for option in values
            options[option] = option
          return options
        return attribute.options
      foreachAttribute: (fields, cb)->
        for key in @fieldorder
          cb key, fields[key]

    getValuesFromUi: ()->
      fields = @model.get "fields"
      for key, field of fields
        field.value = @ui[key].val()
        if field.type is "checkbox"
          field.value = @ui[key].prop('checked')
      return fields

    renderRelatedViews: ->
      fields = @model.get "fields"
      @RelatedViews = {}
      for key, field of fields
        if field.type is "file"
          @RelatedViews[key] = new RelatedFileView
            model: @model
            fieldrelation: key
            collection : new Collection
            multiple: field.multiple
          @RelatedViews[key].render()
          @on "close", => @RelatedViews[key].destroy()
          if @model.isNew() then @$el.find('#'+key).parent().hide().addClass('related-view')
          @$el.find('#'+key).append @RelatedViews[key].el

    events:
      "click .save": "save"
      "click .cancel": "cancel"
      "click .delete": "deleteModel"
      "click .publish-btn": "togglePublish"

    togglePublish: ->
      @model.togglePublish()
      @save()
      @changePublishButton()

    changePublishButton:->
      button = @$el.find ".publish-btn"
      button.find("span").hide()
      if @model.get("published") is true
        button.find("span.unpublish").show()
        button.removeClass "btn-success"
      else
        button.find("span.publish").show()
        button.addClass "btn-success"

    cancel: ->
      App.contentRegion.empty()
      Router.navigate @Config?.collectionName

    save: ->
      @model.set "fields", @getValuesFromUi()
      that = @
      if @model.isNew()
        App[that.options.Config.collectionName].create @model,
          wait: true
          success: (res) ->
            route = res.attributes.name+'/'+res.attributes._id
            Utils.Log that.options.i18n.newModel, 'new',
              text: res.attributes._id
              href: route
            Router.navigate route, trigger:false
      else
        Utils.Log @options.i18n.updateModel, 'update',
          text: @model.get '_id'
          href: @model.get("name")+'/'+@model.get '_id'
        @model.save()


    deleteModel: ->
      Utils.Log @options.i18n.deleteModel, 'delete', text: @model.get '_id'
      App.contentRegion.empty()
      @model.destroy
        success: ->
