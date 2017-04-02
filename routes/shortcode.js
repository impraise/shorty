var express = require('express')
var router = express.Router();
var UrlService = require('../services/url');

router.get('/:shortcode', function(req, res) {

  UrlService.get(req.params.shortcode).then(function(item) {
    if (item) {
      UrlService.updateStats(item).then(function(item) {
        res.redirect(item.url);
      });
    }
    else{
      res.status(404).end();
    }
  });

});

router.get('/:shortcode/stats', function(req, res) {

  UrlService.get(req.params.shortcode).then(function(item) {
    if (item) {
      res.status(200);
      res.json({
        startDate: item.startDate,
        lastSeenDate: item.lastSeenDate,
        redirectCount: item.redirectCount
      });
    }
    else{
      res.status(404).end();
    }
  });

});

module.exports = router;