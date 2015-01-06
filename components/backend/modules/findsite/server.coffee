auth = require "../../utilities/auth"
module.exports.setup = (app, config)->
  Findsite = require('./../../lib/model/Schema')(config.dbTable)
