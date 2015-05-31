userinfo = require('../userinfo').userinfo
request = require('request');

userinfo.get 'o82BBs8XqUSk84CNOA3hfQ0kNS90',(user)->
  console.log user
  request(
    {
      url: 'http://localhost:3000/api/users',
      method: "POST",
      json: true,
      headers:
        "content-type": "application/json",
      body: JSON.stringify(user)
    }, (error, response, body) ->
      console.log body
  )