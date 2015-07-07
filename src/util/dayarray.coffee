Date::addDays = (days) ->
  dat = new Date(@valueOf())
  dat.setDate dat.getDate() + days
  dat

formatDate = (date) ->
  d = new Date(date)
  month = '' + (d.getMonth() + 1)
  day = '' + d.getDate()
  year = d.getFullYear()
  if month.length < 2
    month = '0' + month
  if day.length < 2
    day = '0' + day
  [
    year
    month
    day
  ].join '-'

getDates = (startDate, stopDate) ->
  dateArray = new Array
  currentDate = startDate
  while currentDate <= stopDate
    dateArray.push formatDate(new Date(currentDate))
    currentDate = currentDate.addDays(1)
  dateArray

Date::timeNow = ->
    (if @getHours() < 10 then '0' else '') + @getHours() + ':' + (if @getMinutes() < 10 then '0' else '') + @getMinutes() + ':' + (if @getSeconds() < 10 then '0' else '') + @getSeconds()
  
todayStr = ->
  today = new Date
  dd = today.getDate()
  mm = today.getMonth() + 1
  yyyy = today.getFullYear()
  dd = '0' + dd if dd < 10
  mm = '0' + mm if mm < 10  
  today = yyyy + '-' + mm + '-' + dd

exports.getDateTime = ->
  currentdate = new Date
  datetime = todayStr() + " "+ currentdate.timeNow()

exports.getDayArray = (startDayString, endDayString) ->
  startDate = new Date(startDayString)
  endDate = new Date(endDayString)
  getDates startDate, endDate