var chai = require('chai');
var Url = require('../../models/url');

var expect = chai.expect, assert = chai.assert;

var mongoose = require('../../config/mongoose');
var db = mongoose.createConnection(process.env.TEST_DB_URL || 'mongodb://localhost/test');

describe('Url Model', function() {

  before(function() {
    db.dropDatabase();
  });

  after(function() {
    db.dropDatabase();
  });

  describe('on create', function() {

    it('has the redirect count set to 0', function(done) {

      new Url({url: 'https://www.apple.com', shortcode: 'ABCDEF'})
      .save()
      .then(function(urlCreated) {
        expect(urlCreated.redirectCount).to.equal(0);
        done();
      });

    });

    it('generates a random shortcode if none is provided', function(done) {

      new Url({url: 'https://www.apple.com'})
      .save()
      .then(function(urlCreated) {
        expect(urlCreated.shortcode).to.exist;
        done();
      });

    });

    it('has the startDate set', function(done) {

      new Url({url: 'https://www.apple.com'})
      .save()
      .then(function(urlCreated) {
        expect(urlCreated.startDate).to.exist;
        done();
      });

    });

    it('does not save without a url', function(done) {

      new Url({})
      .save()
      .catch(function(err) {
        expect(err.errors.url.kind).to.equal('required');
        done();
      });

    });

  });

});