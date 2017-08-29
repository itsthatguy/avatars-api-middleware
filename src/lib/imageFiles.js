import fs from 'fs';
import path from 'path';

const DEFAULT_IMAGE_DIR = path.join(__dirname, '..', 'img');

export const dirFor = (type, imageDir) => {
  if (type) return path.join(imageDir, type);
  else return imageDir;
};

export const allNames = (type, imageDir) => {
  return fs.readdirSync(dirFor(type, imageDir)).filter(function(imageFileName) {
    return imageFileName.match(/\.png/);
  }).map(function(imageFileName) {
    return imageFileName.replace(/\.png/, '');
  });
};

export const allPaths = (type, imageDir = DEFAULT_IMAGE_DIR) => {
  var dir;
  dir = dirFor(type, imageDir);
  return allNames(type, imageDir).map(function(name) {
    return path.join(dir, name + '.png');
  });
};

export const pathFor = (type, fileName) => {
  return path.join(dirFor(type), fileName + '.png');
};
