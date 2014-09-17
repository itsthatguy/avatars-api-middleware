module.exports = class
  @_addition: (a, b) -> (a + b)
  @_subtraction: (a, b) -> (a - b)
  @_multiplication: (a, b) -> (a * b)

  @sum: (array) =>
    array.reduce(@_addition, 0)

  @sumAndDiff: (array) =>
    array.reduce (prev, curr, index) =>
      if index % 2 == 0
        @_addition(prev, curr)
      else
        @_subtraction(prev, curr)
    , 0

  @product: (array) =>
    array.reduce(@_multiplication, 1)
