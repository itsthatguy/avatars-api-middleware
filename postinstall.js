
var runCommand = require('run-command');

console.log(">> NODE_ENV: " + process.env.NODE_ENV);

runCommand("bower", ['install']);
runCommand("gulp");
