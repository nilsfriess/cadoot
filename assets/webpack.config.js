const path = require('path')
const glob = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const webpack = require('webpack')

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({cache: true, parallel: true, sourceMap: false}),
      new OptimizeCSSAssetsPlugin({}),
    ],
  },
  entry: {
    app: [
      './js/app.js',
      './js/socket.js',
      './js/helpers.js',
      './js/pages/editQuiz.js',
      './js/pages/host.js',
      './js/pages/info.js',
      './js/pages/landing.js',
      './js/pages/start.js',
    ].concat(glob.sync('./vendor/**/*.js')),
    vendor: ['underscore'],
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, '../priv/static/js'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.s?css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({filename: '../css/app.css'}),
    new CopyWebpackPlugin([{from: 'static/', to: '../'}]),
    new webpack.ProvidePlugin({
      _: 'underscore',
    }),
  ],
})
