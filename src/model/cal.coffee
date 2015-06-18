mongoose = require 'mongoose'
Schema = mongoose.Schema

for num in [1..12]
  if num < 10
    id = 'H00' + num
  else
    id = 'H0' + num
  calSchema = new Schema({}, strict: false)
  mongoose.model id, calSchema