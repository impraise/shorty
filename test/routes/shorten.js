var chai = require('chai'), chaiHttp = require('chai-http');
var app = require('../../index');
var UrlService = require('../../services/url');
var shortcodeLib = require('../../lib/shortcode');

var expect = chai.expect, assert = chai.assert;

chai.use(chaiHttp);

var mongoose = require('../../config/mongoose');
var db = mongoose.createConnection(process.env.TEST_DB_URL || 'mongodb://localhost/test');

describe('url shortening api', function() {

  before(function() {
    db.dropDatabase();
  });

  after(function() {
    db.dropDatabase();
  });

  describe('creating a short url', function() {

    describe('should not create', function() {

      it('if url is not provided', function(done) {      

        chai.request(app)
        .post('/shorten')
        .set('Content-Type', 'application/json')
        .send({})
        .end(function(err, res) {
          expect(res).to.have.status(400);
          done();                               
        });

      });

      it('if provided shortcode already exists', function(done) {

        UrlService.create('https://www.apple.com', 'iW5nF0').then(function(item) {

          if(item){
            chai.request(app)
            .post('/shorten')
            .set('Content-Type', 'application/json')
            .send({
              url: 'https://www.apple.com',
              shortcode: 'iW5nF0'
            })
            .end(function(err, res) {
              expect(res).to.have.status(409);
              done();                               
            });
          }

        });

      });

      it('if provided shortcode is invalid', function(done) {      

        chai.request(app)
        .post('/shorten')
        .set('Content-Type', 'application/json')
        .send({
          url: 'https://www.apple.com',
          shortcode: '12'
        })
        .catch(function(err) {
          expect(err).to.have.status(422);
          done();
        })

      });

    })

    describe('should create', function() {

      it('a random shortcode if none is provided', function(done) {      

        chai.request(app)
        .post('/shorten')
        .set('Content-Type', 'application/json')
        .send({
          url: 'https://www.apple.com'
        })
        .end(function(err, res) {
          expect(res).to.have.status(201);
          expect(res).to.be.json;
          expect(res.body.shortcode).to.exist;
          expect(res.body.shortcode).to.match(shortcodeLib.randomShortcodeRegex);
          done();                               
        });

      });

      it('with the provided valid shortcode', function(done) {      

        chai.request(app)
        .post('/shorten')
        .set('Content-Type', 'application/json')
        .send({
          url: 'https://www.apple.com',
          shortcode: '4R_34y'
        })
        .end(function(err, res) {
          expect(res).to.have.status(201);
          expect(res).to.be.json;
          expect(res.body.shortcode).to.exist;
          expect(res.body.shortcode).to.equal('4R_34y');
          done();                               
        });

      });

    });

  });

});