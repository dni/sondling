define [
  'cs!App'
  'cs!Publish'
  'cs!utilities/Utilities'
  'tpl!../templates/relatedmap.html'
], (App, Publish, Utilities, Template) ->

  class RelatedPolygonMapView extends Marionette.ItemView
    render:(args)->

      @category = App.Categories.findWhere _id: @model.getValue 'category'
      that = @
      @$el.css
        height: '500px'
        width: '500px'
      if @model.getValue('lat') and @model.getValue('lng')
        @pos = new App.google.LatLng(@model.getValue("lat"), @model.getValue('lng'))
      else
        @pos = new App.google.LatLng(App.position.coords.latitude, App.position.coords.longitude)
      @map = new App.google.Map @el,
        zoom:22
        mapTypeId: App.google.MapTypeId.HYBRID
        disableDefaultUI: true
        center: @pos
      if @model.getValue("polygon")
        # draw it
        paths = @model.getValue("polygon").split(";").map (point)->
          latlng = point.split(",")
          new App.google.LatLng latlng[0], latlng[1]
        @rectangle = new App.google.Polygon
          paths: paths
          strokeColor: @category.getValue('color')
          strokeOpacity: 0.8
          strokeWeight: 3
          fillColor: @category.getValue('color')
          fillOpacity: 0.3
        @rectangle.setMap @map
      else
        @drawingManager = new App.google.drawing.DrawingManager
          drawingMode: App.google.drawing.OverlayType.POLYGON
        @drawingManager.setMap @map
        App.google.event.addListener @drawingManager, 'polygoncomplete', (newRect)->
          that.drawingManager.setMap null
          that.rectangle = newRect
          polygonArray = newRect.getPath().getArray()
          polygon = polygonArray.map (point)->
            point.toUrlValue()
          that.model.setValue "polygon", polygon.join(";")
          that.model.save()
      @map.setCenter(@pos)
      # needsresize else it wont have displaybugs
      setTimeout ->
        App.google.event.trigger that.map, 'resize'
      , 500
