router = require('express').Router()

ImageFiles = require('../imageFiles.coffee')
common     = require('./common.coffee')
imager     = require('../imager.coffee')
potato     = require('../potato.coffee')
partTypes  = ['eyes', 'nose', 'mouth']


pg = require('pg-promise')()

cn =
  'host': 'localhost'
  'port': 5432
  'database': 'avatars'
db = pg(cn)





router.param 'id', (req, res, next, id) ->
  [faceKey, faceParts] = potato.parts(id)
  req.faceParts = faceParts
  req.faceKey = faceKey
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
  db.query('select $1 from faces', req.faceKey)
  .then((cachedImage) ->
    if cachedImage?
      console.log('this shit do exist', cachedImage)
      return res.sendImage(err, cachedImage.image, req, res, next)
    else
      imager.combine req.faceParts, (err, stdout) ->
        console.log('this shit don\'t exist')
        db.query('insert into faces (face_key, image) values ($1, $2)', req.faceKey, stdout)
        common.sendImage(err, stdout, req, res, next)
  )

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
