path        = require('path')
gm          = require('gm')
imageMagick = gm.subClass({ imageMagick: true })

class Imager
  minSize: 40
  maxSize: 400

  combine: (face, size, callback) ->
    if callback?
      size = @_parseSize(size)
    else
      callback = size
      size = width: @maxSize, height: @maxSize

    imageMagick()
      .quality(0)
      .in(face.eyes)
      .in(face.nose)
      .in(face.mouth)
      .background(face.color)
      .mosaic()
      .resize(size.width, size.height)
      .trim()
      .gravity('Center')
      .extent(size.width, size.height)
      .stream('png', callback)

  resize: (imagePath, size, callback) ->
    size = @_parseSize(size)

    imageMagick(imagePath)
      .resize(size.width, size.height)
      .trim()
      .autoOrient()
      .stream('png', callback)

  _clamp: (num) -> return Math.min(Math.max(num, @minSize), @maxSize)

  _parseSize: (size) ->
    [width, height] = size.split("x")
    height?= width
    return { width: @_clamp(width), height: @_clamp(height) }

module.exports = new Imager()
