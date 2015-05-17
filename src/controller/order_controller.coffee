Order = require('mongoose').model('Order')

#create new order
exports.create = (req, res, next) ->
  console.log "create new order"
  order = new Order(req.body)
  order.save (err) ->
    if err
      console.log err
      next err
    else
      res.status(200).json order

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