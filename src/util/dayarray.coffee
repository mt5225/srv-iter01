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

exports.getDayArray = (startDayString, endDayString) ->
  startDate = new Date(startDayString)
  endDate = new Date(endDayString)
  getDates startDate, endDate