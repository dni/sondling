define [
  'cs!App'
  'marionette'
  'tpl!../templates/list-item.html'
], (App, Marionette, Template) ->

  map = ''

  class ListItemView extends Marionette.ItemView
    template: Template
    initialize:->
      @category = App.Categories.findWhere _id: @model.getValue 'category'
    render: ->
      color = @category.getValue("color")
      @infoWindow = new App.google.InfoWindow content: @template @model.toJSON()
      @marker = new App.google.Marker
        map: map
        position: @latlng()
        icon:
          strokeColor: color
          path:App.google.SymbolPath.CIRCLE
          scale: 4
      that = @
      App.google.event.addListener @marker, 'click', ->
        that.infoWindow.open map, that.marker

    latlng: ->
      new App.google.LatLng @model.getValue('lat'), @model.getValue('lng')

  class ListView extends Marionette.CollectionView
    childView: ListItemView
    initialize:->
      pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
      @$el.css
        height: '100%'
        width: '100%'
      map = new App.google.Map @el,
        zoom:3
        mapTypeId: App.google.MapTypeId.HYBRID
        # disableDefaultUI: true
      marker = new App.google.Marker
        map: map,
        position: pos
      map.setCenter(pos)

  return ListView
