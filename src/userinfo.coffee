perfect = perfect or {}
https = require('https')
fs = require "fs"
accesskey = require('./accesskey').accesskey

#session manager class
perfect.UserInfo = do ->
  UserInfo = ->

  UserInfo.get = (open_id, callback) ->
    accesskey.getKey (access_token)->
      console.log "[Debug][AccesKey] " + access_token
      options =
        host: 'api.weixin.qq.com'
        port: 443
        path: "/cgi-bin/user/info?access_token=#{access_token}&openid=#{open_id}&lang=zh_CN"
        method: 'GET'
        headers: accept: '*/*'
      req = https.request options, (res) ->
        res.on 'data', (d) ->
          console.log "===> DATA <=== "
          data = JSON.parse d
          callback data

      req.end()
      req.on 'error', (e) ->
        console.log "===> ERROR <=== "
        console.error e
        return

  UserInfo

exports.userinfo = perfect.UserInfo