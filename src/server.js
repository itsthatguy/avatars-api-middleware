import express from 'express';
import path from 'path';
import favicon from 'serve-favicon';
import findPort from 'find-port';
import 'colors';

const app = express();
const basePath = path.join(__dirname, '..');
const faviconPath = path.join(basePath, 'src', 'favicon.ico');

app.use(favicon(faviconPath));

import avatarsRoutes from './routes/avatars';

app.use('/avatars', avatarsRoutes);

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
