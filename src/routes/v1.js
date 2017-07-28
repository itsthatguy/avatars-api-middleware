import { Router } from 'express';

import { allPaths }  from '../lib/imageFiles';
import SlotMachine from '../lib/slotMachine';
import { resize }      from '../lib/imager';
import common      from './common';

const imageFiles = allPaths();
const imageSlotMachine = new SlotMachine(imageFiles);

// eslint-disable-next-line new-cap
const router = Router();

router.param('id', function(req, res, next, id) {
  const image = imageSlotMachine.pull(id);
  req.imagePath = image;
  next();
});

router.get('/:id', function(req, res) {
  res.sendFile(req.imagePath);
});

// with custom size
router.get('/:size/:id', function(req, res, next) {
  resize(req.imagePath, req.params.size, (err, stdout) => {
    common.sendImage(err, stdout, req, res, next);
  });
});

export default router;
