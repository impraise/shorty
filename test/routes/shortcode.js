var chai = require('chai'), chaiHttp = require('chai-http');
var app = require('../../index');
var UrlService = require('../../services/url');

var expect = chai.expect, assert = chai.assert;

chai.use(chaiHttp);

var mongoose = require('../../config/mongoose');
var db = mongoose.createConnection(process.env.TEST_DB_URL || 'mongodb://localhost/test');

describe('url shortening api', function() {

  describe('getting a short url', function() {

    it('should return not found if shortcode does not exist', function(done) {      

      chai.request(app)
      .get('/abcd')
      .end(function(err, res) {
        expect(res).to.have.status(404);
        done();                               
      });

    });

    it('should redirect if shortcode does exist', function(done) {  

      UrlService.create('https://www.apple.com', 'abcdef').then(function(item) {
        if (item) {
          chai.request(app)
          .get('/abcdef')
          .end(function(err, res) {
            expect(res).to.redirect;
            done();                               
          });
        }
      });    

    });

  });

  describe('getting the stats for a short url', function() {

    before(function() {
      db.dropDatabase();
    });

    after(function() {
      db.dropDatabase();
    });

    it('should return not found if shortcode does not exist', function(done) {      

      chai.request(app)
      .get('/abcd/stats')
      .end(function(err, res) {
        expect(res).to.have.status(404);
        done();                               
      });

    });

    it('should return the stats if shortcode does exist', function(done) {

      UrlService.create('https://www.apple.com', 'abcdef').then(function(item) {
        if (item) {
          chai.request(app)
          .get('/abcdef/stats')
          .end(function(err, res) {
            expect(res).to.have.status(200);
            expect(res.body.startDate).to.exist;
            expect(res.body.redirectCount).to.equal(0);
            done();                               
          });
        }
      });

    });

  })

  describe('updating the stats for a short url', function() {

    before(function() {
      db.dropDatabase();
    });

    after(function() {
      db.dropDatabase();
    });

    it('should update the redirect count on each redirect', function(done) {      

      UrlService.create('https://www.apple.com', 'abcdef').then(function(item) {

        expect(item.redirectCount).to.equal(0);

        if (item) {
          chai.request(app)
          .get('/abcdef')
          .end(function(err, res) {
            expect(res).to.have.status(200);
            UrlService.get('abcdef').then(function(item) {
              expect(item.redirectCount).to.equal(1);
              done();
            })                               
          });
        }
      });

    });
  });

});