gm          = require('gm')
imageMagick = gm.subClass({ imageMagick: true })

class Imager
  minSize: 40
  maxSize: 400

  resize: (imgPath, size, req, res, next) ->
    size = @parseSize(size)
    cropOffset = @parseCrop(size)

    imageMagick( imgPath )
    .resize(size.width, size.height, "^")
    .crop(size.width, size.height, cropOffset.horizontal, cropOffset.vertical)
    .autoOrient()
    .stream 'png', (err, stdout) ->
      return next(err) if (err)
      res.setHeader('Expires', new Date(Date.now() + 604800000))
      res.setHeader('Content-Type', 'image/png')
      stdout.pipe(res)

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
