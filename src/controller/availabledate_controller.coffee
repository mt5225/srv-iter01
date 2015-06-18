###
get available days given house_id
###
exports.get = (req, res, next) ->
  house_id = req.params['house_id']
  Cal = require('mongoose').model house_id 
  console.log "query #{house_id} for avaialbe days"
  Cal.find({'info.status': 'available'}).exec (err, days) ->
    if err
      console.log err
      next err
    else
      res.status(200).json days
