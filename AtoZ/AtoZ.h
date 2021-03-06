#ifndef ATOZ_H
#define ATOZ_H



                                                                                   #define AtoZLOGO @"\
                                                                                                      \
              db            ,d                     888888888888                                       \
             d88b           88                              ,88                                       \
            d8'`8b        MM88MMM                         ,88^                                        \
           d8'  `8b         88        ,adPPYba,         ,88^                                          \
          d8YaaaaY8b        88       a8'     '8a      ,88^                                            \
         d8""""""""8b       88       8b       d8    ,88^                                              \
        d8'        `8b      88       '8a,   ,a8'   88^                                                \
       d8'          `8b     'Y888     `^YbbdP^'    888888888888                                       \
                                                                                                      \
           _    _     _           _            _    _                                                 \
          |_   |_)   /_\   |\/|  |_  |  |  |  / \  |_)  |/                                            \
          |    | \  /   \  |  |  |_   \/ \/   \_/  | \  |\                                            \
                                                                                                      "
                                                                                  #define AZWELCOME @"\
                                                                                                      \
Welcome  Bienvenidos! いらっしゃいませ！добро пожаловать! Willkommen! 接 待! Bonjour!                 \
                                                                                                      \
             헔헍허헭•햿헋햺헆햾헐허헋헄! © ⅯⅯⅯⅩⅠⅤ ! 헀헂헍헁헎햻.햼허헆/헺헿헮헹헲혅헴헿헮혆"

#ifdef __cplusplus
  #define AtoZ_EXTERN extern "C" __attribute__((visibility ("default")))
#else
  #define AtoZ_EXTERN extern     __attribute__((visibility ("default")))
#endif /* __cplusplus */

#ifdef __OBJC__

//@import AppKit; ObjectiveC; QuartzCore;

@import AtoZAutoBox;

@import AtoZAppKit;
@import AtoZBezierPath;
@import BWTK;
@import BlocksKit.A2DynamicDelegate;
@import CFAAction;
@import CocoaPuffs;
@import CocoatechCore;
@import CURLHandle;
@import DrawKit;
@import FunSize;
@import KSHTMLWriter;
@import MenuApp;
@import NoodleKit;
@import NMSSH;
@import NSUIKit;
@import ORSSerial;
@import PhFacebook;
@import TwUI;
@import UAGithubEngine;
@import USBDevice;

@import RoutingHTTPServer; // Includes HTTPServer + AsyncSockset + Lumberjack

#define JATEMPLATE_SYNTAX_WARNINGS 1
#define autorelease self

@import ToolKit;  // also handles ExtObjC  + AtoZUniversal + AtoZAutoBox

@import KVOMap;

#import "BlocksAdditions.h"
#import "M13OrderedDictionary.h"
//#import <CocoaLumberjack/CocoaLumberjack.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE; // Log level for robbie (debug)

#pragma mark - ATOZFRAMEWORK

#import "AutoCoding.h"
#import "HRCoder.h"

#import "MutableGeometry.h"

#import "NSImage+AtoZ.h"

/*! id x = CAL.new; [x setGeos:@"bounds", @"x",@100, @"width", @5000, nil];   NEAT! */
//#import "AtoZGeometry.h"
//#import "AZCLI.h"


#import "+.h"
#import "AFNetworking.h"
#import "AGNSSplitView.h"
#import "AGNSSplitViewDelegate.h"
#import "AHLayout.h"
#import "ASIDataCompressor.h"
#import "ASIDataDecompressor.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIInputStream.h"
#import "ASINetworkQueue.h"
#import "AZASImageView.h"
#import "AZAXAuthorization.h"
#import "AZApplePrivate.h"
#import "AZAttachedWindow.h"
#import "AZBackground.h"
#import "AZBackgroundProgressBar.h"
#import "AZBaseModel.h"  // NSDocument / AZDoc
#import "AZBeetlejuice.h"
#import "AZBlockView.h"
#import "AZBonjourBlock.h"
#import "AZBorderlessResizeWindow.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZButton.h"
#import "AZCSSColorExtraction.h"
#import "AZCalculatorController.h"
#import "AZColor.h"
#import "AZCoreScrollView.h"
#import "AZDarkButtonCell.h"
#import "AZDebugLayer.h"
#import "AZDockQuery.h"
#import "AZExpandableView.h"
#import "AZFacebookConnection.h"
#import "AZFactoryView.h"
#import "AZFavIconManager.h"
#import "AZFoamView.h"
#import "AZGit.h"
#import "AZGoogleImages.h"
#import "AZGrid.h"
#import "AZHTMLParser.h"
#import "AZHTTPURLProtocol.h"
#import "AZHomeBrew.h"
#import "AZHostView.h"
#import "AZHoverButton.h"
#import "AZImageToDataTransformer.h"
#import "AZIndeterminateIndicator.h"
#import "AZIndexedObjects.h"
#import "AZInfiniteCell.h"
#import "AZInstantApp.h"
#import "AZLassoView.h"
#import "AZLaunchServices.h"
#import "AZLayer.h"
#import "AZLog.h"
#import "AZLogConsole.h"
#import "AZMacTrackBall.h"
#import "AZMatteButton.h"
#import "AZMatteFocusedGradientBox.h"
#import "AZMattePopUpButton.h"
#import "AZMattePopUpButtonView.h"
#import "AZMatteSegmentedControl.h"
#import "AZMedallionView.h"
#import "AZMouser.h"
#import "AZNamedColors.h"
#import "AZObject.h"
#import "AZPopupWindow.h"
#import "AZPrismView.h"
#import "AZProcess.h"
#import "AZProgressIndicator.h"
#import "AZPropellerView.h"
#import "AZProportionalSegmentController.h"
#import "AZProxy.h"
#import "AZQueue.h"
#import "AZScrollPaneLayer.h"
#import "AZScrollerLayer.h"
#import "AZSegmentedRect.h"
#import "AZSemiResponderWindow.h"
#import "AZSimpleView.h"
#import "AZSizer.h"
#import "AZSnapShotLayer.h"
#import "AZSound.h"
#import "AZSourceList.h"
#import "AZSpeechRecognition.h"
#import "AZSpinnerLayer.h"
#import "AZStopwatch.h"
#import "AZSyntaxTheme.h"
#import "AZSynthesize.h"
#import "AZTimeLineLayout.h"
//#import "AZToggleArrayView.h"
#import "AZTrackingWindow.h"
#import "AZURLBar.h"
#import "AZVeil.h"
#import "AZWeakCollections.h"
#import "AZWikipedia.h"
#import "AZWindowExtend.h"
#import "AZWindowTab.h"
#import "AZWindowTabViewController.h"
#import "AZXMLWriter.h"
#import "AddressBookImageLoader.h"
#import "AssetCollection.h"
#import "AtoZColorWell.h"
#import "AtoZContacts.h"
#import "AtoZDelegate.h"
#import "AtoZEmoji.h"
#import "AtoZFunctions.h"
#import "AtoZGridView.h"
#import "AtoZGridViewProtocols.h"
#import "AtoZInfinity.h"
#import "AtoZModels.h"
#import "AtoZStack.h"
#import "AtoZSwizzles.h"
#import "AtoZWebSnapper.h"
#import "AtoZWebSnapperGridViewController.h"
#import "AZUSBMonitor.h"
#import "BBMeshView.h"
#import "BETaskHelper.h"
#import "BlockDelegate.h"
#import "BlocksAdditions.h"
#import "Bootstrap.h"
#import "CAScrollView.h"
#import "CAWindow.h"
#import "CPAccelerationTimer.h"
#import "CTBadge.h"
#import "CTGradient.h"
#import "CWTask.h"
#import "CalcModel.h"
#import "ColorExplorer.h"
#import "DSSyntaxCollection.h"
#import "DSSyntaxHighlighter.h"
#import "DSSyntaxTextView.h"
#import "DSURLDataSource.h"
#import "DateTools.h"
#import "DefinitionController.h"
#import "EGOCache.h"
#import "EGOImageLoadConnection.h"
#import "GTMHTTPFetcher.h"
#import "HTMLNode.h"
#import "HTMLParserViewController.h"
#import "IsometricView.h"
#import "JSONKit.h"
#import "KBButton.h"
#import "KGNoise.h"
#import "LetterView.h"
#import "MAAttachedWindow.h"
#import "MAKVONotificationCenter.h"
#import "MASShortcut.h"  // SHortcut Manager and View
#import "MediaServer.h"
#import "MondoSwitch.h"
#import "NSOperationStack.h"
#import "NotificationCenterSpy.h"
#import "NullSafe.h"
#import "OperationsRunnerProtocol.h"
#import "PXListDocumentView.h"
#import "PXListView.h"
#import "PXListViewCell.h"
#import "PythonOperation.h"
#import "RoundedView.h"
#import "RuntimeReporter.h"
#import "SDCloseButtonCell.h"
#import "SDToolkit.h"
#import "SIAppCookieJar.h"
#import "SIAuthController.h"
#import "SIConstants.h"
#import "SIInboxDownloader.h"
#import "SIInboxModel.h"
#import "SIViewControllers.h"
#import "SIWindow.h"
#import "SoundManager.h"
#import "StandardPaths.h"
#import "StarLayer.h"
#import "StickyNoteView.h"
#import "TUIFastIndexPath.h"
#import "TUIView+Dimensions.h"
#import "Transition.h"
#import "TransparentWindow.h"

#import "WebView+AtoZ.h"
#import "XLDragDropView.h"
#import "iCarousel.h"


#import "AZGrid.h"
#import "AZMatrix.h"
#import "AZPoint.h"
#import "AZSize.h"
#import "AZRect.h"

@import BlocksKit;


@interface NSObject (AtoZEssential)

-              objectForKeyedSubscript:k;
- (void) setObject:x forKeyedSubscript:(id<NSCopying>)k;

_NA BOOL   faded;  // implementations for CALayer, NSView, NSWindow
_NA   id   representedObject;

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
_RO AZClassProxy * classProxy;
+ performSelector:(SEL)sel;
@end

#define NSCDR NSCoder
#define CPROXY(x)   [[@"a" valueForKey:@"classProxy"] valueForKey:@#x]
#define MASCOLORE(x) [x setValue:[CXPROXY(@"NSColor") valueForKey:@"randomColor"] forKey:@"logForeground"]

#define NSPRINT(x)  [[[@"a" valueForKey:@"classProxy"] valueForKey:@"NSTerminal"]performSelectorWithoutWarnings:NSSelectorFromString(@"printString:") withObject:[x valueForKey:@"colorLogString"]]


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

 

@interface NSBundle (AtoZBundle)

+ (NSB*) frameworkBundleNamed:(NSS*)name;

+ (void) loadAZFrameworks;

/// (  "NSBundle </Users/localadmin/Library/Frameworks/AtoZBezierPath.framework> (loaded)", ... "NSBundle </Users/localadmin/Library/Frameworks/Zangetsu.framework> (loaded)" )
+ (NSA*) azFrameworkBundles;

///  ( AtoZ, AtoZAppKit, .. UIKit, Zangetsu )
+ (NSA*) azFrameworkNames;

/// ( "us.pandamonia.BlocksKit", ... "com.twitter.TwUI" )
+ (NSA*) azFrameworkIds;

/// conveniencer for azFrameworkIds.kvc(@"infoDictionary")
+ (NSA*) azFrameworkInfos;

+ (NSD*) azFrameworkInfoForId:(NSS*)bId;

@end

#define ATOZ AtoZ.sharedInstance

@interface AtoZ : BaseModel <DDLogFormatter>

+ (NSS*) ISP;
/** A "random" `AZDefinition` containing an entry from UrbanDictionary.com.
  * @see AZDefinition
    @warning  This is a sycronous call, and can be slow..  For better results..
    @see +[NSString randomUrabanDBlock:]
    id x = NSS.randomUrbanD;
    XX([x word]);       -> [x word] = GPA
    XX([x definition]); -> [x definition] = Overated system for determining a students intelligence but on occasion it does reflect a person's brain power. Designed primarily for parents and ...
*/
+ (AZDefinition*) randomUrbanD;

+ (void) randomUrabanDBlock:(void (^)(AZDefinition *definition))block;

_RO LogEnv   logEnv;

+ (void) logObject:(id)x file:(const char *)f function:(const char *)func line:(int)l;

//+ (void) logFile:(const char*)file line:(int)ln func:(const char*)fnc format:(id)fmt,...;


@property AZLiveReload *reloader;

/*!
 *  @method isAtoZRunning
 *  @abstract Detects whether AtoZHelper is currently running.
 *  @discussion Cycles through the process list to find whether AtoZHelper is running and returns its findings.
 *  @result Returns YES if AtoZHelper is running, NO otherwise.
 */
//+ (BOOL) isAtoZRunning;

/*  @method setAtoZDelegate:
  @abstract Set the object which will be responsible for providing and receiving Growl information.
  @discussion
  This must be called before using AtoZApplicationBridge. The methods in the GrowlApplicationBridgeDelegate protocol are required and return the basic information needed to register with Growl. The methods in the GrowlApplicationBridgeDelegate_InformalProtocol informal protocol are individually optional.  They provide a greater degree of interaction between the application and growl such as informing the application when one of its Growl notifications is clicked by the user. The methods in the GrowlApplicationBridgeDelegate_Installation_InformalProtocol informal protocol are individually optional and are only applicable when using the Growl-WithInstaller.framework which allows for automated Growl installation.
  When this method is called, data will be collected from inDelegate, Growl will be launched if it is not already running, and the application will be registered with Growl.
  If using the Growl-WithInstaller framework, if Growl is already installed but this copy of the framework has an updated version of Growl, the user will be prompted to update automatically.
  @param inDelegate The delegate for the GrowlApplicationBridge. It must conform to the GrowlApplicationBridgeDelegate protocol.  */

#define AZDELEGATE NSObject<AtoZDelegate>
/*!@method growlDelegate
  @abstract Return the object responsible for providing and receiving Growl information.
  @discussion See setGrowlDelegate: for details.
  @result The Growl delegate. */
//@property (weak)  AZDELEGATE  * atozDelegate;
//+ (AZDELEGATE*)delegate;
//@property (readonly) NSMA *delegates;
//+ (NSMA*) delegates;

_NA MASShortcutView  * azHotKeyView;
_NA MASShortcut    * azHotKey;
_NA    BOOL            azHotKeyEnabled;

_NA  NSW * azWindow;
_NA  NSC * logColor;
_NA  NSA * fonts,          /// 13 font... names.
              * cachedImages;   /// nil.
_RO NSB * bundle;

_RO NSOS * sharedStack;
_RO NSOQ * sharedQ,
              * sharedSQ;

_AS IBO  NSTXTV * stdOutView;

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
+  (NSS*) stringForType:    (id)type;
+  (NSS*) version;
+  (NSB*) bundle;
+  (NSS*) resources;
+  (NSA*) appCategories;
+  (NSA*) macPortsCategories;
+  (void) playNotificationSound: (NSD*)apsDictionary;
+  (void) badgeApplicationIcon:  (NSS*)string;
+  (NSA*) globalPalette;

#define GLOBALPAL [AtoZ globalPalette]

+  (void) testVarargs: (NSA*)args;

/* USAGE: AZVA_ArrayBlock varargB = ^(NSA* enumerator){ NSLog(@"what a value!: %@", enumerator); };
        [AtoZ varargBlock:varargB withVarargs:@"vageen",@2, GREEN, nil];
*/
+  (void)  varargBlock:(void(^)(NSA*enumerator))block withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
+  (void)  sendArrayTo:(SEL)method inClass:(Class)klass withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
-  (void) performBlock:(Blk)block waitUntilDone:(BOOL)wait;
- (NSJS*)  jsonRequest:(NSS*) url;
+ (NSJS*)  jsonRequest:(NSS*) url;

+  (NSA*) processes;

#ifdef GROWL_ENABLED
- (BOOL) registerGrowl; <GrowlApplicationBridgeDelegate>
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
//@property (NA, STR) SoundManager *sManager;
//@property (strong, nonatomic) NSLogConsole *console;

@end

@interface AtoZ (MiscFunctions)

+ (void) say:(NSS*)thing;

+  (CGF) clamp:       (CGF)value     from:(CGF)minimum to:(CGF)maximum;
+  (CGF) scaleForSize:  (CGS)size   inRect:(CGR)rect;
+  (CGR) centerSize:    (CGS)size   inRect:(CGR)rect;
+  (CGP) centerOfRect:  (CGR)rect;
+  (NSR) rectFromPointA:(NSP)pointA andPointB:(NSP)pointB;
+ (void) printRect:   (NSR)toPrint;
+ (void) printCGRect: (CGR)cgRect;
+ (void) printPoint:    (NSP)toPrint;
+ (void) printCGPoint:  (CGP)cgPoint;
+ (void) printTransform:(CGAffineTransform)t;

+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect;

@end

@interface JustABox : NSView
@property (ASS)     BOOL  selected;
@property (RW,CP) CASHL *shapeLayer;
@property (RW,CP) NSC  *save, *color;
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
@property (RO)   BOOL isFlipped;
@property (ASS)   NSTI duration;
@property (WK,RO)  NSView *visibleView;
-  (id) initWithHostView:(NSV*)newHost frontView:(NSV*)newFrontView backView:(NSV*)newBackView;
-(void) flip;
@end

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

