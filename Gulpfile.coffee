gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
cssToJs = require 'gulp-css-to-js'
concat = require 'gulp-concat'
assert = require 'assert'
fs = require 'fs'
util = require 'util'
path = require 'path'
_ = require 'lodash'

gulp.task 'default', ['coffee']

gulp.task 'config', ->
  params = [
    'AUTHURL'
    'CLIENT_ID'
    'SCOPE'
  ]
  params.map (name) ->
    assert name of process.env, "process.env.#{name} not yet defined"
  fs.writeFileSync 'test/config.json', util.inspect(_.pick process.env, params)

gulp.task 'css', ->
  gulp.src ['node_modules/rc-dialog/assets/index.css', 'index.css']
    .pipe cssToJs()
    .pipe concat 'css.js'
    .pipe gulp.dest '.'

gulp.task 'coffee', ['config', 'css'],  ->
  [
    'test/index.coffee'
    'test/callback.coffee'
  ].map (file) ->
    name = path.parse(file).name
    browserify entries: [file]
      .transform 'coffeeify'
      .bundle()
      .pipe source "#{name}.js"
      .pipe gulp.dest 'test'
      .pipe streamify uglify()
      .pipe rename extname: '.min.js'
      .pipe gulp.dest 'test'
