define [
  'cs!App'
  'marionette'
  'cs!./MapFindsView'
  'cs!./MapFindsiteView'
  'cs!./MapTrackView'
  'tpl!../templates/map.html'
], (App, Marionette, MapFindsView, MapFindsiteView, MapTrackView, Template) ->

  App.map = ''
  class MapView extends Marionette.ItemView
    template: Template
    initialize:->
      @createMap()
      @startPositionTracking()
      @initChildren()

    createMap:->
      @$el.css
        height: '100%'
        width: '100%'
      App.map = new App.google.Map @el,
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

    startPositionTracking:->
      pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
      App.map.setCenter(pos)
      setInterval ->
        marker?.setMap null
        App.getCurrentPosition()
        pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
        marker = new App.google.Marker
          map: App.map,
          position: pos
      , 2000

    initChildren:->
      @findView = new MapFindsView collection: App.Finds
      @$el.append @findView.render().el
      @findsiteView = new MapFindsiteView collection: App.Findsites
      @$el.append @findsiteView.render().el
      @trackView = new MapTrackView collection: App.Tracks
      @$el.append @trackView.render().el

  return MapView
