# node libs
fs            = require('fs')
path          = require('path')

# our libs
slotMachine   = require('./slotMachine.coffee')

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
    @eyesFiles  = @files('eyes')
    @noseFiles  = @files('nose')
    @mouthFiles = @files('mouth')

  files: (part) ->
    fs.readdirSync(path.join(generatedPath, 'img', part)).map (val) ->
      path.join(generatedPath, 'img', part, val)

  # Construct Faces Parts
  parts: (string) ->
    return {
      eyes  : slotMachine.pull(@eyesFiles, string)
      nose  : slotMachine.pull(@noseFiles, string)
      mouth : slotMachine.pull(@mouthFiles, string)
      color : slotMachine.pull(@colors, string)
    }

module.exports = new Potato()
