define [
    'cs!App'
    'cs!Publish'
    'cs!./controller/MapController'
    'text!./configuration.json'
    'i18n!./nls/language.js'
    'googlemaps!'
    'less!./style/map.less'
], (App, Publish, Controller, Config, i18n, google) ->

  App.google = google
  App.getCurrentPosition = ->
    App.position =
      coords:
        accuracy: 13976
        altitude: null
        altitudeAccuracy: null
        heading: null
        latitude: 48.579068299999996
        longitude: 14.0396111
        speed: null
      timestamp: Date.now()
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position)->
        App.position = position

  App.getCurrentPosition()

  new Publish.Module
    Controller: Controller
    Config: Config
    i18n:i18n
