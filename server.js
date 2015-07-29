var http = require('http');
var request = require('request');
var fs = require('fs');

const PORT = 5050;

function File(furl, fname) {
  this.name = fname;
  this.url = furl;
  this.downloadFile = function(callback) {
    request.get(this.url).pipe(fs.createWriteStream(this.name)).on('close', callback);
  }
}

var a = new File('https://api.onedrive.com/v1.0/drive/root:/test:/children?access_token=EwB4Aq1DBAAUGCCXc8wU/zFu9QnLdZXy+YnElFkAAcj85gxBkpQwii7fA9AA5vllBXgKnaxMZAS9Ybfzg9Rpr6J/mSeVEjb30bsmjNUQYd2IN6sC7FA9waz3C7Pa1/3j+3G1lYHjvLpWl7jT8xITBEGt0XRFUWrVblr6nPW/C3srLnaDrZj5xuoHEn5XPKIceddX1aW44aes0FX0I1xnA8cfZZ0lORc2C23a5vZ9pQAgu6i4YMQSylKqrTSjDuouszXshqPX0woknabZdqdJ4QfR0s0j2gYBmbGtD25zKAAgS0J5VYssGeODya2hjNuDpg22WNZn+2Zq4S5WZx5xN/0dbcS3T5F51/lQUXQDQTSqGmCwNE3WUPuWQgBSlHgDZgAACIMz3uaxgAIxSAGScF/LVLSLDo4fvp1wR/SXxc0sCvqHiTdynv/B6G4VMmmEtoUuWrTpIZ/9TLaEMMnwEQTbN9cnzdxdB3K0wJxIydMhnwIDkMdQvzwddIA3nxcselan7EeEbWSTar4hb6faLKBHJ4JAuBrccxXCAh0XpbxhQojebq3kG8crTG5ZVyw7MHtW+Vhnw1qr+yho8hHdq4F5VXzKJ8kUJAQO/0rR3TbIB90oIIg21+FqBzUpAoAyTSSMvMfk5RRBVtqaI8EeLWIDDJCs7gSWJzhWaNYo6IcWRC1rjG6dVdj+l9ZlRC2iNAO5f6QJs9ZQkD9ZqgGcENMgX5MdpIAqW6jPe/fiBdZAp6Qn0T0PD9GCChmK21XnzkwggEn3Pn8agBjO48WgYDHZX4+Dv+Qp5ieOyCnPmvQ/R3HEe5sCJcqto+s/n1RbL/eLAzjvYwE', 'aaa.txt');
a.downloadFile(function(){ console.log('success'); });

/*
function handleRequest(request, response){
    response.end('It Works!! Path Hit: ' + request.url);
}

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function(){
    console.log("Server listening on: http://localhost:%s", PORT);
});
*/
