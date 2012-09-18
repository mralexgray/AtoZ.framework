
//  AtoZ.h
//  AtoZ


/*  xcode shortcuts
  @property (nonatomic, assign) <\#type\#> <\#name\#>;
*/

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AppKit/AppKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <xpc/xpc.h>

#import	"BaseModel.h"
#import	"AtoZumbrella.h"
#import	"AZGeometry.h"
#import "AZGeometricFunctions.h"


#import <AtoZ/AtoZFunctions.h>
#import <AtoZ/AtoZModels.h>


#import <AtoZ/BaseModel.h>
#import <AtoZ/NSBag.h>

#import "BlocksAdditions.h"
#import "SMModelObject.h"
#import "AZSimpleView.h"
#import "AZSizer.h"

#import "CALayer+AtoZ.h"
#import "AZMouser.h"
#import "iCarousel.h"
//#import "azCarousel.h"


// Categories
#import "NSFileManager+AtoZ.h"
#import "NSBundle+AtoZ.h"
#import "NSThread+AtoZ.h"
#import "NSNotificationCenter+AtoZ.h"
#import "NSApplication+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSArray+AtoZ.h"
#import "NSString+AtoZ.h"
#import "NSView+AtoZ.h"
#import "NSBezierPath+AtoZ.h"
#import "NSImage+AtoZ.h"
#import "NSWindow+AtoZ.h"
#import "NSShadow+AtoZ.h"
#import "NSNumber+AtoZ.h"
#import "CAAnimation+AtoZ.h"
#import "NSScreen+AtoZ.h"
#import "NSObject+AtoZ.h"
#import "AZNotificationCenter.h"
#import "NSWindow_Flipr.h"
#import "NSLogConsole.h"
#import "AZLaunchServices.h"
#import "AZObject.h"
#import "AZLassoView.h"
#import "AZBackground.h"
#import "AZDarkButtonCell.h"
#import "AZTrackingWindow.h"
#import "AZCSSColors.h"
//#import "MondoSwitch.h"
#import "AZToggleArrayView.h"
//#import "AZToggleView.h"

//Classes
#import "AZSegmentedRect.h"
#import "AZWindowExtend.h"
#import "AZQueue.h"
#import "AZDockQuery.h"
#import "AZAXAuthorization.h"

// Views
#import "AZFoamView.h"
#import "AZBlockView.h"
#import "AZProgressIndicator.h"
#import "AZPopupWindow.h"
#import "AZIndeterminateIndicator.h"
#import "AZAttachedWindow.h"
#import "AZStopwatch.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZInfiniteCell.h"
#import "AZSourceList.h"
#import "AZTalker.h"
#import "AZBoxLayer.h"
#import "AZOverlay.h"
#import "AtoZInfinity.h"
#import "AZFileGridView.h"
#import "AZApplePrivate.h"
#import "RuntimeReporter.h"
#import "AZBackgroundProgressBar.h"
#import "F.h"
#import "NSArray+F.h"
#import "NSDictionary+F.h"
#import "NSNumber+F.h"

#import "LoremIpsum.h"
#import "AZVeil.h"
#import "NotificationCenterSpy.h"
#import "TransparentWindow.h"
#import <BlocksKit/BlocksKit.h>

//static NSEventMask AZMouseActive = NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask;

CGFloat ScreenWidess();
CGFloat ScreenHighness();

@interface NSObject (debugandreturn)
- (id) debugReturn:(id) val;
@end

static double frandom(double start, double end);

//	#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...);
	//extern
void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);


void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications);




extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;

@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end

@interface AZDummy : NSObject
@end

@class NSLogConsole;
@interface AtoZ : BaseModel

+ (NSString*) resources;
+ (NSArray*) appFolderSamplerWith:(NSUInteger)apps;


#ifdef GROWL_ENABLED
<GrowlApplicationBridgeDelegate>
#endif

+ (NSArray*) dock;
+ (NSArray*) dockSorted;
+ (NSArray*) currentScope;
+ (NSArray*) fengShui;
+ (NSArray*) runningApps;
+ (NSArray*) runningAppsAsStrings;
+ (NSArray*) appFolder;
+ (NSArray*) appFolderSorted;


@property (nonatomic, retain) NSBundle *bundle;

+ (NSString*)stringForType:(id)type;
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl;
#endif

+ (NSArray*)appCategories;

//- (id)objectForKeyedSubscript:(NSString *)key;
//- (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key;

+ (NSFont*) fontWithSize:(CGFloat)fontSize;
- (NSJSONSerialization*) jsonReuest:(NSString*)url;
+ (NSJSONSerialization*) jsonReuest:(NSString*)url;
//+ (instancetype) sharedInstance;

//- (NSArray*) dock;
//- (NSArray*) dockSorted;
//- (NSArray*) dockOutline;

- (void) handleMouseEvent:(NSEventMask)event inView:(NSView*)view withBlock:(void (^)())block;
//@property (strong, nonatomic) NSLogConsole *console;

//- (void)performBlock:(void (^)())block;
//- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;



@end

@interface AtoZ (MiscFunctions)

+ (CGFloat)clamp:(CGFloat)value from:(CGFloat)minimum to:(CGFloat)maximum;
+ (CGFloat)scaleForSize:(CGSize)size inRect:(CGRect)rect;
+ (CGRect)centerSize:(CGSize)size inRect:(CGRect)rect;
+ (CGPoint)centerOfRect:(CGRect)rect;
+ (NSRect)rectFromPointA:(NSPoint)pointA andPointB:(NSPoint)pointB;
+ (void) printRect:(NSRect)toPrint;
+ (void) printCGRect:(CGRect)cgRect;
+ (void) printPoint:(NSPoint)toPrint;
+ (void) printCGPoint:(CGPoint)cgPoint;
+ (void) printTransform:(CGAffineTransform)t;

+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect;

@end

//
//@implementation  NSArray (SubscriptsAdd)
//- (id)objectAtIndexedSubscript:(NSUInteger)index {
//	return [self objectAtIndex:index];
//}
//@end
//
//@implementation NSMutableArray (SubscriptsAdd)
//- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
//	if (index < self.count){
//		if (object)
//			[self replaceObjectAtIndex:index withObject:object];
//		else
//			[self removeObjectAtIndex:index];
//	} else {
//		[self addObject:object];
//	}
//}
//@end
//@implementation NSDictionary (SubscriptsAdd)
//- (id)objectForKeyedSubscript:(id)key {
//	return [self objectForKey:key];
//}
//@end
//@implementation NSMutableDictionary (SubscriptsAdd)
//- (void)setObject:(id)object forKeyedSubscript:(id)key {
//	[self setObject:object forKey:key];
//}
//@end



@interface Box : NSView
@property (assign) BOOL selected;
@property (copy, readwrite) CAShapeLayer *shapeLayer;
@property (copy, readwrite) NSColor *save;
@property (copy, readwrite) NSColor *color;
@end


@interface CALayer (AGFlip)
- (void) flipOver;
@end

@interface CAAnimation (NSViewFlipper)
+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)duration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor;
@end

@interface NSView (NSViewFlipper)
-(CALayer *)layerFromContents;
@end

@interface NSViewFlipperController : NSObject {
	NSView *hostView, *frontView, *backView;
    NSView *topView, *bottomView;
    CALayer *topLayer, *bottomLayer;
    BOOL isFlipped;
    NSTimeInterval duration;
}
@property (readonly) BOOL isFlipped;
@property NSTimeInterval duration;
@property (weak, readonly) NSView *visibleView;
-(id)initWithHostView:(NSView *)newHost frontView:(NSView *)newFrontView backView:(NSView *)newBackView;
//-(IBAction)flip:(id)sender;
-(void)flip;
@end



@interface  NSWindow (Borderless)
+ (NSWindow*) borderlessWindowWithContentRect: (NSRect)aRect;
@end


//static void glossInterpolation(void *info, const float *input);
//							   float *output);

static void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);

//static void glossInterpolation(void *info, const CGFloat *input);

void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents);
extern void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect);

extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center);




/** The appledoc application handler.

 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:

 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class.
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.

 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.
 */


// usage
// profile("Long Task", ^{ performLongTask() } );

void profile (const char *name, void (^work) (void));



@interface CAConstraint (brevity)

//+(CAConstraint*)maxX;

//#define maxY = AZConstraint(kCAConstraintMaxY,@"superlayer");
//#define superWide = AZConstraint(kCAConstraintWidth,@"superlayer");
//#define superHigh = AZConstraint(kCAConstraintHeight,@"superlayer");

@end

@interface CALayerNoHit : CALayer
@end
@interface CAShapeLayerNoHit : CAShapeLayer
@end
@interface CATextLayerNoHit : CATextLayer
@end


#define XCODE_COLORS 0

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

