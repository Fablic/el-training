const path = require('path')
const rules = [
  {
    test: /\.tsx?/,
    exclude: /node_modules/,
    loader: 'babel-loader',
  },
  {
    test: /\.(png|jpg|gif)$/,
    type: 'asset/resource',
  },
]

module.exports = {
  target: 'web',
  mode: 'development',
  devtool: 'inline-source-map',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'bundle.js',
  },
  module: {
    rules,
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js'],
  },
  devServer: {
    host: '0.0.0.0',
    disableHostCheck: true,
    historyApiFallback: {
      rewrites: [{ from: /^\/*/, to: '/app.html' }],
    },
    https: true,
  },
}
