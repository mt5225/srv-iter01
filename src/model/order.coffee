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
  status: String
  createDay: String
  houseId: String
  houseName: String
  totalPrice: String
  priceByDayArray:  { type : Array , "default" : [] }
  memo: String
)
mongoose.model 'Order', OrderSchema