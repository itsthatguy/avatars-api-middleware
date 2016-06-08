if (process.env.NODE_ENV == 'production')
  console.log('LOADING NEW RELIC')
  require('newrelic')
require('./lib/webserver.coffee')
