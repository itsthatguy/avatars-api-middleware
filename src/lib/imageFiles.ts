import path from 'path';
import { filePaths, fileNames } from 'avatars-utils';

const imageDir = path.join(__dirname, '..', 'img');

export const imageFilePaths = (type: string): string[] =>
  filePaths(path.join(imageDir, type));

export const imageFileNames = (type: string): string[] =>
  fileNames(path.join(imageDir, type));

export const eyeImages = imageFilePaths('eyes');
export const noseImages = imageFilePaths('nose');
export const mouthImages = imageFilePaths('mouth');
