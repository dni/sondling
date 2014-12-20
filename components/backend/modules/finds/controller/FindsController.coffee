define [
    'cs!App'
    'cs!Publish'
    'cs!utilities/Utilities'
    'cs!modules/files/view/RelatedFileView'
], ( App, Publish, Utilities, FileView ) ->

  class FindsController extends Publish.Controller.LayoutController

    RelatedViews:
      fileView: FileView

#     list: ->
#       App.listTopRegion.show new @TopView
#         navigation: @i18n.navigation
#         newRoute: 'new'+@Config.modelName
#       FilteredCollection = Utilities.FilteredCollection App[@Config.collectionName]
#       FilteredCollection.filter @filterFunction
#       App.contentRegion.show new @ListView collection: FilteredCollection

