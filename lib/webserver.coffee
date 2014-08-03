
http     = require('http')
express  = require('express')
path     = require('path')
favicon  = require('serve-favicon')
findPort = require('find-port')
colors   = require('colors')

Bucketer = require('./bucketer.coffee')
imager   = require('./imager.coffee')

app           = express()
webserver     = http.createServer(app)
basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

# Configure the express server
app.engine('.html', require('ejs').__express)
app.use(favicon(faviconPath))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))

# Find an available port
port = process.env.PORT || 3002
if port > 3002
  webserver.listen(port)
else
  findPort port, port + 100, (ports) ->
    webserver.listen(ports[0])

# Notify the console that we're connected and on what port
webserver.on 'listening', ->
  address = webserver.address()
  console.log "[Firepit] Server running at http://#{address.address}:#{address.port}".green

#
# Routes
# -----------------

# Root
app.get '/', (req, res) -> res.render(path.join(generatedPath, 'index.html'))

# Avatars: Basic Route
app.get '/avatar/:name', (req, res) ->
  bucketer = new Bucketer(10)
  bucket = bucketer.bucketFor(req.params.name)
  res.sendfile( path.join(generatedPath, "img", "avatar#{bucket}.png") )

# Avatars: Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->
  bucketer = new Bucketer(10)
  bucket = bucketer.bucketFor(req.params.name)
  imgPath = path.join(generatedPath, "img", "avatar#{bucket}.png")
  imager.resize(imgPath, req.params.size, req, res, next)


module.exports = webserver
