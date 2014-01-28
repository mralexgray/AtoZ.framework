
//#define SYNTHESIZE_CONSTS #undef SYNTHESIZE_CONSTS

#import "AtoZ.h"
#import "Bootstrap.h"

@implementation KSHTMLWriter (extras)
- (void) writeDocReady:(id)a {

	[self writeJavascript:[[[a isKindOfClass:NSArray.class]?a :@[a] reduce:@"docReady = function(){\n".mutableCopy withBlock:^id(id sum, id obj) {
		return sum = [sum stringByAppendingFormat:@"\n%@\n",[obj stringByReplacingOccurrencesOfString:@";" withString:@"\n"]];
	}]stringByAppendingString:@"\n};"] useCDATA:NO];
}

-(NSMS*) markup { id x = objc_getAssociatedObject(self, _cmd); if (!x) { x = (self.markup = NSMS.new); } return x; }
- (void) setMarkup:(NSMS*) markup { objc_setAssociatedObject(self, @selector(markup), markup, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (void) preview {

	NSS* p = [AtoZ tempFilePathWithExtension:@"html"];
	[self.markup writeToFile:p atomically:YES encoding:NSUTF8StringEncoding error:nil];
	[AZWORKSPACE openFile:p];
}
@end




@implementation Gridly

- (id) init { NSMS* writer = NSMS.new;

	if (self != [super initWithOutputWriter:writer]) return nil;

//	 	_dQ = dispatch_queue_create("SQ",NULL);
//		_listenSocket =  [ASOCK.alloc initWithSocketQueue:_dQ];

	[self writeDocumentOfType:KSHTMLWriterDocTypeHTML_5	encoding:NSUTF8StringEncoding head:^{

		[self writeElement:@"title" text:@"AtoZ Gridly"];
		[self writeStyleElementWithCSSString:	@".gridly {position: relative; width: 960px; }\
																						.brick.small { width: 15%; height: 140px;	}\
																						.brick.large { width: 300px; height: 300px; }\
																						.indicator { width:50px; height:45px; background-color:black; float:right; bottom:0; right:0; }"];
		[@[	@"http://mrgray.com/jq", @"http://mrgray.com/a2z/AtoZ/AtoZHelper/gridly-socket.js"] do:^(id obj) {	[self writeJavascriptWithSrc:obj encoding:NSUTF8StringEncoding]; }];

//		[self writeDocReady:@" \
//		baseline = $(window).width(); $('.brick').watch('width', function(){ $(this).css(height:$(this).width()); });\
//		$(window).on('resize', function(){ scale = $(window).width/baseline; $('.brick').css('background-color', randomColor()); $('.brick').width(300*scale); return $('.gridly').gridly({  base: (width / 4), gutter: 20,  columns: 4 }); });\
//		stopShit = function(e){e.preventDefault(); e.stopPropagation(); }; \
//    brick = \"<div class='brick small'><div class='delete'>X</div></div>\"; \
//   $('.gridly  .brick').on('click',function(e){ stopShit(e); $(this).toggleClass('small large');  size = $(this).hasClass('small')? 140 : 300;$(this).data({'width':size,'height':size});\
//		return $('.gridly').gridly('layout'); }); \
//   $('.gridly .delete').on('click',function(e){ stopShit(e); $(this).closest('.brick').remove(); return $('.gridly').gridly('layout'); }); \
//   $('.add')           .on('click',function(e){ stopShit(e); $('.gridly').append(brick); return $('.gridly').gridly();  }); \
//   //return $('.gridly').gridly('layout'); "];
//		//@"(function(){$(function(){var a;a=\"<div class='brick small'><div class='delete'>&times;</div></div>\";$(document).on(\"click\",\".gridly .brick\",function(c){var d,b;c.preventDefault();c.stopPropagation();d=$(this);d.toggleClass(\"small\");d.toggleClass(\"large\");if(d.hasClass(\"small\")){b=140}if(d.hasClass(\"large\")){b=300}d.data(\"width\",b);d.data(\"height\",b);return $(\".gridly\").gridly(\"layout\")});$(document).on(\"click\",\".gridly .delete\",function(b){var c;b.preventDefault();b.stopPropagation();c=$(this);c.closest(\".brick\").remove();return $(\".gridly\").gridly(\"layout\")});$(document).on(\"click\",\".add\",function(b){b.preventDefault();b.stopPropagation();$(\".gridly\").append(a);return $(\".gridly\").gridly()});return $(\".gridly\").gridly()})}).call(this);"]];
	} body:^{
		[self writeElement:@"div" className:@"container" content:^{
			[self writeElement:@"section" className:@"example" content:^{
				[self writeElement:@"div" className:@"gridly" content:^{
					[[@0 to:@8] eachWithIndex:^(id obj, NSInteger idx) {
						[self writeElement:@"div" classes:@[@"brick",[obj integerValue] % 2 ? @"small" : @"large"] content:^{ [self writeElement:@"div" classes:@[@"inidcator"] content:^{}]; }];

					}];
				}];
			}];
		}];
	}];
	self.markup = writer;
	return self;
}

@end

/*
		NSS* docReady = [@[
			[AZJSVar varNamed:@"brick" value:@"\"<div class='brick small'><div class='delete'>&times;</div></div>\""],
			[AZJQueryMethod javascriptWithSelector:@"document"	function:@"on"			method:@"'click', '.gridly .brick'"
																		callback:@[	@"function(event){ var $this, size;	event.preventDefault();\n	event.stopPropagation();",
																								@"$this = $(this); $this.toggleClass('small'); $this.toggleClass('large');",
																								@"if ($this.hasClass('small')) { size = 140;} if ($this.hasClass('large')) {		 size = 300;}",
																								@"this.data('width', size);	$this.data('height', size);",	@"return $('.gridly').gridly('layout'); }"]],
			[AZJQueryMethod javascriptWithSelector:@"document"	function:@"on"	 method:@"'click', '.gridly .delete'"
																		callback:@[	@"function(event){	var $this;	event.preventDefault(); event.stopPropagation();",
																								@"$this = $(this);	$this.closest('.brick').remove();return $('.gridly').gridly('layout');}"]],
			[AZJQueryMethod javascriptWithSelector:@"document" function:@"on"		 method:@"'click', '.add'"
																		callback:@[	@"function(event) {	event.preventDefault();	event.stopPropagation();",
																								@"$('.gridly').append(brick);	return $('.gridly').gridly(); }"]],
			[AZJQueryMethod javascriptWithSelector:@".gridly"	function:@"gridly" method:@"{ base:60,gutter:20,columns:12 }"	callback:nil]
		] componentsJoinedByString:@"\n"];
		[self writeJavascript: [AZJSVar varNamed:@"docReady" value:JATExpand(@"function(){ {0}}",docReady)] useCDATA:NO];

*/
@interface 	  Bootstrap ()
@property (nonatomic, strong) 	KSHTMLWriter 	*writer;
@property 			 NSMS * mString;
@property 			 NSOQ * oQ;
@property (copy) void(^stringDelegate)(id);

//- (id)initWithUserStyles:(NSS*)css script:(NSS*)script andInnerHTML:(NSS*) html  calling:(BKSenderBlock)block;
//+ (void) initWithUserStyle:(Asset*)css script:(Asset*)script andInnerHTML:(NSS*) html  calling:(void(^)(id))block;

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
/**
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
	if (css) 	boot.css = [boot.css arrayByAddingObject:css];
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
*/
- (NSS*) htmlWithBody:(NSS*)bod { _mString = NSMS.new;

	_writer = [KSHTMLWriter.alloc initWithOutputWriter:_mString docType:KSHTMLWriterDocTypeHTML_5 encoding:NSUTF8StringEncoding];

	[_writer startDocumentWithDocType:@"html" encoding:NSUTF8StringEncoding];
	[_writer             writeElement:@"head" content:^{
		[_writer writeElement:@"title" text:@"recorder"];
		[@[JQUERY, BOOTSTRAP_JS] do:^(id obj) {
			[_writer writeJavascriptWithSrc:obj encoding:NSUTF8StringEncoding];
		}];
		[@[BOOTSTRAP_CSS, FONTAWESOME, BOOTSWATCH_UNITED] do:^(id obj) {
			[_writer writeLinkToStylesheet:obj title:@"" media:@""];
		}];
		[_availCSS.arrangedObjects each:^(Asset* obj) {
			//		AZLOG(obj.propertiesPlease);
			//			if (obj.contents && obj.isActive) {
			//				if (obj.isInline && obj.contents) 	[_writer writeStyleElementWithCSSString:obj.contents];
			//		   else if (obj.path)
			[_writer writeLinkToStylesheet:obj.path title:nil media:nil];
			//:obj.path type:nil rel:nil title:nil media:nil];
		}];
		[_availJS.arrangedObjects each:^(Asset* obj) { // AZLOG(obj);
										  //			if (obj.contents && obj.isActive) {
										  //				if (obj.isInline && obj.contents) 	[_writer writeJavascript:obj.contents useCDATA:NO];
										  //		   else if (obj.path)
			[_writer writeJavascriptWithSrc:obj.path encoding:NSUTF8StringEncoding];
		}];
	}];

	[_writer writeElement:@"body" content:^{
//		[_writer writeHTMLString:custHTML];
		[_writer writeHTMLString:bod];
//		[_writer writeHTMLString:custHTMLFOOT];
	}];

	_html = _mString.copy;
//	NSLog(@"bootstrap2block:  %@", _html);
	//	_stringDelegate(_html);
	return _html;
}

- (NSS*)recorder {

	NSMS *outS = NSMS.new;
	KSHTMLWriter *writer = [KSHTMLWriter.alloc initWithOutputWriter:outS];
	[writer writeHTMLString:custHTMLRECORDER];
	[writer writeJavascriptWithSrc:RECORDERJS encoding:NSUTF8StringEncoding];
	return outS;
}

- (NSS*) demo {


	NSMS *demo 	= NSMutableString.new;
	KSHTMLWriter *writer 	= [KSHTMLWriter.alloc initWithOutputWriter:demo];

	[writer writeElement:@"div" idName:nil className:@"container" content:^{

		[writer writeElement:@"h1" text:@"Bootstrap 3 Template"];
		[writer writeElement:@"p" className:@"lead"  text:@"A Full Featured Example"];

	//	Typography
		[writer writeElement:@"section" idName:@"typography" className:nil content:^{
			[writer writeElementAndClose:@"div" className:@"page-header"];
		//	<!-- Headings & Paragraph Copy -->
			[writer writeElement:@"div" className:@"row" content:^{
				[writer writeElement:@"div" className:@"col-lg-6" content:^{
					[writer writeElement:@"div" className:@"well" content:^{
						[[@1 to:@6] do:^(id obj) {
							[writer writeElement:$(@"h%@",obj) text:$(@"Bootstrap %@",obj)];
						}];
					}];
				}];
				[writer writeElement:@"div" className:@"col-lg-6" content:^{
					[writer writeElement:@"h3" text:@"Bootstrap Framework"];
						[writer writeElement:@"p" text:@"In simple terms, a responsive web design figures out what resolution of device it's being served on. Flexible grids then size correctly to fit the screen."];
						[writer writeElement:@"p" text:@"The new Bootstrap 3 promises to be a smaller build. The separate Bootstrap base and responsive.css files have now been merged into one. There is no more fixed grid, only fluid."];
					[writer writeHorizontalLine];
					[writer writeElement:@"blockquote" className:@"pull-right" content:^{
						[writer writeElement:@"p" text:@"Have you ever had a project where you thought it would be so much better to just throw everything out and start over? I believe that’s what’s happening with BS3."];
						[writer writeElement:@"small" content:^{
							[writer writeElement:@"cite" attributes:@{@"title":@"Source Title"} content:^{
								[writer writeCharacters:@"Quasipickle"];
							}];
						}];
					}];
				}];
			}];
		}];
	// Bootstrap 3 Navbar
		[writer writeElement:@"section" idName:@"navbar" className:nil content:^{
			[writer writeElementAndClose:@"div" className:@"page-header"];
			[writer writeElement:@"h1" text:@"Bootstrap 3 Navbar"];
		}];
		[writer writeElement:@"div" idName:nil className:@"container" content:^{
			[writer writeElement:@"nav" attributes:@{@"class":@"navbar",@"role":@"navigation"} content:^{
			//        <!-- Brand and toggle get grouped for better mobile display -->
				[writer writeElement:@"div" idName:nil className:@"navbar-header" content:^{
					[writer writeElement:@"button" attributes:@{@"class":@"navbar-toggle",@"type":@"button", @"data-toggle":@"collapse",@"data-target":@"navbar-ex1-collapse"} content:^{
						[writer writeElement:@"span" className:@"sr-only" text:@"Toggle navigation"];
						[[@0 to:@2]do:^(id obj) { [writer writeElementAndClose:@"span" className:@"icon-bar"]; }];
					}];
					[writer writeLink:@"#" attributes:@{@"class":@"navbar-brand"} text:@"Title"];
				}];
				//  <!-- Collect the nav links, forms, and other content for toggling -->
				[writer writeElement:@"div" classes:@[@"collapse", @"navbar-collapse", @"navbar-ex1-collapse"] content:^{
					[writer writeElement:@"ul" classes:@[@"nav",@"navbar-nav"] content:^{
						[@[@"Home",@"Link", @"Another Link"] eachWithIndex:^(id obj, NSInteger idx) {
							[writer writeElement:@"li" className:idx == 0 ? @"active" : nil content:^{
								[writer writeLink:@"#" attributes:nil text:obj];
							}];
						}];
						[writer writeElement:@"li" className:@"dropdown" content:^{
							[writer writeElement:@"a" attributes:@{@"href":@"#",@"class":@"dropdown-toggle",@"data-toggle":@"dropdown"} content:^{
								[writer writeElementAndClose:@"b" className:@"caret"];
							}];
							[writer writeElement:@"ul" className:@"dropdown-menu" content:^{
								[@[@"Action",@"One more separated link"] do:^(id obj) {
									[writer writeElement:@"li" content:^{
										[writer writeLink:@"#" attributes:nil text:obj];
									}];
								}];
							}];
						}];
					}];
					[writer writeElement:@"ul" classes:@[@"nav",@"navbar-nav",@"navbar-right"] content:^{
						[writer writeElement:@"li" content:^{
							[writer writeLink:@"#" attributes:nil text:@"Right Nav Link"];
						}];
					}];
				}];
			}];
		}];
		[writer writeElement:@"div" idName:nil className:@"container" content:^{
			[writer writeElement:@"nav" attributes:@{@"class":@[@"navbar",@"navbar-inverse"],@"role":@"navigation"} content:^{
				// Brand and toggle get grouped for better mobile display
				[writer writeElement:@"div" idName:nil className:@"navbar-header" content:^{
					[writer writeElement:@"button" attributes:@{@"class":@"navbar-toggle",@"type":@"button", @"data-toggle":@"collapse",@"data-target":@"navbar-ex1-collapse"} content:^{
						[writer writeElement:@"span" className:@"sr-only" text:@"Toggle navigation"];
						[[@0 to:@2]do:^(id obj) { [writer writeElementAndClose:@"span" className:@"icon-bar"]; }];
					}];
					[writer writeLink:@"#" attributes:@{@"class":@"navbar-brand"} text:@"Title"];
				}];
				// Collect the nav links, forms, and other content for toggling -->
				[writer writeElement:@"div" classes:@[@"collapse",@"navbar-collapse",@"navbar-ex1-collapse"] content:^{
					[writer writeElement:@"ul" classes:@[@"nav",@"navbar-nav"] content:^{
						[writer writeElement:@"li" className:@"active" content:^{
								[writer writeLink:@"#" attributes:nil text:@"Home"];
						}];
						[[@0 to:@2]do:^(id obj) { [writer writeElement:@"li" className:@"active" content:^{
								[writer writeLink:@"#" attributes:nil text:@"Link"];
						}];	}];
						[writer writeElement:@"li" className:@"dropdown" content:^{
							[writer writeLink:@"#" attributes:@{@"class":@"dropdown-toggle",@"data-toggle":@"dropdown"} content:^{
								[writer writeCharacters:@"Dropdown"];
								[writer writeElementAndClose:@"b" className:@"caret"];
							}];
							[writer writeElement:@"ul" className:@"dropdown-menu" content:^{
								[writer writeElement:@"li" content:^{
									[writer writeLink:@"#" attributes:nil text:@"Action"];
								}];
								[writer writeElement:@"li" content:^{
									[writer writeLink:@"#" attributes:nil text:@"One more separated link"];
								}];
							}];
						}];
					}];
					[writer writeElement:@"ul" classes:@[@"nav",@"navbar-nav",@"navbar-right"] content:^{
						[writer writeElement:@"li" content:^{
									[writer writeLink:@"#" attributes:nil text:@"Link"];
						}];
					}];
				}];// /.navbar-collapse -->
			}]; // nav
		}]; //div
	}]; //section>

	return demo.copy;
}
@end
/**
<section>
<!--Bootstrap 3 Scaffolding-->
	<div class="page-header">
		<h1>Grid</h1>
		<p class="lead">Bootstrap 3 scaffolding has changed for improved display on mobile devices</p>
	</div>
	
<div class="container">
<div class="row">
	<div class="col-lg-12"><div class="well"><p>col-lg-12</p></div></div>
</div>
<div class="row">
		<div class="col-lg-4"><div class="well"><p>col-lg-4</p></div></div>
	 <div class="col-lg-4"><div class="well"><p>col-lg-4</p></div></div>
	 <div class="col-lg-4"><div class="well"><p>col-lg-4</p></div></div>
</div>
<div class="row">
	<div class="col-lg-6 col-sm-6"><div class="well"><p>col-lg-6</p></div></div>
 <div class="col-lg-6 col-sm-6"><div class="well"><p>col-lg-6</p></div></div>
</div>
<div class="row">
	<div class="col-lg-9 col-sm-6"><div class="well">col-lg-9 / col-sm-6</div></div>
	<div class="col-lg-3 col-sm-6"><div class="well">col-lg-3 / col-sm-6</div></div>
</div>	
</div>
</section>
	
<!-- Bootstrap 3 Buttons
================================================== -->
<section id="buttons">
	<div class="page-header">
		<h1>Bootstrap 3 Buttons</h1>
		<p class="lead">With no gradients and borders, Bootstrap 3.0 buttons now have a flatter look</p>
	</div>
	
	<h2>Button Sizes (4)</h2>
	<ul class="the-buttons clearfix">
			<li><a class="btn btn-xs btn-primary" href="#">btn-xs</a></li> 	
			<li><a class="btn btn-sm btn-primary" href="#">btn-sm</a></li>
			<li><a class="btn btn-primary" href="#">btn</a></li>
			<li><a class="btn btn-lg btn-primary" href="#">btn-lg</a></li>
	</ul>
	
	<h2>Button Classes</h2>
	<ul class="the-buttons clearfix">
			<li><a class="btn btn-default" href="#">Default</a></li>
			<li><a class="btn btn-primary" href="#">Primary</a></li>
			<li><a class="btn btn-success" href="#">Success</a></li>
			<li><a class="btn btn-info" href="#">Info</a></li>
			<li><a class="btn btn-warning" href="#">Warning</a></li>
			<li><a class="btn btn-danger" href="#">Danger</a></li>
			<li><a class="btn btn-primary disabled" href="#">Disabled</a></li>
			<li><a class="btn btn-link" href="#">Link</a></li>	
			<li>
				<!-- Single button -->
				<div class="btn-group">
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						Dropdown <span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="#">Action</a></li>
						<li><a href="#">Another action</a></li>
						<li><a href="#">Something else here</a></li>
						<li class="divider"></li>
						<li><a href="#">Separated link</a></li>
					</ul>
				</div>
			</li>
			<li><a class="btn btn-info" href="#"><i class="glyphicon glyphicon-map-marker"></i> Icon</a></li>
	</ul>
	
	

</section>

<!-- Icons
================================================== -->
<section id="icons">
	<div class="page-header">
		<h2>Bootstrap 3 Icons</h2>
		<p class="lead">The 2.x icons are now replaced by glyphicons in BS3.</p>
	</div>
	<div class="row">
	 
		<ul class="the-icons clearfix">
			<li><i class="glyphicon glyphicon-glass"></i> glyphicon-glass</li>
			<li><i class="glyphicon glyphicon-music"></i> glyphicon-music</li>
			<li><i class="glyphicon glyphicon-search"></i> glyphicon-search</li>
			<li><i class="glyphicon glyphicon-envelope"></i> glyphicon-envelope</li>
			<li><i class="glyphicon glyphicon-heart"></i> glyphicon-heart</li>
			<li><i class="glyphicon glyphicon-star"></i> glyphicon-star</li>
			<li><i class="glyphicon glyphicon-star-empty"></i> glyphicon-star-empty</li>
			<li><i class="glyphicon glyphicon-user"></i> glyphicon-user</li>
			<li><i class="glyphicon glyphicon-film"></i> glyphicon-film</li>
			<li><i class="glyphicon glyphicon-th-large"></i> glyphicon-th-large</li>
			<li><i class="glyphicon glyphicon-th"></i> glyphicon-th</li>
			<li><i class="glyphicon glyphicon-th-list"></i> glyphicon-th-list</li>
			<li><i class="glyphicon glyphicon-ok"></i> glyphicon-ok</li>
			<li><i class="glyphicon glyphicon-remove"></i> glyphicon-remove</li>
			<li><i class="glyphicon glyphicon-zoom-in"></i> glyphicon-zoom-in</li>
			<li><i class="glyphicon glyphicon-zoom-out"></i> glyphicon-zoom-out</li>
			<li><i class="glyphicon glyphicon-off"></i> glyphicon-off</li>
			<li><i class="glyphicon glyphicon-signal"></i> glyphicon-signal</li>
			<li><i class="glyphicon glyphicon-cog"></i> glyphicon-cog</li>
			<li><i class="glyphicon glyphicon-trash"></i> glyphicon-trash</li>
			<li><i class="glyphicon glyphicon-home"></i> glyphicon-home</li>
			<li><i class="glyphicon glyphicon-file"></i> glyphicon-file</li>
			<li><i class="glyphicon glyphicon-time"></i> glyphicon-time</li>
			<li><i class="glyphicon glyphicon-road"></i> glyphicon-road</li>
			<li><i class="glyphicon glyphicon-download-alt"></i> glyphicon-download-alt</li>
			<li><i class="glyphicon glyphicon-download"></i> glyphicon-download</li>
			<li><i class="glyphicon glyphicon-upload"></i> glyphicon-upload</li>
			<li><i class="glyphicon glyphicon-inbox"></i> glyphicon-inbox</li>

			<li><i class="glyphicon glyphicon-play-circle"></i> glyphicon-play-circle</li>
			<li><i class="glyphicon glyphicon-repeat"></i> glyphicon-repeat</li>
			<li><i class="glyphicon glyphicon-refresh"></i> glyphicon-refresh</li>
			<li><i class="glyphicon glyphicon-list-alt"></i> glyphicon-list-alt</li>
			<li><i class="glyphicon glyphicon-lock"></i> glyphicon-lock</li>
			<li><i class="glyphicon glyphicon-flag"></i> glyphicon-flag</li>
			<li><i class="glyphicon glyphicon-headphones"></i> glyphicon-headphones</li>
			<li><i class="glyphicon glyphicon-volume-off"></i> glyphicon-volume-off</li>
			<li><i class="glyphicon glyphicon-volume-down"></i> glyphicon-volume-down</li>
			<li><i class="glyphicon glyphicon-volume-up"></i> glyphicon-volume-up</li>
			<li><i class="glyphicon glyphicon-qrcode"></i> glyphicon-qrcode</li>
			<li><i class="glyphicon glyphicon-barcode"></i> glyphicon-barcode</li>
			<li><i class="glyphicon glyphicon-tag"></i> glyphicon-tag</li>
			<li><i class="glyphicon glyphicon-tags"></i> glyphicon-tags</li>
			<li><i class="glyphicon glyphicon-book"></i> glyphicon-book</li>
			<li><i class="glyphicon glyphicon-bookmark"></i> glyphicon-bookmark</li>
			<li><i class="glyphicon glyphicon-print"></i> glyphicon-print</li>
			<li><i class="glyphicon glyphicon-camera"></i> glyphicon-camera</li>
			<li><i class="glyphicon glyphicon-font"></i> glyphicon-font</li>
			<li><i class="glyphicon glyphicon-bold"></i> glyphicon-bold</li>
			<li><i class="glyphicon glyphicon-italic"></i> glyphicon-italic</li>
			<li><i class="glyphicon glyphicon-text-height"></i> glyphicon-text-height</li>
			<li><i class="glyphicon glyphicon-text-width"></i> glyphicon-text-width</li>
			<li><i class="glyphicon glyphicon-align-left"></i> glyphicon-align-left</li>
			<li><i class="glyphicon glyphicon-align-center"></i> glyphicon-align-center</li>
			<li><i class="glyphicon glyphicon-align-right"></i> glyphicon-align-right</li>
			<li><i class="glyphicon glyphicon-align-justify"></i> glyphicon-align-justify</li>
			<li><i class="glyphicon glyphicon-list"></i> glyphicon-list</li>

			<li><i class="glyphicon glyphicon-indent-left"></i> glyphicon-indent-left</li>
			<li><i class="glyphicon glyphicon-indent-right"></i> glyphicon-indent-right</li>
			<li><i class="glyphicon glyphicon-facetime-video"></i> glyphicon-facetime-video</li>
			<li><i class="glyphicon glyphicon-picture"></i> glyphicon-picture</li>
			<li><i class="glyphicon glyphicon-pencil"></i> glyphicon-pencil</li>
			<li><i class="glyphicon glyphicon-map-marker"></i> glyphicon-map-marker</li>
			<li><i class="glyphicon glyphicon-adjust"></i> glyphicon-adjust</li>
			<li><i class="glyphicon glyphicon-tint"></i> glyphicon-tint</li>
			<li><i class="glyphicon glyphicon-edit"></i> glyphicon-edit</li>
			<li><i class="glyphicon glyphicon-share"></i> glyphicon-share</li>
			<li><i class="glyphicon glyphicon-check"></i> glyphicon-check</li>
			<li><i class="glyphicon glyphicon-move"></i> glyphicon-move</li>
			<li><i class="glyphicon glyphicon-step-backward"></i> glyphicon-step-backward</li>
			<li><i class="glyphicon glyphicon-fast-backward"></i> glyphicon-fast-backward</li>
			<li><i class="glyphicon glyphicon-backward"></i> glyphicon-backward</li>
			<li><i class="glyphicon glyphicon-play"></i> glyphicon-play</li>
			<li><i class="glyphicon glyphicon-pause"></i> glyphicon-pause</li>
			<li><i class="glyphicon glyphicon-stop"></i> glyphicon-stop</li>
			<li><i class="glyphicon glyphicon-forward"></i> glyphicon-forward</li>
			<li><i class="glyphicon glyphicon-fast-forward"></i> glyphicon-fast-forward</li>
			<li><i class="glyphicon glyphicon-step-forward"></i> glyphicon-step-forward</li>
			<li><i class="glyphicon glyphicon-eject"></i> glyphicon-eject</li>
			<li><i class="glyphicon glyphicon-chevron-left"></i> glyphicon-chevron-left</li>
			<li><i class="glyphicon glyphicon-chevron-right"></i> glyphicon-chevron-right</li>
			<li><i class="glyphicon glyphicon-plus-sign"></i> glyphicon-plus-sign</li>
			<li><i class="glyphicon glyphicon-minus-sign"></i> glyphicon-minus-sign</li>
			<li><i class="glyphicon glyphicon-remove-sign"></i> glyphicon-remove-sign</li>
			<li><i class="glyphicon glyphicon-ok-sign"></i> glyphicon-ok-sign</li>

			<li><i class="glyphicon glyphicon-question-sign"></i> glyphicon-question-sign</li>
			<li><i class="glyphicon glyphicon-info-sign"></i> glyphicon-info-sign</li>
			<li><i class="glyphicon glyphicon-screenshot"></i> glyphicon-screenshot</li>
			<li><i class="glyphicon glyphicon-remove-circle"></i> glyphicon-remove-circle</li>
			<li><i class="glyphicon glyphicon-ok-circle"></i> glyphicon-ok-circle</li>
			<li><i class="glyphicon glyphicon-ban-circle"></i> glyphicon-ban-circle</li>
			<li><i class="glyphicon glyphicon-arrow-left"></i> glyphicon-arrow-left</li>
			<li><i class="glyphicon glyphicon-arrow-right"></i> glyphicon-arrow-right</li>
			<li><i class="glyphicon glyphicon-arrow-up"></i> glyphicon-arrow-up</li>
			<li><i class="glyphicon glyphicon-arrow-down"></i> glyphicon-arrow-down</li>
			<li><i class="glyphicon glyphicon-share-alt"></i> glyphicon-share-alt</li>
			<li><i class="glyphicon glyphicon-resize-full"></i> glyphicon-resize-full</li>
			<li><i class="glyphicon glyphicon-resize-small"></i> glyphicon-resize-small</li>
			<li><i class="glyphicon glyphicon-plus"></i> glyphicon-plus</li>
			<li><i class="glyphicon glyphicon-minus"></i> glyphicon-minus</li>
			<li><i class="glyphicon glyphicon-asterisk"></i> glyphicon-asterisk</li>
			<li><i class="glyphicon glyphicon-exclamation-sign"></i> glyphicon-exclamation-sign</li>
			<li><i class="glyphicon glyphicon-gift"></i> glyphicon-gift</li>
			<li><i class="glyphicon glyphicon-leaf"></i> glyphicon-leaf</li>
			<li><i class="glyphicon glyphicon-fire"></i> glyphicon-fire</li>
			<li><i class="glyphicon glyphicon-eye-open"></i> glyphicon-eye-open</li>
			<li><i class="glyphicon glyphicon-eye-close"></i> glyphicon-eye-close</li>
			<li><i class="glyphicon glyphicon-warning-sign"></i> glyphicon-warning-sign</li>
			<li><i class="glyphicon glyphicon-plane"></i> glyphicon-plane</li>
			<li><i class="glyphicon glyphicon-calendar"></i> glyphicon-calendar</li>
			<li><i class="glyphicon glyphicon-random"></i> glyphicon-random</li>
			<li><i class="glyphicon glyphicon-comment"></i> glyphicon-comment</li>
			<li><i class="glyphicon glyphicon-magnet"></i> glyphicon-magnet</li>

			<li><i class="glyphicon glyphicon-chevron-up"></i> glyphicon-chevron-up</li>
			<li><i class="glyphicon glyphicon-chevron-down"></i> glyphicon-chevron-down</li>
			<li><i class="glyphicon glyphicon-retweet"></i> glyphicon-retweet</li>
			<li><i class="glyphicon glyphicon-shopping-cart"></i> glyphicon-shopping-cart</li>
			<li><i class="glyphicon glyphicon-folder-close"></i> glyphicon-folder-close</li>
			<li><i class="glyphicon glyphicon-folder-open"></i> glyphicon-folder-open</li>
			<li><i class="glyphicon glyphicon-resize-vertical"></i> glyphicon-resize-vertical</li>
			<li><i class="glyphicon glyphicon-resize-horizontal"></i> glyphicon-resize-horizontal</li>
			<li><i class="glyphicon glyphicon-hdd"></i> glyphicon-hdd</li>
			<li><i class="glyphicon glyphicon-bullhorn"></i> glyphicon-bullhorn</li>
			<li><i class="glyphicon glyphicon-bell"></i> glyphicon-bell</li>
			<li><i class="glyphicon glyphicon-certificate"></i> glyphicon-certificate</li>
			<li><i class="glyphicon glyphicon-thumbs-up"></i> glyphicon-thumbs-up</li>
			<li><i class="glyphicon glyphicon-thumbs-down"></i> glyphicon-thumbs-down</li>
			<li><i class="glyphicon glyphicon-hand-right"></i> glyphicon-hand-right</li>
			<li><i class="glyphicon glyphicon-hand-left"></i> glyphicon-hand-left</li>
			<li><i class="glyphicon glyphicon-hand-up"></i> glyphicon-hand-up</li>
			<li><i class="glyphicon glyphicon-hand-down"></i> glyphicon-hand-down</li>
			<li><i class="glyphicon glyphicon-circle-arrow-right"></i> glyphicon-circle-arrow-right</li>
			<li><i class="glyphicon glyphicon-circle-arrow-left"></i> glyphicon-circle-arrow-left</li>
			<li><i class="glyphicon glyphicon-circle-arrow-up"></i> glyphicon-circle-arrow-up</li>
			<li><i class="glyphicon glyphicon-circle-arrow-down"></i> glyphicon-circle-arrow-down</li>
			<li><i class="glyphicon glyphicon-globe"></i> glyphicon-globe</li>
			<li><i class="glyphicon glyphicon-wrench"></i> glyphicon-wrench</li>
			<li><i class="glyphicon glyphicon-tasks"></i> glyphicon-tasks</li>
			<li><i class="glyphicon glyphicon-filter"></i> glyphicon-filter</li>
			<li><i class="glyphicon glyphicon-briefcase"></i> glyphicon-briefcase</li>
			<li><i class="glyphicon glyphicon-fullscreen"></i> glyphicon-fullscreen</li>

			<li><i class="glyphicon glyphicon-dashboard"></i> glyphicon-dashboard</li>
			<li><i class="glyphicon glyphicon-paperclip"></i> glyphicon-paperclip</li>
			<li><i class="glyphicon glyphicon-heart-empty"></i> glyphicon-heart-empty</li>
			<li><i class="glyphicon glyphicon-link"></i> glyphicon-link</li>
			<li><i class="glyphicon glyphicon-phone"></i> glyphicon-phone</li>
			<li><i class="glyphicon glyphicon-pushpin"></i> glyphicon-pushpin</li>
			<li><i class="glyphicon glyphicon-euro"></i> glyphicon-euro</li>
			<li><i class="glyphicon glyphicon-usd"></i> glyphicon-usd</li>
			<li><i class="glyphicon glyphicon-gbp"></i> glyphicon-gbp</li>
			<li><i class="glyphicon glyphicon-sort"></i> glyphicon-sort</li>
			<li><i class="glyphicon glyphicon-sort-by-alphabet"></i> glyphicon-sort-by-alphabet</li>
			<li><i class="glyphicon glyphicon-sort-by-alphabet-alt"></i> glyphicon-sort-by-alphabet-alt</li>
			<li><i class="glyphicon glyphicon-sort-by-order"></i> glyphicon-sort-by-order</li>
			<li><i class="glyphicon glyphicon-sort-by-order-alt"></i> glyphicon-sort-by-order-alt</li>
			<li><i class="glyphicon glyphicon-sort-by-attributes"></i> glyphicon-sort-by-attributes</li>
			<li><i class="glyphicon glyphicon-sort-by-attributes-alt"></i> glyphicon-sort-by-attributes-alt</li>
			<li><i class="glyphicon glyphicon-unchecked"></i> glyphicon-unchecked</li>
			<li><i class="glyphicon glyphicon-expand"></i> glyphicon-expand</li>
			<li><i class="glyphicon glyphicon-collapse"></i> glyphicon-collapse</li>
			<li><i class="glyphicon glyphicon-collapse-top"></i> glyphicon-collapse-top</li>
		</ul>
	</div>
</section>
	

<!-- Forms
================================================== -->
<section id="forms">
	<div class="page-header">
		<h2>Forms</h2>
	</div>

	<div class="row">
		<div class="col-lg-8">
			<h3>Form Inline</h3>
			
			<form class="form-inline well">
				<div class="col-md-3">
						<input type="text" class="form-control" placeholder="Email">
				</div>
				<div class="col-md-3">
					<input type="password" class="form-control" placeholder="Password">
				</div>
				<div class="checkbox">
					<label>
						<input type="checkbox"> Remember me
					</label>
				</div>
				<button type="submit" class="btn btn-default">Sign in</button>
			</form>

			 <h3>Form Horizontal</h3>
			<form class="form-horizontal well">
				<fieldset>
					<legend>Bootstrap 3 Inputs</legend>
					<div class="control-group">
						<label class="control-label" for="input01">Text input</label>
						<div class="controls">
							<input type="text" class="form-control input-xlarge" id="input01">
							<p class="help-block">In addition to freeform text, any HTML5 text-based input appears like so.</p>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="optionsCheckbox">Checkbox</label>
						<div class="controls">
							<label class="checkbox">
								<input type="checkbox" id="optionsCheckbox" value="option1">
								Option one is this and that—be sure to include why it's great
							</label>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="select01">Select list</label>
						<div class="controls">
							<select id="select01" class="form-control">
								<option>something</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="multiSelect">Multicon-select</label>
						<div class="controls">
							<select multiple="multiple" id="multiSelect" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="fileInput">File input</label>
						<div class="controls">
							<input class="form-control input-file" id="fileInput" type="file">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="textarea">Textarea</label>
						<div class="controls">
							<textarea class="form-control input-xlarge" id="textarea" rows="3"></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="optionsCheckbox2">Disabled checkbox</label>
						<div class="controls">
							<label class="checkbox">
								<input type="checkbox" id="optionsCheckbox2" value="option1" disabled="">
								This is a disabled checkbox
							</label>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="inputWarning">Input with warning</label>
						<div class="controls">
							<input type="text" id="inputWarning" class="form-control">
							<span class="help-inline">Something may have gone wrong</span>
						</div>
					</div>
				 <hr>
					<div class="form-actions">
						<button type="submit" class="btn btn-primary">Save changes</button>
						<button type="reset" class="btn">Cancel</button>
					</div>
				</fieldset>
			</form>
		</div>
	</div>

</section>

<!-- Tables
================================================== -->
<section id="tables">
	<div class="page-header">
		<h1>Tables</h1>
	</div>
	
	<table class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th>#</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Username</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1</td>
				<td>Mark</td>
				<td>Otto</td>
				<td>@mdo</td>
			</tr>
			<tr>
				<td>2</td>
				<td>Jacob</td>
				<td>Thornton</td>
				<td>@fat</td>
			</tr>
			<tr>
				<td>3</td>
				<td>Larry</td>
				<td>the Bird</td>
				<td>@twitter</td>
			</tr>
		</tbody>
	</table>
</section>


<!-- Miscellaneous
================================================== -->
<section id="miscellaneous">
	<div class="page-header">
		<h1>Miscellaneous</h1>
	</div>

	<div class="row">
		<div class="col-lg-4">

			<h3 id="breadcrumbs">Breadcrumbs</h3>
			<ul class="breadcrumb">
				<li><a href="#">Home</a> <span class="divider"></span></li>
				<li><a href="#">Library</a> <span class="divider"></span></li>
				<li class="active">Data</li>
			</ul>
		</div>
		<div class="col-lg-4">
			<h3 id="pagination">Pagination</h3>
				<ul class="pagination">
					<li><a href="#">«</a></li>
					<li><a href="#">1</a></li>
					<li><a href="#">2</a></li>
					<li><a href="#">3</a></li>
					<li><a href="#">4</a></li>
					<li><a href="#">5</a></li>
					<li><a href="#">»</a></li>
				</ul>
		</div>
		
		<div class="col-lg-4">
			<h3 id="pager">Pagers</h3>
				
				<ul class="pager">
					<li><a href="#">Previous</a></li>
					<li><a href="#">Next</a></li>
				</ul>
				
				<ul class="pager">
					<li class="previous disabled"><a href="#">? Older</a></li>
					<li class="next"><a href="#">Newer ?</a></li>
				</ul>
		</div>
	</div>


	<!-- Navs
	================================================== -->

	<div class="row">
		<div class="col-lg-4">

			<h3 id="tabs">Tabs</h3>
			<ul class="nav nav-tabs">
				<li class="active"><a href="#A" data-toggle="tab">Section 1</a></li>
				<li><a href="#B" data-toggle="tab">Section 2</a></li>
				<li><a href="#C" data-toggle="tab">Section 3</a></li>
			</ul>
			<div class="tabbable">
				<div class="tab-content">
					<div class="tab-pane active" id="A">
						<p>I'm in Section A.</p>
					</div>
					<div class="tab-pane" id="B">
						<p>Howdy, I'm in Section B.</p>
					</div>
					<div class="tab-pane" id="C">
						<p>What up girl, this is Section C.</p>
					</div>
				</div>
			</div> <!-- /tabbable -->
			
		</div>
		<div class="col-lg-4">
			<h3 id="pills">Pills</h3>
			<ul class="nav nav-pills">
				<li class="active"><a href="#">Home</a></li>
				<li><a href="#">Profile</a></li>
				<li class="dropdown">
					<a class="dropdown-toggle" data-toggle="dropdown" href="#">Dropdown <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="#">Action</a></li>
						<li><a href="#">Another action</a></li>
						<li><a href="#">Something else here</a></li>
						<li class="divider"></li>
						<li><a href="#">Separated link</a></li>
					</ul>
				</li>
				<li class="disabled"><a href="#">Disabled link</a></li>
			</ul>
		</div>
		
		<div class="col-lg-4">
			
			<h3 id="list">Nav Lists</h3>
				
			<div class="well" style="padding: 8px 0;">
				<ul class="nav nav-list">
					<li class="nav-header">List header</li>
					<li class="active"><a href="#">Home</a></li>
					<li><a href="#">Library</a></li>
					<li><a href="#">Applications</a></li>
					<li class="divider"></li>
					<li><a href="#">Help</a></li>
				</ul>
			</div>
		</div>
	</div>


<!-- Labels
================================================== -->

	<div class="row">
		<div class="col-lg-4">
			<h3 id="labels">Labels</h3>
			<span class="label">Default</span>
			<span class="label label-success">Success</span>
			<span class="label label-warning">Warning</span>
			<span class="label label-danger">Danger</span>
			<span class="label label-info">Info</span>
		</div>
		<div class="col-lg-4">
			<h3 id="badges">Badges</h3>
			<span class="badge">Default</span>
		</div>
		<div class="col-lg-4">
			<h3 id="badges">Progress bars</h3>
			<div class="progress">
				<div class="progress-bar progress-bar-info" style="width: 20%"></div>
			</div>
			<div class="progress">
				<div class="progress-bar progress-bar-success" style="width: 40%"></div>
			</div>
			<div class="progress">
				<div class="progress-bar progress-bar-warning" style="width: 60%"></div>
			</div>
			<div class="progress">
				<div class="progress-bar progress-bar-danger" style="width: 80%"></div>
			</div>
			
		</div>
		
		
		</div>
	<br>
	
	
<!-- Panel & ListGroups
================================================== -->
<hr>

	<h2 id="panels">Bootstrap 3 Panels</h2>
	
	<div class="row">
		<div class="col-lg-4">
			<div class="panel panel-default">
			<div class="panel-heading">Panel heading</div>
			<div class="panel-body">Hello. This is the Panel content.</div>
		</div>
		</div>
		<div class="col-lg-4">
			<div class="panel panel-primary">
			<div class="panel-heading">Panel primary</div>
			<div class="panel-body">Panels are new in BS3.</div>
		</div>
		</div>
		<div class="col-lg-4">
			<div class="panel panel-success">
			<div class="panel-heading">Panel success</div>
			<div class="panel-body">You can use contextual classes.</div>
		</div>
		</div>
	</div>
	

<!-- ListGroups
================================================== -->
<hr>

	<h2 id="panels">Bootstrap 3 List Groups</h2>
	
	<div class="row">
		<div class="col-lg-4">
			<ul class="list-group">
				<li class="list-group-item">List item 1</li>
				<li class="list-group-item">List item 2</li>
				<li class="list-group-item">Mobile-first</li>
				<li class="list-group-item">Responsive</li>
				<li class="list-group-item">Lightweight</li>
			</ul>
		</div>
		<div class="col-lg-4">
			<ul class="list-group">
				<li class="list-group-item"><span class="glyphicon glyphicon-chevron-right"></span> List item 1</li>
				<li class="list-group-item"><span class="glyphicon glyphicon-chevron-right"></span> List item 2</li>
				<li class="list-group-item"><span class="glyphicon glyphicon-chevron-right"></span> Mobile-first</li>
				<li class="list-group-item"><span class="glyphicon glyphicon-chevron-right"></span> Responsive</li>
				<li class="list-group-item"><span class="glyphicon glyphicon-chevron-right"></span> Lightweight</li>
			</ul>
		</div>
		<div class="col-lg-4">
			<div class="list-group">
				<a href="#" class="list-group-item active">
					Linked list group
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
				<a href="#" class="list-group-item">Dapibus ac facilisis in
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
				<a href="#" class="list-group-item">Morbi leo risus
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
				<a href="#" class="list-group-item">Porta ac consectetur ac
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
				<a href="#" class="list-group-item">Vestibulum at eros
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
			</div>
		</div>
	</div>
	
	
<!-- Well Sizes
================================================== -->
<hr>
	<h2>Well Sizes</h2>
	<div class="row">
		<div class="col-lg-12">
			 <div class="well well-sm"> 
					.well-sm
				</div>		 	
				<div class="well"> 
					.well
				</div>
			 <div class="well well-lg"> 
					.well-lg
				</div>
		</div>
	</div>
<hr>

	
</section>
	<hr>
	<a href="http://www.bootply.com/65566">Edit on Bootply</a>
	<hr>
</div>

         
*/

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


NSString * const custHTML = @"\n\
<!-- Part 1: Wrap all page content here -->\n\
<div id='wrap'>\n\
\n\
  <!-- Fixed navbar -->\n\
  <div class='navbar navbar-fixed-top'>\n\
	<div class='navbar-inner'>\n\
	  <div class='container'>\n\
		<button type='button' class='btn btn-navbar' data-toggle='collapse' data-target='.nav-collapse'>\n\
		  <span class='icon-bar'></span>\n\
		  <span class='icon-bar'></span>\n\
		  <span class='icon-bar'></span>\n\
		</button>\n\
		<a class='brand' href='#'>Project name</a>\n\
		<div class='nav-collapse collapse'>\n\
		  <ul class='nav'>\n\
			<li class='active'><a href='#'>Home</a></li>\n\
			<li><a href='#about'>About</a></li>\n\
			<li><a href='#contact'>Contact</a></li>\n\
			<li class='dropdown'>\n\
			  <a href='#' class='dropdown-toggle' data-toggle='dropdown'>Dropdown <b class='caret'></b></a>\n\
			  <ul class='dropdown-menu'>\n\
				<li><a href='#'>Action</a></li>\n\
				<li><a href='#'>Another action</a></li>\n\
				<li><a href='#'>Something else here</a></li>\n\
				<li class='divider'></li>\n\
				<li class='nav-header'>Nav header</li>\n\
				<li><a href='#'>Separated link</a></li>\n\
				<li><a href='#'>One more separated link</a></li>\n\
			  </ul>\n\
			</li>\n\
		  </ul>\n\
		</div><!--/.nav-collapse -->\n\
	  </div>\n\
	</div>\n\
  </div>\n\
\n\
  <!-- Begin page content -->\n\
  <div class='container'>\n\
	<div class='page-header'>\n\
	  <h1>Sticky footer with fixed navbar</h1>\n\
	</div>\n\
	<p class='lead'>Pin a fixed-height footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added within <code>#wrap</code> with <code>padding-top: 60px;</code> on the <code>.container</code>.</p>\n\
	<p>Back to <a href='./sticky-footer.html'>the sticky footer</a> minus the navbar.</p>\n\
  </div>";

NSString * const custHTMLFOOT = @"\n\
  	<div id='push'></div>\n\
	</div>\n\
	<div id='footer'>\n\
  	<div class='container'>\n\
			<p class='muted credit'>Example courtesy <a href='http://martinbean.co.uk'>Martin Bean</a> and\n\
																  <a href='http://ryanfait.com/sticky-footer/'>Ryan Fait</a>.</p>\n\
  	</div>\n\
	</div>";


NSString * const custHTMLRECORDER = @"\n\
 <div id='wrapper'>\n\
<h1><a href='http://github.com/jwagener/recorder'>Recorder Example</a></h1>\n\
<p>\n\
This is a very basic example for the Recorder.js. Checkout <a href='http://github.com/jwagener/recorder'>GitHub</a> for details and have a look at the source for this file.  Start by clicking record:\n\
</p><div>\n\
  <a href='javascript:record()'  id='record'					   >Record</a>\n\
  <a href='javascript:play()'	id='play'   >Play</a> \n\
  <a href='javascript:stop()'	id='stop'   >Stop</a>\n\
  <a href='javascript:upload()'  id='upload' >Upload to SoundCloud</a>\n\
</div>\n\
<span id='time'>0:00</span>\n\
</div>";



/*
@implementation AZJS
- (NSS*) description { return self.stringValue; }
- (NSS*) stringValue { return [NSException raise:@"Problemo" format:@"need to implement this"], nil; }
@end

@implementation  AZJSVar
+ (instancetype) varNamed:(NSS*)name value:(NSS*)val {AZJSVar *s = self.new;  s.varName = name, s.value = val;return s; }
- (NSS*) stringValue {  return  [_varName stringByAppendingFormat:@" = %@;", _value]; }
@end

@interface  AZJQueryMethod ()
@property (readonly) NSS * callBackString;
@end
@implementation AZJQueryMethod
+(instancetype) javascriptWithSelector:(NSS*)select function:(NSS*)f method:(NSS*)m callback:(NSA*)callback{

	AZJQueryMethod *s = self.new;  s.selector = select, s.function = f; s.method = m; s.callback = callback ?: nil; return s;
}
- (NSString*) callBackString { if (!_callback) return @""; return  [@", " stringByAppendingString:[_callback componentsJoinedByString:@"\n"]]; }
- (NSS*) stringValue {

	return JATExpand(@"$({_selector}).{_function}( {_method} {3});", _selector,_function, _method, self.callBackString);
}
@end
*/
