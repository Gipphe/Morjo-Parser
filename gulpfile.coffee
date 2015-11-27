'use strict'
gulp = require('gulp')
uglify = require('gulp-uglify')
cssnano = require('gulp-cssnano')
sass = require('gulp-sass')
coffee = require('gulp-coffee')
rename = require('gulp-rename')
concat = require('gulp-concat')
jshint = require('gulp-jshint')
plumber = require('gulp-plumber')
stripDebug = require('gulp-strip-debug')
vendors = [
	'js/jquery.js'
	'js/transit.js'
	'js/lodash.js'
]
gulp.task 'js', [ 'coffee' ], ->
	src = [
		'js/*.js'
		'!js/*.min.js'
		'!js/main*.js'
		'!js/jquery*.js'
		'!js/transit*.js'
		'!js/lodash*.js'
	]
	dest = 'js'
	gulp.src(src)
		.pipe plumber()
		.pipe rename(suffix: '.min')
		.pipe jshint()
		.pipe stripDebug()
		.pipe uglify()
		.pipe gulp.dest(dest)
gulp.task 'css', [ 'scss' ], ->
	src = [
		'css/*.css'
		'!css/*.min.css'
	]
	dest = 'css'
	gulp.src(src)
		.pipe plumber()
		.pipe rename(suffix: '.min')
		.pipe cssnano()
		.pipe gulp.dest(dest)
gulp.task 'coffee', ->
	src = [ 'js/coffee/*.coffee' ]
	dest = 'js'
	gulp.src(src)
		.pipe plumber()
		.pipe rename(extname: '.js')
		.pipe coffee()
		.pipe gulp.dest(dest)
gulp.task 'scss', ->
	src = [ 'css/scss/*.scss' ]
	dest = 'css'
	gulp.src(src)
		.pipe plumber()
		.pipe rename(extname: '.css')
		.pipe sass()
		.pipe gulp.dest(dest)
gulp.task 'watch', ->
	gulp.watch [
		'js/*.js'
		'!js/*.min.js'
		'!js/jquery*.js'
		'!js/lodash*.js'
		'!js/transit*.js'
	], [ 'js' ]
	gulp.watch [ 'js/coffee/*.coffee' ], [ 'coffee' ]
	gulp.watch [
		'css/*.css'
		'!css/*.min.css'
	], [ 'css' ]
	gulp.watch [ 'css/scss/*.scss' ], [ 'scss' ]
	return
gulp.task 'js_vendors', [
	'js'
	'css'
], ->
	src = vendors
	dest = 'js'

	### 	var sourcemapsWriteOptions = {
			debug: true,
			sourceMappingURLPrefix: 'http://srvpsh03.intrano.coop/display/' + dest + '/'
		}; 
	###

	gulp.src(src)
		.pipe plumber()
		.pipe rename(suffix: '.min')
		.pipe uglify()
		.pipe gulp.dest(dest)
gulp.task 'concat', [
	'js'
	'scss'
	'coffee'
	'css'
	'js_vendors'
], ->
	css_src = [
		'css/*.css'
		'!css/*.min.css'
		'!css/main*.css'
	]
	css_dest = 'css'
	js_src = [
		'js/*.js'
		'!js/*.min.js'
		'!js/main*.js'
	]
	js_dest = 'js'
	gulp.src(css_src)
		.pipe plumber()
		.pipe concat('main.css')
		.pipe gulp.dest(css_dest)
		.pipe rename(suffix: '.min')
		.pipe cssnano()
		.pipe gulp.dest(css_dest)
	gulp.src(js_src)
		.pipe plumber()
		.pipe concat('main.js')
		.pipe gulp.dest(js_dest)
		.pipe rename(suffix: '.min')
		.pipe uglify()
		.pipe gulp.dest(js_dest)
	return
gulp.task 'default', [
	'concat'
	'watch'
]