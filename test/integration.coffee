supertest = require('supertest')
webserver = require('../lib/webserver')

describe 'routing', ->
  request = null

  beforeEach ->
    request = supertest(webserver)

  describe 'root', ->
    it 'redirects to the one-pager', (done) ->
      request.get('/')
        .expect(302)
        .expect('location', 'http://avatars.adorable.io')
        .end(done)

  describe 'v1 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatar/abott')
        .expect('Content-Type', /image/)
        .end(done)

    it 'can resize an image', (done) ->
      request.get('/avatar/220/abott')
        .expect('Content-Type', /image/)
        .end(done)

  describe 'v2 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatars/abott')
        .expect('Content-Type', /image/)
        .end(done)

    it 'can resize an image', (done) ->
      request.get('/avatars/220/abott')
        .expect('Content-Type', /image/)
        .end(done)

    it 'can manually compose an image', (done) ->
      request.get('/avatars/face/eyes1/nose4/mouth11/bbb')
        .expect(200)
        .expect('Content-Type', /image/)
        .end(done)
