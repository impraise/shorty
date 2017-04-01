var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var urlSchema = new Schema({
  url: String,
  shortcode: String,
  lastSeenDate: Date,
  redirectCount: {type: Number, default: 0}
}, {
  timestamps: { createdAt: 'startDate' }
});

module.exports = mongoose.model('Url', urlSchema);