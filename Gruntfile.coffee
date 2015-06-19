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
      'myhost': grunt.file.readJSON 'tc.host'

    sshexec:
      restart:
        command: "forever restart Kmin"
        options: config: 'myhost'

    sftp: 
      dev:
        files:  './': ['dist/**', 'package.json', 'accesskey.json']
        options:
          config: 'myhost'
          path: '/root/srv-iter01/bin'
          srcBasePath: 'dist/'
          createDirectories: true

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'run-remote', [
    'coffee'
    'sftp:dev'
    'sshexec:restart'
  ]
  grunt.registerTask 'run-local', [
    'compile'
    'nodemon'
  ]