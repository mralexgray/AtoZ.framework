
//  AtoZ.h
//  AtoZ


/*  xcode shortcuts
  @property (nonatomic, assign) <\#type\#> <\#name\#>;
*/


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIView NSView;
typedef CGSize NSSize;
typedef CGRect NSRect;
typedef UIColor NSColor;
#else
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import <XPCKit/XPCKit.h>
#import <xpc/xpc.h>
#import <XPCKit/XPCKit.h>
#import <xpc/xpc.h>



#define EXCLUDE_STUB_PROTOTYPES 1
#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>

//#define GROWL_ENABLED
//#include <Growl/Growl.h>

//#define ATOZITUNES_ENABLED
//#import <AtoZiTunes/AtoZiTunes.h>

#import <QSCore/QSCore.h>
#import <QSFoundation/QSFoundation.h>
#import <QSInterface/QSInterface.h>
#import <QSEffects/QSEffects.h>

#import <QSCore/QSCore.h>
#import "BlocksAdditions.h"
#import <BlocksKit/BlocksKit.h>

#import <Lumberjack/Lumberjack.h>

#include <AudioToolbox/AudioToolbox.h>
#import "AtoZUmbrella.h"
#import "AZGeometry.h"
#import "AZGeometricFunctions.h"


#import "BaseModel.h"
#import "SMModelObject.h"
#import "AZSimpleView.h"
#import "AZSizer.h"

//#import <AtoZiTunes/AtoZiTunes.h>
#import "CALayer+AtoZ.h"
#import "AZMouser.h"

#import "iCarousel.h"
//#import "azCarousel.h"


#import "AZVeil.h"

#import "NotificationCenterSpy.h"

#import "TransparentWindow.h"


// Categories
#import "NSFileManager+AtoZ.h"
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



static NSEventMask AZMouseActive = NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask;

CGFloat ScreenWidess();
CGFloat ScreenHighness();

extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;

@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end

@interface AZDummy : NSObject
@end

@class NSLogConsole;
@interface AtoZ : BaseModel



#ifdef GROWL_ENABLED
<GrowlApplicationBridgeDelegate>
#endif

@property (nonatomic, retain) NSBundle *bundle;

+ (NSString*)stringForType:(id)type;
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl;
#endif
#define kMaxFontSize    10000

+ (CGFloat)fontSizeForAreaSize:(NSSize)areaSize withString:(NSString *)stringToSize usingFont:(NSString *)fontName;

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

+ (NSArray*) dock;
+ (NSArray*) dockSorted;
//+ (NSArray*) dockOutline;
+ (NSArray*) currentScope;

+ (NSArray*) fengShui;

+ (NSArray*) runningApps;
+ (NSArray*) runningAppsAsStrings;
+ (NSArray*) appFolder;
+ (NSArray*) appFolderSorted;

@property (assign) AZDockSort sortOrder;
@property (nonatomic, retain) NSArray *dock;
@property (nonatomic, retain) NSArray *dockSorted;
@property (nonatomic, retain) NSArray *appCategories;
//@property (nonatomic, retain) NSArray *dockOutline;

@property (nonatomic, strong) NSArray *appFolderSorted;
@property (nonatomic, strong) NSArray *appFolder;
@property (nonatomic, strong) NSArray *appFolderStrings;

+ (NSArray*) appFolderSamplerWith:(NSUInteger)apps;

- (void) handleMouseEvent:(NSEventMask)event inView:(NSView*)view withBlock:(void (^)())block;
//@property (strong, nonatomic) NSLogConsole *console;

//- (void)performBlock:(void (^)())block;
//- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;

@end

@interface AZColor : BaseModel
@property (nonatomic, readonly) CGFloat 	brightness;
@property (nonatomic, readonly) CGFloat 	saturation;
@property (nonatomic, readonly) CGFloat 	hue;
@property (nonatomic, readonly) CGFloat 	hueComponent;

@property (nonatomic, assign)	float 		percent;
@property (nonatomic, assign) 	NSUInteger 	count;
@property (nonatomic, strong)	NSString 	* name;
@property (nonatomic, strong)	NSColor	 	* 	color;
+ (id) instanceWithObject: (NSDictionary *)dic;
-(NSArray*) colorsForImage:(NSImage*)image;
@end

extern NSString *const AtoZFileUpdated;
//@class AJSiTunesResult;
@interface AZFile : BaseModel
//@property (weak)	id itunesDescription;
//@property (weak)	id itunesResults;
@property (strong, nonatomic)	NSString *calulatedBundleID;

//@property (strong, nonatomic)	AJSiTunesResult *itunesInfo;
@property (strong, nonatomic)	NSString * 	path;
@property (strong, nonatomic)	NSString *	name;
@property (strong, nonatomic) 	NSColor	 * 	color;
@property (strong, nonatomic) 	NSColor	 * 	customColor;
@property (strong, nonatomic)	NSColor	 *	labelColor;
@property (assign, nonatomic)	NSNumber * 	labelNumber;
@property (strong, nonatomic)  	NSArray	 * 	colors;
@property (strong, nonatomic)  	NSImage	 * 	icon;
@property (strong, nonatomic)  	NSImage	 * 	image;
@property (nonatomic, assign) 	CGPoint		dockPoint;
@property (nonatomic, assign) 	CGPoint		dockPointNew;
@property (nonatomic, assign) 	NSUInteger	spot;
@property (nonatomic, assign) 	NSUInteger 	spotNew;
@property (nonatomic, readonly)	CGFloat		hue;
@property (nonatomic, readonly)	BOOL		isRunning;
@property (nonatomic, readonly)	BOOL		hasLabel;
@property (nonatomic, assign)	BOOL		needsToMove;

@property (nonatomic, assign)		AZWindowPosition		position;

+ (AZFile*) dummy;
+ (AZFile*) forAppNamed:(NSString*)appName;
+ (AZFile*) instanceWithPath:(NSString *)path;
+ (AZFile*) instanceWithColor:(NSColor*)color;
//+ (instancetype) instanceWithObject:(id)object;

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

@interface NSNumber (Incrementer)
- (NSNumber *)increment;
@end

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

@interface NSBag : NSObject {
	NSMutableDictionary *dict;
}
+ (NSBag *) bag;
+ (NSBag *) bagWithObjects: (id) anObject,...;
- (void) add: (id) anObject;
- (void) addObjects:(id)item,...;
- (void) remove: (id) anObject;
- (NSInteger) occurrencesOf: (id) anObject;
- (NSArray *) objects;
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



@interface NSObject (debugandreturn)
- (id) debugReturn:(id) val;
@end



static double frandom(double start, double end);





#import "AtoZ.h"


//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

#ifndef AZ_RETAIN
#if __has_feature(objc_arc)
#define AZ_RETAIN(x) (x)
#define AZ_RELEASE(x) (void)(x)
#define AZ_AUTORELEASE(x) (x)
#define AZ_SUPER_DEALLOC (void)(0)
#define __AZ_BRIDGE __bridge
#else
#define __AZ_WEAK
#define AZ_WEAK assign
#define AZ_RETAIN(x) [(x) retain]
#define AZ_RELEASE(x) [(x) release]
#define AZ_AUTORELEASE(x) [(x) autorelease]
#define AZ_SUPER_DEALLOC [super dealloc]
#define __AZ_BRIDGE
#endif
#endif

//  ARC Helper ends




#define AZRelease(value) \
if ( value ) { \
//[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
//[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;



CGFloat DegreesToRadians(CGFloat degrees);
NSNumber* DegreesToNumber(CGFloat degrees);

#define AZVpoint(p) [NSValue valueWithPoint:p]
#define AZVrect(r)  [NSValue valueWithRect:r]
#define AZVsize(s)  [NSValue valueWithSize:s]
#define AZV3dT(t)   [NSValue valueWithCATransform3D:t]

//extern NSString *const AtoZSuperLayer;
#define AZSuperLayerSuper (@"superlayer")


#define AZConstraint(attr, rel) \
[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]

//extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
//[NSArray arrayWithArray:@[
//AZConstRelSuper( kCAConstraintMaxX ),
//AZConstRelSuper( kCAConstraintMinX ),
//AZConstRelSuper( kCAConstraintWidth),
//AZConstRelSuper( kCAConstraintMinY ),
//AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

//#define AZConstraint(attr, rel) \
//[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]


//@property (nonatomic, assign) <\#type\#> <\#name\#>;
// AZConst(<\#CAConstraintAttribute\#>, <#\NSString\#>);
// AZConst(<#CAConstraintAttribute#>, <#NSString*#>);

#define AZConst(attr, rel) \
[CAConstraint constraintWithAttribute:attr relativeTo: rel attribute: attr]

#define AZConstScaleOff(attr, rel, scl, off) \
[CAConstraint constraintWithAttribute:attr relativeTo:rel attribute:attr scale:scl offset:off]

#define AZConstRelSuper(attr) \
[CAConstraint constraintWithAttribute:attr relativeTo:AZSuperLayerSuper attribute:attr]

#define AZConstRelSuperScaleOff(attr, scl, off) \
[CAConstraint constraintWithAttribute:attr relativeTo:AZSuperLayerSuper attribute:attr scale:scl offset:off]

#define AZConstAttrRelNameAttrScaleOff(attr1, relName, attr2, scl, off) \
[CAConstraint constraintWithAttribute:attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]

#define AZTArea(frame) \
[[NSTrackingArea alloc] initWithRect:frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:nil]




#define AZTAreaInfo(frame, info) \
[[NSTrackingArea alloc] initWithRect: frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:info];

#define AZBezPath(rect) [NSBezierPath bezierPathWithRect:rect]
#define AZQtzPath(rect) [[NSBezierPath bezierPathWithRect:rect]quartzPath]
#define AZContentBounds [[[self window]contentView]bounds]

//#define AZTransition(duration, type, subtype) CATransition *transition = [CATransition animation];
//[transition setDuration:1.0];
//[transition setType:kCATransitionPush];
//[transition setSubtype:kCATransitionFromLeft];


//#import "AtoZiTunes.h"

// Sweetness vs. longwindedness

#define $point(A)       	[NSValue valueWithPoint:A]

#define $points(A,B)       	[NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)    	[NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define ptmake(A,B)			CGPointMake(A,B)
#define $(...)        		((NSString *)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $array(...)  		((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)    	 	((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)     		((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)       		[NSNumber numberWithInt:(A)]
#define $ints(...)    		[NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)     		[NSNumber numberWithFloat:(A)]
#define $doubles(...) 		[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   		[[@#__VA_ARGS__ splitByComma] trimmedStrings]
#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) \
+(NSSet *)keyPathsForValuesAffecting##A { \
static NSSet *re = nil; \
if (!re) { \
re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; \
} \
return re;\
}

#define foreach(B,A) A.andExecuteEnumeratorBlock = \
^(B, NSUInteger A##Index, BOOL *A##StopBlock)

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock = \
//  ^(B, NSUInteger C, BOOL *A##StopBlock)

#define AZBONK @throw \
[NSException \
exceptionWithName:@"WriteThisMethod" \
reason:@"You did not write this method, yet!" \
userInfo:nil]

#define GENERATE_SINGLETON(SC) \
static SC * SC##_sharedInstance = nil; \
+(SC *)sharedInstance { \
if (! SC##_sharedInstance) { \
SC##_sharedInstance = [[SC alloc] init]; \
} \
return SC##_sharedInstance; \
}



#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))


#define RED				[NSColor colorWithCalibratedRed:0.797 green:0.000 blue:0.043 alpha:1.000]
#define ORANGE			[NSColor colorWithCalibratedRed:0.888 green:0.492 blue:0.000 alpha:1.000]
#define YELLOw			[NSColor colorWithCalibratedRed:0.830 green:0.801 blue:0.277 alpha:1.000]
#define GREEN			[NSColor colorWithCalibratedRed:0.367 green:0.583 blue:0.179 alpha:1.000]
#define BLUE			[NSColor colorWithCalibratedRed:0.267 green:0.683 blue:0.979 alpha:1.000]
#define BLACK			[NSColor blackColor]
#define GREY			[NSColor grayColor]
#define WHITE			[NSColor whiteColor]
#define RANDOMCOLOR		[NSColor randomColor]
#define CLEAR			[NSColor clearColor]
#define PURPLE 			[NSColor colorWithCalibratedRed:0.617 green:0.125 blue:0.628 alpha:1.000]
#define LGRAY			[NSColor colorWithCalibratedWhite:.5 alpha:.6]
#define GRAY1			[NSColor colorWithCalibratedWhite:.1 alpha:1]
#define GRAY2			[NSColor colorWithCalibratedWhite:.2 alpha:1]
#define GRAY3			[NSColor colorWithCalibratedWhite:.3 alpha:1]
#define GRAY4			[NSColor colorWithCalibratedWhite:.4 alpha:1]
#define GRAY5			[NSColor colorWithCalibratedWhite:.5 alpha:1]
#define GRAY6			[NSColor colorWithCalibratedWhite:.6 alpha:1]
#define GRAY7			[NSColor colorWithCalibratedWhite:.7 alpha:1]
#define GRAY8			[NSColor colorWithCalibratedWhite:.8 alpha:1]
#define GRAY9			[NSColor colorWithCalibratedWhite:.9 alpha:1]

#define cgRED			[RED 		CGColor]
#define cgORANGE		[ORANGE 	CGColor]
#define cgYELLOW		[YELLOW		CGColor]
#define cgGREEN			[GREEN		CGColor]
#define cgPURPLE		[PURPLE		CGColor]

#define cgBLUE			[[NSColor blueColor]	CGColor]
#define cgBLACK			[[NSColor blackColor]	CGColor]
#define cgGREY			[[NSColor grayColor]	CGColor]
#define cgWHITE			[[NSColor whiteColor]	CGColor]
#define cgRANDOMCOLOR	[RANDOMCOLOR	CGColor]
#define cgCLEARCOLOR	[[NSColor clearColor]	CGColor]


#define kBlackColor [[NSColor blackColor]	CGColor]
#define kWhiteColor [[NSColor whiteColor]	CGColor]
#define kTranslucentGrayColor CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.5, 1.0})
#define kTranslucentLightGrayColor cgGREY
#define	kAlmostInvisibleWhiteColor CGColorCreate( kCGColorSpaceGenericGray, {1, 0.05, 1.0})
#define kHighlightColor [[NSColor randomColor] CGColor]
#define kRedColor [[NSColor redColor]	CGColor]
#define kLightBlueColor [[NSColor blueColor]	CGColor]


// random macros utilizing arc4random()

#define RAND_UINT_MAX		0xFFFFFFFF
#define RAND_INT_MAX		0x7FFFFFFF

// RAND_UINT() positive unsigned integer from 0 to RAND_UINT_MAX
// RAND_INT() positive integer from 0 to RAND_INT_MAX
// RAND_INT_VAL(a,b) integer on the interval [a,b] (includes a and b)
#define RAND_UINT()				arc4random()
#define RAND_INT()				((int)(arc4random() & 0x7FFFFFFF))
#define RAND_INT_VAL(a,b)		((arc4random() % ((b)-(a)+1)) + (a))

// RAND_FLOAT() float between 0 and 1 (including 0 and 1)
// RAND_FLOAT_VAL(a,b) float between a and b (including a and b)
#define RAND_FLOAT()			(((float)arc4random()) / RAND_UINT_MAX)
#define RAND_FLOAT_VAL(a,b)		(((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// note: Random doubles will contain more precision than floats, but will NOT utilize the
//        full precision of the double. They are still limited to the 32-bit precision of arc4random
// RAND_DOUBLE() double between 0 and 1 (including 0 and 1)
// RAND_DOUBLE_VAL(a,b) double between a and b (including a and b)
#define RAND_DOUBLE()			(((double)arc4random()) / RAND_UINT_MAX)
#define RAND_DOUBLE_VAL(a,b)	(((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))

// RAND_BOOL() a random boolean (0 or 1)
// RAND_DIRECTION() -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)
#define RAND_BOOL()				(arc4random() & 1)
#define RAND_DIRECTION()		(RAND_BOOL() ? 1 : -1)


#define NEG(a)	-a



//CGFloat DEGREEtoRADIAN(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RADIANtoDEGREEES(CGFloat radians) {return radians * 180 / M_PI;};

CGImageRef ApplyQuartzComposition(const char* compositionName, const CGImageRef srcImage);

static inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }

#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))

//#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//#define NSLog(args...) _AZLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
//void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);

//BOOL flag = YES;
//NSLog(flag ? @"Yes" : @"No");
//?: is the ternary conditional operator of the form:
//condition ? result_if_true : result_if_false
#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")
#define YESNO(b) ((b) ? @"YES" : @"NO")


#define LogProps(a) NSLog(@"%@", a.propertiesPlease)
#define logprop(a) NSLog(@"%@", [a propertiesPlease])
//#define logobj(a) id logit = a \	     NSLog(@"%@", a)
#define desc(a) NSLog(@"%@", [a description])



// degree to radians
#define ARAD	 0.017453f
#define DEG2RAD(x) ((x) * ARAD)
#define RAD2DEG(rad) (rad * 180.0f / M_PI)

//returns float in range 0 - 1.0f
//usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero
#define RAND01() ((random() / (float)0x7fffffff ))

	//	#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...);
//extern
void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);


void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications);

@class AZTrackingWindow;
@interface AtoZ (Animations)

+ (CAAnimation *) animationForOpacity;
+ (CAAnimation *) animateionForScale;
+ (CAAnimation *) animationForRotation;

+ (void) flipDown:(AZTrackingWindow*)window;

+ (void) shakeWindow:(NSWindow*)window;

@end




#endif
