ua = require('universal-analytics')

module.exports = (req, res, next) ->
  visitor = ua('UA-49535937-3')

  eventParams =
    ec: 'API Request'                        # category
    ea: req.get('Referrer') || 'no referrer' # action
    el: req.ip                               # label
    dp: req.url                              # page path

  visitor.event(eventParams).send()
  next()
