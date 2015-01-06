define [
    'cs!Publish'
    'cs!./controller/FindsiteController'
    'text!./configuration.json'
    'i18n!./nls/language.js'
], ( Publish, Controller, Config, i18n) ->

  new Publish.Module
    Controller: Controller
    Config: Config
    i18n:i18n
