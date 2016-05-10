  c = require 'coffee-script'.register()

	if 0
		menubar = require 'menubar'
		mb = menubar()

		mb.on 'ready', ->
			console.log 'app is ready'
			$ = require 'nodobjc'
			$.import 'Cocoa'

			pool = $.NSAutoreleasePool('alloc')('init')

			$.NSLog($('test'));

			#$.NSBeep()
			#$.NSLog 'whatveHELLL!'


	$ = require('nodobjc')
	$.import('Foundation')

	pool = $.NSAutoreleasePool 'new'

	$.import '~/Library/Frameworks/ORSSerial.framework'

	# console.error($.MM2200087.getClass().methods())

	p = $.ORSSerialPortManager('sharedSerialPortManager')('availablePorts')('firstObject')


	signature = ['v',['?', '@']]
	blockDecl = ((self, obj) -> console.log "#{obj}")

	m = $.MM2200087 'meterOnPort', p, 'onChange', $ blockDecl, signature

	# m 'setPort', p


	# m 'setOnChange',

	#console.log p.methods()
	#console.log p

	# m.port = p
	# m.onChange = (x) -> console.log x

	$.CFRunLoopRun()


// console.error($.MM2200087.getClass().methods())




