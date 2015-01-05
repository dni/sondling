fs = require "fs-extra"
auth = require './../../utilities/auth'

module.exports.setup = (app, config)->
  SubcategorySchema = require('./../../lib/model/Schema')(config.dbTable)
