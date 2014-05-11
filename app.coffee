
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
    arr.reduce (p, n) => return @getNum(p + n.charCodeAt('0'))

a = new Algorhythmic()

app.get '/avatar/:name', (req, res) ->
  str = req.params.name
  stringArray = str.split('')
  id = a.compute(stringArray)
  res.sendfile((path.join(staticPath, "img", "avatar#{id}.png")))


module.exports = webserver
