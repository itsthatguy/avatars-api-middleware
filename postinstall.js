#!/usr/bin/env node

var path = require('path');
var spawn = require('win-spawn');


basedir = path.join(__dirname, "node_modules", ".bin");


var runCommand = function(command, args) {

  var cmd = spawn(path.join(basedir, command), args);

  cmd.stdout.setEncoding('utf8');
  cmd.stdout.on('data', function(data) {
    console.log(data);
  });
  cmd.stderr.setEncoding('utf8');
  cmd.stderr.on('data', function(data) {
    console.log(data);
  });
  cmd.on('close', function(code) {
    console.log('Child process exited with code', code);
  });
}


runCommand("bower", ['install']);
runCommand("gulp");
