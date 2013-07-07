
//#define SYNTHESIZE_CONSTS
//#undef SYNTHESIZE_CONSTS
#import "Bootstrap.h"
//#import <KSHTMLWriterFramework/KSHTMLWriterKit.h>
//#import "KSHTMLWriter.h"
//#import "KSWriter.h"


@interface Bootstrap ()
//@property (nonatomic, strong) 	NSMA 		*cssAssets, 	*jsAssets;
@property (strong) NSMS *mString;
@property (strong) NSOperationQueue *oQ;
@property (copy) void(^stringDelegate)(id);

//- (id)initWithUserStyles:(NSS*)css script:(NSS*)script andInnerHTML:(NSS*) html  calling:(BKSenderBlock)block;
+ (void) initWithUserStyle:(Asset*)css script:(Asset*)script andInnerHTML:(NSS*) html  calling:(void(^)(id))block;

@end

NSString * const custCSS = @"html,	body{height:100%; } #wrap{min-height:100%;height:auto !important;height:100%;/* Negative indent footer by it's height */	margin:0 auto -60px;}	#push,	#footer{height:60px;}	#footer{background-color:#f5f5f5;}	@media (max-width:767px){#footer{margin-left:-20px;margin-right:-20px;padding-left:20px;padding-right:20px;}	}	#wrap > .container{padding-top:60px;}	.container .credit{margin:20px 0;}	code{font-size:80%;}";


@implementation Bootstrap

- (void) setUp { 			 _bundle = [NSB bundleForClass:KSHTMLWriter.class];
								 _oQ = NSOperationQueue.new;
	 _oQ.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
//	[_oQ addObserver:self forKeyPath:@"operations" options:0 context:NULL];

//	[_oQ addOperationWithBlock:^{
//		[@[@"js", @"css"] each:^(NSS* ext){  [self setValue:[[[_bundle URLsForResourcesWithExtension:ext subdirectory:ext] filter:^BOOL(NSURL* object) {  return ![((NSS*)object.path.lastPathComponent) containsAnyOf:@[@"bootstrap-popover",@"bootstrap-transition"]]; }]
//						   cw_mapArray:^id(NSURL* url) {
//
//			return [Asset instanceOfType:[ext assetFromString] withPath:$(@"/%@/%@", ext, url.path.lastPathComponent) orContents:nil isInline:NO];//$(@"/%@/%@", ext, url.path.lastPathComponent) orContents:nil isInline:YES];}] forKey:ext];
//		}] forKey:ext]; }];
//	}];
////		NSLog(@"css: %@  js: %@", _css, _js);
//		self.html;
//	}];
}

- (NSA*) css {

	return [_bundle pathsForResourcesOfType:@"css" inDirectory:@"css"];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSS*)key
{
	NSSet* kps = [super keyPathsForValuesAffectingValueForKey:key];
	return  [key isEqualToAnyOf:@[@"css", @"js", @"userHTML"]] ? [kps setByAddingObject:((Bootstrap*)self.class.sharedInstance).html] : kps;
}

- (void) observeValueForKeyPath:(NSS*)kP ofObject:(id)obj change:(NSD*)change context:(void*)c
{
	if ( areSame(_oQ, obj) && areSame(kP, @"operations") && _oQ.operations.count == 0 )  {
		NSLog(@"queue has completed");
//		self.html = nil;
	} else	[super observeValueForKeyPath:kP ofObject:obj change:change context:c];
}


+ (void) initWithUserStyle:(Asset*)css script:(Asset*)script andInnerHTML:(NSS*) html  calling:(void(^)(id sender))block
{
	Bootstrap *boot 		= Bootstrap.sharedInstance;
	if (css) 	boot.css 	= [boot.css arrayByAddingObject:css];
	if (script) boot.js 	= [boot.js arrayByAddingObject:script];
//	boot.stringDelegate = [block copy];
//	NSLog(@"Bootstrap: %@", boot.stringDelegate);
	NSXMLDocument *doc = [NSXMLDocument.alloc initWithXMLString:boot.html options:NSXMLDocumentTidyHTML error:nil];
	//Convert the NSXMLDocument to NSData
	NSData *data = [doc XMLDataWithOptions:NSXMLNodePrettyPrint];
	//Create a string from the NSData object you have
	NSString *string = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
//	//Create a NSAttributedString from it
//	NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:string] autorelease];
//	//Now set the attributed string for the NSTextView
//	[[xmlTextView textStorage] setAttributedString:attributedString];
	block(string);
}

- (NSS*) html
{
	_mString = NSMS.new;
	_writer = [KSHTMLWriter.alloc initWithOutputWriter:_mString docType:KSHTMLWriterDocTypeHTML_5 encoding:NSUTF8StringEncoding];
	[_writer startDocumentWithDocType:@"html" encoding:NSUTF8StringEncoding];

	[_writer writeElement:@"head" content:^{
		[_writer writeElement:@"title" text:@"recorder"];
		[_writer writeJavascriptWithSrc:JQUERY encoding:NSUTF8StringEncoding];
		[_css each:^(Asset* obj) {
//		AZLOG(obj.propertiesPlease);
//			if (obj.contents && obj.isActive) {
//				if (obj.isInline && obj.contents) 	[_writer writeStyleElementWithCSSString:obj.contents];
//		   else if (obj.path)
   	[_writer writeLinkToStylesheet:obj.path title:nil media:nil];//:obj.path type:nil rel:nil title:nil media:nil];
//		}
		}];
		[_js each:^(Asset* obj) { // AZLOG(obj);
//			if (obj.contents && obj.isActive) {
//				if (obj.isInline && obj.contents) 	[_writer writeJavascript:obj.contents useCDATA:NO];
//		   else if (obj.path)
		[_writer writeJavascriptWithSrc:obj.path encoding:NSUTF8StringEncoding];
		}];
	}];
	
	[_writer writeElement:@"body" content:^{
		[_writer writeHTMLString:custHTML];
		[_writer writeHTMLString:custHTMLRECORDER];
		[_writer writeJavascriptWithSrc:RECORDERJS encoding:NSUTF8StringEncoding];

		[_writer writeHTMLString:custHTMLFOOT];
	}];

	_html = _mString.copy;
	NSLog(@"bootstrap2block:  %@", _html);
//	_stringDelegate(_html);
	return _html;
}
			
@end
//	self.js  = $array(@"/jquery.js", @"/js/navigation.js", @"/js/boostrap.min.js");
//	self.jsOut = jsOut;
/**
	self.xml = $(@"<html><head><style> %@ </style> <script>%@</script>"  //cssout, jsout
	"<body><div id='navigation' class='navbar'>"
	"<div class='navbar-inner'>"
		"<div class='container-fluid'>"
			"<a class='brand' href='/index.html'>lunarsite</a>"
			"<ul id='navigation-list' class='nav'>"
				"<li>"
					"<a href='/index.html'>Home</a>"
				"</li>"
				"<li>"
					"<a href='/blog.html'>Blog"
					"</a>"
				"</li>"
				"<li>"
					"<a href='/tags/index.html'>Tags</a>"
				"</li>"
			"</ul>"
		"</div>"
	"</div>"
"</div>"
"<div id='content-container' class='container-fluid'>"
	"<div class='hero-unit'>"
		"<h1>404</h1>"
		"<p>Sorry, but there is nothing at this place.</p>"
	"</div>"
	"<div class='row-fluid'>"
	"<div class='well'>"
	"<p>This page has been relaunched in Apr 2012. At this, a lot ofout-dated information was removed. None of this is archived anywhereon this page, so don't bother to search.  Instead, take a look at the"
	"<a href='/index.html'>front page"
	"</a> to see what this site offersnow."
	"</p>"
	"</div>"
	"</div>"
	"<hr>"
	"<footer>"
	"<p>&copy; Copyright Sebastian Wiesner 2012. Contact me via "
	"<a href='mailto:lunaryorn@googlemail.com'>email"
	"</a>, "
	"<a href='https://github.com/lunaryorn'>GitHub"
	"</a> or "
	"<a href='https://bitbucket.org/lunar'>BitBucket"
	"</a>."
	"</p>"
	"<p>This work is licensed under a "
	"<a rel='license' href='http://creativecommons.org/licenses/by-nc-sa/3.0/'>Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License"
	"</a>."
	"</p>"
//	"<p>Last updated {{site.time | date_to_string }}"
	"</p>"
	"</footer>"
	"</div></body></html>", self.cssOut,self.jsOut);

	NSLog(@"%@", xml);
//	[writer startDocumentWithDocType:@"html" encoding:NSUTF8StringEncoding];
//	[writer startElement:@"head"];
//	[writer startStyleElementWithType:@"css"];
//	[writer writeStyleElementWithCSSString:self.cssOut];
//	[writer endElement];
//	[writer startJavascriptCDATA];
//	[writer writeJavascript:self.jsOut useCDATA:YES];
//	[writer endJavascriptCDATA];
//	"<meta name="viewport" content="width=device-width, initial-scale=1.0">
//   <meta name="description" content="My personal site">
//   <meta name="author" content="Sebastian Wiesner">
//	[writer startStyleElementWithType:@"css"];
//	[self writeCSS:css];
//	[writer endElement];
//	[writer endElement];


//	NSLog(@"%@", directoryAndFileNames);
//	[NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[KSHTMLWriter class]] pathForResource:@"bootstrap.min" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil]);
//	[writer endElement];
//   <link href="/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
//	[writer writeString:@
//	[writer writeJavascript:jsOut useCDATA:NO];
//	NSLog(@"XMLOUT: %@" , self.xml);
//	[writer writeJavascript:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"jquery" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil] useCDATA:NO];
//	[writer writeJavascript:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bootstrap.min" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil] useCDATA:NO];
//	[writer writeJavascript:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"navigation.js" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil] useCDATA:NO];
//	[writer writeHTMLString:@"</body></html>"];
//	[writer writeToFile:@"~/Desktop/bootie.html" atomically:YES];

	}
	return self;
}
//-(void) writeCSS:(NSArray*)cssArray {	for (NSString* css in cssArray){
//		NSString *filePath = [resources stringByAppendingPathComponent:css];
//		NSLog(@"Path: %@", filePath);
//		NSError *error;
//		NSString *cssOut = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//		[writer writeString:cssOut];
//	}
//}

-(NSString*) cssOut {
	NSMutableString *out = [NSMutableString string];
	for (NSString* cssString in self.css)
	[out appendFormat:@""
	"%@", [NSString stringWithContentsOfFile: [resources stringByAppendingPathComponent:cssString] 
									encoding:NSUTF8StringEncoding error:nil]];
	return out.copy;
}

-(NSString*) jsOut {
	NSMutableString *out = [NSMutableString string];
	for (NSString* jsString in self.js)
	[out appendFormat:@""
	"%@", [NSString stringWithContentsOfFile: [resources stringByAppendingPathComponent:jsString] 
									encoding:NSUTF8StringEncoding error:nil]];
	return out.copy;
}
*/




NSString * const custHTML = @""
"<!-- Part 1: Wrap all page content here -->"
"<div id='wrap'>"
""
"  <!-- Fixed navbar -->"
"  <div class='navbar navbar-fixed-top'>"
"	<div class='navbar-inner'>"
"	  <div class='container'>"
"		<button type='button' class='btn btn-navbar' data-toggle='collapse' data-target='.nav-collapse'>"
"		  <span class='icon-bar'></span>"
"		  <span class='icon-bar'></span>"
"		  <span class='icon-bar'></span>"
"		</button>"
"		<a class='brand' href='#'>Project name</a>"
"		<div class='nav-collapse collapse'>"
"		  <ul class='nav'>"
"			<li class='active'><a href='#'>Home</a></li>"
"			<li><a href='#about'>About</a></li>"
"			<li><a href='#contact'>Contact</a></li>"
"			<li class='dropdown'>"
"			  <a href='#' class='dropdown-toggle' data-toggle='dropdown'>Dropdown <b class='caret'></b></a>"
"			  <ul class='dropdown-menu'>"
"				<li><a href='#'>Action</a></li>"
"				<li><a href='#'>Another action</a></li>"
"				<li><a href='#'>Something else here</a></li>"
"				<li class='divider'></li>"
"				<li class='nav-header'>Nav header</li>"
"				<li><a href='#'>Separated link</a></li>"
"				<li><a href='#'>One more separated link</a></li>"
"			  </ul>"
"			</li>"
"		  </ul>"
"		</div><!--/.nav-collapse -->"
"	  </div>"
"	</div>"
"  </div>"
""
"  <!-- Begin page content -->"
"  <div class='container'>"
"	<div class='page-header'>"
"	  <h1>Sticky footer with fixed navbar</h1>"
"	</div>"
"	<p class='lead'>Pin a fixed-height footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added within <code>#wrap</code> with <code>padding-top: 60px;</code> on the <code>.container</code>.</p>"
"	<p>Back to <a href='./sticky-footer.html'>the sticky footer</a> minus the navbar.</p>"
"  </div>";

NSString * const custHTMLFOOT = @""
"  <div id='push'></div>"
"</div>"
""
"<div id='footer'>"
"  <div class='container'>"
"	<p class='muted credit'>Example courtesy <a href='http://martinbean.co.uk'>Martin Bean</a> and <a href='http://ryanfait.com/sticky-footer/'>Ryan Fait</a>.</p>"
"  </div>"
"</div>";




NSString * const custHTMLRECORDER = @""
					"  <div id='wrapper'>"
					"<h1><a href='http://github.com/jwagener/recorder'>Recorder Example</a></h1>"
					"<p>"
					"This is a very basic example for the Recorder.js. Checkout <a href='http://github.com/jwagener/recorder'>GitHub</a> for details and have a look at the source for this file.  Start by clicking record:"
					"</p><div>"
					"  <a href='javascript:record()'  id='record'					   >Record</a>"
					"  <a href='javascript:play()'	id='play'   >Play</a> "
					"  <a href='javascript:stop()'	id='stop'   >Stop</a>"
					"  <a href='javascript:upload()'  id='upload' >Upload to SoundCloud</a>"
					"</div>"
					"<span id='time'>0:00</span>"
					"</div>";
