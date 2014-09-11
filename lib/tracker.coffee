Tracker = require('nodealytics')

trackingID = 'UA-49535937-3'
host = 'api.adorable.io'
Tracker.initialize(trackingID, host)

module.exports = Tracker
