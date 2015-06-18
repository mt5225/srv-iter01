House = require('mongoose').model('House')


exports.list = (req, res, next) ->
  House.find({}).exec (err, houses) ->
    if err
      console.log err
      next err
    else
      res.status(200).json houses

exports.get = (req, res, next) ->
  house_id = req.params['house_id']
  console.log "house_id= #{house_id}"
  House.find({'id': "#{house_id}"}).exec (err, house) ->
    if err
      console.log err
      next err
    else
      res.status(200).json house
