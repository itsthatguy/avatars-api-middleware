class Algorhythmic
  max: 10

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @_compute(stringArray)

  _compute: (array) ->
    array
    .map(@_getCharInt)
    .reduce((previousInt, currentInt) =>
      (previousInt + currentInt) % @max
    , 0) + 1

  _getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

module.exports = new Algorhythmic()
