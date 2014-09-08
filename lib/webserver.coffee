
http     = require('http')
express  = require('express')
fs       = require('fs')
path     = require('path')
favicon  = require('serve-favicon')
findPort = require('find-port')
colors   = require('colors')

SlotMachine = require('./slotMachine.coffee')
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

imageFiles = fs.readdirSync(path.join(generatedPath, 'img'))

# Root
app.get '/', (req, res) -> res.render(path.join(generatedPath, 'index.html'))

# Avatars: Basic Route
app.get '/avatar/:name', (req, res) ->
  slotMachine = new SlotMachine(imageFiles)
  image = slotMachine.pull(req.params.name)
  res.sendfile( path.join(generatedPath, "img", image) )

# Avatars: Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->
  slotMachine = new SlotMachine(imageFiles)
  image = slotMachine.pull(req.params.name)
  imgPath = path.join(generatedPath, "img", image)
  imager.resize(imgPath, req.params.size, req, res, next)


module.exports = webserver
