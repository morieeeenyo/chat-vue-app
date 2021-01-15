const { VueLoaderPlugin } = require("vue-loader"); //vue-loaderのインポート
const path = require('path');
module.exports = {
  mode: "development",
  entry: './src/main.js', //エントリファイル
  output: {
    path: `${__dirname}/../public/javascripts`, //dirnameで現在のパスを絶対パスで指定。ここは絶対パスじゃないとエラーになる
    filename: 'bundle.js' //出力名をbundle.jsに
  },
  module: {
    rules: [
      { //vueファイルを読み込むための設定
        test: /\.vue$/,
        exclude: /node_modules/,
        loader: 'vue-loader'
      },
      { //cssを読み込むための設定
        test: /\.css$/,
        exclude: /node_modules/,
        use: ['style-loader', 'css-loader'],
      },
    ]
  },
  devServer: {
    contentBase: path.resolve(__dirname, 'public'),
    watchContentBase: true,
    publicPath: '/public/javascripts',
    openPage: 'index.html'
  },
  resolve: {
    alias: { //vue-loaderを使う際にこの設定がないとエラーになりました
      'vue$': 'vue/dist/vue.esm.js' // 'vue/dist/vue.common.js' for webpack 1
    }
  },
  plugins: [new VueLoaderPlugin()] //importしたvue-loaderを使えるよう定義
}