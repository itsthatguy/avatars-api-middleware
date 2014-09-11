http     = require('http')
express  = require('express')
fs       = require('fs')
path     = require('path')
favicon  = require('serve-favicon')
findPort = require('find-port')
colors   = require('colors')

SlotMachine = require('./slotMachine.coffee')
Tracker = require('./tracker.coffee')
imager   = require('./imager.coffee')

app           = express()
router        = express.Router()
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

port = process.env.PORT || 3002
env = process.env.NODE_ENV

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

#
# Routing
# -----------------
imageFiles = fs.readdirSync(path.join(generatedPath, 'img'))
slotMachine = new SlotMachine(imageFiles)

# Determine which avatar to serve
router.param 'name', (req, res, next, id) ->
  image = slotMachine.pull(id)

  req.image = image
  req.imagePath = path.join(generatedPath, 'img', image)
  next()

# Tracking
router.use (req, res, next) ->
  if env == 'production'
    Tracker.trackPage('API request', req.url, next)

# Root
router.get '/', (req, res) ->
  res.redirect('http://avatars.adorable.io')

# Avatars: Basic Route
router.get '/avatar/:name', (req, res) ->
  res.sendFile(req.imagePath)

# Avatars: Route with custom Size
router.get '/avatar/:size/:name', (req, res, next) ->
  imager.resize(req.imagePath, req.params.size, req, res, next)

app.use('/', router)

module.exports = webserver
