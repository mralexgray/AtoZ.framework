
#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

#define AZSTDIN NSFileHandle.fileHandleWithStandardInput
@interface AZCLIMenu 	: NSObject
@property (STRNG)	NSA* items;
@property (RONLY)	NSS* outputString;
@property (ASS)   NSRNG range;
@end
@interface AZCLIHandler : NSObject	{ NSA* palette; }

@property (NATOM) BOOL finished;
@property (STRNG) NSFileHandle *stdinFileHandle;
@property (RONLY) NSC *nextColor;
- (void) mainMenu;
@end

@implementation AZCLIHandler

- (id) init { 	if (self != super.init ) return nil;

  _stdinFileHandle = AZSTDIN;
  palette = [NSC colorsInFrameworkListNamed:@"FengShui"];
  [AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification object:_stdinFileHandle];
  fprintf(stdout, "Welcome to %s.  Please choose a test option.", colorizeStringWithColors(@"AtoZ.framework", RED, WHITE).UTF8String);
  fflush(stdout);
  [self mainMenu];
  return self;
}
- (NSC*) nextColor 		{ static NSUI _p = 0; _p++; return [palette normal:_p]; }
- (NSS*) methodMenu	 { return self.instanceMethodArray.count ? [NSS stringFromArray:[self.instanceMethodArray nmap:^id(id obj, NSUI i) {
										return $(@"\n\t%ld:\t%@", i, colorizeStringWithColor(obj, self.nextColor));}]] : nil;   	}

- (NSS*) frameworkMenu	{	return [NSS stringFromArray:[AZFWORKBUNDLE.frameworkIdentifiers nmap:^id(id obj, NSUI i) {
										return $(@"%ld:%@", 100 + i, [colorizeStringWithColor(obj, self.nextColor) paddedTo:60]); }]]; 	}

//- (VoidBlock) actionAtIndex {}

- (void) mainMenu {	fprintf(stdout, "\n\nAvailable Frameworks:\n\n%s",	self.frameworkMenu.UTF8String); 
							fprintf(stdout, "\n\nAvailable Tests:%s\n",  		self.methodMenu.UTF8String );
							[_stdinFileHandle readInBackgroundAndNotify];
}	

- (void)didReadStdin:(NSNOT*)note
{
   NSS *string = [NSS stringWithData:[note.userInfo objectForKey:NSFileHandleNotificationDataItem] encoding:NSASCIIStringEncoding];
	NSUI select  = string.integerValue;
	BOOL hit = select < self.instanceMethodNames.count ||  ( 100 <= select && select < 100 + AZFWORKBUNDLE.frameworkIdentifiers.count);
	!hit  ? [self mainMenu] 
			: fprintf(stdout, "YOu selected %ld\n", select);
//	if ([result respondsToSelector:@selector(UTF8String)])  fprintf(stdout, "%s\n", [result UTF8String]);   fprintf(stdout, "objj> ");
	fflush(stdout);
	[_stdinFileHandle readInBackgroundAndNotify];
}
- (void) colorLogging {

	COLORLOG(YELLOw, @"whatever %@", @4);	NSD *allColorInfo = NSC.colorsAndNames;
	NSLog(@"Available named colors:\n%@", 	[NSS stringFromArray:[allColorInfo.allKeys map:^id(id obj) {
															return colorizeStringWithColor(	
																	[obj stringByPaddingToLength:22 withString:@" " startingAtIndex:0], 
																	allColorInfo[obj]);	
														}]]);
	[self mainMenu];
}
- (void) variadicColorLogging {

	LOGCOLORS(RED, @"red", ORANGE, @"orange", YELLOw, @"yellow", GREEN, @"green", BLUE, @"blue", PURPLE, GREY, "purple (but not in the right order", "Grey (also out of order)", nil);
}

//	NSFileHandle *inHandle = AZSTDIN; // Read from stdin
//	[AZNOTCENTER addObserver:self selector:@selector(stdinDataAvailable) name:NSFileHandleDataAvailableNotification object:inHandle];
//	[inHandle waitForDataInBackgroundAndNotify];
//   return self;
//}

//- (void) stdinDataAvailable 	{
//	
//	NSData *theData = [[NSFileHandle fileHandleWithStandardInput] availableData];
//	NSLog(@"Got data: %@", theData);
//	_finished 		 = !theData.length;	
//	if (_finished)  return; 
//	[AZSTDIN waitForDataInBackgroundAndNotify];	// Listen for more
//   
//}
@end

int main(int argc, char *argv[]) {	@autoreleasepool {

	// Create the input handler
   AZCLIHandler *ih = AZCLIHandler.new;
	while (!ih.finished) AZRUNFOREVER;	   // Kick the run loop
	
//					__block NSUI chooser = 1; 
//		int inputOne;
//				
//	  scanf("%i", &inputOne);
//	  NSLog (@"You chose: %i : %@", inputOne, allOpts[(inputOne + 1)]);
//	  int inputTwo;
//	  NSLog (@"Enter another number: ");
//	  scanf("%i", &inputTwo);
//	  NSLog (@"%i + %i = %d", inputOne, inputTwo, inputOne + inputTwo);
//*/
   }
	return 0;
}

/*
		NSApplication *app			= [NSApplication sharedApplication];
		NSRect 			frame  	= (NSRect) { 100, 100, 300, 300 };
		NSWindow 			*window 	= [[NSWindow alloc] initWithContentRect:frame
														   styleMask:NSTitledWindowMask|NSResizableWindowMask
															 backing:NSBackingStoreBuffered defer:false];
		[window setTitle:@"Testing"];
		AtoZ *whatver = [AtoZ sharedInstance];
//		[AtoZ playRandomSound];
		TestView *view = [[TestView alloc] initWithFrame:frame];
		[window setContentView:view];
		[window setDelegate:view];
		//		[window makeKeyAndOrderFront:window];
		[NSApp activateIgnoringOtherApps:YES];
		[app run];
	} */
//		AZLOG([NSB applicationSupportFolder]);
//		[AZStopwatch stopwatch:@"Runtime" timing:^{


		
//						COLORLOG(value, @"%@", key);
//			}];
//			COLORLOG(RANDOMCOLOR, @"%@", NSS.randomDicksonism);
//			NSC.logPalettes;
			
//			COLORLOG(GREEN, @"%@",[NSC colorNames]);
//			AZLOG([CWPathUtilities applicationSupportFolder]);
			//		NSLog(@"TEST start");
//			AZFile *f = [AZFile instanceWithPath:@"/Applications/Safari.app"];
//			AZLOG([AZFILEMANAGER attributesOfItemAtPath:f.path error:nil]);

		

//		AZLOG([[AtoZ sharedInstance]instanceMethodNames]);



//	TestStopwatchBlock(@"testTheWatch");
//		NSArray *u = [NSArray arrayWithArrays: @[@[@"array1", @[@"array1level2"]],@[@"array2", @"array2item2"], @[@"array3"]]];
//		AZLOG(	u );
//		AZLOG([NSArray classMethods]);

//		AZLOG([NSColor allColors]);
//	[NSThread performBlock:^{
//		[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSCopying)])];
//	} afterDelay:2];
//	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFileManagerDelegate)])];
//	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFastEnumeration)])];
//		AZLOG([AZAppFolder sharedInstance]);
//		AZLOG([AZFile forAppNamed:@"/Applications/Safari.app"]);

//	AZLOG([NSColor colorsInFrameworkListNamed:@"OrigamiMice"]);

//	NSImage *web = [NSImage imageFromWebPageAtURL:[NSURL URLWithString:@"http://google.com"] encoding:NSUTF8StringEncoding];
//	AZLOG(web);
//	[paddy quantize];
//		[[AZColor sharedInstance] colorsForImage:[NSImage az_imageNamed:@"mrgray.logo.png"]]);
//	AZFile *s = [AZFile	instanceWithImage:[NSImage randomIcon]];
//	AZLOG(s.propertiesPlease);
//	[s.image saveAs:@"/Users/localadmin/Desktop/poops.png"];

//	AZFile* dum = [AZFile dummy];
//	AZLOG(dum.propertiesPlease);
//	[dum.image saveAs:@"/Users/localadmin/Desktop/poop.png"];
//
//	AZFile* ss = [AZFile instanceWithColor:RANDOMCOLOR];
//	AZLOG(ss.propertiesPlease);
//	[ss.image saveAs:@"/Users/localadmin/Desktop/poopss.png"];
//
//	AZTalker *welcome = [AZTalker new];
//	[welcome say:@"welcome"];
//
//	[[AZTalker sharedInstance]say:@"huge vgaenn"];
//
//
//	CGPoint a = AZAnchorPointForPosition( AZPositionLeft);
//
//	NSLog(@"%@", NSStringFromPoint(a));

//		NSA* s  = [NSA arrayWithContentsOfFile:@"/Users/localadmin/Desktop/gists.plist"];
//		NSBag *b = [s ojectsInSubdictionariesForKey:@"language"];
//		AZLOG(b);

/**

@interface ExampleTest : GHTestCase { }
@end

@implementation ExampleTest

- (BOOL)shouldRunOnMainThread {
		// By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
		// Also an async test that calls back on the main thread, you'll probably want to return YES.
	return NO;
}

- (void)setUpClass {
		// Run at start of all tests in the class
}

- (void)tearDownClass {
		// Run at end of all tests in the class
}

- (void)setUp {
		// Run before each test method
}

- (void)tearDown {
		// Run after each test method
}

- (void)testFoo {
	NSString *a = @"foo";
	GHTestLog(@"I can log to the GHUnit test console: %@", a);

		// Assert a is not NULL, with no custom error description
	GHAssertNotNULL(a, nil);

		// Assert equal objects, add custom error description
	NSString *b = @"bar";
	GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
}

- (void)testBar {
		// Another test
}

@end
#import <Foundation/Foundation.h>

#import <GHUnit/GHUnit.h>
#import <GHUnit/GHTestApp.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {

			// Register any special test case classes
			//[[GHTesting sharedInstance] registerClassName:@"GHSpecialTestCase"];

		int retVal = 0;
			// If GHUNIT_CLI is set we are using the command line interface and run the tests
			// Otherwise load the GUI app
		if (getenv("GHUNIT_CLI")) {
			retVal = [GHTestRunner run];
		} else {
				// To run all tests (from ENV)
			GHTestApp *app = [[GHTestApp alloc] init];
				// To run a different test suite:
				//GHTestSuite *suite = [GHTestSuite suiteWithTestFilter:@"GHSlowTest,GHAsyncTestCaseTest"];
				//				GHTestApp *app = [[GHTestApp alloc] initWithSuite:suite];
				// Or set global:
				//GHUnitTest = @"GHSlowTest";
			[NSApp run];
		}
		return retVal;
	}
}
*/

/*
void cliDefaults(){
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	NSUInteger counter = [defaults[@"counter"]unsignedIntegerValue] +1;
	[defaults setPersistentDomain:[NSDictionary dictionaryWithObject:@(counter) forKey:@"counter"] forName:@"com.mralexgray.atozCLI"];
	[defaults synchronize];
	NSLog(@"welcome the the CLI.  We've launched %ld times!", counter);
}
void quantize() {
	[AZStopwatch start:@"quantize"];
	cliDefaults();
	@autoreleasepool {
		[[NSImage systemImages] eachConcurrentlyWithBlock:^(NSInteger index, id objI, BOOL *stop) {
			[[[AZColor sharedInstance] colorsForImage:objI] az_each:^(id obj, NSUInteger index, BOOL *stop) {
			NSLog(@"Hello, World!  %@", [obj propertiesPlease]);
			}];
		}];
	}
	[AZStopwatch stop:@"quantize"];
}

void TestStopwatchBlock (NSString* name) {
	[AZStopwatch stopwatch:name timing:^{
			[AtoZ performBlock:^{
//				[self someLongAssFunction];
			} afterDelay:10];
		[AtoZ performSelector:@selector(dock) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
			AZLOG(@"longblock");
	}];
}

//const NSImage*paddy = [[NSImage alloc]initWithContentsOfFile:@"/Library/Desktop Pictures/Rice Paddy.jpg"];

@interface AAAA : BaseModel
@end
@implementation AAAA
@end
@interface TestView : NSView <NSWindowDelegate> { }

@property (strong) CALayer* lay;
-(void)drawRect:(NSRect)rect;
@end

@implementation TestView

-(void)viewDidMoveToSuperview {
	NSLog(@"view did load");
	self.wantsLayer = YES;
	self.lay = [CALayer layer];
	_lay.frame = quadrant(self.bounds, 1);
	_lay.backgroundColor = cgRED;
	self.layer.sublayers = @[_lay];
}
-(void)drawRect:(NSRect)rect {
	[[NSColor blueColor] set];
	NSRectFill( [self bounds] );
}

-(void)windowWillClose:(NSNotification *)note {		[[NSApplication sharedApplication] terminate:self];	}

- (void) mouseDown:(NSEvent*)ev	{	[_lay animateOverAndUpFrom:_lay.position to:AZCenterOfRect(quadrant(self.bounds, 3)) duration:5];	}
@end
*/
