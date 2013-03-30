//
//  Bootstrap.h
//  KSHTMLWriter
//
//  Created by Alex Gray on 5/6/12.
//  Copyright (c) 2012 Karelia Software. All rights reserved.
//


//#import "KSHTMLWriter.h"

#define JQUERY @"http://code.jquery.com/jquery-2.0.0b2.js"
#define RECORDERJS @"http://mrgray.com/js/recorder.js/recorder.js"

@class KSHTMLWriter, Asset;
@interface Bootstrap : BaseModel

@property (nonatomic, strong) 	KSHTMLWriter 	*writer;
@property (readonly)			NSString 		*xml;
@property (nonatomic, strong)	NSA				*js, *css;
@property (nonatomic, strong)	NSS				*userHTML, *html;
@property (nonatomic, strong) 	NSBundle	 	*bundle;




@end

//#ifdef SYNTHESIZE_CONSTS
//# define STR_CONST(name, value) NSString* const name = @ value
//#else
//# define STR_CONST(name, value) extern NSString* const name
//#endif

extern NSString * const custCSS;
extern NSString * const custHTMLRECORDER;
extern NSString * const custHTMLFOOT;
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
//"  <a href='javascript:record()'  id='record'                       >Record</a>"
//"  <a href='javascript:play()'    id='play'   >Play</a> "
//"  <a href='javascript:stop()'    id='stop'   >Stop</a>"
//"  <a href='javascript:upload()'  id='upload' >Upload to SoundCloud</a>"
//"</div>"
//"<span id='time'>0:00</span>"
//"</div>");

