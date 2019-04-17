import Router from 'express';
import uuid from 'uuid';

import { allNames, pathFor } from '../lib/imageFiles';
import { combine } from '../lib/imager';
import potato from '../lib/potato';

const partTypes = ['eyes', 'nose', 'mouth'];

const router = Router();

const sendImage = ({ stdout, response }) => {
  response.setHeader('Expires', new Date(Date.now() + 604800000));
  response.setHeader('Content-Type', 'image/png');
  stdout.pipe(response);
};

router.param('id', (req, res, next, id) => {
  const faceParts = potato.parts(id);
  // @ts-ignore
  req.faceParts = faceParts;
  return next();
});

router.get('/list', (req, res) => {
  const response = { face: {} };

  partTypes.forEach(type => {
    response.face[type] = allNames(type);
  });

  return res.set('Content-Type', 'application/json').send(response);
});

router.get('/:size?/random', (req, res) => {
  const faceParts = potato.parts(uuid.v4());

  return combine(faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

router.get('/:size?/:id', (req, res, next) => {
  // @ts-ignore
  return combine(req.faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

router.get('/face/:eyes/:nose/:mouth/:color/:size?', (req, res, next) => {
  const faceParts = { color: '#' + req.params.color };

  partTypes.forEach(type => {
    const possibleFileNames = allNames(type);
    const requestedFileName = req.params[type];

    let fileName;
    if (possibleFileNames.includes(requestedFileName)) {
      fileName = requestedFileName;
    } else if (requestedFileName === 'x') {
      fileName = '';
    } else {
      fileName = possibleFileNames[0];
    }

    faceParts[type] = pathFor(type, fileName);
  });

  return combine(faceParts, req.params.size, (err, stdout) =>
    sendImage({ stdout, response: res }),
  );
});

export default router;
