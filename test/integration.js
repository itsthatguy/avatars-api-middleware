import supertest from 'supertest';
import { expect } from 'chai';
import { subClass } from 'gm';
import webserver from '../src/server';

const im = subClass({ imageMagick: true });

const parseImage = function(res, callback) {
  res.setEncoding('binary');
  res.data = '';

  res.on('data', function(chunk) {
    res.data += chunk;
  });

  res.on('end', function() {
    callback(null, new Buffer(res.data, 'binary'));
  });
};

describe('routing', function() {
  var request;

  beforeEach(function() {
    request = supertest(webserver);
  });

  describe('v2 avatar request', function() {
    it('responds with an image', function(done) {
      request.get('/avatars/abott').expect('Content-Type', /image/).end(done);
    });

    it('can resize an image', function(done) {
      request.get('/avatars/220/abott').parse(parseImage).end(function(err, res) {
        im(res.body).size(function(_, size) {
          expect(size).to.eql({ height: 220, width: 220 });
          done();
        });
      });
    });

    it('can manually compose an image', function(done) {
      request.get('/avatars/face/eyes1/nose4/mouth11/bbb')
      .expect(200)
      .expect('Content-Type', /image/)
      .end(done);
    });

    it('can manually compose an image with a custom size', function(done) {
      request.get('/avatars/face/eyes1/nose4/mouth11/bbb/50')
      .expect(200)
      .expect('Content-Type', /image/)
      .parse(parseImage).end(function(err, res) {
        im(res.body).size(function(_, size) {
          expect(size).to.eql({ height: 50, width: 50 });
          done();
        });
      });
    });
  });

  describe('v2 avatar list requests', function() {
    it('responds with json', function(done) {
      request.get('/avatars/list').expect('Content-Type', /json/).end(done);
    });

    it('responds with a list of possible face parts', function(done) {
      request.get('/avatars/list').end(function(err, res) {
        const faceParts = res.body.face;
        expect(faceParts).to.have.keys('eyes', 'mouth', 'nose');
        done();
      });
    });
  });

  describe('v2 avatar random requests', function() {
    it('can randomly generate a new avatar', function(done) {
      const getRandom = () => request
          .get('/avatars/random')
          .expect(200)
          .expect('Content-Type', /image/)
          .parse(parseImage);

      getRandom().end((_, r1) => {
        getRandom().end((_, r2) => {
          im(r1.body).identify('%#', (_, id1) => {
            im(r2.body).identify('%#', (_, id2) => {
              expect(id1).not.to.equal(id2);
              done();
            });
          });
        });
      });
    });

    it('supports a custom size parameter', function(done) {
      request
        .get('/avatars/50/random')
        .expect(200)
        .expect('Content-Type', /image/)
        .parse(parseImage)
        .end(function(err, res) {
          im(res.body).size(function(_, size) {
            expect(size).to.eql({ height: 50, width: 50 });
            done();
          });
        });
    });
  });
});
