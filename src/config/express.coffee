express = require 'express'
morgan = require 'morgan'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
cors = require 'cors'


module.exports = ->
  app = express()
  app.use(morgan 'combined')
  app.use(bodyParser.urlencoded(
    extended: true
  ))
  app.use bodyParser.json()
  app.use methodOverride()
  app.use cors() #enable cross-domain ajax
  return app
