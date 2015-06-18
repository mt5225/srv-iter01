mongoose = require 'mongoose'
Schema = mongoose.Schema

mongoose.model('Survey', new Schema({}, strict: false))