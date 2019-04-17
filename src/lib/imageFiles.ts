import fs from 'fs';
import path from 'path';

const IMAGE_DIR = path.join(__dirname, '..', 'img');

const imageFiles: (path: string) => string[] = p =>
  fs.readdirSync(p).filter(fileName => fileName.match(/\.png$/));

const imageDir: (type: ImageType) => string = type =>
  type ? path.join(IMAGE_DIR, type) : IMAGE_DIR;

export const allNames: (type: ImageType) => string[] = type =>
  imageFiles(imageDir(type)).map(imageFileName =>
    imageFileName.replace(/\.png/, ''),
  );

export const allPaths: (type: ImageType) => string[] = type => {
  const dir = imageDir(type);
  return imageFiles(dir).map(file => path.join(dir, file));
};

export const pathTo: (type: ImageType, name: string) => string = (type, name) =>
  path.join(imageDir(type), name + '.png');
