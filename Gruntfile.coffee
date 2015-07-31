module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt
  grunt.initConfig
    watch:
      coffee:
        files: ['{,*/}*.coffee' ]
        tasks: ['newer:coffee']
    coffee:
      glob_to_multiple:
        expand: true
        flatten: false
        cwd: './src'
        src: ['**/*.coffee']
        dest: './dist'
        ext: '.js'

    nodemon:
      dev:
        script: './dist/main.js'

    sshconfig:
      'myhost_qa': grunt.file.readJSON 'tc.host'
      'myhost_prod': grunt.file.readJSON 'tc_prod.host'

    sshexec:
      restart_qa:
        command: "export NODE_ENV=qa;cd /root/srv-iter01;forever stop bin/main.js;forever start ./bin/main.js"
        options: config: 'myhost_qa'
      restart_prod:
        command: "export NODE_ENV=prod;cd /root/srv-iter01;forever stop bin/main.js;forever start ./bin/main.js"
        options: config: 'myhost_prod'
        
    sftp:
      qa:
        files:  './': ['dist/**', 'package.json', 'accesskey.json']
        options:
          config: 'myhost_qa'
          path: '/root/srv-iter01/bin'
          srcBasePath: 'dist/'
          createDirectories: true
      prod:
        files:  './': ['dist/**', 'package.json', 'accesskey.json']
        options:
          config: 'myhost_prod'
          path: '/root/srv-iter01/bin'
          srcBasePath: 'dist/'
          createDirectories: true

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'run-remote-qa', [
    'coffee'
    'sftp:qa'
    'sshexec:restart_qa'
  ]
  grunt.registerTask 'run-remote-prod', [
    'coffee'
    'sftp:prod'
    'sshexec:restart_prod'
  ]
  grunt.registerTask 'run-local', [
    'compile'
    'nodemon'
  ]