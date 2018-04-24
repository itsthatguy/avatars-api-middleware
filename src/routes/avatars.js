import Router from 'express';
import uuid from 'uuid';

import { allNames, pathFor } from '../lib/imageFiles';
import common from './common';
import { combine } from '../lib/imager';
import potato from '../lib/potato';

const partTypes = ['eyes', 'nose', 'mouth'];

// eslint-disable-next-line new-cap
const router = Router();

router.param('id', function(req, res, next, id) {
  var faceParts;
  faceParts = potato.parts(id);
  req.faceParts = faceParts;
  return next();
});

router.get('/list', function(req, res) {
  let response = { face: {} };

  partTypes.forEach(function(type) {
    response.face[type] = allNames(type);
  });

  return res.set('Content-Type', 'application/json').send(response);
});

router.get('/:size?/random', function(req, res) {
  var faceParts;
  faceParts = potato.parts(uuid.v4());
  req.faceParts = faceParts;

  return combine(faceParts, req.params.size, function(err, stdout) {
    return common.sendImage(err, stdout, req, res);
  });
});

router.get('/:size?/:id', function(req, res, next) {
  return combine(req.faceParts, req.params.size, function(err, stdout) {
    return common.sendImage(err, stdout, req, res, next);
  });
});

router.get('/face/:eyes/:nose/:mouth/:color/:size?', function(req, res, next) {
  let faceParts = { color: '#' + req.params.color };

  partTypes.forEach(function(type) {
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

  return combine(faceParts, req.params.size, function(err, stdout) {
    return common.sendImage(err, stdout, req, res, next);
  });
});

export default router;
