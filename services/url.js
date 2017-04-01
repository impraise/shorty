var Url = require('../models/url');

module.exports = {

  create: function(path, shortcode) {
    return new Url({
      url: path,
      shortcode: shortcode
    }).save();
  },

  get: function(shortcode) {
    return Url.findOne({
      shortcode: shortcode
    });
  },

  updateStats: function(url) {
    url.redirectCount = url.redirectCount + 1;
    url.lastSeenDate = new Date();
    return url.save()
  }

};