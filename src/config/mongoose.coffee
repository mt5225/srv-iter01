module.exports = ->
  mongoose = require 'mongoose'
  db = mongoose.connect 'mongodb://localhost/perfectlife'
  #register models
  require '../model/order'
  require '../model/user'
  require '../model/house'
  require '../model/cal'
  require '../model/survey'
  return db