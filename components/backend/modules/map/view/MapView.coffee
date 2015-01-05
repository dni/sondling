define [
  'cs!App'
  'marionette'
  'tpl!../templates/list-item.html'
], (App, Marionette, Template) ->

  map = ''
  class ListItemView extends Marionette.ItemView
    template: Template
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
      category = App.Categories.findWhere _id: @model.getValue 'category'
      subcategory = App.Subcategories.findWhere _id: @model.getValue 'subcategory'
      @infoWindow = new App.google.InfoWindow content: @template @model.toJSON()
      @marker = new App.google.Marker
        map: map
        position: @latlng()
        icon:
          strokeColor: category.getValue("color")
          path:App.google.SymbolPath[subcategory.getValue("symbol")]
          scale: parseInt(subcategory.getValue("size"))
      that = @
      @listener = App.google.event.addListener @marker, 'click', ->
        that.infoWindow.open map, that.marker
    latlng: ->
      new App.google.LatLng @model.getValue('lat'), @model.getValue('lng')

  class ListView extends Marionette.CollectionView
    childView: ListItemView
    initialize:->
      @$el.css
        height: '100%'
        width: '100%'
      map = new App.google.Map @el,
        zoom:3
        mapTypeId: App.google.MapTypeId.HYBRID
        disableDefaultUI: true
        mapTypeControl: false
        panControl: true
        panControlOptions:
          position: App.google.ControlPosition.RIGHT_BOTTOM
        zoomControl: true,
        zoomControlOptions:
          style: App.google.ZoomControlStyle.LARGE,
          position: App.google.ControlPosition.RIGHT_BOTTOM
        scaleControl: true
        scaleControlOptions:
          position: App.google.ControlPosition.RIGHT_BOTTOM
        streetViewControl: false
      pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
      map.setCenter(pos)
      setInterval ->
        marker?.setMap null
        App.getCurrentPosition()
        pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
        marker = new App.google.Marker
          map: map,
          position: pos
      , 2000

  return ListView
