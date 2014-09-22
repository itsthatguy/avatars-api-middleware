fs     = require('fs')
path   = require('path')
router = require('express').Router()

SlotMachine = require('../slotMachine.coffee')
common      = require('./common.coffee')
imager      = require('../imager.coffee')

imageFiles = fs.readdirSync(common.imageDir)
               .filter (imageFile) ->
                 imageFile.match(/\.png/)
               .map (imageFile) ->
                 path.join(common.imageDir, imageFile)

imageSlotMachine = new SlotMachine(imageFiles)

router.param 'id', (req, res, next, id) ->
  image = imageSlotMachine.pull(id)
  req.imagePath = image
  next()

router.get '/:id', (req, res, next) ->
  res.sendFile(req.imagePath)

# with custom size
router.get '/:size/:id', (req, res, next) ->
  imager.resize req.imagePath, req.params.size, (err, stdout) ->
    common.sendImage(err, stdout, req, res, next)

module.exports = router
