module.exports = ->
  mongoose = require 'mongoose'
  db = mongoose.connect 'mongodb://localhost/perfectlife'
  #register models
  require '../model/order'

  return db