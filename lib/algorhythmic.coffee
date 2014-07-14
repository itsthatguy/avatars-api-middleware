class Algorhythmic
  max: 10

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @_compute(stringArray) + 1

  _compute: (array) ->
    array
    .map(@_getCharInt)
    .reduce((previousInt, currentInt) =>
      (previousInt + currentInt) % @max
    , 0)

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

module.exports = new Algorhythmic()
