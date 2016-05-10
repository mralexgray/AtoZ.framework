

WebSocketServer = require('websocket').server

http = require('http')

server = http.createServer (request, response) ->
  console.log new Date + ' Received request for ' + request.url
  response.writeHead 404
  response.end()

originIsAllowed = (origin) ->
  # put logic here to detect whether the specified origin is allowed.
  true

server.listen 8080, ->
  console.log new Date + ' Server is listening on port 8080'

wsServer = new WebSocketServer
  httpServer: server
  autoAcceptConnections: false

connections = exports.connections = []

wsServer.on 'request', (request) ->
  if !originIsAllowed(request.origin)
    # Make sure we only accept requests from an allowed origin
    request.reject()
    return console.log new Date + ' Connection from origin ' + request.origin + ' rejected.'

  connection = request.accept('sensors-protocol', request.origin)
  console.log new Date + ' Connection accepted.'

  connections.push connection
  console.log connections.length
  # continuos data flow
  # setInterval ->
    # connection.send JSON.stringify 
      # "msgtype":"data"
      # "sensortype":"temperature"
      # "sensorid":"123"
      # "value": sensorValue
  # , 500
  
  connection.on 'message', (message) ->
    if message.type == 'utf8'
      console.log 'Received Message: ' + message.utf8Data
      # connection.sendUTF(message.utf8Data);
      # connection.sendUTF('{"temp": ' + Math.random(120)*1000 + '}')
      connection.sendUTF '{ "msgtype":"data", "sensortype":"temperature", "sensorid":"123", "value":"' + 10000 + '" }'
    else if message.type == 'binary'
      console.log 'Received Binary Message of ' + message.binaryData.length + ' bytes'
      connection.sendBytes message.binaryData

  connection.on 'close', (reasonCode, description) ->
    console.log new Date + ' Peer ' + connection.remoteAddress + ' disconnected.'
