path   = require('path')
router = require('express').Router()

common = require('./common.coffee')
imager = require('../imager.coffee')
potato = require('../potato.coffee')

router.param 'id', (req, res, next, id) ->
  faceParts = potato.parts(id)
  req.faceParts = faceParts
  next()

router.get '/:id', (req, res, next) ->
  imager.combine req.faceParts, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

# with custom size
router.get '/:size/:id', (req, res, next) ->
  imager.combine req.faceParts, req.params.size, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

# with custom face parts
router.get '/face/:eyes/:nose/:mouth/:color', (req, res, next) ->
  pathFor = (type, name) -> path.join(common.imageDir, type, "#{name}.png")
  {eyes, nose, mouth, color} = req.params

  faceParts =
    eyes: pathFor('eyes', eyes)
    nose: pathFor('nose', nose)
    mouth: pathFor('mouth', mouth)
    color: "##{color}"

  imager.combine faceParts, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router
