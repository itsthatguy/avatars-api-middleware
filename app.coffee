
http        = require('http')
express     = require('express')
path        = require('path')
gm          = require('gm')
imageMagick = gm.subClass({ imageMagick: true })


app = express()
webserver = http.createServer(app)
basePath = path.join(__dirname)
staticPath = path.join(basePath, '/.generated/')

app.engine('html', require('ejs').renderFile)

app.configure ->
  app.use('/assets', express.static(staticPath))
  app.use('/vendor', express.static(basePath + '/bower_components/'))

port = process.env.PORT || 3007
webserver.listen(port)

app.get '/', (req, res) ->
  res.render(path.join(staticPath, "index.html"))

max = 10

class Algorhythmic
  getNum: (val) ->
    newVal = val % max + 1
    return newVal

  compute: (arr) ->
    arr.reduce (p, n, i) =>
      p = parseInt p.charCodeAt('0') unless i > 1
      n = parseInt n.charCodeAt('0')
      return @getNum(p + n)

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    id = @compute(stringArray)

  parseSize: (size) ->
    size = size.split("x")
    return { width: size[0], height: size[1] }


# Basic Route
app.get '/avatar/:name', (req, res) ->
  a = new Algorhythmic()
  id = a.convert(req.params.name)
  res.sendfile( path.join(staticPath, "img", "avatar#{id}.png") )

# Route with custom Size
app.get '/avatar/:size/:name', (req, res, next) ->

  a = new Algorhythmic()
  id = a.convert(req.params.name)
  size = a.parseSize(req.params.size)
  imgPath = path.join(staticPath, "img", "avatar#{id}.png")

  cropOffset = { h: Math.max(0, size.height-size.width)/2, v: Math.max(0, size.width-size.height)/2 }
  console.log cropOffset

  imageMagick( imgPath )
  .resize(size.width, size.height, "^")
  .crop(size.width, size.height, cropOffset.h, cropOffset.v)
  .autoOrient()
  .stream 'png', (err, stdout) ->
    return next(err) if (err)
    res.setHeader('Expires', new Date(Date.now() + 604800000))
    res.setHeader('Content-Type', 'image/png')
    stdout.pipe(res)



module.exports = webserver
