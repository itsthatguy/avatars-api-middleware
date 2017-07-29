const _addition = (a, b) => {
  return a + b;
};

const _subtraction = (a, b) => {
  return a - b;
};

const _multiplication = (a, b) => {
  return a * b;
};

export const sum = (array) => {
  return array.reduce(_addition, 0);
};

export const sumAndDiff = (array) => {
  return array.reduce(function(prev, curr, index) {
    if (index % 2 === 0) {
      return _addition(prev, curr);
    } else {
      return _subtraction(prev, curr);
    }
  }, 0);
};

export const product = (array) => {
  return array.reduce(_multiplication, 1);
};
