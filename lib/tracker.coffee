Tracker = require('mixpanel')

projectID = '489a8cc0db758b483e9db84d765c88ee'
tracker = Tracker.init(projectID)
tracker.config.track_ip = 1

module.exports = tracker
