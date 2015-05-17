mongoose = require 'mongoose'
#register for data model
Schema = mongoose.Schema
OrderSchema = new Schema (
  orderId: String
  houseId: String
  checkInDay: String
  checkOutDay: String
  numOfGuest: String
  wechatOpenID: String
  wechatNickName: String
)
mongoose.model 'Order', OrderSchema