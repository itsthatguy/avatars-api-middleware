sum = require('./hashingFunctions').sum

class SlotMachine
  constructor: (slots, hashingFn) ->
    @slots = slots
    @numSlots = @slots.length
    @hashingFn = hashingFn || sum

  pull: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @slots[@_indexFor(stringArray)]

  _indexFor: (array) ->
    intArray = array.map(@_getCharInt)
    (@hashingFn(intArray) + intArray.length) % @numSlots

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

module.exports = SlotMachine
