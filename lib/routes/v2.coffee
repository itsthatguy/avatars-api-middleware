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

# list out face part possibilities
router.get '/list', (req, res, next) ->
  response = face: {}
  partTypes.forEach (type) ->
    response.face[type] = ImageFiles.allNames(type)

  res
    .set('Content-Type', 'application/json')
    .send(response)

router.get '/:id', (req, res, next) ->
  imager.combine req.faceParts, false, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

# with custom size
router.get '/:size/:id', (req, res, next) ->
  imager.combine req.faceParts, req.params.size, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)
  , req.params.size

# with custom face parts
router.get '/face/:eyes/:nose/:mouth/:color/:size?', (req, res, next) ->
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

  imager.combine faceParts, req.params.size, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router