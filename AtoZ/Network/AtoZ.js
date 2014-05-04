///*jslint -W033, -W098, -W099, -W116 */ 
///*jslint browser: true*/
/*global $,Meny*/
/*atoz AZWebSocketServer.baseHTML */
var ws = new WebSocket('ws://mrgray.com:3333')
$(function () {
	$('body').append('<div class="meny"><h2>Menu</h2><ul><li><a href="http://lab.hakim.se/avgrund/">Avgrund</a></li>\
				<li><a href="http://lab.hakim.se/radar/">Radar</a></li>\
				<li><a href="http://lab.hakim.se/forkit-js/">forkit.js</a></li>\
				<li><a href="http://lab.hakim.se/scroll-effects/">stroll.js</a></li>\
				<li><a href="http://lab.hakim.se/zoom-js">zoom.js</a></li>\
				<li><a href="http://lab.hakim.se/reveal-js">reveal.js</a></li></ul></div><div class="contents"><article></article></div>')

	function note(tit, txt) { $('.container').first().notify('create', { title: tit, text: txt }) }
	$('.container').first().notify({ speed: 500 })
	$('#input').show();
	//ws.binaryType = 'arraybuffer'
	ws.onopen    = function () {
		note('CONNECTED', ws.url)
		ws.send('hello from ' + navigator.userAgent);
	}
	ws.onmessage = function (e) {		
		console.log('onmessage!')
		try { 
			var json =	 $.parseJSON(e.data)        // this works with JSON string and JSON object, not sure about others
			if (typeof json === 'object') note('RESPONSE(' + typeof(json) + ')', e.data)//json.payload)
			if (json.toEval) $.globalEval(json.toEval)
			//  if (obj.type === 'image') $('#container')
		} 
		catch (ex) { console.error('data is not JSON') }
	}
	var meny = Meny.create({ // The element that will be animated in from off screen
	  menuElement: document.querySelector('.meny' ),
	  contentsElement: document.querySelector( '.contents' ),     // The contents that gets pushed aside while Meny is active
	// The alignment of the menu (top/right/bottom/left)
	position: 'left',
	// The height of the menu (when using top/bottom position)
	height: 200,
	// The width of the menu (when using left/right position)
	width: 260,
	// Use mouse movement to automatically open/close
	mouse: true,
	// Use touch swipe events to open/close
	touch: true
	})
	$('html').click(function(e) { 		console.log('click ' + e.clientX + ' ' + e.clientY)
//		var offset = $(this).offset();
		ws.send('click ' + e.clientX + ' ' + e.clientY)
 })

})
/*atoz AZWebSocketServer.baseHTML */