//
//  main.m
//  usernotification
//
//    (The WTFPL)
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    Version 2, December 2004
//
//    Copyright (C) 2013 Norio Nomura
//
//    Everyone is permitted to copy and distribute verbatim or modified
//    copies of this license document, and changing it is allowed as long
//    as the name is changed.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//    0. You just DO WHAT THE FUCK YOU WANT TO.
//
/*

 zero (0) == FALSE  == NO
 

NOTES:


BLOCKS:

	__block __typeof(self) selfish = self;

LAYERS:

	self.root = [self setupHostViewNamed:@"root"];

KVO:
	
	[AZNOTCENTER addObserverForName:BaseModelSharedInstanceUpdatedNotification object:self queue:AZSOQ usingBlock:^(NSNotification *note) {
			[AZTalker say:@"sharedinstance changed, grrrrl"];
	}];
	
	[self addObserverForKeyPaths:@[@"content" ] task:^(id obj, NSD *change) { [selfish setContentSubLayers];}];
	
	[self addObserverForKeyPaths:@[@"contentLayer",NSViewBoundsDidChangeNotification ] task:^(id obj, NSD *change) { ....
	
AZWORKSPACE:	
											
	selfcontent	= [AZFolder samplerWithCount:RAND_INT_VAL(12, 48)];


*/

#ifndef ATOZFRAMEWORK
#define ATOZFRAMEWORK
#endif 

#import <pwd.h>
//#import <stat.h>
//#import <pwd.h>
#import <unistd.h>
#import <dirent.h>
#import <xpc/xpc.h>
#import <sys/stat.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <Cocoa/Cocoa.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>
//#import <Python/Python.h>
#import <libkern/OSAtomic.h>
#import <Security/Security.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreServices/CoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

#import <MenuApp/MenuApp.h>

#import <BlocksKit/BlocksKit.h>
//#import <BlocksKit/A2BlockDelegate.h>
#import <BlocksKit/A2DynamicDelegate.h>

#import <BWTK/BWToolkitFramework.h>
#import <CocoaPuffs/CocoaPuffs.h>
#import <CocoatechCore/CocoatechCore.h>
#import <DrawKit/DKDrawKit.h>
#import <FunSize/FunSize.h>
#import <Lumberjack/Lumberjack.h>
#import <KSHTMLWriter/KSHTMLWriter.h>
#import <MapKit/MapKit.h>
#import <NoodleKit/NoodleKit.h>
#import <NanoStore/NanoStore.h>
//#import <Nu/Nu.h>
#import <PhFacebook/PhFacebook.h>
#import <Rebel/Rebel.h>
#import <TwUI/TUIKit.h>
#import <Zangetsu/Zangetsu.h>
#import <AtoZBezierPath/AtoZBezierPath.h>
#import <AtoZAppKit/AtoZAppKit.h>

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
	#if __has_feature(objc_arc)											// ARC Helper Version 2.2
		#define ah_retain 		self
		#define ah_release 		self
		#define ah_autorelease 	self
		#define release 			self										// Is this right?  Why's mine different?
		#define autorelease 		self										// But shit hits fan without.
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
	


//#import <AIUtilities/AIUtilities.h>
#import "AZObserversAndBinders.h"
#import "extobjc_OSX/extobjc.h"
#import "AtoZAutoBox/AtoZAutoBox.h"
#import "KVOMap/KVOMap.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCArrayMapping.h"
//#import "KVOMap/DCDictionaryRearranger.h"
//#import "KVOMap/DCKeyValueObjectMapping.h"
//#import "KVOMap/DCObjectMapping.h"
//#import "KVOMap/DCParserConfiguration.h"
//#import "KVOMap/DCPropertyAggregator.h"
//#import "KVOMap/DCValueConverter.h"

#import "JREnum.h"
#import "objswitch.h"
#import "SelectorMatcher.h"
#import "ObjectMatcher.h"

#import "NSObject_KVOBlock.h"
//#import "CTBlockDescription.h"  in autobox now

#import "AtoZUmbrella.h"
#import "AtoZTypes.h"
#import "AtoZGeometry.h"
#import "NSOrderedDictionary.h"
#import "AZIndexedObjects.h"

#import "AZGrid.h"

//#import <AtoZ


//#import <AtoZUI/AtoZUI.h>
//#import <RMKit/RMKit.h>
//#import <NanoStore/NanoStore.h>
//#import <MapKit/MapKit.h>
//#import <XPCKit/XPCKit.h>
//#import <Zangetsu/Zangetsu.h>

/* ESSENTIAL */
#import "F.h"
#import "NSBag.h"
#import "NSArray+F.h"
#import "objswitch.h"
#import "NSNumber+F.h"
#import "NSDictionary+F.h"
#import "NSOperationStack.h"

#import "AZStopwatch.h"
#import "ConciseKit.h"
#import "NSArray+AtoZ.h"
#import "AtoZUmbrella.h"
#import "AtoZGeometry.h"
#import "AtoZFunctions.h"

#import "AtoZCategories.h"
#import "NSTerminal.h"
#import "AZLog.h"
#import "AtoZContacts.h"

/* MODEL */

#import "DSSyntaxCollection.h"
#import "DSSyntaxTextView.h"
#import "AZSyntaxTheme.h"
#import "DSRubySyntaxDefinition.h"
#import "DSObjectiveCSyntaxDefinition.h"
#import "DSPodfileSyntaxDefinition.h"
#import "DSPodspecSyntaxDefinition.h"
#import "DSSyntaxHighlighter.h"
#import "DSSyntaxTextView.h"


#import "JsonElement.h"
#import "HRCoder.h"
#import "AutoCoding.h"
#import "BaseModel.h"
#import "BaseModel+AtoZ.h"
#import "NullSafe.h"

#import "SDToolkit.h"
#import "MAKVONotificationCenter.h"
#import "AZHTTPURLProtocol.h"
#import "BlocksAdditions.h"

//#import "PythonOperation.h"

#import "NotificationCenterSpy.h"
#import "TransparentWindow.h"
#import "LoremIpsum.h"
#import "AFNetworking.h"

#import "AtoZNodeProtocol.h"
#import "CABlockDelegate.h"
#import "DefinitionController.h"
#import "AZFactoryView.h"

#import "NSLogConsole.h"
#import "Bootstrap.h"

//   CORE

#import "CAScrollView.h"
#import "AssetCollection.h"
#import "AZSpeechRecognition.h"
#import "SynthesizeSingleton.h"
#import "AZSynthesize.h"

// END CORE
#import "AZBlockView.h"
#import "AZTalker.h"
#import "iCarousel.h"
//#import "azCarousel.h"
#import "AZProcess.h"
#import "CTGradient.h"
#import "AZApplePrivate.h"

#import "RuntimeReporter.h"
#import "CTBadge.h"

#import "AZBackgroundProgressBar.h"

#import "AZObject.h"
//	#import "AZPalette.h"
//	#import "AZFile.h"
//	#import "AtoZModels.h"

#import "AZColor.h"


/*  FACEBOOK	*/
#import "RoutingHTTPServer.h"
#import "AssetCollection.h"
#import "AZHTTPRouter.h"
#import "AZFacebookConnection.h"

#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+AtoZ.h"

#import "HTTPServer.h"
#import "HTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPResponse.h"
#import "HTTPDataResponse.h"
#import "HTTPAuthenticationRequest.h"
#import "DDNumber.h"
#import "DDRange.h"
#import "DDData.h"
#import "HTTPFileResponse.h"
#import "HTTPAsyncFileResponse.h"
#import "HTTPDynamicFileResponse.h"
#import "WebSocket.h"
#import "WebSocket+AtoZ.h"

#import "HTTPLogging.h"

#import "AZBonjourBlock.h"

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
#import "NSString+AtoZEnums.h"

//#import "MondoSwitch.h"

/* FOUNDATION CLASSES */
#import "AZCLI.h"
#import "AZCLICategories.h"
#import "AZWeakCollections.h"
#import "AZXMLWriter.h"
#import "AZHTMLParser.h"
#import "AZGoogleImages.h"
#import "AZMacTrackBall.h"


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
#import "AZLaunchServices.h"
#import "AZLassoView.h"
#import "AZBackground.h"

#import "AZSound.h"
#import "Transition.h"
#import "LetterView.h"
#import "CPAccelerationTimer.h"
#import "StandardPaths.h"

/* CONTROLS */
//#import "AZMatteButton.h"
//#import "AZMatteFocusedGradientBox.h"
//#import "AZMattePopUpButton.h"
//#import "AZMattePopUpButtonView.h"
//#import "AZMatteSegmentedControl.h"
#import "AZToggleArrayView.h"
//#import "AZToggleView.h"
//
//#import "AZDarkButtonCell.h"
////#import "SNRHUDKit.h"
//#import "SNRHUDButtonCell.h"
////#import "SNRHUDImageCell.h"
//#import "SNRHUDScrollView.h"
//#import "SNRHUDSegmentedCell.h"
//#import "SNRHUDTextFieldCell.h"
//#import "SNRHUDTextView.h"
//#import "SNRHUDWindow.h"
////#import "AZStatusItemView.h"
#import "NSMenu+Dark.h"

#import "AtoZDelegate.h"


/* WINDOWS */
#import "AZWindowTab.h"
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
#import "AZSnapShotLayer.h"

#import "AtoZWebSnapper.h"
#import "AZURLSnapshot.h"
#import "HTMLNode.h"

// Views
#import "AtoZInfinity.h"
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
#import "StarLayer.h"
#import "XLDragDropView.h"
#import "AGNSSplitViewDelegate.h"
#import "AGNSSplitView.h"
#import "StickyNoteView.h"

#import "AZVeil.h"

#import "PXListView.h"
#import "PXListViewCell.h"
#import "PXListDocumentView.h"

// TwUI
#import "TUIView+Dimensions.h"
//#import "TUITableOulineView.h"
//#import "TUINavigationController.h"
#import "TUICarouselNavigationController.h"
#import "AHLayout.h"
#import "AZExpandableView.h"
#import "AZProportionalSegmentController.h"
#import "TUIFastIndexPath.h"
//#import "TUIRefreshControl.h"

// COREDATA
#import "AZImageToDataTransformer.h"

// UNUSED
//#import "AZFileGridView.h"
//#import "AZBoxLayer.h"
//#import "AZOverlay.h"


extern NSString *AZGridShouldDrawKey;
extern NSString *AZGridUnitWidthKey;
extern NSString *AZGridUnitHeightKey;
extern NSString *AZGridColorDataKey;


typedef id(^FilterBlock)(id element,NSUInteger idx, BOOL *stop);

@interface NSObject (AZFunctional)

-(id)processByPerformingFilterBlocks:(NSA*)filterBlocks;

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


@interface AZClassProxy : NSObject	- (id)valueForUndefinedKey:(NSString *)key;									@end

//	(I actually added this to my application delegate and implemented application:delegateHandlesKey:)
// Now you are ready to bind class methods to the Application object, even in the interface builder,
// with the keyPath @"classProxy.CharacterSet.allCharacterSets".

@interface NSObject (AZClassProxy)		- (id)classProxy;		+ (id)performSelector:(SEL)sel;					@end

#define CPROXY(x,y)  	[[[self vFK:@"classProxy"] vFK:MACRO_VALUE_TO_STRING(x)]vFK:MACRO_VALUE_TO_STRING(y)]

@interface AZDummy : NSObject
+ (instancetype) sharedInstance;
//- (void)addOperation:(NSOperation*)op;
@property (NATOM, STRNG) NSOperationQueue *sharedQ, *sharedSQ, *sharedStack;
@end

#define TestVarArgs(fmt...) [AtoZ sendArrayTo:$SEL(@"testVarargs:") inClass:AtoZ.class withVarargs:fmt]
#define TestVarArgBlock(fmt...) [AtoZ  varargBlock:^(NSA*values) { [values eachWithIndex:^(id obj, NSInteger idx) {  printf("VARARG #%d:  %s <%s>\n", (int)idx, [obj stringValue].UTF8String, NSStringFromClass([obj class]).UTF8String); }]; } withVarargs:fmt]


// extobjc EXTENSIONS

//#define synthesizeAssociations(...) ({ int x = metamacro_argcount(__VA_ARGS__); metamacro_tail( 
//int sum = firstNum, number;   va_start (args, firstNum);
//    while (1) if (!(number = va_arg (args, int))) break; else sum += number;
//    va_end (args);   return (sum);

/*!
 *	@class      AtoZ
 *	@abstract   A class used to interface with AtoZ
 *	@discussion This class provides a means to interface with AtoZ
 *	 Currently it provides a way to detect if AtoZ is installed and launch the AtoZHelper if it's not already running.
 */
@class MASShortcutView, MASShortcut;

@class AZLiveReload;
@interface AtoZ : BaseModel <DDLogFormatter>

@property AZLiveReload *reloader;

/*!
 *	@method isAtoZRunning
 *	@abstract Detects whether AtoZHelper is currently running.
 *	@discussion Cycles through the process list to find whether AtoZHelper is running and returns its findings.
 *	@result Returns YES if AtoZHelper is running, NO otherwise.
 */
+ (BOOL) isAtoZRunning;
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
@property (weak) 	AZDELEGATE	* atozDelegate;
+ (AZDELEGATE*)delegate;
@property (readonly) NSMA *delegates;
+ (NSMA*) delegates;

@property (NATOM,STRNG) MASShortcutView	* azHotKeyView;
@property (NATOM,STRNG) MASShortcut 		* azHotKey;
@property (NATOM) 		BOOL 					  azHotKeyEnabled;

@property (NATOM,STRNG) NSW * azWindow;
@property (NATOM,STRNG) NSC * logColor;
@property (NATOM) 		NSA * basicFunctions,
									 * fonts,
									 * cachedImages;
@property (RONLY) 		NSB * bundle;
@property (RONLY) 	  BOOL 	inTTY,
									   inXcode;

@property (ASS) IBO 	NSTXTV * stdOutView;

@property AZBonjourBlock *bonjourBlock;

+  (void) processInfo;
-  (NSS*) formatLogMessage:(DDLogMessage*)lm;
-  (void) appendToStdOutView:(NSS*)text;
+  (void) playSound:(id)number;
+  (void) playRandomSound;
+  (NSF*) controlFont;
+  (NSA*) fonts;
+  (NSF*) font:(NSS*)family size:(CGF)size;
+  (NSS*) tempFilePathWithExtension:(NSS*)extension;
+  (NSS*) randomFontName;
+  (void) plistToXML: (NSS*) path;
+  (NSA*) dock;
+  (NSA*) dockSorted;
+  (NSA*) runningApps;
+  (NSA*) runningAppsAsStrings;
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
+  (void) testVarargs: (NSA*)args;


/* USAGE:	AZVA_ArrayBlock varargB = ^(NSA* enumerator){ NSLog(@"what a value!: %@", enumerator); };
				[AtoZ varargBlock:varargB withVarargs:@"vageen",@2, GREEN, nil];
*/
+  (void) varargBlock: (void(^)(NSA*enumerator))block withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
+  (void) sendArrayTo: (SEL)method inClass:(Class)klass withVarargs:(id)varargs, ... NS_REQUIRES_NIL_TERMINATION;
-  (void) performBlock:(VoidBlock)block waitUntilDone:(BOOL)wait;
- (NSJS*) jsonRequest: (NSString*) url;
+ (NSJS*) jsonRequest: (NSString*) url;

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
#ifdef GROWL_ENABLED 
- (BOOL) registerGrowl;	<GrowlApplicationBridgeDelegate>
#endif
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

//typedef void(^log)(NSS*s);
// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


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
