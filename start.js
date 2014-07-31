
var runCommand = require('run-command');

console.log(">> NODE_ENV: " + process.env.NODE_ENV);

runCommand("coffee", ['app.coffee']);
if (process.env.NODE_ENV == "development") {
  runCommand("gulp", ['watch-pre-tasks'], function() {
    runCommand("gulp", ['watch']);
  });
}
