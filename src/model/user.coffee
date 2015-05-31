mongoose = require 'mongoose'
#register for data model
Schema = mongoose.Schema
UserSchema = new Schema (
  subscribe: String
  openid: String
  nickname: String
  sex: String
  language: String
  city: String
  province: String
  country: String
  headimgurl: String
  subscribe_time: Number
  unionid: String
  remark: String
  groupid: Number
  email: String
  address: String
  realname: String
)
mongoose.model 'User', UserSchema

###
  {
    "subscribe": 1,
    "openid": "o6_bmjrPTlm6_2sgVt7hMZOPfL2M",
    "nickname": "Band",
    "sex": 1,
    "language": "zh_CN",
    "city": "广州",
    "province": "广东",
    "country": "中国",
    "headimgurl":    "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0",
   "subscribe_time": 1382694957,
   "unionid": " o6_bmasdasdsad6_2sgVt7hMZOPfL"
   "remark": "",
   "groupid": 0
}
###