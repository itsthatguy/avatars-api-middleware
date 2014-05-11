// Gulpfile.js
// Require the needed packages
var gulp       = require('gulp'),
    gutil      = require('gulp-util'),
    clean      = require('gulp-clean'),
    stylus     = require('gulp-stylus'),
    browserify = require('gulp-browserify'),
    rename     = require('gulp-rename'),
    livereload = require('gulp-livereload');

var paths = {
  cssPath: ['./app/css/**/*.styl*'],
  cssInput: './app/css/main.styl',
  cssOutput: './.generated/css',
  coffeePath: ['./app/js/**/*.coffee'],
  coffeeInput: './app/js/main.coffee',
  coffeeOutput: './.generated/js',
  assetsBasePath: './app',
  assetsPaths: [
    './app/img/**/*',
    './app/fonts/**/*',
    './app/**/*.html'
  ],
  assetsOutput: './.generated/'
};


gulp.task('default', function () {
  console.log("default task does nothing, hombre.")
});


//
// Stylus
//

gulp.task('stylus', function () {
  gulp.src(paths.cssInput)
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.cssOutput));
});


//
// Coffee
//

gulp.task('coffee', function() {
  gulp.src(paths.coffeeInput, { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    })
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('main.js'))
    .pipe(gulp.dest(paths.coffeeOutput))

  gulp.src('./app/js/app.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }).on('error', gutil.log).on('error', gutil.beep))
    .pipe(rename('app.js'))
    .pipe(gulp.dest(paths.coffeeOutput))
});


//
// Static Assets
//

gulp.task('assets', function() {
  gulp.src(paths.assetsPaths, {base: paths.assetsBasePath})
    .on('error', gutil.log)
    .on('error', gutil.beep)
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// Clean
//

gulp.task('clean', function() {
  gulp.src('./.generated/**/*', {read: false})
    .pipe(clean());
});


//
// Watch
//

gulp.task('watch', ['clean','stylus','coffee','assets'], function() {
  var server = livereload();
  gulp.watch(paths.cssPath, ['stylus']);
  gulp.watch(paths.coffeePath, ['coffee']);
  gulp.watch(paths.assetsPaths, ['assets']);
  gulp.watch('.generated/**').on('change', function(file) {
    server.changed(file.path);
  });
});

gulp.task('default', ['stylus', 'coffee', 'assets']);
