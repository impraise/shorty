// Requires
var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var dotenv = require('dotenv');

dotenv.load();

// Setup app
var app = express();
app.use(bodyParser.json());

// Setup mongoose
var mongoose = require('mongoose');
mongoose.Promise = global.Promise;

if (process.env.NODE_ENV === 'test') {
  mongoose.connect(process.env.TEST_DB_URL || 'mongodb://localhost/test');
}
else{
  mongoose.connect(process.env.DB_URL || 'mongodb://localhost/shortydb');
}

app.use('/shorten', require('./routes/shorten'));
app.use('/', require('./routes/shortcode'));

module.exports = app;