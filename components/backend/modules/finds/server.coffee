auth = require "../../utilities/auth"
module.exports.setup = (app, config)->
  Finds = require('./../../lib/model/Schema')(config.dbTable)
