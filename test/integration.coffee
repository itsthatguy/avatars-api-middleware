request = require('supertest')
webserver = require('../lib/webserver')

describe 'requesting an avatar', ->
  it 'responds with an image', (done) ->
    request(webserver)
      .get('/avatar/abbot')
      .expect('Content-Type', /image/)
      .expect(200, done)
