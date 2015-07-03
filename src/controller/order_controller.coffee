Order = require('mongoose').model('Order')
dayArray = require '../util/dayarray'

#create new order
exports.create = (req, res, next) ->
  console.log "create new order"
  order = new Order(req.body)
  console.log order
  order.save (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json order
      #update booking status
      dayarray =  dayArray.getDayArray(order.checkInDay, order.checkOutDay)
      dayarray.pop() #exclude checkout day
      houseAvail = require('mongoose').model(order.houseId)
      for item in dayarray
        console.log "set #{item} as booked"
        houseAvail.findOne { day: item }, (err, record) ->
          if err
            console.log "cannot find record"
          else
            record.set('info.status', 'booked');
            record.set('info.info', order.orderId);
            record.save()


#return orders by wechat open_id
exports.list = (req, res, next) ->
  wechat_openid = req.params['wechat_openid']
  console.log "list all orders belong to an user/wechat open_id"
  console.log req.params
  Order.find('wechatOpenID': "#{wechat_openid}").exec (err, orders) ->
    if err
      console.log err
      next err
    else
      res.status(200).json orders

#set order status
exports.setStatus = (req, res, next) ->
  console.log "===> set order status <==="
  orderId = req.params['order_id']
  status = req.body.status
  console.log "orderId=#{orderId} status=#{status}"
  Order.update { orderId: orderId }, { $set: status: status }, (err, order) ->
    console.log order
    res.status(200).json order

#check house availability
exports.check = (req, res, next) ->
  console.log "===> check availability for booking <==="
  dayarray =  dayArray.getDayArray(req.body.checkInDay, req.body.checkOutDay)
  dayarray.pop() #exclude checkout day
  console.log dayarray
  houseAvail = require('mongoose').model(req.body.houseId)
  records = []
  async = require 'async'
  async.forEach dayarray, ((item, callback) ->
    houseAvail.findOne { day: item }, (err, res) ->
      records.push res
      callback()
  ), (err) ->
    for record in records
      console.log record.get('day') + ' is ' + record.get('info.status') 
      if record.get('info.status') != 'available'        
        return res.status(200).json {available: 'false'}
    res.status(200).json {available: 'true'}
  


