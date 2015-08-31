var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    './lib/assets/javascripts/index.js.coffee'
  ],

  output: {
    path:     path.join(__dirname, 'dist/'),
    filename: 'index.js',
    library: 'Cable',
    libraryTarget: 'umd'
  },

  module: {
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee'
      }
    ]
  }
};
