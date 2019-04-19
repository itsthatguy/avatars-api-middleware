import sharp from 'sharp';

export type Size = { height: number; width: number };

const minSize = 40;
const maxSize = 400;

const clamp = (num: number): number => {
  return Math.min(Math.max(num, minSize), maxSize);
};

export const toSize = (rawSize: string): Size => {
  const [rawWidth, rawHeight] = rawSize.toLowerCase().split('x');
  const width = clamp(Number(rawWidth) || 0);
  const height = rawHeight ? clamp(Number(rawHeight) || 0) : width;

  return { width, height };
};

export const combine = (face: Face) => {
  return sharp({
    create: {
      width: maxSize,
      height: maxSize,
      channels: 4,
      background: face.color,
    },
  })
    .composite([
      { input: face.eyes },
      { input: face.mouth },
      { input: face.nose },
    ])
    .png();
};

export const resize = (rawSize: string) => {
  const size = toSize(rawSize);
  return sharp().resize(size.width, size.height);
};
