Survey = require('mongoose').model('Survey')

#save survey results
exports.save = (req, res, next) ->
  console.log "save survey results"
  survey = new Survey(req.body)
  survey.save (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json survey

exports.find = (req, res, next) ->
  openid = req.params['openid']
  console.log "find survey by openid #{openid}"
  Survey.find({'userinfo.openid': "#{openid}"}).exec (err, surveys) ->
    if err
      console.log err
      next err
    else
      res.status(200).json surveys