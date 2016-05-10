WebSocketServer = require('websocket').server
http = require 'http'

originIsAllowed = (origin) -> true # put logic here to detect whether the specified origin is allowed


class WSMeter
	# instance = null
	constructor: ->
		# if instance
			# return instance
		# else 
			# instance = this
		# contructor code
		@sensorValue = 1000
		@connections = []
		@server = http.createServer (request, response) ->
			console.log "#{new Date} Received request for #{request.url}"
			response.writeHead 404
			response.end()
		
		@server.listen 8080, -> 
			console.log "#{new Date} Server is listening on port 808"

		@wsServer = new WebSocketServer
			httpServer: @server
			autoAcceptConnections: false
	
		@wsServer.on 'request', (request) ->
			# if not originIsAllowed request.origin
				# Make sure we only accept requests from an allowed origin
				# request.reject()
				# return console.log "#{new Date} Connection from origin #{request.origin} rejected."

			connection = request.accept 'sensors-protocol', request.origin
			@.connections.push connection
			console.log "#{new Date} Connection accepted. c's: #{require('util').inspect(@connections[0])}"
			
			# continuos data flow
			setInterval ->
				j = 
					'msgtype': 'data'
					'sensortype': 'temperature'
					'sensorid': '123'
					'value': @.sensor
				connection.sendUTF JSON.stringify(j)
			, 500

			connection.on 'message', (message) ->
				if message.type == 'utf8'
					console.log 'Received Message: ' + message.utf8Data
					# connection.sendUTF(message.utf8Data);
					# connection.sendUTF('{"temp": ' + Math.random(120)*1000 + '}')
					connection.sendUTF '{ "msgtype":"data", "sensortype":"temperature", "sensorid":"123", "value":"' + 10000 + '" }'
				else if message.type == 'binary'
					console.log "Received Binary Message of #{message.binaryData.length} bytes"
					connection.sendBytes message.binaryData

			connection.on 'close', (reasonCode, description) ->
				console.log "#{new Date} Peer #{connection.remoteAddress} disconnected."

	sendSensor: (sense) ->
		# if @connections.length
		# 	j = JSON.stringify 
		# 		'msgtype': 'data'
		# 		'sensortype': 'temperature'
		# 		'sensorid': '123'
		# 		'value': (@sensor = sense)

		# 	c.sendUTF(j) for c in @.connections 
		
theMeter = new WSMeter
module.exports = exports = theMeter

# '{ "msgtype":"data", "sensortype":"temperature", "sensorid":"123", "value":"' + sensorValue + '" }');