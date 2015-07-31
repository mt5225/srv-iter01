Order = require('mongoose').model('Order')
House = require('mongoose').model('House')
dayArray = require '../util/dayarray'
message = require '../message'
config = require '../config/config'

#create new order
exports.create = (req, res, next) ->
  console.log "create new order"
  order = new Order(req.body)
  console.log order
  order.createDay = dayArray.getDateTime()
  order.save (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json order
      notifyNewOrderToManager order
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
            record.set('info.status', 'booked')
            record.set('info.info', order.orderId)
            record.save()


#return orders by wechat open_id
exports.list = (req, res, next) ->
  wechat_openid = req.params['wechat_openid']
  console.log "list all orders belong to an user/wechat #{wechat_openid}"
  Order.find('wechatOpenID': wechat_openid).exec (err, orders) ->
    if err
      console.log err
      next err
    else
      res.status(200).json orders

#return orders by orderId
exports.get = (req, res, next) ->
  orderId = req.params['orderId']
  console.log "get order by id #{orderId}"
  Order.find('orderId': orderId).exec (err, order) ->
    if err
      console.log err
      next err
    else
      res.status(200).json order

#set order status
exports.setStatus = (req, res, next) ->
  console.log "===> set order status <==="
  orderId = req.params['order_id']
  status = req.body.status
  console.log "orderId=#{orderId} status=#{status}"
  Order.update { orderId: orderId }, { $set: status: status }, (err, result) ->
    console.log result
    res.status(200).json result
  #release the house
  if status is "预订成功"
    Order.findOne {orderId: orderId}, (err, order) ->
      console.log "send notiication to manager about #{order.orderId} success"
      notifyPaySuccessToManager order
    
  if status is "订单取消"
    Order.findOne {orderId: orderId}, (err, order) ->
      console.log "send notiication to manager about #{order.orderId} cancel"
      notifyOrderCancelToManager order
      dayarray =  dayArray.getDayArray(order.checkInDay, order.checkOutDay)
      dayarray.pop() #exclude checkout day
      houseAvail = require('mongoose').model(order.houseId)
      for item in dayarray
        console.log "set #{item} as booked"
        houseAvail.findOne { day: item }, (err, record) ->
            if err
              console.log "cannot find record"
            else
              record.set('info.status', 'available')
              record.save()

#check house availability
exports.check = (req, res, next) ->
  console.log "===> check availability for booking for house id #{req.body.houseId}<==="
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
      if record? 
        console.log record.get('day') + ' is ' + record.get('info.status') 
        if record.get('info.status') isnt 'available'        
          return res.status(200).json {available: 'false'}
      else
        return res.status(200).json {available: 'N/A'}
    res.status(200).json {available: 'true'}
  

#send notiication message to manager about new order
notifyNewOrderToManager = (order) ->
  House.findOne({'id': order.houseId}).exec (err, house) ->
    for openid in config.MANAGER_OPENID_LIST
      msg = {}
      msg.touser = "#{openid}"
      msg.template_name = "resv_success"
      msg.url = "#{config.MNGT_URL}/#/orders/#{order.orderId}"
      msg.data = 
        first: 
          value: "客户 #{order.wechatNickName} 提交了新订单，单号 #{order.orderId}"
          color: "#01579b"
        keyword1: value: "#{house.tribe}"
        keyword2: value: "#{order.houseName}"
        keyword3: value: "入住日期#{order.checkInDay}，退房日期#{order.checkOutDay}"
        keyword4: value: "1"
        keyword5: value: "#{order.totalPrice}元"
        remark: 
          value: "订单处理及查看详情请点击本消息"
          color: "#01579b"
      message.send msg, (result) ->
        console.log result

#send notiication message to manager about order been cancel
notifyOrderCancelToManager = (order) ->
  House.findOne({'id': order.houseId}).exec (err, house) ->
    for openid in config.MANAGER_OPENID_LIST
      msg = {}
      msg.touser = "#{openid}"
      msg.template_name = "mngt_order_cancel"
      msg.url = "#{config.MNGT_URL}/#/orders/#{order.orderId}"
      msg.data =
        first: 
          value: "客户 #{order.wechatNickName} 的订单已取消"
          color: "#01579b"
        keyword1: value: "#{order.orderId}"
        keyword2: value: "#{house.tribe}"
        keyword3: value: "#{house.name}"
        keyword4: value: "#{order.checkInDay}"
        keyword5: value: "#{order.checkOutDay}"
        remark: 
          value: "请确认房源是否已释放，查看订单详情请点击本消息"
          color: "#01579b"
      message.send msg, (result) ->
        console.log result   

#send notiication message to manager about order been cancel
notifyPaySuccessToManager = (order) ->
  House.findOne({'id': order.houseId}).exec (err, house) ->
    for openid in config.MANAGER_OPENID_LIST
      msg = {}
      msg.touser = "#{openid}"
      msg.template_name = "book_success"
      msg.url = "#{config.MNGT_URL}/#/orders/#{order.orderId}"
      msg.data =
        first: 
          value: "客户 #{order.wechatNickName} 的订单支付成功，订单号为#{order.orderId}，请确认"
          color: "#01579b"
        hotelName: value: "#{house.tribe}"
        roomName: value: "#{house.name}"
        pay: value: "#{order.totalPrice}"
        date: value: "#{order.checkInDay}"
        remark: 
          value: "查看订单详情请点击本消息"
          color: "#01579b"
      message.send msg, (result) ->
        console.log result 




