define [
    'cs!Publish'
    'cs!./controller/CategoryController'
    'text!./configuration.json'
    'i18n!./nls/language.js'
    'less!./style/category.less'
], ( Publish, Controller, Config, i18n ) ->

  new Publish.Module
    Controller: Controller
    Config: Config
    i18n:i18n
