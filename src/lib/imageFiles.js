import fs from 'fs';
import path from 'path';

const imageDir = path.join(__dirname, '..', 'img');

export const dirFor = (type) => {
  if (type) return path.join(imageDir, type);
  else return imageDir;
};

export const allNames = (type) => {
  return fs.readdirSync(dirFor(type)).filter(function(imageFileName) {
    return imageFileName.match(/\.png/);
  }).map(function(imageFileName) {
    return imageFileName.replace(/\.png/, '');
  });
};

export const allPaths = (type) => {
  var dir;
  dir = dirFor(type);
  return allNames(type).map(function(name) {
    return path.join(dir, name + '.png');
  });
};

export const pathFor = (type, fileName) => {
  return path.join(dirFor(type), fileName + '.png');
};
