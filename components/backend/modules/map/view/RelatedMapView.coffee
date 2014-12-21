define [
  'cs!App'
  'cs!Publish'
  'cs!utilities/Utilities'
  'tpl!../templates/relatedmap.html'
], (App, Publish, Utilities, Template) ->

  class RelatedMapView extends Marionette.ItemView
    template: Template
    render:(args)->
      that = @
      @$el.css
        height: '500px'
        width: '500px'
      if @model.getValue('lat') and @model.getValue('lng')
        @pos = new App.google.LatLng(@model.getValue("lat"), @model.getValue('lng'))
      else
        @pos = new App.google.LatLng(App.position.coords.latitude, App.position.coords.longitude)
      @map = new App.google.Map @el,
        zoom:25
        mapTypeId: App.google.MapTypeId.HYBRID
        disableDefaultUI: true
        center: @pos
      marker = new App.google.Marker
        map: @map,
        draggable:true
        animation: App.google.Animation.DROP
        position: @pos
      @map.setCenter(@pos)
      # needsresize else it wont have displaybugs
      setTimeout ->
        App.google.event.trigger that.map, 'resize'
      , 500
      App.google.event.addListener marker, 'dragend', (e)->
        that.model.setValue 'lat', e.latLng.lat()
        that.model.setValue 'lng', e.latLng.lng()
        that.model.save()
