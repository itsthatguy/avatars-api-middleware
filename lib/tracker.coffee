Tracker = require('mixpanel')
router = require('express').Router()

projectToken = '489a8cc0db758b483e9db84d765c88ee'
tracker = Tracker.init(projectToken)
tracker.config.track_ip = true

module.exports = router.use (req, res, next) ->
  tracker.track(
    'API request',
    url: req.url,
    referrer: req.get('Referrer'),
    ip: req.ip,
    next
  )
