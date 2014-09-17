module.exports = class
  @_addition: (a, b) -> (a + b)
  @_multiplication: (a, b) -> (a * b)

  @sum: (array) =>
    array.reduce(@_addition, 0)

  @product: (array) =>
    array.reduce(@_multiplication, 1)
