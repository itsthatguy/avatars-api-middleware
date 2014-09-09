class SlotMachine
  constructor: -> return

  pull: (slots, string) ->
    @numBuckets = slots.length
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return slots[@_compute(stringArray)]

  _compute: (array) ->
    array
    .map(@_getCharInt)
    .reduce(@_sumModulo(@numBuckets), 0)

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

  _sumModulo: (modulus) ->
    (a, b) -> (a + b) % modulus

module.exports = new SlotMachine()
