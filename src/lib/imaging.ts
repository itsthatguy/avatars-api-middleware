import sharp from 'sharp';
import { parseSizeFactory } from 'avatars-utils';
import { Face } from './FaceFactory';

const minSize = 40;
const maxSize = 400;

export const parseSize = parseSizeFactory(minSize, maxSize);

export const combine = (face: Face) =>
  sharp({
    create: {
      width: maxSize,
      height: maxSize,
      channels: 4,
      background: face.color,
    },
  }).composite([
    { input: face.eyes },
    { input: face.mouth },
    { input: face.nose },
  ]);

export const resize = (rawSize: string) => {
  const size = parseSize(rawSize);
  return sharp().resize(size.width, size.height);
};
