//
//  Bootstrap.h
//  KSHTMLWriter
//
//  Created by Alex Gray on 5/6/12.
//  Copyright (c) 2012 Karelia Software. All rights reserved.
//


#import "AtoZUmbrella.h"
//#import "GCDAsyncSocket.h"

#define JQUERY							@"http://code.jquery.com/jquery-2.0.0b2.js" // @"http://code.jquery.com/jquery-1.9.1.js"
#define JQUERY_UI						@"http://code.jquery.com/ui/1.10.3/jquery-ui.js"
#define RECORDERJS					@"http://mrgray.com/js/recorder.js/recorder.js"
#define BOOTSTRAP_CSS				@"//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"
#define BOOTSTRAP_JS				@"//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"
#define FONTAWESOME					@"//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css"
#define BOOTSWATCH_UNITED 	@"//netdna.bootstrapcdn.com/bootswatch/3.0.0/united/bootstrap.min.css"

#define JQUERY_UI_CSS				@"http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"
#define LIVEQUERY						@"http://mrgray.com/js/jquery.livequery.js"


@protocol  AZJS                   @prop_RO NSS * stringValue; @end

@interface AZJS : NSString <AZJS> @prop_RO NSS * description; @end

@interface        AZJSVar : AZJS   @prop_CP NSS * varName, * value;

+ (instancetype) varNamed:(NSS*)nm value:(NSS*)val;           @end

@interface  AZJQueryMethod : AZJS

+ (instancetype) withSelector:(NSS*)sel action:(NSS*)f args:(NSA*)a callback:(NSA*)c;

@prop_CP NSS * selector, * action; @prop_CP NSA * callback;   @end

/**	$(selector).on(event,childSelector,data,function,map)
	@param event	Required. Specifies one or more event(s) or namespaces to attach to the selected elements. Multiple event values are separated by space. Must be a valid event
	@param childSelector	Optional. Specifies that the event handler should only be attached to the specified child elements (and not the selector itself, like the deprecated delegate() method).
	@param data	Optional. Specifies additional data to pass along to the function
	@param function	Required. Specifies the function to run when the event occurs
	@param map	Specifies an event map ({event:function, event:function, ...}) containing one or more event to attach to the selected elements, and functions to run when the events occur
*/
@interface  AZJQueryOn : AZJQueryMethod

+ (instancetype) select:(NSS*)slctr on:(NSS*)mthd args:(NSA*)args callback:(NSA*)cback;

@end

@interface KSHTMLWriter (extras)

- (void) writeDocReady:(id)a;

@prop_RO NSMS * markup; - (void) preview;
@end

@class ASOCK;
@interface          Gridly : KSHTMLWriter
@property            ASOCK * listenSocket;
@property             NSMA * sockets;
@property dispatch_queue_t dQ;
@end


//+ (void) initWithUserStyle:(Asset*)css script:(Asset*)script andInnerHTML:(NSS*) html  calling:(void(^)(id sender))block;

@class Asset;
@interface Bootstrap : BaseModel

@prop_NA NSAC *availJS, *availCSS, *headers, *footers, *body;

- (NSS*) htmlWithBody:(NSS*)bod;

#pragma mark - OUTPUT
@property (readonly)					NSS *demo, *xml, *markup;



//@property (nonatomic, strong)		NSA *js, *css;
@property (nonatomic, strong)		NSS *userHTML, *html;
@property (nonatomic, strong) 	NSB	 		*bundle;

@end

//#ifdef SYNTHESIZE_CONSTS
//# define STR_CONST(name, value) NSString* const name = @ value
//#else
//# define STR_CONST(name, value) extern NSString* const name
//#endif

extern NSString * const custCSS,
                * const custHTMLRECORDER,
                * const custHTMLFOOT;
//STR_CONST(custCSS, "html,	body{height:100%; } #wrap{min-height:100%;height:auto !important;height:100%;/* Negative indent footer by it's height */	margin:0 auto -60px;}	#push,	#footer{height:60px;}	#footer{background-color:#f5f5f5;}	@media (max-width:767px){#footer{margin-left:-20px;margin-right:-20px;padding-left:20px;padding-right:20px;}	}	#wrap > .container{padding-top:60px;}	.container .credit{margin:20px 0;}	code{font-size:80%;}");
extern NSString * const custHTML;
//STR_CONST(custHTML,
//NSString * const custHTML = @""
//"<!-- Part 1: Wrap all page content here -->"
//"<div id='wrap'>"
//""
//"  <!-- Fixed navbar -->"
//"  <div class='navbar navbar-fixed-top'>"
//"	<div class='navbar-inner'>"
//"	  <div class='container'>"
//"		<button type='button' class='btn btn-navbar' data-toggle='collapse' data-target='.nav-collapse'>"
//"		  <span class='icon-bar'></span>"
//"		  <span class='icon-bar'></span>"
//"		  <span class='icon-bar'></span>"
//"		</button>"
//"		<a class='brand' href='#'>Project name</a>"
//"		<div class='nav-collapse collapse'>"
//"		  <ul class='nav'>"
//"			<li class='active'><a href='#'>Home</a></li>"
//"			<li><a href='#about'>About</a></li>"
//"			<li><a href='#contact'>Contact</a></li>"
//"			<li class='dropdown'>"
//"			  <a href='#' class='dropdown-toggle' data-toggle='dropdown'>Dropdown <b class='caret'></b></a>"
//"			  <ul class='dropdown-menu'>"
//"				<li><a href='#'>Action</a></li>"
//"				<li><a href='#'>Another action</a></li>"
//"				<li><a href='#'>Something else here</a></li>"
//"				<li class='divider'></li>"
//"				<li class='nav-header'>Nav header</li>"
//"				<li><a href='#'>Separated link</a></li>"
//"				<li><a href='#'>One more separated link</a></li>"
//"			  </ul>"
//"			</li>"
//"		  </ul>"
//"		</div><!--/.nav-collapse -->"
//"	  </div>"
//"	</div>"
//"  </div>"
//""
//"  <!-- Begin page content -->"
//"  <div class='container'>"
//"	<div class='page-header'>"
//"	  <h1>Sticky footer with fixed navbar</h1>"
//"	</div>"
//"	<p class='lead'>Pin a fixed-height footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added within <code>#wrap</code> with <code>padding-top: 60px;</code> on the <code>.container</code>.</p>"
//"	<p>Back to <a href='./sticky-footer.html'>the sticky footer</a> minus the navbar.</p>"
//"  </div>");
//STR_CONST(custHTMLFOOT,
//"  <div id='push'></div>"
//"</div>"
//""
//"<div id='footer'>"
//"  <div class='container'>"
//"	<p class='muted credit'>Example courtesy <a href='http://martinbean.co.uk'>Martin Bean</a> and <a href='http://ryanfait.com/sticky-footer/'>Ryan Fait</a>.</p>"
//"  </div>"
//"</div>");
//
//
//	  
//
//STR_CONST(custHTMLRECORDER,
//"  <div id='wrapper'>"
//"<h1><a href='http://github.com/jwagener/recorder'>Recorder Example</a></h1>"
//"<p>"
//"This is a very basic example for the Recorder.js. Checkout <a href='http://github.com/jwagener/recorder'>GitHub</a> for details and have a look at the source for this file.  Start by clicking record:"
//"</p><div>"
//"  <a href='javascript:record()'  id='record'					   >Record</a>"
//"  <a href='javascript:play()'	id='play'   >Play</a> "
//"  <a href='javascript:stop()'	id='stop'   >Stop</a>"
//"  <a href='javascript:upload()'  id='upload' >Upload to SoundCloud</a>"
//"</div>"
//"<span id='time'>0:00</span>"
//"</div>");

