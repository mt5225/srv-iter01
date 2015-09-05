#require('newrelic') if process.env.NODE_ENV isnt 'prod'
express = require './config/express'
mongoose = require './config/mongoose'
config = require './config/config'

APPID = config.APPID
SECRET = config.APPSecret
REDIRECT_URL = config.REDIRECT_URL
REDIRECT_URL_NODEBB = config.REDIRECT_URL_NODEBB

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
call by wechat server
如果用户同意授权，页面将跳转至 redirect_uri/?code=CODE&state=STATE。若用户禁止授权，则重定向后不会带上code参数，仅会带上state参数redirect_uri?state=STATE
then we will redirect user to origin page
@ref http://mp.weixin.qq.com/wiki/17/c0f37d5704f0b64713d5d2c37b468d75.html
qa.aghchina.com.cn:9000/?code=031fa9f133ceba547e266fab65ead8dv&state=123#/
###
app.get '/api/useroauth', (req, res) ->
  useroauth = require './useroauth'
  code = req.param('code')
  backurl = req.param('state')
  console.log "code = #{code}, backurl=#{backurl} #{APPID} #{SECRET}"
  if code is 'authdeny' #user deny 
    res.writeHead 301, {Location: "http://mp.weixin.qq.com/s?__biz=MzA5NDEyMTEzNg==&mid=215293392&idx=1&sn=0b64443c8cd5f091cc646b1850e2b7e9#rd"}
    res.end()
  else
    useroauth.getOAuth APPID, SECRET, code, (openid) ->  #get user openid using code
      #check if user is subscribe 
      userinfo = require('./userinfo').userinfo
      userinfo.get openid, (wechatuser)->
        console.log wechatuser
        if wechatuser? && wechatuser.subscribe is 1
          console.log "subscribe user, check if user is in local database"
          User = require('mongoose').model('User')
          User.findOne('openid': "#{wechatuser.openid}").exec (err, user) ->
            console.log user
            if !user?
              console.log "user is not in db, create new record"
              userDO = new User(wechatuser)
              userDO.survey = "false"
              userDO.save (err) ->
                if err 
                  res.writeHead 301, {Location: "http://mp.weixin.qq.com/s?__biz=MzA5NDEyMTEzNg==&mid=215293392&idx=1&sn=0b64443c8cd5f091cc646b1850e2b7e9#rd"}
                  res.end()
                else
                  console.log "saved user to db, redirct user to #{REDIRECT_URL}/#/#{backurl}?openid=#{openid}"
                  res.writeHead 301, {Location: "#{REDIRECT_URL}/#/#{backurl}?openid=#{openid}"}
                  res.end()
              return          
            else
              if backurl is 'nodebb'
                nickname = require('querystring').escape user.nickname
                avatar = require('querystring').escape user.headimgurl
                console.log "user in db, redict to nodebb sso srv #{REDIRECT_URL_NODEBB}/api/login?openid=#{openid}&nickname=#{nickname}&avatar=#{avatar}"           
                res.writeHead 301, {Location: "#{REDIRECT_URL_NODEBB}/api/login?openid=#{openid}&nickname=#{nickname}&avatar=#{avatar}"}
                res.end()
              else
                console.log "user in db, redirct user to #{REDIRECT_URL}/#/#{backurl}?openid=#{openid}"
                res.writeHead 301, {Location: "#{REDIRECT_URL}/#/#{backurl}?openid=#{openid}"}
                res.end()
        else
          console.log "user is not in subscribe mode, redirct user to #{REDIRECT_URL}/#/barcode"
          res.writeHead 301, {Location: "http://mp.weixin.qq.com/s?__biz=MzA5NDEyMTEzNg==&mid=215348069&idx=1&sn=1b6212acc08997184fc8347be78acf40#rd"}
          res.end()

###
@depredated get user info by openid
###
app.get '/api/userinfo', (req, res) ->
  userinfo = require('./userinfo').userinfo
  user_openid = req.param('user_openid')
  userinfo.get user_openid,(user)->
    console.log user
    res.status(200).json user

###
send message to user by openid
@param openid, message content
###
app.post '/api/sendmsg', (req, res) ->
  message = require('./message')
  message.send req.body, (msg) ->
    res.status(200).json msg

###
ping plus plus
@param user_openid
###
app.get '/api/pingplus', (req, res) ->
  pingplus = require('./pingplus')
  channel_type = req.param('channel_type')
  user_openid = req.param('user_openid')
  total_price = req.param('total_price')
  order_number = req.param('order_number')
  pingplus.createCharge channel_type, user_openid, total_price, order_number, (charge) ->
    res.status(200).json charge

###
 CRUD service using express and mongoose
###
#curl http://localhost:3000/api/orders/o82BBs8XqUSk84CNOA3hfQ0kNS90
orders = require './controller/order_controller'
app.route('/api/orders').post orders.create
app.route('/api/orders/:wechat_openid').get orders.list
app.route('/api/orders/orderid/:orderId').get orders.get
app.route('/api/orders/availability').post orders.check
app.route('/api/orders/:order_id').post orders.setStatus

#curl http://localhost:3000/api/users/o82BBs8XqUSk84CNOA3hfQ0kNS90
users = require './controller/user_controller'
app.route('/api/users').post users.create
###########################
#get user info by openid, note if user doesnot exist in backend db
#we will query wechat server and create an new user record
###########################
app.route('/api/users/:wechat_openid').get users.get

#return house list
houses = require './controller/house_controller'
app.route('/api/houses').get houses.list
app.route('/api/houses/:house_id').get houses.get


#get available date by house_id
avail = require './controller/availabledate_controller'
app.route('/api/available/:house_id').get avail.get

#save survey
survey = require './controller/survey_controller'
app.route('/api/surveys').post survey.save
#get survey
app.route('/api/surveys/:openid').get survey.find

app.listen 3000, ->
  console.log "ready to serve at port 3000"
