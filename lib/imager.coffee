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
      cropOffset = @parseCrop(size)
    else
      callback = size
      size = width: @maxSize, height: @maxSize

    imageMagick()
      .in(face.eyes)
      .in(face.nose)
      .in(face.mouth)
      .mosaic()
      .trim()
      .gravity('Center')
      .resize(size.width, size.height, "^")
      .background(face.color)
      .extent(@maxSize, @maxSize)
      .stream('png', callback)

  parseCrop: (size) ->
    return {
      horizontal: Math.max(0, size.height-size.width) / 2
      vertical: Math.max(0, size.width-size.height) / 2
    }

  clamp: (num) -> return Math.min(Math.max(num, @minSize), @maxSize)

  parseSize: (size) ->
    [width, height] = size.split("x")
    height?= width
    return { width: @clamp(width), height: @clamp(height) }

module.exports = new Imager()
