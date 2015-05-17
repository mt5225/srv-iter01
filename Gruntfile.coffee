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
      test:
        command: 'uptime'
        options: config: 'myhost'
      restart_forever:
        command: "echo"
        options: config: 'myhost'

    sftp: #todo sftp not working ?
      upload:
        files:  './' : ['accesskey.json', 'package.json']
        options:
          config: 'myhost'
          path: '/home/ubuntu/srviter01/bin'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'run-remote', [
    'coffee'
    'sftp:upload'
  ]
  grunt.registerTask 'run-local', [
    'compile'
    'nodemon'
  ]