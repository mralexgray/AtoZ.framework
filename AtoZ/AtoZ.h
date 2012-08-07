//
//  AtoZ.h
//  AtoZ
//

#import "AtoZUmbrella.h"



CGFloat ScreenWidess();
CGFloat ScreenHighness();

extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;



@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end

typedef enum {
	AZDockSortNatural,
	AZDockSortColor,
	AZDockSortPoint,
	AZDockSortPointNew,
}	AZDockSort;

@class NSLogConsole;
@interface AtoZ : BaseModel
+ (NSArray*) selectedDock;
+ (AtoZ*) sharedInstance;
+ (NSArray*) dock;
//- (NSArray*) dockSorted;
+ (NSArray*) dockSorted;
+ (NSArray*) fengshui;
+ (NSArray*) runningApps;
+ (NSArray*) runningAppsAsStrings;
+ (NSArray*) appFolder;
+ (NSArray*) appFolderSorted;
@property (assign) AZDockSort sortOrder;
@property (nonatomic, retain) NSArray *dock;
@property (nonatomic, retain) NSArray *dockSorted;
- (void) handleMouseEvent:(NSEventMask)event inView:(NSView*)view withBlock:(void (^)())block;
@property (strong, nonatomic) NSLogConsole *console;

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
@end

extern NSString *const AtoZFileUpdated;
//@class AJSiTunesResult;
@interface AZFile : BaseModel
@property (strong, nonatomic)	NSString *itunesDescription;
//@property (strong, nonatomic)	AJSiTunesResult *itunesInfo;
@property (strong, nonatomic)	NSString * 	path;
@property (strong, nonatomic)	NSString *	name;
@property (strong, nonatomic) 	NSColor	 * 	color;
@property (strong, nonatomic) 	NSColor	 * 	customColor;
@property (strong, nonatomic)	NSColor	 *	labelColor;
@property (strong, nonatomic)	NSNumber *	labelNumber;
@property (strong, nonatomic)  	NSArray	 * 	colors;
@property (strong, nonatomic)  	NSImage	 * 	icon;
@property (strong, nonatomic)  	NSImage	 * 	image;
@property (nonatomic, assign) 		CGPoint		dockPoint;
@property (nonatomic, assign) 		CGPoint		dockPointNew;
@property (nonatomic, assign) 		NSUInteger	spot;
@property (nonatomic, assign) 		NSUInteger 	spotNew;
@property (nonatomic, readonly)		CGFloat		hue;
@property (nonatomic, readonly)		BOOL		isRunning;
@property (nonatomic, readonly)		BOOL		hasLabel;
@property (nonatomic, assign)		BOOL		needsToMove;
+ (AZFile*) dummy;
+ (AZFile*) forAppNamed:(NSString*)appName;
+ (id)instanceWithPath:(NSString *)path;
+ (id) instanceWithColor:(NSColor*)color;

@end




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

//static void glossInterpolation(void *info, const float *input,
//							   float *output);
//void perceptualCausticColorForColor(float *inputComponents, float *outputComponents);
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

