fs = require "fs-extra"
auth = require './../../utilities/auth'

module.exports.setup = (app, config)->

  CategorySchema = require('./../../lib/model/Schema')(config.dbTable)
