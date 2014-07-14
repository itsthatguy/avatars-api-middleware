class Algorhythmic
  max: 10

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @_compute(stringArray) + 1

  _compute: (array) ->
    array
    .map(@_getCharInt)
    .reduce(@_sumModulo(@max), 0)

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

  _sumModulo: (modulus) ->
    (a, b) -> (a + b) % modulus

module.exports = new Algorhythmic()
