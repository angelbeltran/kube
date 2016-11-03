let path = require('path')

module.exports = {
  entry: path.resolve(__dirname, 'public/js/app.js'),
  output: {
    path: path.resolve(__dirname, 'public/build'),
    filename: 'app.js'
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules)/,
        loader: 'babel-loader',
        query: {
          presets: ['es2016', 'react']
        }
      }
    ]
  }
}
