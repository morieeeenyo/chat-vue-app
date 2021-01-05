const path = require('path')
const webpack = require('webpack')

module.exports = {
  entry: {
    index: path.join(__dirname, 'src', 'main.js')
  },
  output: {
    path: path.join(__dirname, 'out'),
    filename: 'build.js'
  },
  devtool: 'cheap-module-eval-source-map',
  target: 'node',
  module: {
    rules: [
      {
        test: /.js$/,
        loader: 'babel-loader'
      }
    ]
  },
  plugins: [
    externalPlugins
  ]
}