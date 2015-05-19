express = require './config/express'
mongoose = require './config/mongoose'
sign = require './sign.js'
jsapi = require('./jsapi').JSAPI
userinfo = require('./userinfo').userinfo


APPID = 'wxe2bdce057501817d'

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
###

#signURL = "http://www.mt5225.cc:9000/signTest.html"
#signURL = "http://www.mt5225.cc:9000/"

app.get '/api/sign', (req, res) ->
  signURL = req.param('url')
  jsapi.getKey (ticket)->
    console.log "[Debug][jsapi_key] " + ticket
    strSign = sign(ticket, signURL)
    strSign['appid'] = APPID
    console.log strSign
    res.status(200).json strSign

###
user service
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
###
app.get '/api/userinfo', (req, res) ->
 # user_openid = 'o82BBs8XqUSk84CNOA3hfQ0kNS90'
  user_openid = req.param('user_openid')
  userinfo.get user_openid,(user)->
    console.log user
    res.status(200).json user


###
  Order CRUD
###
orders = require './controller/order_controller'

app.route('/orders').post orders.create
app.route('/orders/:wechat_openid').get orders.list


app.listen 3000, ->
  console.log "ready to serve"