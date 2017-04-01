var chai = require('chai');
var UrlService = require('../../services/url');

var expect = chai.expect, assert = chai.assert;

var mongoose = require('../../config/mongoose');
var db = mongoose.createConnection(process.env.TEST_DB_URL || 'mongodb://localhost/test');

describe('URL service', function() {

  before(function() {
    db.dropDatabase();
  });

  after(function() {
    db.dropDatabase();
  });

  describe('create', function() {

    it('is able to save a new url model from a url and shortcode', function(done) {

      UrlService.create('https://www.apple.com', 'ABCDEF')
      .then(function(urlCreated) {
        expect(urlCreated.url).to.equal('https://www.apple.com');
        expect(urlCreated.shortcode).to.equal('ABCDEF');
        done();
      });

    });

    it('is able to fail when url is not provided', function(done) {

      UrlService.create(null, 'ABCDEF')
      .catch(function(err) {
        expect(err.errors.url.kind).to.equal('required');
        done();
      });

    });

    it('is able to fail when shortcode is invalid', function(done) {

      UrlService.create('https://www.apple.com', 'AB')
      .catch(function(err) {
        expect(err.errors.shortcode.message).to.equal('Invalid shortcode');
        done();
      });

    });

  });

  describe('getting and updating stats', function() {

    before(function(done) {

      UrlService.create('https://www.apple.com', 'ABCDEF')
      .then(function() {
        done();
      });

    });

    it('is able to get an existing url model', function(done) {

      UrlService.get('ABCDEF')
      .then(function(urlCreated) {
        expect(urlCreated).to.exist;
        done();
      });

    });

    it('is able to update stats for an existing url model', function(done) {

      UrlService.get('ABCDEF')
      .then(function(urlFetched) {

        var previousCount = urlFetched.redirectCount;

        UrlService.updateStats(urlFetched)
        .then(function(urlUpdated) {
          expect(urlUpdated.redirectCount).to.be.above(previousCount);
          done();
        });

      });

    });


  });

});