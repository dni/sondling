define [
    'cs!App'
    'cs!Publish'
    'cs!utilities/Utilities'
    'cs!../view/MapView'
    'cs!modules/files/view/RelatedFileView'
], ( App, Publish, Utilities, ListView, FileView ) ->
  class FindsController extends Publish.Controller.LayoutController

    ListView: ListView

    RelatedViews:
      fileView: FileView

    list: ->
      App.listTopRegion.show new @TopView
        navigation: @i18n.navigation
        newRoute: 'new'+@Config.modelName
      FilteredCollection = Utilities.FilteredCollection App[@Config.collectionName]
      FilteredCollection.filter @filterFunction
      App.contentRegion.show new @ListView collection: FilteredCollection

