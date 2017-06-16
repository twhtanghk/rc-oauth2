_ = require 'lodash'
path = require 'path'
webpack = require 'webpack'
PolyfillInjectorPlugin = require 'webpack-polyfill-injector'

module.exports =
  entry:
    index: ['babel-polyfill', './test/index.coffee']
    callback: ['babel-polyfill', './test/callback.coffee']
  output:
    path: path.join __dirname, 'test'
    filename: "[name].js"
  plugins: [
    new webpack.EnvironmentPlugin(
      _.pick(process.env, 'AUTHURL', 'CLIENT_ID', 'SCOPE')
    )
    new PolyfillInjectorPlugin(
      polyfills: [
        'Object.assign'
      ]
      service: true
    )
  ]
  module:
    loaders: [
      { test: /\.coffee$/, use: 'coffee-loader' }
      { test: /\.css$/, use: ['style-loader', 'css-loader'] }
    ]
  devtool: "#source-map"
  devServer:
    disableHostCheck: true
