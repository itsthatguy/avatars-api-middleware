
http    = require('http')
express = require('express')
path    = require('path')
favicon = require('serve-favicon')
fs      = require('fs')

a       = require('./algorhythmic.coffee')
imager  = require('./imager.coffee')

app           = express()
webserver     = http.createServer(app)
basePath      = path.dirname(require.main.filename)
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

app.engine('.html', require('ejs').__express)

app.use(favicon(faviconPath))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))

port = process.env.PORT || 3002
webserver.listen(port)


# Root
app.get '/', (req, res) -> res.render(path.join(generatedPath, 'index.html'))

# Static Routing
# Take a standard route that may or may not have a file extension
# if there is no extension, return the path with a .html extension
app.get /^\/(\w+)(?:\.)?(\w+)?/, (req, res) ->
  path = req.params[0]
  ext  = req.params[1] ? "html"
  res.render(path.join(basePath, ".generated", "#{path}.#{ext}"))

# Avatars: Basic Route
app.get '/avatar/:name', (req, res) ->
  id = a.convert(req.params.name)
  res.sendfile( path.join(staticPath, "img", "avatar#{id}.png") )

# Avatars: Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->
  id = a.convert(req.params.name)
  imgPath = path.join(staticPath, "img", "avatar#{id}.png")
  imager.resize(imgPath, req.params.size, req, res, next)




module.exports = webserver
