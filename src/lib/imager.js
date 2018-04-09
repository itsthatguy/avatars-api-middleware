import gm          from 'gm';
const imageMagick = gm.subClass({ imageMagick: true });

const minSize = 40;
const maxSize = 400;

const _clamp = (num) => {
  return Math.min(Math.max(num, minSize), maxSize);
};

const _parseSize = (size) => {
  const ref = size.split('x');
  const width = ref[0];
  let height = ref[1];

  if (height === null) height = width;

  return {
    width: _clamp(width),
    height: _clamp(height)
  };
};

export const combine = (face, size, callback) => {
  if (size) { size = _parseSize(size); }
  else {
    size = { width: maxSize, height: maxSize };
  }

  imageMagick()
  .quality(0)
  .in(face.eyes)
  .in(face.nose)
  .in(face.mouth)
  .background(face.color)
  .mosaic()
  .resize(size.width, size.height)
  .trim()
  .gravity('Center')
  .extent(size.width, size.height)
  .stream('png', callback);
};

export const resize = (imagePath, size, callback) => {
  size = _parseSize(size);

  imageMagick(imagePath)
  .resize(size.width, size.height)
  .stream('png', callback);
};
