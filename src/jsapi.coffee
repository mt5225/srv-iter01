perfect = perfect or {}
https = require('https')
accesskey = require('./accesskey').accesskey

#jsapi class
perfect.JSAPI = do ->
  JSAPI = ->

  JSAPI.getKey = (callback) ->
    accesskey.getKey (access_token)->
      console.log "[Debug][AccesKey] " + access_token
      options =
        host: 'api.weixin.qq.com'
        port: 443
        path: "/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"
        method: 'GET'
        headers: accept: '*/*'
      req = https.request options, (res) ->
        res.on 'data', (d) ->
          console.log "===> DATA <=== "
          data = JSON.parse d
          console.log data
          callback data['ticket']

      req.end()
      req.on 'error', (e) ->
        console.log "===> ERROR <=== "
        console.error e
        return

  JSAPI

exports.JSAPI = perfect.JSAPI