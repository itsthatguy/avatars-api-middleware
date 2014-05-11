
http    = require('http')
express = require('express')
path    = require('path')


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
    str = string
    stringArray = str.split('')
    id = a.compute(stringArray)


app.get '/avatar/:name', (req, res) ->
  a = new Algorhythmic()
  id = a.convert(req.params.name)
  res.sendfile((path.join(staticPath, "img", "avatar#{id}.png")))


module.exports = webserver
