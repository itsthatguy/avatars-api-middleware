ua = require('universal-analytics')

visitor = ua('UA-49535937-3')

module.exports = (req, res, next) ->
  eventParams =
    ec: 'API Request'                        # category
    ea: req.get('Referrer') || 'no referrer' # action
    el: req.ip                               # label
    dp: req.url                              # page path

  visitor.event(eventParams, next)
