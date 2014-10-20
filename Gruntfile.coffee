module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON '_public/package.json'
    nodewebkit:
      options:
        version: '0.10.5'
        build_dir: './dist'
        # specifiy what to build
        mac: no
        win: yes
        linux32: no
        linux64: no
      src: './_public/**/*'

  grunt.loadNpmTasks 'grunt-node-webkit-builder'
  grunt.registerTask 'default', ['nodewebkit']
