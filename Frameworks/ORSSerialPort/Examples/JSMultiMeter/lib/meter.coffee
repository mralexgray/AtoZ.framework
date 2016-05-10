$ = require 'nodobjc'
EventLoop = require 'nodobjc/examples/EventLoop'

EventLoop.initObjC $

$.import 'Foundation'
$.import '~/Library/Frameworks/ORSSerial.framework'

evtLoop = new EventLoop()
pool = $.NSAutoreleasePool 'new'

module.exports = class Meter
	@constructor: (@callback) ->
		@port = $.ORSSerialPortManager('sharedSerialPortManager')('availablePorts')('firstObject')
		signature = ['v',['?', '@']]
		blockDecl = ((self, obj) -> @callback(obj))
		@meter = $.MM2200087 'meterOnPort', p, 'onChange', $ blockDecl, signature
		evtLoop.start()


# m 'setPort', p


# m 'setOnChange',

#console.log p.methods()
#console.log p

# m.port = p
# m.onChange = (x) -> console.log x


# $.CFRunLoopRun()
