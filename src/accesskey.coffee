perfect = perfect or {}
https = require('https')
fs = require "fs"

#session manager class
perfect.AccessKey = do ->
  AccessKey = ->

  APPID = 'wxe2bdce057501817d'
  APPSecret = 'c907a867dc3deebff5c0b2c392c77b90'

  createTimestamp = ->
    parseInt((new Date).getTime() / 1000) + ''

  renewKey = (callback)->
    options =
      host: 'api.weixin.qq.com'
      port: 443
      path: "/cgi-bin/token?grant_type=client_credential&appid=#{APPID}&secret=#{APPSecret}"
      method: 'GET'
      headers: accept: '*/*'
    req = https.request options, (res) ->
      res.on 'data', (d) ->
        console.log "===> DATA <=== "
        data = JSON.parse d
        console.log data
        key = data['access_token']
        console.log "AccessKey: " + key
        callback key
        #write to local disk
        accesskey =
          key: key
          timestamp: createTimestamp()
        fs.writeFile 'accesskey.json', JSON.stringify(accesskey), (error) ->
          console.error("Error writing file", error) if error


    req.end()
    req.on 'error', (e) ->
      console.log "===> ERROR <=== "
      console.error e
      return

  AccessKey.getKey = (callback)->
    fs.readFile 'accesskey.json', (err, data) ->
      contents = JSON.parse data
      console.log "cached key= " + contents['key']
      key = contents['key']
      timegap = parseInt((new Date).getTime() / 1000) - parseInt(contents['timestamp'])
      #if ticket is within 2 hours
      if timegap < 7200
        console.log "within 2hour, read access key from local cache"
        callback key
      else
        console.log "generate an new ticket"
        renewKey callback

  AccessKey

exports.accesskey = perfect.AccessKey