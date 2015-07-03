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
      console.log "user query result #{JSON.stringify(user)}"
      if user == null 
        console.log "query wechat server to get user info and store in db"
        userinfo = require('../userinfo').userinfo
        userinfo.get wechat_openid,(user)->
          userDO = new User(user)
          userDO.survey = "false"
          userDO.save ->
            if err 
              res.status(400).send message: getErrorMessage(err)
            else
              res.status(200).json user
      else
        console.log "find something in db, return"
        res.status(200).json user

#update or create user
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