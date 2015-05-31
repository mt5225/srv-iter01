User = require('mongoose').model('User')

#query user
exports.get = (req, res, next) ->
  wechat_openid = req.params['wechat_openid']
  console.log "query user with openid #{wechat_openid}"
  User.findOne('openid': "#{wechat_openid}").exec (err, user) ->
    if err
      console.log err
      next err
    else
      res.status(200).json user

#create new user
exports.create = (req, res, next) ->
  console.log "create new user"
  console.log req.body
  user  = new User(req.body)
  user.save (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json user