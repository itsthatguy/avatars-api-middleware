
class Algorhythmic
  max: 10
  getNum: (val) ->
    newVal = val % @max + 1
    return newVal

  compute: (arr) ->
    arr.reduce (p, n, i) =>
      p = parseInt p.charCodeAt('0') unless i > 1
      n = parseInt n.charCodeAt('0')
      return @getNum(p + n)

  convert: (string) ->
    str = string.replace(/\.(png|jpg|gif|)$/g, "")
    stringArray = str.split('')
    return @compute(stringArray)


module.exports = new Algorhythmic()
