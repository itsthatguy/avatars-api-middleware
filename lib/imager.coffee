path        = require('path')
gm          = require('gm')
imageMagick = gm.subClass({ imageMagick: true })

basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')

class Imager
  minSize: 40
  maxSize: 400

  combine: (face, size, callback) ->
    if callback?
      size = @parseSize(size)
    else
      callback = size
      size = width: @maxSize, height: @maxSize

    imageMagick()
      .in(face.eyes)
      .in(face.nose)
      .in(face.mouth)
      .mosaic()
      .resize(size.width, size.height)
      .trim()
      .autoOrient()
      .gravity('Center')
      .extent(size.width, size.height)
      .background(face.color)
      .stream('png', callback)

  clamp: (num) -> return Math.min(Math.max(num, @minSize), @maxSize)

  parseSize: (size) ->
    [width, height] = size.split("x")
    height?= width
    return { width: @clamp(width), height: @clamp(height) }

module.exports = new Imager()
