auth = require "../../utilities/auth"
module.exports.setup = (app, config)->
  Tracks = require('./../../lib/model/Schema')(config.dbTable)
