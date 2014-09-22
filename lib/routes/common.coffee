path = require('path')

module.exports =
  sendImage: (err, stdout, req, res, next) ->
    res.setHeader('Expires', new Date(Date.now() + 604800000))
    res.setHeader('Content-Type', 'image/png')
    stdout.pipe(res)

  imageDir: path.join(__dirname, '..', '..', '.generated', 'img')
