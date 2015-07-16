request = require 'request'
accesskey = require('./accesskey').accesskey
config = require './config/config'

###
message template mapping
###

exports.send = (body, callback) ->
  accesskey.getKey (access_token)->
    console.log "[Debug][AccesKey] " + access_token
    body.template_id = config.WECHAT_MSG_T[body.template_name]
    console.log body
    request {
      url: "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{access_token}"
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
      body: JSON.stringify(body) 
    }, (error, response, body) ->
      if error
        console.log error
        callback error
      else
        console.log response.statusCode, body
        callback body
      return


###
==message sample, note the template_id is passed by caller with alias
       {
           "touser":"o82BBs8XqUSk84CNOA3hfQ0kNS90",
           "template_id":"wVs3fCjtb9kvcnE4vscX64bfjmTi5uLoqt6oPjUWmt0",
           "url":"http://qa.aghchina.com.cn:9000",
           "topcolor":"#FF0000",
           "data":{
                   "first": {
                       "value":"您好",
                       "color":"#173177"
                   }
           }
       }
###