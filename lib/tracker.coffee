Tracker = require('nodealytics')

trackingID = 'UA-49535937-1'
host = 'api.adorable.io'
Tracker.initialize(trackingID, host)

module.exports = Tracker
