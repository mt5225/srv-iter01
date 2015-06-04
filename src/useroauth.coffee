https = require 'https'
fs = require 'fs'
userinfo = require('./userinfo').userinfo


exports.getOAuth = (APPID, SECRET, CODE, callback) ->
  options =
    host: 'api.weixin.qq.com'
    port: 443
    path: "/sns/oauth2/access_token?appid=#{APPID}&secret=#{SECRET}&code=#{CODE}&grant_type=authorization_code"
    headers: accept: '*/*'
  req = https.request options, (res) ->
    res.on 'data', (d) ->
      console.log "===> OAUTH DATA with CODE #{CODE}<=== "
      data = JSON.parse d
      console.log "oauth result: #{JSON.stringify(data)}"
      callback data['openid']   

  req.end()
  req.on 'error', (e) ->
    console.log "===> ERROR <=== "
    console.error e
    return
 