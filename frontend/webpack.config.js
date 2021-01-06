const { VueLoaderPlugin } = require("vue-loader");
module.exports = {
  entry: {
    application: './src/main.js',
  },
  output: {
    path: `${__dirname}/../public/javascripts`,
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        exclude: /node_modules/,
        loader: 'vue-loader'
      }
    ]
  },
  plugins: [new VueLoaderPlugin()]
}