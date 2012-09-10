
//  AtoZ.h
//  AtoZ


/*  xcode shortcuts
  @property (nonatomic, assign) <\#type\#> <\#name\#>;
*/

#import "AtoZUmbrella.h"



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



