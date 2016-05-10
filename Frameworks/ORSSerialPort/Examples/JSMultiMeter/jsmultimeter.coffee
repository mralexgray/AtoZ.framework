
ws = require './lib/ws-server'

callb = (snap) -> 
  global["sensorValue"] = snap
  console.log snap('display')

Meter = require './lib/meter'
m = new Meter(callb)




# setInterval ->
  # global["sensorValue"] = Math.random(120) * 1000
# , 100

console.log m, ws

###
setInterval -> 
  meter.sendSensor (Math.random 120) * 1000
  console.log meter.connections
, 2000


  if not wsmeter.connections
    return # console.log "connections:${wsmeter.connections}"
  sensorValue = Math.random(120) * 1000
  j = 
    'msgtype': 'data'
    'sensortype': 'temperature'
    'sensorid': '123'
    'value': sensorValue
  stringed = JSON.stringify(j)
  console.log stringed
  c.sendUTF(stringed) for c in wsmeter.connections
###



###
meter = require './lib/meter', (display) ->
  for c in connections
    c.sendUTF "\"msgtype\": \"data\", \"sensortype\":\"temperature\", 
               \"sensorid\":\"123\", \"value\":"' + sensorValue + '" }');
###
