var express = require('express');
var bodyParser = require('body-parser');

var app = express();

// Ensure we only accept Content-Type: application/json
app.use(
  bodyParser.json({
    type: 'application/json'
  })
);

// Routes
app.use('/shorten', require('../routes/shorten'));
app.use('/', require('../routes/shortcode'));

module.exports = app;