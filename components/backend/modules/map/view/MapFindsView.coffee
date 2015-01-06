define [
  'cs!App'
  'marionette'
  'tpl!../templates/list-item.html'
  'i18n!../../finds/nls/language'
], (App, Marionette, Template, i18n) ->

  map = ''
  class ListItemView extends Marionette.ItemView
    template: Template
    t: i18n.attributes
    latlng: ->
      new App.google.LatLng @model.getValue('lat'), @model.getValue('lng')
    renderImage: (size) ->
      return '' unless @file
      if size? then size = 'smallPic'
      '<img src="/public/files/'+@file[size].value+ '" alt="'+@file.alt.value+'"/>'

    initialize:->
      @updateRelations()
      @file = App.Files.filter (file)=>
        file.getValue('fieldrelation') is 'teaserimage' and
        file.getValue('relation') is @model.get('_id')
      .pop()?.get 'fields'


    updateRelations:->
      @category = App.Categories.findWhere _id: @model.getValue 'category'
      @subcategory = App.Subcategories.findWhere _id: @model.getValue 'subcategory'

    modelEvents:
      "change": "updateMarker"
      "destroy": "destroyMarker"

    render: ->
      @createMarker()

    destroyMarker:->
      @marker.setMap null
      App.google.event.removeListener @listener

    updateMarker:->
      @destroyMarker()
      @createMarker()

    createMarker:->
      that = @
      @updateRelations()
      @infoWindow = new App.google.InfoWindow content: @template @model.toJSON()
      @marker = new App.google.Marker
        map: App.map
        position: @latlng()
        icon:
          strokeColor: that.category.getValue("color")
          path:App.google.SymbolPath[that.subcategory.getValue("symbol")]
          scale: parseInt(that.subcategory.getValue("size"))
      @listener = App.google.event.addListener @marker, 'click', ->
        that.infoWindow.open App.map, that.marker

  class ListView extends Marionette.CollectionView
    childView: ListItemView
