

$ = require('nodobjc')
   	$.import('Foundation')

var pool = $.NSAutoreleasePool('new')

$.import('~/Library/Frameworks/ORSSerial.framework');

// console.error($.MM2200087.getClass().methods())


var p = $.ORSSerialPortManager('sharedSerialPortManager')('availablePorts')('firstObject')

console.log(p)

// var multimeter = $.MM2200087('new');



// var block = (function(){ console.log(this); });
// x('setOnChange', block)
// console.log(p.getClass())


	// console.log(obj('description')('UTF8String'));

// console.log(p, x)

// array('enumerateObjectsUsingBlock', $(function (self, obj, index, bool) {
// 	var d = array('objectAtIndex',index)('description')('UTF8String');
// 	var v = obj('description')('UTF8String');
// 	assert.equal(d,v);
// }, ['v',['?', '@','I','^B']]));

  

  // x('meterOnPort',  onChange:^(id thing){

//     [thing log];

//   }];


// var i = $.ORSSerialPort('new')

//console.error(i)
//console.error(i.methods())
//console.error(i('hello'))

// var require ('c3')

// #!/usr/bin/env node
var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(8080, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});

wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});

function originIsAllowed(origin) {
  // put logic here to detect whether the specified origin is allowed.
  return true;
}

 

setInterval(function() {
  sensorValue = 500; // Math.random(120)*1000;
}, 100);

wsServer.on('request', function(request) {
    if (!originIsAllowed(request.origin)) {
      // Make sure we only accept requests from an allowed origin
      request.reject();
      console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
      return;
    }

    var connection = request.accept('sensors-protocol', request.origin);
    console.log((new Date()) + ' Connection accepted.');

    // continuos data flow
    setInterval(function() {
        connection.sendUTF('{ "msgtype":"data", "sensortype":"temperature", "sensorid":"123", "value":"' + sensorValue + '" }');
    }, 500);

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            // connection.sendUTF(message.utf8Data);
            // connection.sendUTF('{"temp": ' + Math.random(120)*1000 + '}')

            connection.sendUTF('{ "msgtype":"data", "sensortype":"temperature", "sensorid":"123", "value":"' + 10000 + '" }');


        }
        else if (message.type === 'binary') {
            console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
            connection.sendBytes(message.binaryData);
        }
    });

    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});


window.jQuery = $ = require('jquery')
// Bootstrap doesn't have a "main" field / export anything =(
var bootstrap = require('bootstrap/dist/js/bootstrap')

// Get Bootstrap styles with cssify
var style = require('./node_modules/bootstrap/dist/css/bootstrap.css')

var popover = document.createElement('span')
popover.innerHTML = 'I have a popover'
document.body.appendChild(popover)

$(popover).popover({ content: 'I am popover text' })


multimeter('setPort', p)


// __dirname + '/Test Framework.framework')

// console.error($.NSTestClass)
// console.error($.NSTestClass.methods())/
// console.error($.NSTestClass('hello'))

// console.error($.ORSSerialPort)
// console.error($.ORSSerialPort.methods())
// console.error($.NSTestClass(''))

// console.error($.MultiMeter)
// console.error($.MultiMeter.methods())

// console.error($.MM2200087)
