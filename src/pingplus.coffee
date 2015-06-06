config = require './config/config'

PING_APP_KEY = config.PING_APPID
PING_TRADE_KEY = config.PING_TRADE_KEY

exports.createCharge = (user_openid, callback) ->
  pingpp = require('pingpp')("#{PING_TRADE_KEY}")
  uuid = require 'node-uuid'
  console.log PING_APP_KEY
  console.log PING_TRADE_KEY
  pingpp.charges.create {
      subject: 'aghchina'
      body: 'aghchina'
      amount: 1
      order_no: uuid.v1().replace /-/g, ''
      channel: 'wx_pub'
      currency: 'cny'
      client_ip: '127.0.0.1'
      app: id: "#{PING_APP_KEY}"
      extra: open_id: "#{user_openid}"
    }, (err, charge) ->
      if err
        console.log err
        callback err
      else
        console.log charge
        callback charge
      return  
