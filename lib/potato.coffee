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
    return {
      color : @colorMachine.pull(string)
      eyes  : @eyesMachine.pull(string)
      nose  : @noseMachine.pull(string)
      mouth : @mouthMachine.pull(string)
    }

module.exports = new Potato()
