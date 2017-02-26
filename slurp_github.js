#!/usr/bin/env node

const  https = require('https');
const crypto = require('crypto');
const fs = require('fs');
const prompt = require('prompt');

var exec = require('child_process').exec;

var options = {
  hostname: 'api.github.com',
  port: 443,
  path: '/user/repos',
  method: 'GET',
  headers: {
    'User-Agent': 'slurp_github/0.1 (x86_64-apple-darwin10.2.0) nodejs/6.10'
  }
}

function puts(error, stdout, stderr) { console.log(error);console.log(stderr);console.log(stdout) }

const tokenfile = process.env.HOME+'/.secrets/slurp_key'; //

function slurp_repos(parsed){
  //TODO: need to get new repos only
  //Requires making a list of the ones it downloaded from ls

  for(var i in parsed){

    var sshUrl = parsed[i]['ssh_url'];
    exec("git clone "+sshUrl, puts);
  }
}


// get password from stdin
prompt.get([{
  name: 'password',
  hidden: true,
  required: true
}],(e,r) => {
  fs.readFile(tokenfile,(e,data)=>{
    var enc = data.toString().trim();
    var decipher = crypto.createDecipher('aes256',r.password);
    var key = decipher.update(enc, 'base64','utf8');
    key += decipher.final('utf8');
    options.headers['Authorization']='token '+key;
    var req = https.request(options, (res)=> {
      var body = '';
      res.on("data",(d)=>{
        body += d;
      });
      res.on("end",()=>{
        var parsed = JSON.parse(body);
        slurp_repos(parsed);
      });
    });
    req.end();
  });
});
// open it and decrypt contents
