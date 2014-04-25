# Grunt configuration updated to latest Grunt.  That means your minimum
# version necessary to run these tasks is Grunt 0.4.
#
# Please install this locally and install `grunt-cli` globally to run.
'use strict'

module.exports = (grunt) ->
  
  # Load all grunt tasks
  require('load-grunt-tasks')(grunt)
  # Show elapsed time at the end
  require('time-grunt')(grunt)
  
  # Initialize the configuration
  grunt.initConfig
    
    # Metadata.
    pkg:
      grunt.file.readJSON('package.json')
    banner:
      '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed MIT */\n'
    
    # Task configuration.
    clean:
      files:
        ['dist']
        
    concat:
      options:
        banner:
          '<%= banner %>'
        stripBanners:
          true
          
      dist:
        src:
          ['src/<%= pkg.name %>.js']
        dest:
          'dist/jquery.<%= pkg.name %>.js'

    uglify:
      options:
        banner:
          '<%= banner %>'
      dist:
        src:
          '<%= concat.dist.dest %>'
        dest:
          'dist/jquery.<%= pkg.name %>.min.js'

    # Run QUnit tests for Lo-Dash and Underscore. They will be merged soon,
    # since LayoutManager has changed its dependency back to a hard Underscore.
    # The lodash.underscore still works perfectly fine.
    qunit:
      all:
        options:
          urls:
            ['http://localhost:9000/test/<%= pkg.name %>.html']

    # Lint source, node, and test code with some sane options.
    jshint:
      options:
        reporter:
          require('jshint-stylish')
      gruntfile:
        options:
          jshintrc:
            '.jshintrc'
        src:
          'Gruntfile.js'
      src:
        options:
          jshintrc:
            'src/.jshintrc'
        src:
          ['src/**/*.js']
      test:
        options:
          jshintrc:
            'test/.jshintrc'
        src:
          ['test/**/*.js']
    
    # requirejs coffeescript
    requirejs:
      compile:
        options:
          baseUrl: 'src/script/coffee'
          mainConfigFile: 'src/script/coffee/build.coffee'
          #optimize: 'uglify'
          name: 'main'
          out: 'src/script/main.js'
    
    # watch source code change
    watch:
      all:
        files: 'src/**/*.*'
        options:
          livereload: true
      gruntfile:
        files:
          '<%= jshint.gruntfile.src %>'
        tasks:
          ['jshint:gruntfile']
      scripts:
        files:
          ['<%= jshint.src.src %>']
        tasks:
          ['jshint:src', 'qunit']
      styles:
        files:
          'src/style/less/*.less'
        tasks:
          ['recess:build']
      test:
        files:
          '<%= jshint.test.src %>'
        tasks:
          ['jshint:test', 'qunit']
          
    recess:
      build:
        options:
          compile: true
        files:
          'src/style/main.css': 'src/style/less/*.less'
      dist:
        options:
          compile: true
          compress: true
        src:
          'src/style/less/*.less'
        dest:
          'dist/style/main.css'

    connect:
      dev:
        options:
          hostname: "*"
          port: 9292
          base: 'src/'
          #keepalive: true
          livereload: true
          open: 'http://localhost:9292'
          
    copy:
      bootstrap:
        files:[
          {
            expand: true
            src: 'bower_components/bootstrap/dist/css/bootstrap.css'
            dest: 'src/style/'
            flatten: true
            filter: 'isFile'
          }
          {
            expand: true
            src: 'bower_components/bootstrap/dist/js/bootstrap.js'
            dest: 'src/script/'
            flatten: true
            filter: 'isFile'
          }
        ]
         
    
            
  #Default task.
  grunt.registerTask 'default', ['jshint', 'connect', 'qunit', 'clean', 'concat', 'uglify']
  grunt.registerTask 'server', ->
    grunt.log.warn 'The `server` task has been deprecated. Use `grunt serve` to start a server.'
    grunt.task.run ['serve']
  grunt.registerTask 'serve', ['connect', 'watch']
  grunt.registerTask 'test', ['jshint', 'connect', 'qunit']
  
  # Load external Grunt task plugins.
  grunt.loadNpmTasks 'grunt-recess'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'