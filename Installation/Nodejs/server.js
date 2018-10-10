    var dispatcher = require('httpdispatcher');
    var http = require('http');
    var url = require('url');
    var kafka = require('kafka-node');
    var os = require("os");

    var extend = require('util')._extend

    var fs = require('fs');

     var stream = fs.createWriteStream("log.txt");



    function kafaProducer(topics, mes, part) {
    // ... 
     Producer = kafka.Producer,
     client = new kafka.Client('23.251.153.93:2181');


 fs.appendFile('log.txt', JSON.stringify(mes)+os.EOL, function (err) {

});
     //console.log(client);
     producer = new Producer(client);
     payloads = [
         { topic: topics, messages: JSON.stringify(mes) , partition: part },
     ];

      client.on('ready', function (){
       
    })  

    client.on('error', function (err){
       
    })  


 //    producer 'on' ready to send payload to kafka.
     producer.on('ready', function(){
        producer.send(payloads, function(err, data){
          
        });
        console
     });

     producer.on('error', function(err){});
    }

    dispatcher.setStatic('/resources');

    dispatcher.setStaticDirname('static');

    dispatcher.onGet("/omniture", function(request, response) {
      
      var headers = request.headers;
      var method = request.method;
      //console.log(request.connection.remoteAddress);
     // console.log(headers);
      var url_parts = url.parse(request.url,true);
      //console.log(url_parts.query);
      var o = extend({"userIp" : request.connection.remoteAddress}, headers);
      extend(o,  url_parts.query);
     
      kafaProducer("omniture",o,0);
      var body = [];
      request.on('error', function(err) {
              console.error(err);
      }).on('data', function(chunk) {
             body.push(chunk);
       }).on('end', function() {
       body = Buffer.concat(body).toString();
    // BEGINNING OF NEW STUFF
      // console.log('body----'+body);

      response.on('error', function(err) {
      console.error(err);
       });

      response.statusCode = 200;
      response.setHeader('Content-Type', 'application/json');

      var responseBody = {
        headers: headers,
        method: method,
        url: url,
        body: body
    };

      response.write("recieved");
      response.end();
    }); 
     });

      dispatcher.onGet("/", function(request, response) {
      var headers = request.headers;
      var method = request.method;
      console.log(headers);
      var url_parts = url.parse(request.url,true);
      console.log(url_parts.query);
      var o = extend({"userIp" : request.connection.remoteAddress}, headers);
      extend(o,  url_parts.query);
     
      kafaProducer("test1",o,0);      
      var body = [];
      request.on('error', function(err) {
              console.error(err);
      }).on('data', function(chunk) {
             body.push(chunk);
       }).on('end', function() {
       body = Buffer.concat(body).toString();
    // BEGINNING OF NEW STUFF
       //console.log(body);

      response.on('error', function(err) {
      console.error(err);
       });

      response.statusCode = 200;
      response.setHeader('Content-Type', 'application/json');

      var responseBody = {
        headers: headers,
        method: method,
        url: url,
        body: body
    };

      response.write(JSON.stringify(responseBody));
      response.end();
    }); 
     });

    dispatcher.onPost("/tealium", function(request, response) {
      var headers = request.headers;
      var method = request.method;
      var body = request.body;
      console.log('body ='+ body);
	  kafaProducer('tealium', body, 0);


      var responseBody = {
        headers: headers,
        method: method,
        url: url,
        body: "recieved"
    };
		  response.writeHead(200, {
	'Content-Type' : 'application/json',
    'Access-Control-Allow-Origin' : '*',
		}); 
      response.on('error', function(err) {
      console.error(err);
       });
      response.end();
    });

    dispatcher.onError(function(req, res) {
        res.writeHead(404);
        res.end();
    });

    http.createServer(function (req, res) {
        dispatcher.dispatch(req, res);
    }).listen(80);
