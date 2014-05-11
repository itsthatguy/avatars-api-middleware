


class tst
  fn: (val) ->
    max = 16
    newVal = val % max + 1

    return newVal

  f2: (arr) ->
    arr.reduce (p, n) =>
      return @fn p + n
module.exports = new tst()