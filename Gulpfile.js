// Environment Variables!
var dotenv = require('dotenv');
dotenv.load();

// Gulpfile.js
// Require the needed packages
var gulp         = require('gulp'),
    ejs          = require('gulp-ejs'),
    gutil        = require('gulp-util'),
    jade         = require('gulp-jade'),
    rename       = require('gulp-rename'),
    stylus       = require('gulp-stylus'),
    browserify   = require('gulp-browserify'),
    path         = require('path');

// var del, livereload, runSequence;

if (process.env.NODE_ENV == "development") {
  del         = require('del'),
  livereload  = require('gulp-livereload'),
  runSequence = require('run-sequence');
}

var baseAppPath = path.join(__dirname, 'app'),
    baseStaticPath = path.join(__dirname, '.generated'),
    baseJsPath = path.join(baseAppPath, 'js'),
    baseCssPath = path.join(baseAppPath, 'css');

var paths = {
  cssInput: path.join(baseCssPath, 'main.styl'),
  cssOutput: path.join(baseStaticPath, 'css'),
  coffeeInput: path.join(baseJsPath, 'app.coffee'),
  coffeeOutput: path.join(baseStaticPath, 'js'),
  cleanPath: path.join(baseStaticPath, '**', '*'),
  ejsPath:  [path.join(baseAppPath, '**', '*.ejs')],
  jadePath:  [path.join(baseAppPath, '**', '*.jade')],
  assetsBasePath: baseAppPath,
  assetsPaths: [
    path.join(baseAppPath, 'img', '**', '*'),
    path.join(baseAppPath, 'fonts', '**', '*'),
    path.join(baseAppPath, '**', '*.html')
  ],
  assetsOutput: baseStaticPath
};

var watchPaths = {
  css: [
    path.join(baseCssPath, '**', '*.styl*'),
    baseCssPath, path.join('**', '*', '*.styl*')
  ],
  coffee: [path.join(baseJsPath, '**', '*.coffee')],
  assets: paths.assetsPaths,
  ejs: paths.ejsPath,
  jade: paths.jadePath
}

var testFiles = [
  '.generated/js/app.js',
  'test/client/*.js'
];


gulp.task('test', function() {
  // Be sure to return the stream
  return gulp.src(testFiles)
    .pipe(karma({
      configFile: 'karma.conf.js',
      action: 'run'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});


//
// Stylus
//


// Get and render all .styl files recursively
gulp.task('stylus', function () {
  return gulp.src(paths.cssInput)
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.cssOutput));
});


//
// Coffee
//

gulp.task('coffee', function() {
  return gulp.src(paths.coffeeInput, { read: false })
    .pipe(browserify({
      basedir: __dirname,
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }).on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('app.js'))
    .pipe(gulp.dest(paths.coffeeOutput));
});


//
// Jade
//

gulp.task('jade', function() {
  return gulp.src(paths.jadePath)
    .pipe(jade({ pretty: true }))
    .pipe(gulp.dest(paths.assetsOutput))
});

//
// EJS
//

gulp.task('ejs', function() {
  return gulp.src(paths.ejsPath)
    .pipe(ejs()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// Static Assets
//

gulp.task('assets', function() {
  return gulp.src(paths.assetsPaths, {base: paths.assetsBasePath})
    .on('error', gutil.log)
    .on('error', gutil.beep)
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// clean
//

gulp.task('clean', function() {
  return del(paths.cleanPath, { sync: true });
});


//
// Watch pre-tasks
//

gulp.task('watch-pre-tasks', function(callback) {
  runSequence('clean',['coffee','stylus','assets','ejs','jade'], callback);
});

//
// Watch
//
gulp.task('watch', function(callback) {

  gulp.watch(watchPaths.css, ['stylus'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.coffee, ['coffee'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.assets, ['assets'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.ejs, ['ejs'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.jade, ['jade'])
    .on('error', gutil.log)
    .on('error', gutil.beep);

  if (livereload) {
    var server = livereload.listen({ silent: true });
    if (server) {
      gutil.log('[LiveReload] Now listening on port: ' + server.port);
      livereload.changed();
    }
    gulp.watch(path.join(baseStaticPath, '**'))
      .on('change', livereload.changed);
  }
});

gulp.task('default', ['stylus', 'coffee', 'assets', 'ejs', 'jade']);
