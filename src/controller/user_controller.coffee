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
  console.log "create or update user"
  console.log req.body
  user  = new User(req.body)
  upsertData = user.toObject();
  delete upsertData._id

  User.update({openid: user.openid}, upsertData, {upsert: true}, (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json user
  )