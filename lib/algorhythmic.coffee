class Algorhythmic
  max: 10

  compute: (array) ->
    array
    .map(@getCharInt)
    .reduce((previousInt, currentInt) =>
      (previousInt + currentInt) % @max
    , 0) + 1

  getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @compute(stringArray)

module.exports = new Algorhythmic()
