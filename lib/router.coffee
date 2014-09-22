express = require('express')
fs      = require('fs')
path    = require('path')
router  = express.Router()

# our libs
SlotMachine = require('./slotMachine.coffee')
Tracker     = require('./tracker.coffee')
imager      = require('./imager.coffee')
potato      = require('./potato.coffee')

# Common definitions
sendImage = (err, stdout, req, res, next) ->
  res.setHeader('Expires', new Date(Date.now() + 604800000))
  res.setHeader('Content-Type', 'image/png')
  stdout.pipe(res)

imageDir = path.join(__dirname, '..', '.generated', 'img')

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

## V1 (STATIC)
imageFiles = fs.readdirSync(imageDir)
               .filter (imageFile) ->
                 imageFile.match(/\.png/)
               .map (imageFile) ->
                 path.join(imageDir, imageFile)

imageSlotMachine = new SlotMachine(imageFiles)

router.param 'idV1', (req, res, next, id) ->
  image = imageSlotMachine.pull(id)
  req.imagePath = image
  next()

router.get '/avatar/:idV1', (req, res, next) ->
  res.sendFile(req.imagePath)

# with custom size
router.get '/avatar/:size/:idV1', (req, res, next) ->
  imager.resize req.imagePath, req.params.size, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

## V2 (DYNAMIC)
router.param 'idV2', (req, res, next, id) ->
  faceParts = potato.parts(id)
  req.faceParts = faceParts
  next()

router.get '/avatars/:idV2', (req, res, next) ->
  imager.combine req.faceParts, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

# with custom size
router.get '/avatars/:size/:idV2', (req, res, next) ->
  imager.combine req.faceParts, req.params.size, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

# with custom face parts
router.get '/avatars/face/:eyes/:nose/:mouth/:color', (req, res, next) ->
  pathFor = (type, name) -> path.join(imageDir, type, "#{name}.png")
  {eyes, nose, mouth, color} = req.params

  faceParts =
    eyes: pathFor('eyes', eyes)
    nose: pathFor('nose', nose)
    mouth: pathFor('mouth', mouth)
    color: "##{color}"

  imager.combine faceParts, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

module.exports = router
