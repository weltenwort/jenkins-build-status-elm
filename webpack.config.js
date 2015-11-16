'use strict';

var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var JENKINS_URL = process.env.JENKINS_URL;
var JENKINS_AUTH = process.env.JENKINS_AUTH;

module.exports = {
    devtool: 'eval-source-map',
    entry: [
        path.join(__dirname, 'index.js')
    ],
    output: {
        path: path.join(__dirname, '/dist/'),
        filename: '[name].js',
        publicPath: '/'
    },
    plugins: [
        new HtmlWebpackPlugin({
            inject: 'body',
            filename: 'index.html'
        }),
        //new webpack.optimize.OccurenceOrderPlugin(),
        //new webpack.NoErrorsPlugin(),
        //new webpack.DefinePlugin({
            //'process.env.NODE_ENV': JSON.stringify('development')
        //})
    ],
    module: {
        loaders: [
            { test: /\.elm$/, loader: 'exports?Elm!ulmus'},
            { test: /\.json?$/, loader: 'json' },
            { test: /\.css$/, loader: 'style!css' },
        ],
    },
    devServer: {
        proxy: {
            '/external/jenkins*': {
                auth: JENKINS_AUTH,
                rewrite: function(req) {
                    var jenkinsMatch = req.url.match(/^\/external\/jenkins(.*)/)
                    if (jenkinsMatch !== null) {
                        req.url = jenkinsMatch[1];
                    }
                },
                target: JENKINS_URL,
            }
        }
    }
};
