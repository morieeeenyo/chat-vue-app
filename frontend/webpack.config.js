const { VueLoaderPlugin } = require("vue-loader"); //vue-loaderのインポート
const path = require('path'); // output.pathに絶対パスを指定する必要があるため、pathモジュールを読み込んでおく
module.exports = {
  mode: "development", // モードの設定、v4系以降はmodeを指定しないと、webpack実行時に警告が出る。デフォルトではproductionになっている。今回は本番環境で使用しないのでdevelopmentにした
  entry: './src/main.js', //エントリファイル
  output: {
    path: `${__dirname}/../public/javascripts`, //dirnameで現在のパスを絶対パスで指定。ここは絶対パスじゃないとエラーになる
    filename: 'bundle.js' //出力名をbundle.jsに
  },
  module: {
    rules: [
      { //vueファイルを読み込むための設定
        test: /\.vue$/, //loaderの処理対象のファイル。vue全て
        exclude: /node_modules/, //loaderの処理対象から外すファイル
        loader: 'vue-loader'
      },
      { //cssを読み込むための設定
        test: /\.css$/, //loaderの処理対象のファイル。css全て
        exclude: /node_modules/, //loaderの処理対象から外すファイル
        use: ['style-loader', 'css-loader'],
      },
    ]
  },
  //webpack-dev-server用設定
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