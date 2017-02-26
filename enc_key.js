#!/usr/bin/env node
const crypto = require('crypto');
const fs = require('fs');
const prompt = require('prompt');

// Get key from prompt
//Get Password from prompt

prompt.get([{
  name: 'keyname',
  required:true
},{
  name: 'apikey',
  required: true
},{
  name: 'password',
  hidden: true,
  required: true
}],(e,r) => {
  var cipher = crypto.createCipher('aes256', r.password);
  var enc = cipher.update(r.apikey,'utf8','base64');
  enc += cipher.final('base64');
  fs.writeFile(process.env.HOME+'/.secrets/'+r.keyname, enc, (e) => {
    if(e){
      console.log(e);
    }
  });
});
