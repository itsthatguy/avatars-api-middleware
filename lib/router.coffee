express = require('express')
fs      = require('fs')
path    = require('path')
router  = express.Router()

# our libs
SlotMachine = require('./slotMachine.coffee')
Tracker     = require('./tracker.coffee')
imager      = require('./imager.coffee')
potato      = require('./potato.coffee')

# Helper function for the stream callback
sendImage = (err, stdout, req, res, next) ->
  res.setHeader('Expires', new Date(Date.now() + 604800000))
  res.setHeader('Content-Type', 'image/png')
  stdout.pipe(res)

# Tracking
if process.env.NODE_ENV == 'production'
  router.use (req, res, next) ->
    tracker.track(
      'API request',
      url: req.url,
      referrer: req.get('Referrer'),
      ip: req.ip,
      next
    )

# Root
router.get '/', (req, res) ->
  res.redirect('http://avatars.adorable.io')

# V1 (static)
imagePath = path.join(__dirname, '..', '.generated', 'img')
imageFiles = fs.readdirSync(imagePath)
               .filter (imageFile) ->
                 imageFile.match(/\.png/)
               .map (imageFile) ->
                 path.join(imagePath, imageFile)

imageSlotMachine = new SlotMachine(imageFiles)

router.param 'idV1', (req, res, next, id) ->
  image = imageSlotMachine.pull(id)
  req.imagePath = image
  next()

router.get '/avatar/:idV1', (req, res, next) ->
  res.sendFile(req.imagePath)

router.get '/avatar/:size/:idV1', (req, res, next) ->
  res.sendFile(req.imagePath)

# V2 (dynamic)
router.param 'idV2', (req, res, next, id) ->
  faceParts = potato.parts(id)
  req.faceParts = faceParts
  next()

# Avatars: Basic Route
router.get '/avatars/:idV2', (req, res, next) ->
  imager.combine req.faceParts, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

# Avatars: Route with custom Size
router.get '/avatars/:size/:idV2', (req, res, next) ->
  imager.combine req.faceParts, req.params.size, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

module.exports = router
