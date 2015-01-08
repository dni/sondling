define [
  'cs!App'
  'marionette'
  'tpl!../templates/list-item.html'
  'i18n!../../finds/nls/language'
], (App, Marionette, Template, i18n) ->

  class ListItemView extends Marionette.ItemView
    t: i18n.attributes

    modelEvents:
      "change": "updatePolyline"
      "destroy": "destroyPolyline"

    render: ->
      @createPolyline()

    destroyPolyline:->
      @polyline.setMap null

    updatePolyline:->
      @destroyPolyline()
      @createPolyline()

    createPolyline:->
      that = @
      latlngs = @model.getValue("track").split(';').map (track)->
        latlng = track.split(',')
        new App.google.LatLng latlng[0], latlng[1]
      @polyline = new App.google.Polyline
          path: latlngs
          geodesic: true
          strokeColor: '#FF0000'
          strokeOpacity: 1.0
          strokeWeight: 2

      @polyline.setMap App.map

  class ListView extends Marionette.CollectionView
    childView: ListItemView
