module.exports = class
  @_addition: (a, b) -> (a + b)
  @_multiplication: (a, b) -> (a * b)

  @sum: (array) =>
    array.reduce(@_addition, 0)

  @reverseSum: (array) =>
    array.reverse().reduce(@_addition, 0)

  @product: (array) =>
    array.reduce(@_multiplication, 0)

  @reverseProduct: (array) =>
    array.reverse().reduce(@_multiplication, 0)
