
http    = require('http')
express = require('express')
path    = require('path')
crypto  = require('crypto')


app = express()
webserver = http.createServer(app)
basePath = path.join(__dirname)
staticPath = path.join(basePath, '/.generated/')

app.engine('html', require('ejs').renderFile)

app.configure ->
  app.use('/assets', express.static(staticPath))
  app.use('/vendor', express.static(basePath + '/bower_components/'))

port = process.env.PORT || 3007
webserver.listen(port)

app.get '/', (req, res) ->
  res.render(path.join(staticPath, "index.html"))

app.get '/avatar/:name', (req, res) ->
  str = req.params.name
  id = Math.abs(parseInt(str.split('').reduce((previousValue, currentValue, index, array) ->
    charValue = currentValue.charCodeAt('0')
    if (index % 2 == 0)
      val = previousValue + charValue
    else
      val = previousValue - charValue
    return val
  , 0)/10))
  console.log id
  res.sendfile((path.join(staticPath, "img", "avatar#{id}.png")))


module.exports = webserver
