import express from 'express';
import path from 'path';
import favicon from 'serve-favicon';

import avatarsRoutes from '../src/routes/avatars';

const app = express();
const port = Number(process.env.PORT) || 3002;

const faviconPath = path.join(__dirname, '..', 'src', 'favicon.ico');
app.use(favicon(faviconPath));

app.use('/avatars', avatarsRoutes);

app.listen(port, () =>
  console.log(`[Adorable Avatars] Running at: http://localhost:${port}`),
);

export default app;
