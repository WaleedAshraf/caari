"use strict";

const debug = process.env.NODE_ENV !== "production";

const webpack = require('webpack');
const path = require('path');
const entryPath =  path.join(__dirname, 'web', 'app-client.js')
module.exports = {
  devtool: debug ? 'inline-sourcemap' : null,
  entry: entryPath, // Your appʼs entry point
 // entry: path.join(__dirname, 'web', 'app-client.js'),
  
  output: {
    path: path.join(__dirname, 'static', 'js'),
    publicPath: "/static/js/",
    filename: 'bundle.js'
  },
  module: {
    loaders: [{
      test: path.join(__dirname, 'web'),
      loader: [ 'babel-loader' ],
      query: {
        cacheDirectory: 'babel_cache',
        presets: ['react', 'es2015']
      }
    }]
  },
  plugins: debug ? [] : [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    }),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: { warnings: false },
      mangle: true,
      sourcemap: false,
      beautify: false,
      dead_code: true
    }),
  ]
};
