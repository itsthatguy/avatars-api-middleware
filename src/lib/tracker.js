import ua from 'universal-analytics';

const tracker = (req, res, next) => {
  const visitor = ua('UA-49535937-3');

  const eventParams = {
    ec: 'API Request',                        // category
    ea: req.get('Referrer') || 'no referrer', // action
    el: req.ip,                               // label
    dp: req.url,                              // page path
  };

  visitor.event(eventParams).send();
  next();
};

export default tracker;
