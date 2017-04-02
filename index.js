// Load env
var dotenv = require('dotenv');
dotenv.load();

var app = require('./config/express');
var mongoose = require('./config/mongoose');

module.exports = app;