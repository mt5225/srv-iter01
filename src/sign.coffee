createNonceStr = ->
  Math.random().toString(36).substr 2, 15

createTimestamp = ->
  parseInt((new Date).getTime() / 1000) + ''

raw = (args) ->
  keys = Object.keys(args)
  keys = keys.sort()
  newArgs = {}
  keys.forEach (key) ->
    newArgs[key.toLowerCase()] = args[key]
    return
  string = ''
  for k of newArgs
    string += '&' + k + '=' + newArgs[k]
  string = string.substr(1)
  string

###
* @synopsis 签名算法
*
* @param jsapi_ticket 用于签名的 jsapi_ticket
* @param url 用于签名的 url ，注意必须动态获取，不能 hardcode
*
* @returns
###

sign = (jsapi_ticket, url) ->
  ret =
    jsapi_ticket: jsapi_ticket
    nonceStr: createNonceStr()
    timestamp: createTimestamp()
    url: url
  string = raw(ret)
  jsSHA = require('jssha')
  shaObj = new jsSHA(string, 'TEXT')
  ret.signature = shaObj.getHash('SHA-1', 'HEX')
  ret

module.exports = sign
