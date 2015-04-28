express = require 'express'
morgan = require 'morgan'
sign = require './sign.js'
#todo util to load and cache key
ticket = 'sM4AOVdWfPE4DxkXGEs8VMyrPTaDyfEkWUdfl5NOd97nrgajR7YbsHwWj195fKjT7zD56-k34O2hq3Jku5cntQ'

app = express()
app.use(morgan 'combined')
app.get '/api/sign', (req, res) ->
  res.status(200).json sign(ticket, "www.mt5225.cc")
app.listen 3000, ->
  console.log "ready to serve"