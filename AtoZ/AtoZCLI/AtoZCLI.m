
#import <AtoZ/AtoZ.h>
#import <SansNib/SansNib.h>
#import <unistd.h>
#import <stdio.h>

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

#define FORCE_XCOLORS 1
#define FORCE_LOAD 1
#define PRINT_ENV 0

void CRWait (void) { while ( getchar() != '\n' ) { }; }

/*! GAMEPLAN
`   AZWINDOW Tabs surround screen,
    MenuAPp Instance runs controller status item and dropdown window...
    Menu app also weirdly enoguh seems to load atoz via a METHOD!
  
  reading from interactive prompt:
    int inputOne;
    NSLog (@"Enter number: ");
    scanf("%i", &inputOne);
    NSNumber *ddd = @(inputTwo);
  
  @note This is the actual full declaration of main() on OS X. The "apple"  parameter is the path to the executable, i.e. _NSGetProgname().
*/
int main(int argc, char **argv, char **envp, char **apple) { @autoreleasepool {	AZSHAREDAPP;

#if FORCE_XCOLORS
  int res;	setenv("XCODE_COLORS", "YES", &res);
#endif
#if PRINT_ENV 
	AZLogEnv(envp);
#endif
#ifdef FORCE_LOAD

//  XX(AZPROCINFO.environment);
//  [NSB loadAZFrameworks];
//	NSString * path 	= [AZPROCINFO.environment[@"AZBUILD"] withString:@"/AtoZ.framework/Versions/A/Frameworks"];// @"/Library/Frameworks/AtoZ.framework/Versions/A/Frameworks";

//  printf("%s",path.UTF8String);
//NSString * bPath	= path.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent;
//	NSBundle * bundl = [NSBundle bundleWithPath:path];// stringByAppendingPathComponent:@"AtoZ.Framework"]];
//	NSError  * e;		do { fprintf(stderr, "While Bundle Not loaded...: %s\n", bundl.debugDescription.UTF8String);
//				   [ bundl preflightAndReturnError:&e]  ? bundl.load : fprintf(stderr, "Preflight reported error.. %s\n",      e.debugDescription.UTF8String);
//		} while (! bundl.isLoaded );
//  LOGCOLORS([NSB allFrameworks], nil);
#endif		
//    [AZCLIMenu addMenuFor:NSB.azFrameworkIds starting:100palette:RANDOMPAL];
    
    NSA *fws =NSB.azFrameworks[@"bundlePath"]; NSUI longest = [fws lengthOfLongestMemberString];
    [fws do:^(id obj) {
      [NSTerminal printString:[AZLog colorizeString:[obj paddedTo:longest] withColor:GPALNEXT].clr];
    }];
    [SansNib run];
//		id cliApp = [NSClassFromString(@"AZCLI") new];  /* Start the "App" */	[NSApp run];  // Into the sunset
//		
}	return EXIT_SUCCESS;	}


//	return NSApplicationMain(argc, (const char **) argv);
//NSLog(@"%@ %@  %@  %@",path, b, e, [b bundleIdentifier] ); 	}
//#include <stdio.h>
//#include <sys/ioctl.h>
//#import <AtoZ/AtoZ.h>
//#import "NSTerminal.h"


//	AppDelegate *appDelegate = AppDelegate.new; [application setDelegate:appDelegate];[application run];
//	[NSApp run];
//	[NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture];
//	while(![[cli sharedInstance]boolForKey:@"finished"])	[NSRunLoop.currentRunLoop run];

//	fprintf ( stderr, "Preflighting path: %s\n", path.UTF8String);

/*	struct winsize w;
	ioctl(0, TIOCGWINSZ, &w);

	printf ("lines %d\n", w.ws_row);
	printf ("columns %d\n", w.ws_col);
	printf ("%s", getenv("ENV"));
	printf("%sred\n", KRED);
	printf("%sgreen\n", KGRN);
	printf("%syellow\n", KYEL);
	printf("%sblue\n", KBLU);
	printf("%smagenta\n", KMAG);
	printf("%scyan\n", KCYN);
	printf("%swhite\n", KWHT);
	printf("%snormal\n", KNRM);

	char *xcode_colors = getenv(XCODE_COLORS);
	if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
		// XcodeColors is installed and enabled!
		setenv("XcodeColors", "YES", 0); // Enables XcodeColors (you obviously have to install it too)
	else 	printf ("%sUH oh, so hay xcode colores", KWHT);
*/
//	printf ("%s%s", KWHT, [AtoZ.sharedInstance.instanceMethodNames stringValueInColumnsCharWide:50].UTF8String);
//AZRUNFOREVER;

/*
	__block NSUI chooser = 1;	int inputOne;
  scanf("%i", &inputOne);
  NSLog (@"You chose: %i : %@", inputOne, allOpts[(inputOne + 1)]);
  int inputTwo;
  NSLog (@"Enter another number: ");
  scanf("%i", &inputTwo);
  NSLog (@"%i + %i = %d", inputOne, inputTwo, inputOne + inputTwo);


	NSFileHandle *inHandle = AZSTDIN; // Read from stdin
	[AZNOTCENTER addObserver:self selector:@selector(stdinDataAvailable) name:NSFileHandleDataAvailableNotification object:inHandle];
	[inHandle waitForDataInBackgroundAndNotify];
   return self;	}

- (void) stdinDataAvailable   {

	NSData *theData = [[NSFileHandle fileHandleWithStandardInput] availableData];
	NSLog(@"Got data: %@", theData);
	_finished        = !theData.length;
	if (_finished)  return;
	[AZSTDIN waitForDataInBackgroundAndNotify];	// Listen for more

}
                NSApplication *app			= [NSApplication sharedApplication];
                NSRect          frame   = (NSRect) { 100, 100, 300, 300 };
                NSWindow            *window     = [NSWindow.alloc initWithContentRect:frame
                                                                                                                   styleMask:NSTitledWindowMask|NSResizableWindowMask
                                                                                                                         backing:NSBackingStoreBuffered defer:false];
                [window setTitle:@"Testing"];
                AtoZ *whatver = [AtoZ sharedInstance];
   //		[AtoZ playRandomSound];
                TestView *view = [TestView.alloc initWithFrame:frame];
                [window setContentView:view];
                [window setDelegate:view];
                //		[window makeKeyAndOrderFront:window];
                [NSApp activateIgnoringOtherApps:YES];
                [app run];
        } 
		  
		AZLOG([NSB applicationSupportFolder]);
		[AZStopwatch stopwatch:@"Runtime" timing:^{
		COLORLOG(value, @"%@", key);			}];

		COLORLOG(RANDOMCOLOR, @"%@", NSS.randomDicksonism);
		NSC.logPalettes;

			COLORLOG(GREEN, @"%@",[NSC colorNames]);
			AZLOG([CWPathUtilities applicationSupportFolder]);
		NSLog(@"TEST start");
			AZFile *f = [AZFile instanceWithPath:@"/Applications/Safari.app"];
			AZLOG([AZFILEMANAGER attributesOfItemAtPath:f.path error:nil]);

	AZLOG([[AtoZ sharedInstance]instanceMethodNames]);
	TestStopwatchBlock(@"testTheWatch");
		NSArray *u = [NSArray arrayWithArrays: @[@[@"array1", @[@"array1level2"]],@[@"array2", @"array2item2"], @[@"array3"]]];
		AZLOG(	u );
		AZLOG([NSArray classMethods]);

		AZLOG([NSColor allColors]);
	[NSThread performBlock:^{
		[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSCopying)])];
	} afterDelay:2];
	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFileManagerDelegate)])];
	[AZTalker say:StringFromBOOL([AZDock conformsToProtocol:@protocol(NSFastEnumeration)])];
		AZLOG([AZAppFolder sharedInstance]);
		AZLOG([AZFile forAppNamed:@"/Applications/Safari.app"]);

	AZLOG([NSColor colorsInFrameworkListNamed:@"OrigamiMice"]);

	NSImage *web = [NSImage imageFromWebPageAtURL:[NSURL URLWithString:@"http://google.com"] encoding:NSUTF8StringEncoding];
	AZLOG(web);
	[paddy quantize];
		[[AZColor sharedInstance] colorsForImage:[NSImage az_imageNamed:@"mrgray.logo.png"]]);
	AZFile *s = [AZFile	instanceWithImage:[NSImage randomIcon]];
	AZLOG(s.propertiesPlease);
	[s.image saveAs:@"/Users/localadmin/Desktop/poops.png"];

	AZFile* dum = [AZFile dummy];
	AZLOG(dum.propertiesPlease);
	[dum.image saveAs:@"/Users/localadmin/Desktop/poop.png"];

	AZFile* ss = [AZFile instanceWithColor:RANDOMCOLOR];
	AZLOG(ss.propertiesPlease);
	[ss.image saveAs:@"/Users/localadmin/Desktop/poopss.png"];

	AZTalker *welcome = [AZTalker new];
	[welcome say:@"welcome"];

	[[AZTalker sharedInstance]say:@"huge vgaenn"];


	CGPoint a = AZAnchorPtAligned( AZPositionLeft);

	NSLog(@"%@", NSStringFromPoint(a));

		NSA* s  = [NSA arrayWithContentsOfFile:@"/Users/localadmin/Desktop/gists.plist"];
		NSBag *b = [s ojectsInSubdictionariesForKey:@"language"];
		AZLOG(b);
		
*/


/**

   @interface ExampleTest : GHTestCase { }
   @end

   @implementation ExampleTest

   - (BOOL)shouldRunOnMainThread {
                // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
                // Also an async test that calls back on the main thread, you'll probably want to return YES.
        return NO;
   }

   - (void) setUpClass {
                // Run at start of all tests in the class
   }

   - (void) tearDownClass {
                // Run at end of all tests in the class
   }

   - (void) setUp {
                // Run before each test method
   }

   - (void) tearDown {
                // Run after each test method
   }

   - (void) testFoo {
        NSString *a = @"foo";
        GHTestLog(@"I can log to the GHUnit test console: %@", a);

                // Assert a is not NULL, with no custom error description
        GHAssertNotNULL(a, nil);

                // Assert equal objects, add custom error description
        NSString *b = @"bar";
        GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
   }

   - (void) testBar {
                // Another test
   }

   @end
   #import <AtoZ/AtoZ.h>
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
                        GHTestApp *app = GHTestApp.new;
                                // To run a different test suite:
                                //GHTestSuite *suite = [GHTestSuite suiteWithTestFilter:@"GHSlowTest,GHAsyncTestCaseTest"];
                                //				GHTestApp *app = [GHTestApp.alloc initWithSuite:suite];
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
        NSUserDefaults *defaults = NSUserDefaults.new;
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

//int clear_console()	{    NSLog(@"\n\n\n\n\n\n\n\n");
/*	Then, when you want to clear the console just add a breakpoint before the NSLog with this condition:
		Condition: 1 > 0
		Action: Debugger Command expr (int) clear_console()
		Options: Automatically continue after evaluating Check it to skip the pause. */
//	return 0;
//}


