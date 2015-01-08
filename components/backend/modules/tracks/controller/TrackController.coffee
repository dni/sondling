define [
    'cs!App'
    'cs!Publish'
    'cs!utilities/Utilities'
    'cs!../view/TrackListView'
    'cs!../view/TrackTopView'
], ( App, Publish, Utilities, ListView, TopView) ->

  class TrackController extends Publish.Controller.Controller
    TopView: TopView
    ListView: ListView
    initialize:->
      @trackPoints = []
      @recording = false
      App.vent.on 'startTracking', @start
      App.vent.on 'stopTracking', @stop
      App.vent.on 'newPosition', @newPosition

    newPosition:->
      point = App.position.coords.latitude+','+App.position.coords.longitude
      return unless @recording and @trackPoints[@trackPoints.length-1] isnt point
      @trackPoints.push point
    start:=>
      @trackPoints = []
      @recording = true
    stop:=>
      model = @createNewModel()
      model.setValue 'track', @trackPoints.join(';')
      App.Tracks.create model,
        wait: true
        success: (res) ->
          route = res.attributes.name+'/'+res.attributes._id
          Utilities.Log @i18n.newModel, 'new',
            text: res.attributes._id
            href: route
      @recording = false
