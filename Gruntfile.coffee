module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    watch:
      coffee:
        files: [
          'public/javascripts/*.coffee', 'spec/javascripts/*.coffee'
        ]
        tasks: ['coffee:compile']

    coffee:
      compile:
        files: [
          {
            expand: true,
            src: ['public/javascripts/*.coffee', 'spec/javascripts/*.coffee'],
            ext: '.js',
            rename: (dest, src) ->
              src.replace("/javascripts/", "/javascripts/compiled/")
          }
        ]