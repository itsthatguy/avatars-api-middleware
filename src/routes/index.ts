import Router, { Response } from 'express';
import uuid from 'uuid';

import { imageFileNames, imageFilePaths } from '../lib/imageFiles';
import { combine, resize } from '../lib/imaging';
import FaceFactory from '../lib/FaceFactory';

const imageTypes: ImageType[] = ['eyes', 'nose', 'mouth'];

const router = Router();

const pngResponse = (response: Response) => {
  response.setHeader('Expires', new Date(Date.now() + 604800000).toUTCString());
  return response.type('image/png');
};

router.get('/list', (req, res) => {
  const face = {};
  imageTypes.forEach(type => (face[type] = imageFileNames(type)));

  res.set('Content-Type', 'application/json').send({ face });
});

router.get('/:size?/random', (req, res) => {
  const { size } = req.params;
  const face = FaceFactory.create(uuid.v4());

  combine(face)
    .pipe(resize(size))
    .pipe(pngResponse(res));
});

router.get('/:size?/:id', (req, res, next) => {
  const { id, size } = req.params;
  const face = FaceFactory.create(id);

  combine(face)
    .pipe(resize(size))
    .pipe(pngResponse(res));
});

router.get('/face/:eyes/:nose/:mouth/:color/:size?', (req, res, next) => {
  const { color, size } = req.params;
  const face = { color: `#${color}` } as Face;

  imageTypes.forEach(type => {
    const requestedName = req.params[type];
    const paths = imageFilePaths(type);
    face[type] = paths.find(path => !!path.match(requestedName)) || paths[0];

    if (requestedName === 'x') {
      face[type] = '';
    }
  });

  combine(face)
    .pipe(resize(size))
    .pipe(pngResponse(res));
});

export default router;
