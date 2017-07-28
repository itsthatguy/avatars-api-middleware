if (process.env.NODE_ENV === 'production') {
  // eslint-disable-next-line no-console
  console.log('LOADING NEW RELIC');
  require('newrelic');
}

import express from 'express';
import path from 'path';
import favicon from 'serve-favicon';
import findPort from 'find-port';
// eslint-disable-next-line no-unused-vars
import colors from 'colors';

const app = express();
const basePath = path.join(__dirname, '..');
const faviconPath = path.join(basePath, 'src', 'favicon.ico');

app.engine('.html', require('ejs').__express);
app.use(favicon(faviconPath));
app.get('/', function(req, res) {
  return res.redirect('http://avatars.adorable.io');
});

if (process.env.NODE_ENV === 'production') {
  app.use(require('./tracker'));
}

import routesV1 from './routes/v1';
import routesV2 from './routes/v2';

app.use('/avatar', routesV1);
app.use('/avatars', routesV2);

const listen = (port) => {
  app.listen(port, function () {
    const { address } = this.address();
    // eslint-disable-next-line no-console
    console.log(`[Adorable Avatars] Running at: http://${address}:${port}`.green);
  });
};

const port = process.env.PORT || 3002;
if (port > 3002) {
  listen(port);
} else {
  findPort(port, port + 100, function(ports) {
    return listen(ports[0]);
  });
}

export default app;
