import supertest from 'supertest';
import { expect } from 'chai';
import server from './server';
import sharp = require('sharp');

describe('middleware', () => {
  let metaReader: sharp.Sharp;

  beforeEach(() => {
    metaReader = sharp();
  });

  describe('v2 avatar request', () => {
    it('responds with an image', done => {
      supertest(server)
        .get('/avatars/abott')
        .expect('Content-Type', /image/)
        .end(done);
    });

    it('can resize an image', done => {
      supertest(server)
        .get('/avatars/220/abott')
        .pipe(metaReader);

      metaReader
        .metadata()
        .then(meta => {
          expect(meta.height).to.eql(220);
          expect(meta.width).to.eql(220);
          done();
        })
        .catch(done);
    });

    it('can manually compose an image', done => {
      supertest(server)
        .get('/avatars/face/eyes1/nose4/mouth11/bbb')
        .expect(200)
        .expect('Content-Type', /image/)
        .end(done);
    });

    it('can manually compose an image with a custom size', done => {
      supertest(server)
        .get('/avatars/face/eyes1/nose4/mouth11/bbb/50')
        .expect(200)
        .expect('Content-Type', /image/)
        .pipe(metaReader);

      metaReader
        .metadata()
        .then(meta => {
          expect(meta.height).to.eql(50);
          expect(meta.width).to.eql(50);
          done();
        })
        .catch(done);
    });
  });

  describe('v2 avatar list requests', () => {
    it('responds with json', done => {
      supertest(server)
        .get('/avatars/list')
        .expect('Content-Type', /json/)
        .end(done);
    });

    it('responds with a list of possible face parts', done => {
      supertest(server)
        .get('/avatars/list')
        .end((err, res) => {
          const faceParts = res.body.face;
          expect(faceParts).to.have.keys('eyes', 'mouth', 'nose');
          done();
        });
    });
  });

  describe('v2 avatar random requests', () => {
    it('can randomly generate a new avatar', done => {
      const getRandom = () =>
        supertest(server)
          .get('/avatars/random')
          .expect(200)
          .expect('Content-Type', /image/);
      const metaReader2 = sharp();

      getRandom().pipe(metaReader);
      getRandom().pipe(metaReader2);

      Promise.all([metaReader.metadata(), metaReader2.metadata()])
        .then(([meta, meta2]) => {
          expect(meta.size).not.to.equal(meta2.size);
          done();
        })
        .catch(done);
    });

    it('supports a custom size parameter', done => {
      supertest(server)
        .get('/avatars/50/random')
        .expect(200)
        .expect('Content-Type', /image/)
        .pipe(metaReader);

      metaReader
        .metadata()
        .then(meta => {
          expect(meta.height).to.eql(50);
          expect(meta.width).to.eql(50);
          done();
        })
        .catch(done);
    });
  });
});
