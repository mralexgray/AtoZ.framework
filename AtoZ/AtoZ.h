#ifndef ATOZ_H
#define ATOZ_H



                                                                                   #define AtoZLOGO @"\
																																																			\
							db            ,d                     888888888888																				\
						 d88b           88                              ,88																				\
            d8'`8b        MM88MMM                         ,88^ 																				\
           d8'  `8b         88        ,adPPYba,         ,88^   																				\
          d8YaaaaY8b        88       a8'     '8a      ,88^      																  		\
         d8""""""""8b       88       8b       d8    ,88^       																				\
        d8'        `8b      88       '8a,   ,a8'   88^         																				\
       d8'          `8b     'Y888     `^YbbdP^'    888888888888																				\
																																																		  \
			     _    _     _           _            _    _																									\
          |_   |_)   /_\   |\/|  |_  |  |  |  / \  |_)  |/																				 		\
					|    | \  /   \  |  |  |_   \/ \/   \_/  | \  |\																				   	\
																																																			"
                                                                                  #define AZWELCOME @"\
                                                                                                      \
Welcome  Bienvenidos! いらっしゃいませ！добро пожаловать! Willkommen! 接 待! Bonjour!                 \
                                                                                                      \
             𝗔𝗍𝗈𝗭•𝖿𝗋𝖺𝗆𝖾𝗐𝗈𝗋𝗄! © ⅯⅯⅯⅩⅠⅤ ! 𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆"

#ifdef __cplusplus
  #define AtoZ_EXTERN extern "C" __attribute__((visibility ("default")))
#else
  #define AtoZ_EXTERN extern     __attribute__((visibility ("default")))
#endif /* __cplusplus */

#ifdef __OBJC__


#import "AtoZUmbrella.h"

@import AtoZAppKit;
@import AtoZBezierPath;
@import BWTK;
@import BlocksKit;
@import BlocksKit.A2DynamicDelegate;
@import CFAAction;
@import CocoaPuffs;
@import CocoatechCore;
@import DrawKit;
@import FunSize;
@import KSHTMLWriter;
@import NoodleKit;
@import PhFacebook;
@import TwUI;
@import UAGithubEngine;
@import UIKit;
@import Zangetsu;

@import RoutingHTTPServer;

#import "AtoZCategories.h"

/*
#import <AtoZAppKit/AtoZAppKit.h>
#import <AtoZBezierPath/AtoZBezierPath.h>
#import <BWTK/BWToolkitFramework.h>
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/BlocksKit.h>
#import <CFAAction/CFAAction.h>
#import <CocoaPuffs/CocoaPuffs.h>
#import <CocoatechCore/CocoatechCore.h>
#import <DrawKit/DrawKit.h>
#import <FunSize/FunSize.h>
#import <KSHTMLWriter/KSHTMLWriter.h>
#import <NoodleKit/NoodleKit.h>
#import <PhFacebook/PhFacebook.h>
#import <TwUI/TwUI.h>
#import <UAGithubEngine/UAGithubEngine.h>
#import <UIKit/UIKit.h>
#import <Zangetsu/Zangetsu.h>


  #import <Foundation/NSObjCRuntime.h>
  #import <QuartzCore/QuartzCore.h>
                                                          @import Darwin;
#import <ApplicationServices/ApplicationServices.h>   //  @import ApplicationServices;
#import <AudioToolbox/AudioToolbox.h>                 //  @import AudioToolbox;
#import <AVFoundation/AVFoundation.h>                 //  @import AVFoundation;
#import <CoreServices/CoreServices.h>                 //  @import CoreServices;
#import <Dispatch/Dispatch.h>                         //  @import Dispatch;
#import <SystemConfiguration/SystemConfiguration.h>   //  @import SystemConfiguration;
#import <WebKit/WebView.h>
@import RoutingHTTPServer;

#import <Zangetsu/Zangetsu.h>
#import <RoutingHTTPServer/RoutingHTTPServer.h>

#import "AOPProxy/AOPProxy.h"
#import "CollectionsKeyValueFilteringX/CollectionsKeyValueFiltering.h"
#import "JATemplate/JATemplate.h"
#import <KVOMap/KVOMap.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <AtoZAutoBox/AtoZAutoBox.h>
#import <MenuApp/MenuApp.h>
#import <NMSSH/NMSSH.h>
#import <Rebel/Rebel.h>

#import "AtoZSingleton/AtoZSingleton.h"
#import <MapKit/MapKit.h>
#import <RoutingHTTPServer/AZRouteResponse.h>

#import "JREnum.h"
#import "objswitch.h"
#import "BaseModel.h"
#import "AutoCoding.h"
#import "HRCoder.h"
#import "F.h"

#import "AtoZAutoBox/AtoZAutoBox.h"
#import "AtoZTypes.h"
#import "AtoZMacroDefines.h"
#import "BoundingObject.h"
#import "AtoZGeometry.h"

*/
/*
//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

//#import <Availability.h>
#undef ah_retain
#undef ah_dealloc
#undef ah_autorelease           // autorelease
#undef ah_dealloc               // dealloc
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_release self
#define ah_autorelease self
#define ah_dealloc self
#else
#define ah_retain retain
#define ah_release release
#define ah_autorelease autorelease
#define ah_dealloc dealloc
#undef __bridge
#define __bridge
#undef __bridge_transfer
#define __bridge_transfer
#endif

//  Weak reference support

//#import <Availability.h>
#if !__has_feature(objc_arc_weak)
#undef ah_weak
#define ah_weak unsafe_unretained
#undef __ah_weak
#define __ah_weak __unsafe_unretained
#endif

//  Weak delegate support

//#import <Availability.h>
#undef ah_weak_delegate
#undef __ah_weak_delegate
#if __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define ah_weak_delegate weak
#define __ah_weak_delegate __weak
#else
#define ah_weak_delegate unsafe_unretained
#define __ah_weak_delegate __unsafe_unretained
#endif
*/

@interface NSObject (AtoZEssential)

-              objectForKeyedSubscript:k;
- (void) setObject:x forKeyedSubscript:(id<NSCopying>)k;

@prop_NA BOOL   faded;  // implementations for CALayer, NSView, NSWindow
@prop_NA   id   representedObject;

@end

typedef id(^FilterBlock)(id element,NSUInteger idx, BOOL *stop);

//static NSEventMask AZMouseActive = NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask);
//static NSEventMask AZMouseButton = NS | NSMouseExitedMask |NSMouseEnteredMask;

/* A shared operation que that is used to generate thumbnails in the background. */
extern NSOQ *AZSharedOperationQueue(void);
extern NSOQ *AZSharedSingleOperationQueue(void);
extern NSOQ *AZSharedOperationStack(void);

@interface NSObject (debugandreturn)
- debugReturn:val;
@end

extern NSS *const AtoZSharedInstanceUpdated,
           *const AtoZDockSortedUpdated;

@interface NSObject (AtoZDelegate)
- (void) dockItemDidUpdateValues:(NSNotification*)info;
@end


#import "OperationsRunner.h"


/*! @abstract AZClassProxy enables `performSelector` to be called on `Class`'s.  Yay!.
  @discussion (I actually added this to my application delegate and implemented application:delegateHandlesKey:)
              Now you are ready to bind class methods to the Application object, even in the interface builder,
              with the keyPath @"classProxy.CharacterSet.allCharacterSets". */
              
AZNSIFACE(AZClassProxy)

/*! Naive example: @c

 [[NSBundle bundleWithPath:[[NSString stringWithUTF8String:getenv("AZBUILD")] 
                            stringByAppendingPathComponent:@"AtoZ.framework"]] load];
                            
  NSLog(@"%@", objc_msgSend([NSString class], NSSelectorFromString(@"dicksonisms")));
  NSLog(@"%@", objc_msgSend([[@"" valueForKey:@"classProxy"] valueForKey:@"NSString"], NSSelectorFromString(@"dicksonisms")));
*/

@interface NSObject (AZClassProxy)
@prop_RO AZClassProxy * classProxy;
+ performSelector:(SEL)sel;
@end

#define NSCDR NSCoder
#define CPROXY(x) 	[[@"a" valueForKey:@"classProxy"] valueForKey:@#x]
#define MASCOLORE(x) [x setValue:[CXPROXY(@"NSColor") valueForKey:@"randomColor"] forKey:@"logForeground"]

#define NSPRINT(x) 	[[[@"a" valueForKey:@"classProxy"] valueForKey:@"NSTerminal"]performSelectorWithoutWarnings:NSSelectorFromString(@"printString:") withObject:[x valueForKey:@"colorLogString"]]


#define TestVarArgs(fmt...) [AtoZ sendArrayTo:$SEL(@"testVarargs:") inClass:AtoZ.class withVarargs:fmt]
#define TestVarArgBlock(fmt...) [AtoZ  varargBlock:^(NSA*values) { [values eachWithIndex:^(id obj, NSInteger idx) {  printf("VARARG #%d:  %s <%s>\n", (int)idx, [obj stringValue].UTF8String, NSStringFromClass([obj class]).UTF8String); }]; } withVarargs:fmt]

@interface NSObject (AZTestRoutine)
+ (NSA*) testableClasses;
+ (NSD*) testableMethods;
@end

// extobjc EXTENSIONS

//#define synthesizeAssociations(...) ({ int x = metamacro_argcount(__VA_ARGS__); metamacro_tail( 
//int sum = firstNum, number;   va_start (args, firstNum);
//    while (1) if (!(number = va_arg (args, int))) break; else sum += number;
//    va_end (args);   return (sum);

@class MASShortcutView, MASShortcut, AZLiveReload, NSOS, AZBonjourBlock;

/*! @class      AtoZ
    @abstract   A class used to interface with AtoZ
    @discussion This class provides a means to interface with AtoZ
                Currently it provides a way to detect if AtoZ is installed and launch the AtoZHelper if it's not already running.
 */
#define ATOZ AtoZ.sharedInstance

@interface AtoZ : BaseModel <DDLogFormatter>

@prop_RO	LogEnv   logEnv;

+ (void) logObject:(id)x file:(const char *)f function:(const char *)func line:(int)l;

//+ (void) logFile:(const char*)file line:(int)ln func:(const char*)fnc format:(id)fmt,...;



@property AZLiveReload *reloader;

/*!
 *	@method isAtoZRunning
 *	@abstract Detects whether AtoZHelper is currently running.
 *	@discussion Cycles through the process list to find whether AtoZHelper is running and returns its findings.
 *	@result Returns YES if AtoZHelper is running, NO otherwise.
 */
//+ (BOOL) isAtoZRunning;

/*	@method setAtoZDelegate:
	@abstract Set the object which will be responsible for providing and receiving Growl information.
	@discussion 
	This must be called before using AtoZApplicationBridge. The methods in the GrowlApplicationBridgeDelegate protocol are required and return the basic information needed to register with Growl. The methods in the GrowlApplicationBridgeDelegate_InformalProtocol informal protocol are individually optional.  They provide a greater degree of interaction between the application and growl such as informing the application when one of its Growl notifications is clicked by the user. The methods in the GrowlApplicationBridgeDelegate_Installation_InformalProtocol informal protocol are individually optional and are only applicable when using the Growl-WithInstaller.framework which allows for automated Growl installation.
	When this method is called, data will be collected from inDelegate, Growl will be launched if it is not already running, and the application will be registered with Growl.
	If using the Growl-WithInstaller framework, if Growl is already installed but this copy of the framework has an updated version of Growl, the user will be prompted to update automatically.
	@param inDelegate The delegate for the GrowlApplicationBridge. It must conform to the GrowlApplicationBridgeDelegate protocol.	*/

#define AZDELEGATE NSObject<AtoZDelegate>
/*!@method growlDelegate
	@abstract Return the object responsible for providing and receiving Growl information.
	@discussion See setGrowlDelegate: for details.
	@result The Growl delegate.	*/
//@property (weak) 	AZDELEGATE	* atozDelegate;
//+ (AZDELEGATE*)delegate;
//@property (readonly) NSMA *delegates;
//+ (NSMA*) delegates;

@prop_NA MASShortcutView	* azHotKeyView;
@prop_NA MASShortcut 		* azHotKey;
@prop_NA 		BOOL 					  azHotKeyEnabled;

@prop_NA  NSW * azWindow;
@prop_NA  NSC * logColor;
@prop_NA	NSA * fonts,          /// 13 font... names.
              * cachedImages;   /// nil.
@prop_RO  NSB * bundle;
@prop_RO BOOL 	inTTY,          /// Seems accurate..
                        inXcode;

@prop_RO NSOS * sharedStack;
@prop_RO NSOQ * sharedQ,
              * sharedSQ;

@prop_AS IBO 	NSTXTV * stdOutView;

@prop_ AZBonjourBlock *bonjourBlock;

+      (NSTI) lastActivity;
+      (BOOL) isInternetAvail;


+      (NSS*) macroFor:(NSS*)w;
+      (NSD*) macros;
+      (void) processInfo;
//-  (NSS*) formatLogMessage:(DDLogMessage*)lm;
-      (void) appendToStdOutView:(NSS*)text;

// SOUNDS
+      (void) playSound:number;
+      (void) playRandomSound;

+      (NSF*) controlFont;
+ (CGFontRef) cfFont; // CF controlFont;
+  (NSA*) fonts;
+  (NSF*) font:(NSS*)family size:(CGF)size;
+  (NSS*) tempFilePathWithExtension:(NSS*)extension;
+  (NSS*) randomFontName;

+  (void) plistToXML: (NSS*) path;
+  (NSA*) dock; // aka AZDock.sharedInstance
+  (NSA*) dockSorted;
+  (NSA*) runningApps; // NO WOrkie
+  (NSA*) runningAppsAsStrings; // AOK
+  (void) onAppSwitch:(void(^)(id runningApp))block;
+  (void) trackIt;
-   (NSP) convertToScreenFromLocalPoint: (NSP) point relativeToView: (NSV*) view;
-  (void) moveMouseToScreenPoint: (NSP) point;
-  (void) handleMouseEvent: (NSEventMask)event inView: (NSV*)view withBlock: (void (^)())block;
+  (NSS*) stringForType:		(id)type;
+  (NSS*) version;
+  (NSB*) bundle;
+  (NSS*) resources;
+  (NSA*) appCategories;
+  (NSA*) macPortsCategories;
+  (void) playNotificationSound: (NSD*)apsDictionary;
+  (void) badgeApplicationIcon:  (NSS*)string;
+  (NSA*) globalPalette;

+  (void) testVarargs: (NSA*)args;

/* USAGE:	AZVA_ArrayBlock varargB = ^(NSA* enumerator){ NSLog(@"what a value!: %@", enumerator); };
				[AtoZ varargBlock:varargB withVarargs:@"vageen",@2, GREEN, nil];
*/
+  (void)  varargBlock:(void(^)(NSA*enumerator))block withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
+  (void)  sendArrayTo:(SEL)method inClass:(Class)klass withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
-  (void) performBlock:(VoidBlock)block waitUntilDone:(BOOL)wait;
- (NSJS*)  jsonRequest:(NSS*) url;
+ (NSJS*)  jsonRequest:(NSS*) url;

+  (NSA*) processes;

#ifdef GROWL_ENABLED
- (BOOL) registerGrowl;	<GrowlApplicationBridgeDelegate>
#endif


//+ (AZPOS) positionForString: (NSS*)strVal;
//+  (NSS*) stringForPosition:(AZPOS)enumVal;
//+ (NSFont*) fontWithSize: (CGFloat) fontSize;
//- (NSFont*) registerFonts:(CGFloat)size;
//+ (void) testSizzle;
//+ (void) testSizzleReplacement;
//+ (NSA*) currentScope;
//+ (NSA*) fengShui;
//+ (NSA*) appFolder;
//+ (NSA*) appCategories;
//+ (NSA*) appFolderSorted;
//+ (NSA*) appFolderSamplerWith: (NSUInteger) apps;
//@property (NATOM, STRNG) SoundManager *sManager;
//@property (strong, nonatomic) NSLogConsole *console;

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

@interface JustABox : NSView
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

//typedef void(^log)(NSS*s);


/** The appledoc application handler.

 This is the principal tool class. It represents the entry point for the application. The main promises of the class are parsing and validating of command line arguments and initiating documentation generation. Generation is divided into several distinct phases:

 1. Parsing data from source files: This is the initial phase where input directories and files are parsed into a memory representation (i.e. objects) suitable for subsequent handling. This is where the source code files are  parsed and validated for possible file or object-level incosistencies. This step is driven by `GBParser` class.
 2. Post-processing of the data parsed in the previous step: At this phase, we already have in-memory representation of all source code objects, so we can post-process and validate things such as links to other objects etc. We can also update in-memory representation with this data and therefore prepare everything for the final phase. This step is driven by `GBProcessor` class.
 3. Generating output: This is the final phase where we use in-memory data to generate output. This step is driven by `GBGenerator` class.
 @warning *Global settings implementation details:* To be able to properly apply all levels of settings - factory defaults, global settings and command line arguments - we can't solely rely on `DDCli` for parsing command line args. As the user can supply templates path from command line (instead of using one of the default paths), we need to pre-parse command line arguments for templates switches. The last one found is then used to read global settings. This solves proper settings inheritance up to global settings level. Another issue is how to implement code that deals with global settings; there are several possible solutions (the simplest from programmers point of view would be to force the user to pass in templates path as the first parameter, then `DDCli` would first process this and when we would receive notification, we could parse the option, load in global settings and resume operation). At the end I chose to pre-parse command line for template arguments before passing it to `DDCli`. This did require some tweaking to `DDCli` code (specifically the method that converts option string to KVC key was moved to public interface), but ended up as very simple to inject global settings - by simply using the same KCV messages as `DDCli` uses. This small tweak allowed us to use exactly the same path of handling global settings as normal command line arguments. The benefits are many: all argument names are alreay unit tested to properly map to settings values, code reuse for setting the values.	*/

/*  xcode shortcuts  @property (nonatomic, assign) <\#type\#> <\#name\#>;	*/

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



// #undef ah_retain #undef ah_dealloc #undef ah_autorelease autorelease #undef ah_dealloc dealloc

//
//  ARC Helper
//
//  Version 2.2
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//
/*
	#import <Availability.h>
	#undef ah_retain
	#undef ah_dealloc
	#undef ah_autorelease autorelease
	#undef ah_dealloc dealloc
	#if __has_feature(objc_arc)
		#define ah_retain self
		#define ah_release self
		#define ah_autorelease self
		#define ah_dealloc self
	#else
		#define ah_retain retain
		#define ah_release release
		#define ah_autorelease autorelease
		#define ah_dealloc dealloc
		#undef __bridge
		#define __bridge
		#undef __bridge_transfer
		#define __bridge_transfer
	#endif

	//  Weak reference support

	#import <Availability.h>
	#if !__has_feature(objc_arc_weak)
		#undef ah_weak
		#define ah_weak unsafe_unretained
		#undef __ah_weak
		#define __ah_weak __unsafe_unretained
	#endif

	//  Weak delegate support

	#import <Availability.h>
	#undef ah_weak_delegate
	#undef __ah_weak_delegate
	#if __has_feature(objc_arc_weak) && \
		(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
		__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
		#define ah_weak_delegate weak
		#define __ah_weak_delegate __weak
	#else
		#define ah_weak_delegate unsafe_unretained
		#define __ah_weak_delegate __unsafe_unretained
	#endif

//  ARC Helper ends
*/

//#import "GCDAsyncSocket.h"
//#import "GCDAsyncSocket+AtoZ.h"
//#import "HTTPServer.h"
//#import "HTTPConnection.h"
//#import "HTTPMessage.h"
//#import "HTTPResponse.h"
//#import "HTTPDataResponse.h"
//#import "HTTPAuthenticationRequest.h"
//#import "DDNumber.h"
//#import "DDRange.h"
//#import "DDData.h"
//#import "HTTPFileResponse.h"
//#import "HTTPAsyncFileResponse.h"
//#import "HTTPDynamicFileResponse.h"
//#import "RoutingHTTPServer.h"
//#import "WebSocket.h"
//#import "RouteRequest.h"
//#import "RouteResponse.h"
//#import "WebSocket.h"
//#import "AZWebSocketServer.h"
//#import "HTTPLogging.h"

////@import ObjectiveC;
////@import Security;
////@import Quartz;
////#import <QuartzCore/QuartzCore.h>
////#import <QuartzCore/QuartzCore.h>
////@import ApplicationServices;
////@import AVFoundation;
////@import CoreServices;
////@import AudioToolbox;

//#import <objc/message.h>
//#import <objc/runtime.h>
//#import <AppKit/AppKit.h>
//#import <Quartz/Quartz.h>
//#import <Security/Security.h>
//#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreServices/CoreServices.h>
//#import <AVFoundation/AVFoundation.h>
//#import <ApplicationServices/ApplicationServices.h>


//#import <stat.h>
//#import <Python/Python.h>
//#import <NanoStore/NanoStore.h>
//#import <Nu/Nu.h>


//  ARC Helper ends


/*
	#if __has_feature(objc_arc)											// ARC Helper Version 2.2
		#define ah_retain 		self
		#define ah_release 		self
		#define ah_autorelease 	self
//		#define release 			self										// Is this right?  Why's mine different?
	//	#define autorelease 		self										// But shit hits fan without.
		#define ah_dealloc 		self
	#else
		#define ah_retain 		retain
		#define ah_release 		release
		#define ah_autorelease 	autorelease
		#define ah_dealloc 		dealloc
		#undef 	__bridge
		#define  __bridge
		#undef   __bridge_transfer
		#define  __bridge_transfer
	#endif
	#if !__has_feature(objc_arc_weak)									// Weak reference support
		#undef 	  ah_weak
		#define 	  ah_weak   unsafe_unretained
		#undef 	__ah_weak
		#define 	__ah_weak __unsafe_unretained
	#endif
	#undef ah_weak_delegate													// Weak delegate support
	#undef __ah_weak_delegate
	#if	__has_feature(objc_arc_weak) && (!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
		#define   ah_weak_delegate weak
		#define __ah_weak_delegate __weak
	#else
		#define   ah_weak_delegate   unsafe_unretained
		#define __ah_weak_delegate __unsafe_unretained
	#endif																		// ARC Helper ends


	//  ARC Helper Version 1.3.1 Created by Nick Lockwood on 05/01/2012. Copyright 2012 Charcoal Design Distributed under the permissive zlib license  Get the latest version from here: https://gist.github.com/1563325
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
	
*/
/*
#import <pwd.h>
#import <stdio.h>
#import <netdb.h>
#import <dirent.h>
#import <unistd.h>
#import <stdarg.h>
#import <unistd.h>
#import <dirent.h>
#import <xpc/xpc.h>
#import <xpc/xpc.h>
#import <sys/stat.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <sys/xattr.h>
#import <arpa/inet.h>
#import <objc/objc.h>
#import <netinet/in.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <Python/Python.h>
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>
#import <Carbon/Carbon.h>
#import <libkern/OSAtomic.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>
#import <AudioToolbox/AudioToolbox.h>
*/

//	#import <extobjc_OSX/e.h>
//	#import "extobjc_OSX/extobjc.h"
//	#import <extobjc/metamacros.h>
//	#import "GCDAsyncSocket.h"
//	#import "GCDAsyncSocket+AtoZ.h"
//	#import "AtoZAutoBox/NSObject+DynamicProperties.h"

//#import <AIUtilities/AIUtilities.h>
//#import "extobjc_OSX/extobjc.h"
//#import "AtoZAutoBox/AtoZAutoBox.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "AtoZSingleton/AtoZSingleton.h"
//#import "ObjcAssociatedObjectHelper/ObjcAssociatedObjectHelpers.h"
//#import "TypedCollections/TypedCollections.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCArrayMapping.h"
//#import "KVOMap/DCDictionaryRearranger.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCObjectMapping.h"
//#import "KVOMap/DCParserConfiguration.h"
//#import "KVOMap/DCPropertyAggregator.h"
//#import "KVOMap/DCValueConverter.h"

//#endif 





/*!  PropertyMacros.h

  Created by Nicolas Bouilleaud on 12/04/12, 
   using ideas by Uli Kusterer (http://orangejuiceliberationfront.com/safe-key-value-coding/)
   Laurent Deniau (https://groups.google.com/forum/?fromgroups#!topic/comp.std.c/d-6Mj5Lko_s)
   and Nick Forge (http://forgecode.net/2011/11/compile-time-checking-of-kvc-keys/)


  Usage : 
   $keypath(foo)                    -> @"foo"
   $keypath(foo,bar)                -> @"foo.bar"
   $keypath(foo,inexistentkey)        -> compilation error: undeclared selector 'inexistentkey'

 @note Be sure to set -Wundeclared-selector.
*/

#define PP_RSEQ_N()                                 9,8,7,6,5,4,3,2,1,0 
#define PP_ARG_N(_1,_2,_3,_4,_5,_6,_7,_8,_9,N,...)  N 
#define PP_NARG_(...)                               PP_ARG_N(__VA_ARGS__) 
#define PP_NARG(...)                                PP_NARG_(__VA_ARGS__,PP_RSEQ_N()) 

#define KVCCHECK(p)                                 NSStringFromSelector(@selector(p))

#define KVCCHECK_1(_1)                              KVCCHECK(_1)
#define KVCCHECK_2(_1,_2)                           KVCCHECK_1(_1),KVCCHECK_1(_2)
#define KVCCHECK_3(_1,_2,_3)                        KVCCHECK_1(_1),KVCCHECK_2(_2,_3)
#define KVCCHECK_4(_1,_2,_3,_4)                     KVCCHECK_1(_1),KVCCHECK_3(_2,_3,_4)
#define KVCCHECK_5(_1,_2,_3,_4,_5)                  KVCCHECK_1(_1),KVCCHECK_4(_2,_3,_4,_5)
#define KVCCHECK_6(_1,_2,_3,_4,_5,_6)               KVCCHECK_1(_1),KVCCHECK_5(_2,_3,_4,_5,_6)
#define KVCCHECK_7(_1,_2,_3,_4,_5,_6,_7)            KVCCHECK_1(_1),KVCCHECK_6(_2,_3,_4,_5,_6,_7)
#define KVCCHECK_8(_1,_2,_3,_4,_5,_6,_7,_8)         KVCCHECK_1(_1),KVCCHECK_7(_2,_3,_4,_5,_6,_7,_8)
#define KVCCHECK_9(_1,_2,_3,_4,_5,_6,_7,_8,_9)      KVCCHECK_1(_1),KVCCHECK_8(_2,_3,_4,_5,_6,_7,_8,_9)

#define KVCPATH_1(_1)                               @#_1
#define KVCPATH_2(_1,_2)                            @#_1"."#_2
#define KVCPATH_3(_1,_2,_3)                         @#_1"."#_2"."#_3
#define KVCPATH_4(_1,_2,_3,_4)                      @#_1"."#_2"."#_3"."#_4
#define KVCPATH_5(_1,_2,_3,_4,_5)                   @#_1"."#_2"."#_3"."#_4"."#_5
#define KVCPATH_6(_1,_2,_3,_4,_5,_6)                @#_1"."#_2"."#_3"."#_4"."#_5"."#_6
#define KVCPATH_7(_1,_2,_3,_4,_5,_6,_7)             @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7
#define KVCPATH_8(_1,_2,_3,_4,_5,_6,_7,_8)          @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7"."#_8
#define KVCPATH_9(_1,_2,_3,_4,_5,_6,_7,_8,_9)       @#_1"."#_2"."#_3"."#_4"."#_5"."#_6"."#_7"."#_8"."#_9

#define KP_CONCAT(a,b)                              a ## b
#define KP_XCONCAT(a,b)                             KP_CONCAT(a,b)
#define KP_(m, ...)                                 m(__VA_ARGS__)
#define $keypath(...)                               (0?KP_(KP_XCONCAT(KVCCHECK_, PP_NARG(__VA_ARGS__)), __VA_ARGS__) :\
                                                       KP_(KP_XCONCAT(KVCPATH_, PP_NARG(__VA_ARGS__)), __VA_ARGS__) )

#endif /* __OBJC__ */

#endif /* ATOZ_H */

