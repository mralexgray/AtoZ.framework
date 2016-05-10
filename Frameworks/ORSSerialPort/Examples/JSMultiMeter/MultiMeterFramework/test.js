var $ = require('nodobjc')

$.import('Foundation')

console.error($.NSTestClass)

var pool = $.NSAutoreleasePool('alloc')('init')

// Absolute path
$.import('/Users/localadmin/Library/Frameworks/ORSSerial.framework');

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
console.error($.MM2200087.getClass().methods())


var p = $.ORSSerialPortManager('sharedSerialPortManager')('availablePorts')('firstObject')


// console.log(p.getClass())


var block = (function(){ console.log(this); });

var x = $.MM2200087('new');
// x('setOnChange', block)
x('setPort', p)

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
