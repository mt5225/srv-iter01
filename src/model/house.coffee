mongoose = require 'mongoose'
Schema = mongoose.Schema

House = new Schema(
    id: String
    display_id: String
    name: String
    likes: String
    price: String
    image: String
    avator: String
    description: String
    owner: String
    ownerid: String
    stars: String
    capacity: String
    story: String
    owner_story: String
    facility: String
    tribe: String
    average_price: String
    house_pic_list: []
    owner_pic_list: []
    facility_pic_list: []
)

mongoose.model 'House', House