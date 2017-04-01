var chai = require('chai');
var shortcodeLib = require('../../lib/shortcode');

var expect = chai.expect, assert = chai.assert;

describe('module to generate shortcode', function() {

  it('generates a random shortcode based on decided regex', function() {      

    expect(shortcodeLib.generate()).to.match(shortcodeLib.randomShortcodeRegex);

  });

});