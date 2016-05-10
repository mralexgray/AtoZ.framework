
@import AppKit; @import WebControl; @import ORSSerial;

@interface RickshawGraph : WebView @end

@interface MMAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet RickshawGraph *graph;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet GaugeView *guage;
@property	(weak) IBOutlet MM2200087 *m;
@property	(weak) IBOutlet NSPopUpButton * ports;

@end

@implementation MMAppDelegate

- (IBAction)onPopupBtnSelectedItemChanged:(id)sender
{
    [AZUSERDEFS setInteger:_ports.indexOfSelectedItem forKey:@"selectedItemIndex"];
}

- (void) applicationDidFinishLaunching:(NSNotification*)x {


	_Text path1 = [AZAPPBUNDLE pathForResource:@"example-resize" ofType:@"html" inDirectory:@"canv-gauge"];
	_Text __unused html = [Text fromFile:path1];

//	[_webView.mainFrame loadHTMLString:html baseURL:[AZAPPBUNDLE.resourceURL URLByAppendingPathComponent:@"canv-gauge"]];

	[SERIALPORTS log];

	_m.onChange = ^(id<MultiMeter> thing){
		id __unused x = [thing display][kLCD];

		NSLog(@"onchange: %@", thing);
		[_guage stringByEvaluatingJavaScriptFromString:
			[NSString stringWithFormat:@"gaugejs.setValue(%f);",[x floatValue]]];

	};

  [_ports bind:NSSelectedObjectBinding toObject:_m withKeyPath:@"port" options:nil];

  [_ports setTarget:self];
  [_ports setAction:@selector(onPopupBtnSelectedItemChanged:)];
  [_m setPort:SERIALPORTS[[AZUSERDEFS unsignedIntForKey:@"selectedItemIndex"]]];

  //  [_ports selectItemAtIndex:;

//	_m = MM2200087.new;
//	_m.port = SERIALPORTS[0];

	//    [_webView setDrawsBackground:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end


@implementation WebView (inject)

// inject JS string into document
- (void) injectJS:(NSString*) jsString
{
    DOMDocument* domDocument = [self mainFrameDocument];
    DOMElement* jsElement = [domDocument createElement:@"script"];
    [jsElement setAttribute:@"type" value:@"text/javascript"];
    DOMText* jsText = [domDocument createTextNode:jsString];
    [jsElement appendChild:jsText];
    DOMElement* bodyElement = (DOMElement*)[[domDocument getElementsByTagName:@"body"] item: 0];
    [bodyElement appendChild:jsElement];
}

// inject CSS string into document
- (void) injectCSS:(NSString*) cssString
{
    DOMElement* jsElement = [self.mainFrameDocument createElement:@"style"];
    [jsElement setAttribute:@"type" value:@"text/css"];
    DOMText* jsText = [self.mainFrameDocument createTextNode:cssString];
    [jsElement appendChild:jsText];
    DOMElement* bodyElement = (DOMElement*)[[self.mainFrameDocument getElementsByTagName:@"head"] item: 0];
    [bodyElement appendChild:jsElement];
}

@end



@implementation RickshawGraph


- (void) awakeFromNib {

	id base = @"rickshaw/examples";

	_Text path1 = [AZAPPBUNDLE pathForResource:@"meter" ofType:@"html" inDirectory:base],
         html = [Text fromFile:path1];

	[self.mainFrame loadHTMLString:html baseURL:[AZAPPBUNDLE.resourceURL URLByAppendingPathComponent:base]];

	return;


	NSBundle* bundle = [NSBundle bundleForClass:self.class];

	[self.mainFrame loadHTMLString: @"<div id='content'><div id='chart'></div></div>" baseURL:nil];


//	for (id css in @[@"graph", @"detail", @"legend"]) {
//	<link type="text/css" rel="stylesheet" href="css/extensions.css">

	[self injectCSS:[NSString fromFile:[bundle pathForResource:@"rickshaw" ofType:@"css" inDirectory:@"rickshaw"]]];
	for (id z in @[ @[@"rickshaw",@"rickshaw"],@[@"d3.v3",@"rickshaw/vendor"]]) {

				id x = [bundle pathForResource:z[0] ofType:@"js" inDirectory:z[1]];
				if (![x length]) [z log];
				id j = [NSString fromFile:x];
				[self stringByEvaluatingJavaScriptFromString:j];
//				[self injectJS:z];
		}
		[self stringByEvaluatingJavaScriptFromString:@"console.log('whatever');"];
		[self stringByEvaluatingJavaScriptFromString:@" \
\
	var tv = 250;\
	var graph = new Rickshaw.Graph( {\
	element: document.getElementById(\"chart\"),\
	width: 900,\
	height: 500,\
	renderer: 'line',\
	series: new Rickshaw.Series.FixedDuration([{ name: 'one' }], undefined, {\
			timeInterval: tv,\
			maxDataPoints: 100,\
			timeBase: new Date().getTime() / 1000\
		}) \
	});\
	\
	graph.render();"];

}


@end

@interface NSArrayToStringTransformer : NSValueTransformer
￭
@implementation NSArrayToStringTransformer
+ (Class)transformedValueClass { return NSString.class; }
- (nullable id)transformedValue:(nullable id)value { return [value joinedWithSpaces]; }
￭

int main(int argc, const char * argv[]) {
	return NSApplicationMain(argc, argv);
}


/*
// @"../src/css/.css", @"../src/css/detail.css", @"../src/css/legend.css">
//	for css in @[@"graph", @"detail", @"legend"]
//	<link type="text/css" rel="stylesheet" href="css/extensions.css">

	<script src="../vendor/d3.v3.js"></script>
	<script src="../rickshaw.js"></script>
</head>
<body>

<div id="content">
	<div id="chart"></div>
</div>

<script>

// add some data every so often

var i = 0;
var iv = setInterval( function() {

	var data = { one: Math.floor(Math.random() * 40) + 120 };

	var randInt = Math.floor(Math.random()*100);
	data.two = (Math.sin(i++ / 40) + 4) * (randInt + 400);
	data.three = randInt + 300;

	graph.series.addData(data);
	graph.render();

}, tv );

</script>

</body>
*/
