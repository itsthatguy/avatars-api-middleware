import Router from 'express';
import uuid from 'uuid';

import { imageFileNames, imageFilePaths } from '../lib/imageFiles';
import { combine } from '../lib/imager';
import potato from '../lib/potato';

const imageTypes: ImageType[] = ['eyes', 'nose', 'mouth'];

const router = Router();

const sendImage = ({ stdout, response }) => {
  response.setHeader('Expires', new Date(Date.now() + 604800000));
  response.setHeader('Content-Type', 'image/png');
  stdout.pipe(response);
};

router.get('/list', (req, res) => {
  const face = {};
  imageTypes.forEach(type => (face[type] = imageFileNames(type)));

  return res.set('Content-Type', 'application/json').send({ face });
});

router.get('/:size?/random', (req, res) => {
  const faceParts = potato.parts(uuid.v4());

  return combine(faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

router.get('/:size?/:id', (req, res, next) => {
  const faceParts = potato.parts(req.params.id);

  return combine(faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

router.get('/face/:eyes/:nose/:mouth/:color/:size?', (req, res, next) => {
  const faceParts = { color: `#${req.params.color}` };

  imageTypes.forEach(type => {
    const requestedName = req.params[type];
    const paths = imageFilePaths(type);
    faceParts[type] =
      paths.find(path => !!path.match(requestedName)) || paths[0];

    if (requestedName === 'x') {
      faceParts[type] = '';
    }
  });

  return combine(faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

export default router;
