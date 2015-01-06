define [
    'cs!Publish'
    'cs!../view/CategoryListView'
], ( Publish, ListView ) ->
  class CategoryController extends Publish.Controller.Controller
    ListView: ListView

