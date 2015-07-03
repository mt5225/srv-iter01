config = require './config/config'

PING_APP_KEY = config.PING_APPID
PING_TRADE_KEY = config.PING_TRADE_KEY
PING_TEST_KEY = config.PING_TEST_KEY

exports.createCharge = (channel_type, user_openid, total_price, order_number, callback) ->
  console.log "#{channel_type} #{user_openid} #{total_price} #{order_number}"
  
  pingpp = require('pingpp')("#{PING_TRADE_KEY}")
  uuid = require 'node-uuid'
  extraOption = {}
  switch channel_type
    when "wx_pub" then extraOption = {open_id: "#{user_openid}"}
    when "alipay" then extraOption = {}
    when "alipay_wap" then extraOption = {
      success_url: 'http://qa.aghchina.com.cn:9000'
      cancel_url: 'http://qa.aghchina.com.cn:9000'
    }
  console.log extraOption

  pingpp.charges.create {
      subject: 'aghchina'
      body: 'aghchina'
      amount: parseInt(total_price) * 100
      order_no: order_number.replace /-/g, ''
      channel: channel_type
      currency: 'cny'
      client_ip: '127.0.0.1'
      app: id: "#{PING_APP_KEY}"
      extra: extraOption
    }, (err, charge) ->
      if err
        console.log err
        callback err
      else
        console.log charge
        callback charge
      return 
    

