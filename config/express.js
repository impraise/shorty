var express = require('express');
var bodyParser = require('body-parser');

var app = express();
app.use(bodyParser.json());

// Routes
app.use('/shorten', require('../routes/shorten'));
app.use('/', require('../routes/shortcode'));

module.exports = app;