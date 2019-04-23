import path from 'path';
import { filePaths, fileNames } from 'avatars-utils';
import { Face } from './FaceFactory';

const imageDir = path.join(__dirname, '..', 'img');

export const imageFilePaths = (type: keyof Face): string[] =>
  filePaths(path.join(imageDir, type));

export const imageFileNames = (type: keyof Face): string[] =>
  fileNames(path.join(imageDir, type));

export const eyeImages = imageFilePaths('eyes');
export const noseImages = imageFilePaths('nose');
export const mouthImages = imageFilePaths('mouth');
