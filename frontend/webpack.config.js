const { VueLoaderPlugin } = require("vue-loader");
const path = require('path');
module.exports = {
  mode: "development",
  entry: './src/main.js',
  output: {
    path: `${__dirname}/../public/javascripts`,
    filename: 'main.js'
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
  devServer: {
    contentBase: path.resolve(__dirname, 'public'),
    watchContentBase: true,
    publicPath: '/public/javascripts',
    openPage: 'index.html'
	},
  plugins: [new VueLoaderPlugin()]
}