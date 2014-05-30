
http    = require('http')
express = require('express')
path    = require('path')

a       = require('./lib/algorhythmic.coffee')
imager  = require('./lib/imager.coffee')


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


# Basic Route
app.get '/avatar/:name', (req, res) ->
  id = a.convert(req.params.name)
  res.sendfile( path.join(staticPath, "img", "avatar#{id}.png") )

# Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->
  id = a.convert(req.params.name)
  imgPath = path.join(staticPath, "img", "avatar#{id}.png")
  imager.resize(imgPath, req.params.size, req, res, next)


module.exports = webserver
