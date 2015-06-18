mongoose = require 'mongoose'
Schema = mongoose.Schema

House = new Schema(
    id: String,
    name: String,
    likes: String,
    price: String,
    image: String,
    avator: String,
    description: String,
    owner: String,
    ownerid: String,
    stars: String,
    capacity: String,
    story: String,
    owner_story: String
)

mongoose.model 'House', House