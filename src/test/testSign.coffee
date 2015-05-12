jsapi = require('../jsapi').JSAPI
sign = require('../sign')

#accesskey.renewKey()
jsapi.getKey (ticket)->
  console.log "[Debug][jsapi_key] " + ticket
  console.log sign(ticket, 'http://www.mt5225.cc')
