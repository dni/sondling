define [
  'cs!App'
  'backbone'
  'marionette'
  'tpl!../templates/top.html'
],
(App, Backbone, Marionette, Template) ->

  class TopModel extends Backbone.Model
    defaults:
      navigation: 'Navigation Title'
      newModel:false
      newRoute:false
      search:false
      icon: 'plus'

  class TopView extends Marionette.ItemView
    template: Template
    ui:
      play: "#toggleRecord"
    events:
      "click #toggleRecord": "toggle"
    initialize: (args)->
      @model = new TopModel args
    toggle:->
      @ui.play.toggleClass 'active'
      @ui.play.find('span').toggleClass 'glyphicon-record'
      .toggleClass 'glyphicon-stop'
      if @ui.play.hasClass 'active'
        App.vent.trigger 'startTracking'
      else
        App.vent.trigger 'stopTracking'
