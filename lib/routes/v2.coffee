router = require('express').Router()

ImageFiles = require('../imageFiles.coffee')
common     = require('./common.coffee')
imager     = require('../imager.coffee')
potato     = require('../potato.coffee')
partTypes  = ['eyes', 'nose', 'mouth']

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
  faceParts = color: "##{req.params.color}"

  partTypes.forEach (type) ->
    possibleFileNames = ImageFiles.allNames(type)
    requestedFileName = req.params[type]

    fileName = if requestedFileName in possibleFileNames
      requestedFileName
    else if requestedFileName == 'x'
      ''
    else
      possibleFileNames[0]

    faceParts[type] = ImageFiles.pathFor(type, fileName)

  imager.combine faceParts, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router
