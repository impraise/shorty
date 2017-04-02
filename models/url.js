var mongoose = require('mongoose');
var shortcodeLib = require('../lib/shortcode');

var Schema = mongoose.Schema;

var urlSchema = new Schema({
  url: {type: String, required: true},
  shortcode: {
    type: String, 
    validate: {
      validator: function(v) {
        return /^[0-9a-zA-Z_]{4,}$/.test(v);
      },
      message: 'Invalid shortcode'
    }
  },
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