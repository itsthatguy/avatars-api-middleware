supertest = require('supertest')
webserver = require('../lib/webserver')

describe 'routing', ->
  request = null

  beforeEach ->
    request = supertest(webserver)

  describe 'root', ->
    it 'redirects to the one-pager', (done) ->
      request.get('/')
        .expect('location', 'http://avatars.adorable.io')
        .expect(302, done)

  describe 'v1 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatar/abott')
        .expect('Content-Type', /image/)
        .expect(200, done)

  describe 'v2 avatar request', ->
    it 'responds with an image', (done) ->
      request.get('/avatars/abott')
        .expect('Content-Type', /image/)
        .expect(200, done)
