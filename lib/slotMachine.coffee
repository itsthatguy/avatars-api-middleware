class SlotMachine
  constructor: (slots, hashingFn) ->
    @slots = slots
    @numSlots = @slots.length
    @hashingFn = hashingFn || @_defaultHashingFn

  pull: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @slots[@_indexFor(stringArray)]

  _indexFor: (array) ->
    intArray = array.map(@_getCharInt)
    @hashingFn(intArray) % @numSlots

  _defaultHashingFn: (array) ->
    array.reduce(@_sum, 0)

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

  _sum: (a, b) -> (a + b)

module.exports = SlotMachine
