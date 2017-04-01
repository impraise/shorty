var randomstring = require('randomstring');

module.exports = {

  randomShortcodeRegex: /^[0-9a-zA-Z_]{6}$/,

  generate: function() {
    return randomstring.generate({
      length: 6,
      custom: this.randomShortcodeRegex
    });
  }

};