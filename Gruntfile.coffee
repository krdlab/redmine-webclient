module.exports = (grunt) ->
  require('load-grunt-tasks') grunt

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    appconf:
      name: 'client'
      main: 'index.html'
    browserify:
      dist:
        files:
          'dist/app/js/<%= appconf.name %>.js': ['app/js/{,*/}*.js']
        options:
          transform: ['partialify', 'debowerify']
    uglify:
      build:
        src:  'dist/app/js/<%= appconf.name %>.js'
        dest: 'dist/app/js/<%= appconf.name %>.min.js'
    copy:
      dist:
        files: [
          { expand: true
          , cwd: 'app'
          , src: ['*.{ico,png,txt}', 'img/{,*/}*.*', 'css/{,*/}*.*', '<%= appconf.main %>']
          , dest: 'dist/app'
          },
          { expand: true
          , cwd: 'bower_components/bootstrap/dist'
          , src: ['css/*.css', 'fonts/*.*', 'js/*.js']
          , dest: 'dist/app'
          },
          { expand: true
          , cwd: 'bower_components/jquery/dist'
          , src: ['*.js']
          , dest: 'dist/app/js'
          }
        ]
    watch:
      options:
        livereload: true
      scripts:
        files: [
            'app/{,*/}*.html'
          , 'app/css/{,*/}*.css'
          , 'app/js/{,*/}*.js'
        ]
        tasks: ['browserify', 'uglify', 'copy']
    connect:
      options:
        port: 9000
        hostname: 'localhost'
        livereload: true
      dist:
        options:
          base: ['dist/app']

  grunt.registerTask 'default', ['browserify', 'uglify', 'copy']
  grunt.registerTask 'autobuild', ['watch']
  grunt.registerTask 'server', ['connect', 'watch']
