module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-template')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    watch:
      coffee:
        files: [
          'app/assets/javascripts/*.coffee', 'spec/javascripts/*.coffee'
        ]
        tasks: ['coffee:compile']

    coffee:
      compile:
        files: [
          {
            expand: true,
            src: ['app/assets/javascripts/*.coffee', 'spec/javascripts/*.coffee'],
            ext: '.js'
          }
        ]

    template_runner: {
      files: {
        'spec/javascripts/ajax_tokenizer_spec.js.coffee': ['spec/javascripts/ajax_tokenizer_spec.js.coffee.erb']
      }
    }
