define [
  'cs!App'
  'marionette'
  'tpl!../templates/poly-item.html'
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

    modelEvents:
      "change": "updatePolygon"
      "destroy": "destroyPolygon"

    render: ->
      @createPolygon()

    destroyPolygon:->
      @polygon?.setMap null
      App.google.event.removeListener @listener

    updatePolygon:->
      @destroyPolygon()
      @createPolygon()

    createPolygon:->
      return unless @model.getValue('polygon')
      that = @
      @updateRelations()
      @infoWindow = new App.google.InfoWindow content: @template @model.toJSON()
      paths = @model.getValue("polygon").split(";").map (point)->
        latlng = point.split(",")
        new App.google.LatLng latlng[0], latlng[1]
      @polygon = new App.google.Polygon
        paths: paths
        strokeColor: @category.getValue("color")
        strokeOpacity: 0.8
        strokeWeight: 3
        fillColor: @category.getValue("color")
        fillOpacity: 0.3
      @polygon.setMap App.map
      @listener = App.google.event.addListener @polygon, 'click', (e)->
        that.infoWindow.setPosition e.latLng
        that.infoWindow.open App.map

  class ListView extends Marionette.CollectionView
    childView: ListItemView
