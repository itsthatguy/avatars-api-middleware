
class Algorhythmic
  max: 10
  getNum: (val) ->
    newVal = val % @max + 1
    return newVal

  compute: (arr) ->
    if arr.length == 1
      char = @getCharInt(arr[0])
      return @getNum(char)

    arr.reduce (previousChar, currentChar, i) =>
      previousChar = @getCharInt(previousChar) unless i > 1
      currentChar  = @getCharInt(currentChar)
      return @getNum(previousChar + currentChar)

  getCharInt: (char) -> parseInt char.charCodeAt(0) or 0

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @compute(stringArray)


module.exports = new Algorhythmic()
