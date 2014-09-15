# node libs
fs            = require('fs')
path          = require('path')

# our libs
SlotMachine   = require('./slotMachine.coffee')

basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')

class Potato
  colors: [
    '#81bef1'
    '#ad8bf2'
    '#bff288'
    '#de7878'
    '#a5aac5'
    '#6ff2c5'
    '#f0da5e'
    '#eb5972'
    '#f6be5d'
  ]

  constructor: ->
    @colorMachine = new SlotMachine(@colors)
    @eyesMachine  = new SlotMachine(@files('eyes'))
    @noseMachine  = new SlotMachine(@files('nose'))
    @mouthMachine = new SlotMachine @files('mouth'), (array) ->
      array.reduce(((a, b) -> a * b), 0)

  files: (part) ->
    fs.readdirSync(path.join(generatedPath, 'img', part)).map (val) ->
      path.join(generatedPath, 'img', part, val)

  # Construct Faces Parts
  parts: (string) ->
    return {
      color : @colorMachine.pull(string)
      eyes  : @eyesMachine.pull(string)
      nose  : @noseMachine.pull(string)
      mouth : @mouthMachine.pull(string)
    }

module.exports = new Potato()
