# Load all required libraries.
gulp = require 'gulp'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'
jade = require 'gulp-jade'
minifyHTML = require 'gulp-minify-html'
imagemin = require 'gulp-imagemin'
svgmin = require 'gulp-svgmin'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
del = require 'del'
gutil = require 'gulp-util'

paths =
  src:
    scripts: 'src/scripts/**/*.coffee'
    templates: 'src/templates/**/*.jade'
    styles: 'src/styles/**/*.sass'
    fonts: 'src/fonts/**/*'
    images: 'src/images/**/*'
  dest:
    scripts: 'dist/scripts'
    templates: 'dist/templates'
    styles: 'dist/styles'
    fonts: 'dist/fonts'
    images: 'dist/images'

gulp.task 'scripts', ->
  gulp.src [paths.src.scripts, '!src/scripts/index.coffee' ]
    .pipe coffee({bare:true}).on('error', onError)
      # .pipe uglify()
      # .pipe concat('all.min.js')
    .pipe gulp.dest paths.dest.scripts
  gulp.src 'src/scripts/index.coffee'
    .pipe coffee({bare:true}).on('error', onError)
    .pipe gulp.dest '.'

# Create you HTML from Jade
gulp.task 'templates', ->
  gulp.src [ paths.src.templates, '!src/templates/index.jade' ]
    .pipe jade({pretty: true}).on('error', onError)
    # .pipe minifyHTML()
    .pipe gulp.dest paths.dest.templates
  gulp.src 'src/templates/index.jade'
    .pipe jade({pretty: true}).on('error', onError)
    .pipe gulp.dest '.'

# Create your CSS from Sass
gulp.task 'styles', ->
  gulp.src paths.src.styles
    .pipe sass().on('error', onError)
    .pipe prefix "> 1%"
    # .pipe cssmin keepSpecialComments: 0
    .pipe gulp.dest paths.dest.styles

# Copy all static images
gulp.task 'images', ->
  gulp.src paths.src.images
    .pipe imagemin optimizationLevel: 5
    .pipe gulp.dest paths.dest.images

# Minify your SVG.
gulp.task 'svg', ->
  gulp.src paths.src.images+'.svg'
    .pipe svgmin()
    .pipe gulp.dest paths.dest.images

# Copy the fonts using streams.
gulp.task 'fonts', ->
  gulp.src paths.src.fonts
    .pipe gulp.dest paths.dest.fonts

# Rerun the task when a file changes
gulp.task 'watch', ->
  gulp.watch paths.src.scripts, ['scripts']
  gulp.watch paths.src.templates, ['templates']
  gulp.watch paths.src.styles, ['styles']
  gulp.watch paths.src.images, ['images','svg']
  gulp.watch paths.src.fonts, ['fonts']

# Default task call every tasks created so far.
gulp.task 'default', ['watch', 'scripts', 'templates', 'styles', 'images', 'svg', 'fonts']

onError = (error) ->
  gutil.log error
  this.emit 'end'
  return