process.env.NODE_ENV = process.env.NODE_ENV || 'qa';
express = require './config/express'
mongoose = require './config/mongoose'
config = require './config/config'

APPID = config.APPID
SECRET = config.APPSecret
REDIRECT_URL = config.REDIRECT_URL

db = mongoose()
app = express()

###
sign service
curl localhost:3000/api/sign
{ jsapi_ticket: 'sM4AOVdWfPE4DxkXGEs8VMyrPTaDyfEkWUdfl5NOd96S2DU4MBdvdvSfkAvlF3Lv3BreWffhmjkmGCLpyHKwFQ',
  nonceStr: 'hnsde8qnoqsvpld',
  timestamp: '1431415715',
  url: 'http://www.mt5225.cc',
  signature: 'ec0cffe3ddbac350d75c0451c23042ea0af140f0',
  appid: 'wxe2bdce057501817d'
}
note: the signURL will be passed by the caller
###

app.get '/api/sign', (req, res) ->
  sign = require './sign.js'
  jsapi = require('./jsapi').JSAPI
  signURL = req.param('url')
  jsapi.getKey (ticket)->
    console.log "[Debug][jsapi_key] " + ticket
    strSign = sign(ticket, signURL)
    strSign['appid'] = APPID
    console.log strSign
    res.status(200).json strSign


###
get userinfo by wechat oauth
@ref http://mp.weixin.qq.com/wiki/17/c0f37d5704f0b64713d5d2c37b468d75.html
qa.aghchina.com.cn:9000/?code=031fa9f133ceba547e266fab65ead8dv&state=123#/
###
app.get '/api/useroauth', (req, res) ->
  useroauth = require './useroauth'
  code = req.param('code')
  console.log "code = #{code}"
  useroauth.getOAuth APPID, SECRET, code, (data) ->
    console.log "#{REDIRECT_URL}?user_openid=#{data}"
    res.writeHead 301, {Location: "#{REDIRECT_URL}?user_openid=#{data}"}
    res.end()
    

###
user service to query userinfo from wechat api
curl localhost:3000/api/userinfo?user_openid=o82BBs8XqUSk84CNOA3hfQ0kNS90
{ subscribe: 1,
  openid: 'o82BBs8XqUSk84CNOA3hfQ0kNS90',
  nickname: '蒋庆',
  sex: 1,
  language: 'en',
  city: '朝阳',
  province: '北京',
  country: '中国',
  headimgurl: 'http://wx.qlogo.cn/mmopen/PiajxSqBRaELJbrdqoOdck7Tph5OvpvMjTx1PlibRmfBSYkficu9rSkuamzCcYuvl5RhF882EJH46U1Hob5TPrB8A/0',
  subscribe_time: 1428411986,
  remark: '',
  groupid: 0 }
mongo
use perfectlife
db.users.find()
###
app.get '/api/userinfo', (req, res) ->
  userinfo = require('./userinfo').userinfo
  user_openid = req.param('user_openid')
  userinfo.get user_openid,(user)->
    console.log user
    res.status(200).json user


###
ping plus plus
@param user_openid
###
app.get '/api/pingplus', (req, res) ->
  pingplus = require('./pingplus')
  user_openid = req.param('user_openid')
  pingplus.createCharge user_openid, (charge) ->
    res.status(200).json charge

###
 CRUD service using express and mongoose
###
#curl http://localhost:3000/api/orders/o82BBs8XqUSk84CNOA3hfQ0kNS90
orders = require './controller/order_controller'
app.route('/api/orders').post orders.create
app.route('/api/orders/:wechat_openid').get orders.list

#curl http://localhost:3000/api/users/o82BBs8XqUSk84CNOA3hfQ0kNS90
users = require './controller/user_controller'
app.route('/api/users').post users.create
app.route('/api/users/:wechat_openid').get users.get

app.listen 3000, ->
  console.log "ready to serve at port 3000"
