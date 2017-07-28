const common = {
  sendImage: (err, stdout, req, res) => {
    res.setHeader('Expires', new Date(Date.now() + 604800000));
    res.setHeader('Content-Type', 'image/png');
    stdout.pipe(res);
  }
};

export default common;
