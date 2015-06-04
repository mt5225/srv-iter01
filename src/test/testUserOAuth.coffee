request = require('request');

request(
  {
    url: 'http://qa.aghchina.com.cn:3000/api/useroauth?code=021752ef7be62677bdf1f063ccb0b80C',
    method: "GET"
  }, (error, response, body) ->
    console.log body 
)

#qa.aghchina.com.cn:9000/?code=021907903b8b64193cc41d2ba7f7644T&state=aghchina#/