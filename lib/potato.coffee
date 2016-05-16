# our libs
HashingFunctions = require('./hashingFunctions.coffee')
ImageFiles       = require('./imageFiles.coffee')
SlotMachine      = require('./slotMachine.coffee')

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
    @eyesMachine  = new SlotMachine(ImageFiles.allPaths('eyes'))
    @noseMachine  = new SlotMachine(ImageFiles.allPaths('nose'))
    @mouthMachine = new SlotMachine(ImageFiles.allPaths('mouth'), HashingFunctions.sumAndDiff)

  # Construct Faces Parts
  parts: (string) ->
    [colorIndex, color] = @colorMachine.pull(string)
    [eyesIndex, eyes] = @eyesMachine.pull(string)
    [noseIndex, nose] = @noseMachine.pull(string)
    [mouthIndex, mouth] = @mouthMachine.pull(string)
    faceKey = "c#{colorIndex}e#{eyesIndex}n#{noseIndex}m#{mouthIndex}"
    faceParts = {
      color : color
      eyes  : eyes
      nose  : nose
      mouth : mouth
    }

    return [faceKey, faceParts]

module.exports = new Potato()
