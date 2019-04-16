import fs from 'fs';
import path from 'path';

const DEFAULT_IMAGE_DIR = path.join(__dirname, '..', 'img');

export const dirFor = (type, imageDir = DEFAULT_IMAGE_DIR) => {
  if (type) {
    return path.join(imageDir, type);
  }

  return imageDir;
};

export const allNames = (type, imageDir = DEFAULT_IMAGE_DIR) => {
  return fs
    .readdirSync(dirFor(type, imageDir))
    .filter(imageFileName => {
      return imageFileName.match(/\.png/);
    })
    .map(imageFileName => {
      return imageFileName.replace(/\.png/, '');
    });
};

export const allPaths = (type, imageDir = DEFAULT_IMAGE_DIR) => {
  const dir = dirFor(type, imageDir);
  return allNames(type, imageDir).map(name => path.join(dir, name + '.png'));
};

export const pathFor = (type, fileName, imageDir = DEFAULT_IMAGE_DIR) => {
  return path.join(dirFor(type, imageDir), fileName + '.png');
};
