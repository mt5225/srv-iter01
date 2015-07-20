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
  member_type: String #会员类型
  member_level: String #会员等级
  memo: String #备忘
  fav: [] #爱好, Array
)
mongoose.model 'User', UserSchema