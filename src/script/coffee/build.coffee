require.config
  deps: ['main']
  baseUrl: 'src/script/js'
  path:
    jquery: 'bower_components/jquery/dist'
  packages: [{
    name: 'cs'
    location: 'require-cs'
    main: 'cs'
  }
  {
    name: 'coffee-script'
    main: 'index'
  }]