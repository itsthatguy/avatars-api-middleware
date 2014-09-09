# node packages
http          = require('http')
express       = require('express')
fs            = require('fs')
path          = require('path')
favicon       = require('serve-favicon')
findPort      = require('find-port')
colors        = require('colors')

# our libs
potato        = require('./potato.coffee')
imager        = require('./imager.coffee')

# configuration
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

# Helper function for the stream callback
sendFile = (err, stdout, req, res, next) ->
  res.setHeader('Expires', new Date(Date.now() + 604800000))
  res.setHeader('Content-Type', 'image/png')
  stdout.pipe(res)

# Root
app.get '/', (req, res) -> res.redirect('http://avatars.adorable.io')

# Avatars: Basic Route
app.get '/avatar/:name', (req, res, next) ->
  faceParts = potato.parts(req.params.name)
  face = imager.combine faceParts, (err, stdout) ->
    sendFile(err, stdout, req, res, next)

# Avatars: Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->
  faceParts = potato.parts(req.params.name)
  imager.resize faceParts, req.params.size, (err, stdout) ->
    sendFile(err, stdout, req, res, next)


module.exports = webserver
