var express = require('express')
var router = express.Router();
var UrlService = require('../services/url');

router.post('/', function (req, res) {
  if (req.body.url) {
    UrlService.get(req.body.shortcode).then(function(item) {
      if(!item){
        UrlService.create(req.body.url, req.body.shortcode).then(function(item) {
          res.status(201);
          res.json({
            shortcode: item.shortcode
          });
        }).catch(function(err) {
          if (err.errors.shortcode.message === 'Invalid shortcode') {
            res.status(422).end();
          }
          else{
            res.status(500).end();
          }
        });
      }
      else{
        res.status(409).end();
      }
    });
  }
  else{
    res.status(400).end();
  }
});

module.exports = router;