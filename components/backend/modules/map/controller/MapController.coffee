define [
    'cs!App'
    'cs!Publish'
    'cs!utilities/Utilities'
    'cs!../view/MapView'
], ( App, Publish, Utilities, MapView) ->

  class MapController extends Publish.Controller.Controller
    initialize:->
      App.vent.on "ready", =>
        App.mapRegion.show new MapView collection: App.Finds
    list: ->
      App.listRegion.empty()
      App.contentRegion.empty()
      App.listTopRegion.show new @TopView
        navigation: @i18n.navigation
