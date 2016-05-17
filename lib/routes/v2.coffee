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
  db.query('select image from faces where face_key=$1', req.faceKey)
  .then((results) ->
    if results.length
      console.log "GOT IT FROM DA CACHE"
      cachedImage = results[0].image
      return res.end(cachedImage)
    else
      chunks = []
      imager.combine req.faceParts, (err, stream) ->
        stream.on('data', (chunk) -> chunks.push chunk)
        stream.on('end', ->
          data = Buffer.concat(chunks)
          db.query('insert into faces (face_key, image) values ($1, $2)', [req.faceKey, data])
          .then -> console.log "image for " + req.faceKey + " cached successfully."
          .catch -> console.log "Error while trying to cache " + req.faceKey, arguments
        )
        common.sendImage(err, stream, req, res, next)
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
