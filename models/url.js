var mongoose = require('mongoose');
var shortcodeLib = require('../lib/shortcode');

var Schema = mongoose.Schema;

var urlSchema = new Schema({
  url: {type: String, required: true},
  shortcode: String,
  lastSeenDate: Date,
  redirectCount: {type: Number, default: 0}
}, {
  timestamps: { createdAt: 'startDate' }
});

urlSchema.pre('save', function(next) {
  if (!this.shortcode) {
    this.shortcode = shortcodeLib.generate();
  }
  next();
});

module.exports = mongoose.model('Url', urlSchema);