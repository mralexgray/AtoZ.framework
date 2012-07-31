//
//  AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

/** The appledoc application handler.
 
 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:
 
 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class. 
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.
 */

//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#define __AH_BRIDGE __bridge
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#define __AH_BRIDGE
#endif
#endif

//  ARC Helper ends

#import "AZSugar.h"
#import "MondoSwitch.h"
#import "AZToggle.h"
//#import "AZToggleView.h"

//Classes

#import "AZQueue.h"
//#import "FSItem.h"
#import "AZAXAuthorization.h"
#import "AZDockQuery.h"

// Controllers
//#import "AZMenuBarAppController.h"

// Views
#import "AZFoamView.h"
#import "AZBlockView.h"
#import "AZProgressIndicator.h"
#import "AZPopupWindow.h"
#import "AZIndeterminateIndicator.h"
#import "AZAttachedWindow.h"

// Categories
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
#import "CALayer+AtoZ.h"
#import "NSScreen+AtoZ.h"
#import "NSObject+AtoZ.h"

#import "AZGeometry.h"
#import "NSWindow_Flipr.h"


#import "TransparentWindow.h"
#import "RoundedView.h"

#import "AZStopwatch.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "BaseModel.h"
//#import "NSObject+AutoCoding.h"

#import "AZSizer.h"
#import "AZApplePrivate.h"
#import "AZInfiniteCell.h"



#import "AZSourceList.h"
#import "AZTalker.h"
#import "AZBoxLayer.h"
#import "AZOverlay.h"
#import "AZSimpleView.h"
#import "AtoZInfinity.h"

//#import "AtoZInfintieScroll.h"

CGFloat DegreesToRadians(CGFloat degrees);
NSNumber* DegreesToNumber(CGFloat degrees);


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

#define AZRelease(value) \
if ( value ) { \
//[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
//[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;


#define AZConstraint(attr, rel) \
[CAConstraint constraintWithAttribute:attr relativeTo:rel attribute:attr]

#define AZConst(attr, rel) \
[CAConstraint constraintWithAttribute:attr relativeTo:rel attribute:attr]

#define AZConstScaleOff(attr, rel, scl, off) \
[CAConstraint constraintWithAttribute:attr relativeTo:rel attribute:attr scale:scl offset:off]

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



extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;

@interface AtoZ : BaseModel
+ (AtoZ*) sharedInstance;
+ (NSArray*) dock;
//- (NSArray*) dockSorted;
+ (NSArray*) dockSorted;
+ (NSArray*) fengshui;
+ (NSArray*) runningApps;
+ (NSArray*) appFolder;
+ (NSArray*) appFolderSorted;
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

@interface AZFile : BaseModel

@property (strong, nonatomic)	NSString * 	path;
@property (strong, nonatomic)	NSString *	name;
@property (strong, nonatomic) 	NSColor	 * 	color;
@property (strong, nonatomic) 	NSColor	 * 	customColor;
@property (strong, nonatomic)	NSColor	 *	labelColor;
@property (strong, nonatomic)	NSNumber *	labelNumber;
@property (strong, nonatomic)  	NSArray	 * 	colors;
@property (strong, nonatomic)  	NSImage	 * 	icon;
@property (strong, nonatomic)  	NSImage	 * 	image;
@property (nonatomic, assign) 		NSPoint		dockPoint;
@property (nonatomic, assign) 		NSPoint		dockPointNew;
@property (nonatomic, assign) 		NSUInteger	spot;
@property (nonatomic, assign) 		NSUInteger 	spotNew;
@property (nonatomic, readonly)		CGFloat		hue;
@property (nonatomic, readonly)		BOOL		isRunning;
@property (nonatomic, readonly)		BOOL		hasLabel;
@property (nonatomic, assign)		BOOL		needsToMove;
+ (AZFile*) dummy;
+ (id)instanceWithPath:(NSString *)path;
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
