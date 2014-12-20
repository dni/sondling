define [
  'cs!App'
  'marionette'
  'tpl!../templates/list-item.html'
  'googlemaps!'
], (App, Marionette, Template, g) ->

  map = ''

  class ListItemView extends Marionette.ItemView
    template: Template
    initialize:->
      @category = App.Categories.findWhere _id: @model.getValue 'category'
    render: ->
      color = @category.getValue("color")
      @infoWindow = new g.InfoWindow content: @template @model.toJSON()
      @marker = new g.Marker
        map: map
        position: @latlng()
        icon:
          strokeColor: color
          path:g.SymbolPath.CIRCLE
          scale: 4
      that = @
      g.event.addListener @marker, 'click', ->
        that.infoWindow.open map, that.marker

    latlng: ->
      new g.LatLng @model.getValue('lat'), @model.getValue('lng')

  class ListView extends Marionette.CollectionView
    childView: ListItemView
    initialize:->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition (position)->
          @pos = new g.LatLng(position.coords.latitude, position.coords.longitude)
          marker = new g.Marker
            map: map,
            position: pos,
          map.setCenter(pos)
      @$el.css
        height: '100%'
        width: '100%'
      map = new g.Map @el,
        zoom:3
        mapTypeId: g.MapTypeId.HYBRID
        disableDefaultUI: true
        center: new g.LatLng 47.397, 13.644

  return ListView
