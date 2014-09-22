express = require('express')
router  = express.Router()

# our libs
imager  = require('./imager.coffee')
Tracker = require('./tracker.coffee')
potato  = require('./potato.coffee')

# Helper function for the stream callback
sendImage = (err, stdout, req, res, next) ->
  res.setHeader('Expires', new Date(Date.now() + 604800000))
  res.setHeader('Content-Type', 'image/png')
  stdout.pipe(res)

# Determine which avatar to serve
router.param 'name', (req, res, next, id) ->
  faceParts = potato.parts(id)

  req.faceParts = faceParts
  next()

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

# Avatars: Basic Route
router.get '/avatar/:name', (req, res, next) ->
  imager.combine req.faceParts, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

# Avatars: Route with custom Size
router.get '/avatar/:size/:name', (req, res, next) ->
  imager.combine req.faceParts, req.params.size, (err, stdout) ->
    sendImage(err, stdout, req, res, next)

module.exports = router
