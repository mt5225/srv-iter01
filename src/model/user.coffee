mongoose = require 'mongoose'
#register for data model
Schema = mongoose.Schema
UserSchema = new Schema (
  subscribe: String #订阅状态
  openid: String #wechat openid
  nickname: String  # 微信中的昵称
  sex: String  # 性别
  language: String  # 语言
  city: String # 城市
  province: String  # 省份
  country: String  # 国家
  headimgurl: String # 头像
  subscribe_time: Number   #订阅公众号的时间
  unionid: String  #unionid
  remark: String  #自我描述
  groupid: Number #groupid
  email: String  #邮箱
  address: String  #地址
  realname: String  #真实姓名
  cell: String  #手机号
  identity: String #证件号
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