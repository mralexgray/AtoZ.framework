#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#include <pwd.h>
#include <sys/types.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <unistd.h>
#import <libkern/OSAtomic.h>
#import <sys/time.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <dirent.h>
#import <xpc/xpc.h>
#import <Python/Python.h>
#import <Security/Security.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreServices/CoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

#ifndef DSFavIcon_UINSImage_h
	#define DSFavIcon_UINSImage_h
	#if TARGET_OS_IPHONE
		#import <UIKit/UIKit.h>
		#define UINSImage   UIImage
		#define UINSScreen  UIScreen
	#else
		#import <Cocoa/Cocoa.h>
		#define UINSImage   NSImage
		#define UINSScreen  NSScreen
	#endif
#endif

//#pragma GCC diagnostic ignored "-Wformat-security"
//#import <NanoStore/NSFNanoObjectProtocol.h>
//#import <NanoStore/NSFNanoObject.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <NanoStore/NSFNanoStore.h>
//#import <NanoStore/NSFNanoPredicate.h>
//#import <NanoStore/NSFNanoExpression.h>
//#import <NanoStore/NSFNanoSearch.h>
//#import <NanoStore/NSFNanoSortDescriptor.h>
//#import <NanoStore/NSFNanoResult.h>
//#import <NanoStore/NSFNanoBag.h>
//#import <NanoStore/NSFNanoEngine.h>
//#import <NanoStore/NSFNanoGlobals.h>
//#import <Growl/Growl.h>
//#import "Nu.h"

// ARC is compatible with iOS 4.0 upwards, but you need at least Xcode 4.2 with Clang LLVM 3.0 to compile it.
//#if !__has_feature(objc_arc)
//#error This project must be compiled with ARC (Xcode 4.2+ with LLVM 3.0 and above)
//#endif


//#define EXCLUDE_STUB_PROTOTYPES 1
//#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>

#import <BlocksKit/BlocksKit.h>
#import <CocoaPuffs/CocoaPuffs.h>
#import <CocoatechCore/CocoatechCore.h>
#import <DrawKit/DKDrawKit.h>
#import <FunSize/FunSize.h>
#import <Lumberjack/Lumberjack.h>
#import <KSHTMLWriterFramework/KSHTMLWriterFramework.h>
#import <MapKit/MapKit.h>
#import <NoodleKit/NoodleKit.h>
//#import <Nu/Nu.h>
#import <PhFacebook/PhFacebook.h>
#import <Rebel/Rebel.h>

#import <TwUI/TUIKit.h>
#import <Zangetsu/Zangetsu.h>

#import <AtoZBezierPath/AtoZBezierPath.h>
#import <AtoZAppKit/BGHUDAppKit.h>

#import "AtoZUmbrella.h"

//#import <AtoZUI/AtoZUI.h>
//#import <RMKit/RMKit.h>
//#import <NanoStore/NanoStore.h>
//#import <KSHTMLWriterFramework/KS>
//#import <MapKit/MapKit.h>
//#import <XPCKit/XPCKit.h>
//#import <Zangetsu/Zangetsu.h>


//typedef void(^log)(NSS*s);

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;



/* ESSENTIAL */
#import "F.h"
#import "NSBag.h"
#import "NSArray+F.h"
#import "NSNumber+F.h"
#import "NSDictionary+F.h"
#import "NSOperationStack.h"

#import "AZStopwatch.h"
#import "ConciseKit.h"
#import "NSArray+AtoZ.h"
#import "AtoZUmbrella.h"
#import "AtoZGeometry.h"
#import "AtoZFunctions.h"

/* MODEL */
#import "JsonElement.h"
#import "AutoCoding.h"
#import "HRCoder.h"
#import "BaseModel.h"


#import "SDToolkit.h"

#import "MAKVONotificationCenter.h"
#import "AZHTTPURLProtocol.h"
#import "BlocksAdditions.h"

#import "PythonOperation.h"

#import "NotificationCenterSpy.h"
#import "TransparentWindow.h"
#import "LoremIpsum.h"
#import "AFNetworking.h"



//#import <RoutingHTTPServer/RoutingHTTPServer.h>

#import "Bootstrap.h"

/*  FACEBOOK	*/
#import "AssetCollection.h"
#import "AZHTTPRouter.h"
#import "AZFacebookConnection.h"

#import "GCDAsyncSocket.h"
#import "HTTPServer.h"
#import "HTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPResponse.h"
#import "HTTPAuthenticationRequest.h"
#import "DDNumber.h"
#import "DDRange.h"
#import "DDData.h"
#import "HTTPFileResponse.h"
#import "HTTPAsyncFileResponse.h"
#import "WebSocket.h"
#import "HTTPLogging.h"

//   CORE


#import "CAScrollView.h"
#import "AssetCollection.h"
#import "AZSpeechRecognition.h"

// END CORE

#import "AZTalker.h"
#import "SynthesizeSingleton.h"
#import "iCarousel.h"
//#import "azCarousel.h"

#import "CTGradient.h"
#import "AZApplePrivate.h"
#import "RuntimeReporter.h"
#import "CTBadge.h"

#import "AZBackgroundProgressBar.h"

//	#import "AZPalette.h"
//	#import "AZObject.h"
//	#import "AZFile.h"
//	#import "AtoZModels.h"
//	#import "AZObject.h"
//	#import "AtoZModels.h"

/* STACKEXCHANGE */
#import "SIConstants.h"
#import "SIAppCookieJar.h"
#import "NSHTTPCookie+Testing.h"
#import "SIWindow.h"
#import "SIInboxDownloader.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "SIInboxModel.h"
#import "SIAuthController.h"
#import "SIViewControllers.h"
//#import "DSURLDataSource.h"
//#import "CKSingleton.h"

#import "AtoZGridView.h"
#import "AtoZGridViewProtocols.h"
#import "AtoZColorWell.h"

#import "AZCalculatorController.h"

#import "AZLayer.h"
#import "AZASIMGV.h"

#import "AZSizer.h"
#import "AZMouser.h"
#import "AtoZModels.h"
#import "KGNoise.h"


/* FOUNDATION  CATEGORIES */
#import "NSBundle+AtoZ.h"
#import "NSDictionary+AtoZ.h"
#import "NSFileManager+AtoZ.h"
#import "NSImage+AtoZ.h"
#import "NSImage-Tint.h"
#import "NSIndexSet+AtoZ.h"
#import "NSNotificationCenter+AtoZ.h"
#import "NSNumber+AtoZ.h"
#import "NSObject-Utilities.h"
#import "NSObject+AtoZ.h"
#import "NSObject+Properties.h"
#import "NSScreen+AtoZ.h"
#import "NSString+AtoZ.h"
#import "NSThread+AtoZ.h"
#import "NSUserDefaults+Subscript.h"
#import "NSValue+AtoZ.h"
//#import "NSManagedObjectContext+EasyFetch.h"
//#import "NSUserDefaults+AtoZ.h"

/* COCOA CATEGORIES	*/
#import "NSDate+AtoZ.h"
#import "NSFont+AtoZ.h"
#import "NSOutlineView+AtoZ.h"
#import "NSTask+OneLineTasksWithOutput.h"
#import "NSEvent+AtoZ.h"
#import "CAAnimation+AtoZ.h"
#import "CALayer+AtoZ.h"
#import "NSApplication+AtoZ.h"
#import "NSURL+AtoZ.h"
#import "NSCell+AtoZ.h"
#import "NSBezierPath+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSShadow+AtoZ.h"
#import "NSView+AtoZ.h"
#import "NSWindow+AtoZ.h"
#import "NSTableView+AtoZ.h"

//#import "MondoSwitch.h"
//#import "AZToggleView.h"

/* FOUNDATION CLASSES */
#import "NSOrderedDictionary.h"
#import "AZWeakCollections.h"


/*	COLOR AND IMAGE CLASSES */

#import "AZSimpleView.h"

//Classes
#import "AZHomeBrew.h"
#import "AZDebugLayer.h"
#import "AZInstantApp.h"
#import "AddressBookImageLoader.h"
#import "AZHostView.h"
#import "AZSegmentedRect.h"
#import "AZFavIconManager.h"
#import "AZQueue.h"
#import "AZDockQuery.h"
#import "AZAXAuthorization.h"
//#import "AZNotificationCenter.h"
#import "NSLogConsole.h"
#import "AZLaunchServices.h"
#import "AZLassoView.h"
#import "AZBackground.h"
#import "AZCSSColors.h"
#import "AZSound.h"
#import "Transition.h"
#import "LetterView.h"
#import "CPAccelerationTimer.h"
#import "StandardPaths.h"

/* CONTROLS */
#import "AZToggleArrayView.h"
#import "AZDarkButtonCell.h"
//#import "SNRHUDKit.h"
#import "SNRHUDButtonCell.h"
#import "SNRHUDImageCell.h"
#import "SNRHUDScrollView.h"
#import "SNRHUDSegmentedCell.h"
#import "SNRHUDTextFieldCell.h"
#import "SNRHUDTextView.h"
#import "SNRHUDWindow.h"



/* WINDOWS */
#import "AZAttachedWindow.h"
#import "AZBorderlessResizeWindow.h"
#import "AZSemiResponderWindow.h"
#import "AZTrackingWindow.h"
#import "AZWindowExtend.h"
#import "CAWindow.h"
#import "MAAttachedWindow.h"
#import "NSWindow_Flipr.h"


/* CoreScroll */
#import "AZCoreScrollView.h"
#import "AZTimeLineLayout.h"
#import "AZScrollPaneLayer.h"
#import "AZScrollerLayer.h"
#import "WebView+AtoZ.h"
// #import "AZSnapShotLayer.h"

#import "AtoZWebSnapper.h"
#import "AZURLSnapshot.h"
#import "AZHTMLParser.h"
//#import "HTMLNode.h"

// Views
#import "AtoZInfinity.h"
#import "AZBlockView.h"
#import "AZIndeterminateIndicator.h"
#import "AZLassoLayer.h"
#import "AZLassoView.h"
#import "AZFoamView.h"
#import "AZMedallionView.h"
#import "AZPopupWindow.h"
#import "AZPrismView.h"
#import "AZPropellerView.h"
#import "AZProgressIndicator.h"
#import "AZSimpleView.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZInfiniteCell.h"
#import "AZSourceList.h"
#import "BBMeshView.h"
#import "CalcModel.h"
#import "NSTextView+AtoZ.h"
#import "StarLayer.h"
#import "NSSplitView+DMAdditions.h"
#import "XLDragDropView.h"


#import "AZVeil.h"

#import "PXListView.h"
#import "PXListViewCell.h"
#import "PXListDocumentView.h"

// TwUI
#import "TUIView+Dimensions.h"
#import "AHLayout.h"
#import "AZExpandableView.h"

// COREDATA
#import "AZImageToDataTransformer.h"

// UNUSED
//#import "AZFileGridView.h"
//#import "AZBoxLayer.h"
//#import "AZOverlay.h"

/*  xcode shortcuts  @property (nonatomic, assign) <\#type\#> <\#name\#>;	*/


/*  http://stackoverflow.com/questions/4224495/using-an-nsstring-in-a-switch-statement
 You can use it as

 FilterBlock fb1 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"YES"]) { NSLog(@"You did it");  *stop = YES;} return element;};
 FilterBlock fb2 = ^id(id element, NSUInteger idx, BOOL *stop){ if ([element isEqualToString:@"NO"] ) { NSLog(@"Nope");		*stop = YES;} return element;};

 NSArray *filter = @[ fb1, fb2 ];
 NSArray *inputArray = @[@"NO",@"YES"];

 [inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 [obj processByPerformingFilterBlocks:filter];
 }];
 but you can also do more complicated stuff, like aplied chianed calculations:

 FilterBlock b1 = ^id(id element,NSUInteger idx, BOOL *stop) {return [NSNumber numberWithInteger:[(NSNumber *)element integerValue] *2 ];};
 FilterBlock b2 = ^id(NSNumber* element,NSUInteger idx, BOOL *stop) {
 *stop = YES;
 return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];
 };
 FilterBlock b3 = ^id(NSNumber* element, NSUInteger idx,BOOL *stop) {return [NSNumber numberWithInteger:[element integerValue]*[element integerValue]];};

 NSArray *filterBlocks = @[b1,b2, b3, b3, b3];
 NSNumber *numberTwo = [NSNumber numberWithInteger:2];
 NSNumber *numberTwoResult = [numberTwo processByPerformingFilterBlocks:filterBlocks];
 NSLog(@"%@ %@", numberTwo, numberTwoResult);
 */

typedef id(^FilterBlock)(id element,NSUInteger idx, BOOL *stop);

@interface NSObject (AZFunctional)
-(id)processByPerformingFilterBlocks:(NSArray *)filterBlocks;
@end

//static NSEventMask AZMouseActive = NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask);
//static NSEventMask AZMouseButton = NS | NSMouseExitedMask |NSMouseEnteredMask;



/* A shared operation que that is used to generate thumbnails in the background. */
extern NSOperationQueue *AZSharedOperationQueue(void);
extern NSOperationQueue *AZSharedSingleOperationQueue(void);
extern NSOperationQueue *AZSharedOperationStack(void);

@interface NSObject (debugandreturn)
- (id) debugReturn:(id) val;
@end

extern NSString *const AtoZSharedInstanceUpdated;
extern NSString *const AtoZDockSortedUpdated;

@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end

#import "OperationsRunner.h"

@interface AZDummy : NSObject
+ (instancetype) sharedInstance;
//- (void)addOperation:(NSOperation*)op;
@property (NATOM, STRNG) NSOperationQueue *sharedQ, *sharedSQ, *sharedStack;
@end

/*
@class AZTaskResponder;
typedef void (^asyncTaskCallback)(AZTaskResponder *response);
@interface AZTaskResponder: BaseModel
@property (copy) BKReturnBlock 		returnBlock;
@property (copy) asyncTaskCallback 	asyncTask;
@property (NATOM,STRNG) id response;
//Atoz
+ (void) aSyncTask:(asyncTaskCallback)handler;
- (void) parseAsyncTaskResponse;
// this is how we make the call:
// [AtoZ aSyncTask:^(AZTaskResponder *response) {   respond to result;  }];
@end
*/

@class NSLogConsole;
@interface AtoZ : BaseModel


@property (ASS) 			IBOutlet NSTextView *stdOutView;
@property (NATOM,STRNG) NSColor* logColor;
- (void) appendToStdOutView:(NSS*)text;

@property (NATOM, STRNG) NSA *basicFunctions;

#ifdef GROWL_ENABLED
- (BOOL) registerGrowl;
<GrowlApplicationBridgeDelegate>
#endif

//+ (NSIMG*)imageNamed:(NSString *)name;
//@property (NATOM, STRNG) SoundManager *sManager;

+ (void) playSound:(id)number;
+ (void) playRandomSound;
+ (NSF*) controlFont;
+ (NSA*) fonts;
+ (NSF*) font:(NSS*)family size:(CGF)size;

@property (NATOM, STRNG) NSA* fonts;
@property (RONLY) NSA* cachedImages;

+ (NSS*) tempFilePathWithExtension:(NSS*)extension;
+ (NSS*) randomFontName;
+ (void) plistToXML: (NSS*) path;
+ (NSA*) dock;
+ (NSA*) dockSorted;
+ (NSA*) runningApps;
+ (NSA*) runningAppsAsStrings;
//+ (void) testSizzle;
//+ (void) testSizzleReplacement;
//+ (NSA*) currentScope;
//+ (NSA*) fengShui;
//+ (NSA*) appFolder;
//+ (NSA*) appCategories;
//+ (NSA*) appFolderSorted;
//+ (NSA*) appFolderSamplerWith: (NSUInteger) apps;
+ (void) trackIt;
-  (NSP) convertToScreenFromLocalPoint: (NSP) point relativeToView: (NSV*) view;
- (void) moveMouseToScreenPoint: (NSP) point;
- (void) handleMouseEvent: (NSEventMask)event inView: (NSV*)view withBlock: (void (^)())block;

+ (AZPOS) positionForString: (NSS*)strVal;
+  (NSS*) stringForPosition:(AZPOS)enumVal;
+  (NSS*) stringForType:		(id)type;

//+ (NSFont*) fontWithSize: (CGFloat) fontSize;
//- (NSFont*) registerFonts:(CGFloat)size;
- (NSJSONSerialization*) jsonRequest: (NSString*) url;
+ (NSJSONSerialization*) jsonRequest: (NSString*) url;

+ (NSS*) version;
+ (NSB*) bundle;
+ (NSS*) resources;
+ (NSA*) appCategories;
+ (NSA*) macPortsCategories;

@property (nonatomic, retain) NSBundle *bundle;

/*@property (strong, nonatomic) NSLogConsole *console;	
- (id)objectForKeyedSubscript:(NSString *)key; - (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key;	*/

//- (void) performBlock:(VoidBlock)block;
- (void) performBlock:(VoidBlock)block waitUntilDone:(BOOL)wait;

+ (void) playNotificationSound: (NSD*)apsDictionary;
+ (void) badgeApplicationIcon:  (NSS*)string;
@end

@interface AtoZ (MiscFunctions)

+ (void) say:(NSS*)thing;

+  (CGF) clamp: 			(CGF)value	   from:(CGF)minimum to:(CGF)maximum;
+  (CGF) scaleForSize:	(CGS)size	  inRect:(CGR)rect;
+  (CGR) centerSize:		(CGS)size	  inRect:(CGR)rect;
+  (CGP) centerOfRect:	(CGR)rect;
+  (NSR) rectFromPointA:(NSP)pointA andPointB:(NSP)pointB;
+ (void) printRect:		(NSR)toPrint;
+ (void) printCGRect:	(CGR)cgRect;
+ (void) printPoint:		(NSP)toPrint;
+ (void) printCGPoint:	(CGP)cgPoint;
+ (void) printTransform:(CGAffineTransform)t;

+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect;

@end

typedef void (^KVOLastChangedBlock)( NSS *whatKeyChanged, id whichInstance, id newVal);
typedef void (^KVONewInstanceBlock)( id newInstance );

extern NSString *const BaseModelDidAddNewInstance;

@interface BaseModel (AtoZ)

/* Shared instance is the object modified after each key change.
	After being notified of change to the shared instance, call this to get last modified key of last modified instance */
+ (NSS*)	lastModifiedKey;
+ (INST)	lastModifiedInstance;
+ (void)	setLastModifiedKey:	(NSS*)key      forInstance:(id)object;
+ (void)	setLastChangedBlock:	(KVOLastChangedBlock) lastChangedBlock;
+ (void)	setNewInstanceBlock: (KVONewInstanceBlock) onInitBlock;

+ (INST)	objectAtIndex:(NSUI)idx;
+ (NSUI) instances;

@property (RONLY) 		NSUI instanceNumber;
@property (RONLY) 		NSA 	*superProperties;
@property (RONLY) 		NSS 	*uniqueID;
@property (NATOM,ASS) 	BOOL 	 convertToXML;
+ (NSS*) saveFilePath;


-   (id) objectForKeyedSubscript:					(id)  key;
-   (id) objectAtIndexedSubscript:					(NSUI)idx;
- (void) setObject: (id)obj atIndexedSubscript: (NSUI)idx;
- (void) setObject: (id)obj forKeyedSubscript:  (IDCP)key;
-   (id) valueForUndefinedKey:						(NSS*)key;
@end

/**


//- (void) swizzleSave;
//- (NSS*) uniqueID;


+ (instancetype) swizzleInstanceWithObject:(id)obj;
@implementation  NSArray (SubscriptsAdd)
- (id)objectAtIndexedSubscript:(NSUInteger)index {
	return [self objectAtIndex:index];
}
@end

@implementation NSMutableArray (SubscriptsAdd)
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
	if (index < self.count){
		if (object)
			[self replaceObjectAtIndex:index withObject:object];
		else
			[self removeObjectAtIndex:index];
	} else {
		[self addObject:object];
	}
}
@end
@implementation NSDictionary (SubscriptsAdd)
- (id)objectForKeyedSubscript:(id)key {
	return [self objectForKey:key];
}
@end
@implementation NSMutableDictionary (SubscriptsAdd)
- (void)setObject:(id)object forKeyedSubscript:(id)key {
	[self setObject:object forKey:key];
}
@end
*/
@interface Box : NSView
@property (ASS) 		BOOL 	selected;
@property (RDWRT,CP) CASHL *shapeLayer;
@property (RDWRT,CP) NSC 	*save, *color;
@end

@interface CAAnimation (NSViewFlipper)
+(CAA*)flipAnimationWithDuration:(NSTI)duration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGF)scaleFactor;
@end

@interface NSViewFlipperController : NSObject {
	NSView *hostView, *frontView, *backView, *topView, *bottomView;
	CALayer *topLayer, *bottomLayer;
	NSTimeInterval duration;
	BOOL isFlipped;
}
@property (RONLY) 	BOOL isFlipped;
@property (ASS)		NSTI duration;
@property (WK,RONLY)	NSView *visibleView;

-  (id) initWithHostView:(NSV*)newHost frontView:(NSV*)newFrontView backView:(NSV*)newBackView;
-(void) flip;
@end





@interface CAConstraint (brevity)
//+(CAConstraint*)maxX;

@end


/** The appledoc application handler.

 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:

 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class.
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.	*/

