var supertest = require('supertest'),
    should = require('chai').should(),
    expect = require('chai').expect,
    mongoClient = require('mongodb').MongoClient;

var api = supertest('http://localhost:8090');

var adminUserName = "admin";
var adminUserPassword = "admin";

describe('Authentication', function(){
         
         it('admin can login', function(done){
            
            api.post('/api/login')
            .type('json')
            .send({
                  'username': adminUserName,
                  'password': adminUserPassword
                  })
            .expect(200)
            .end(function(err, res){
                 expect(res.body).to.not.equal(null);
                 expect(res.body.status).to.not.equal("error");
                 expect(res.body.status).to.equal("ok");
                 expect(res.body.user).to.equal("admin");
                 expect(res.body.token).to.not.equal(null);
                 done();
            });
        });
         
         
         it('can create new user', function(done){
            
            });

});
