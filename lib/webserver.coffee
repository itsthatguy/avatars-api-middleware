# node packages
http     = require('http')
express  = require('express')
path     = require('path')
favicon  = require('serve-favicon')
findPort = require('find-port')
colors   = require('colors')

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
app.get '/', (req, res) ->
  res.redirect('http://avatars.adorable.io')
app.use('/avatar', require('./routes/v1'))
app.use('/avatars', require('./routes/v2'))
if process.env.NODE_ENV == 'production'
  app.use(require('./tracker'))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))

port = process.env.PORT || 3002

# Find an available port
if port > 3002
  webserver.listen(port)
else
  findPort port, port + 100, (ports) ->
    webserver.listen(ports[0])

# Notify the console that we're connected and on what port
webserver.on 'listening', ->
  address = webserver.address()
  console.log "[Firepit] Server running at http://#{address.address}:#{address.port}".green

module.exports = webserver
