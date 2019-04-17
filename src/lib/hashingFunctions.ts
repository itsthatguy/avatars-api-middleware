const isEven: (num: number) => boolean = num => num % 2 === 0;

export const sum: (array: number[]) => number = arr =>
  arr.reduce((a, b) => a + b, 0);

export const sumAndDiff: (array: number[]) => number = array =>
  array.reduce(
    (prev, curr, index) => (isEven(index) ? prev + curr : prev - curr),
    0,
  );
