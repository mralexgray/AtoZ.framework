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

/*! @discussion
  
  The DTFWYWTPL * The DO THE FUCK WHAT YOU WANT TO PUBLIC LICENSE, Version 2, Modified, ® 2013 Alex Gray, lol.

    You are permitted to copy and distribute verbatim (or modified), copies of this license document.
    As for the software, all rules and stipulations of the DO THE FUCK WHAT YOU WANT TO PUBLIC LICENSE apply, now and in perpetuity.

    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTING, MODIFYING, SLICING AND DICING:

    0.	You just DO WHAT THE FUCK YOU WANT TO DO, baby.
		1.  Stay sexy.

  
@note Important ENV VARS ->    OBJC_PRINT_REPLACED_METHODS   -> figure out which categories are stepping on who's toes! 

REFERECES

VARIADICS ->        /AtoZ.framework/Frameworks/Zangetsu/External/extobjc/Tests/EXTVarargsTest.m





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



Current probs...



*/

#if 0

-+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+-+*%$-+*%$%*+-+*%$%*+- EXAMPLE OF VARIAIDIC METHOD

- (void) appendObjects:(id)firstObject, ...	{  IF_RETURN(!firstObject);

 id eachObject; va_list argList;
 [self addObject: firstObject];             // The first argument isn't part of the varargs list, so we'll handle it separately.
 va_start(argList, firstObject);            // Start scanning for arguments after firstObject.
 while (eachObject = va_arg(argList,id))    // As many times as we can get an argument of type "id"
  [self addObject:eachObject];              // that isn't nil, add it to self's contents.
 va_end(argumentList);

}

#endif

#ifdef YOU_WANT_TO_UNDERSTAND_METAMACROS

from http://paul-samuels.com

/*! Meta macros are pretty nifty but trying to follow how they work can really challenge the limits of your mental stack frame.
  
  Let's start with a fictitious problem that I would like to solve with some metaprogramming. I would probably never do this in a real project but it gives me a realistic use case to work through.

  Imagine I want my view controllers to fail hard if I forget to connect up an outlet in the xib file. I could start with something like this:

@code
- (void)viewDidLoad {  [super viewDidLoad];
  
  NSParameterAssert(self.firstNameTextField);
  NSParameterAssert(self.lastNameTextField);
  NSParameterAssert(self.passwordTextField);
  NSParameterAssert(self.passwordConfirmationTextField);
}

whoa that's a lot of repetition and it's not going to scale well. What would be great is if I could write some code that would write this repetitious code for me, ideally I would just type something like this:

- (void)viewDidLoad { ...
  
  PASAssertConnections(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmation);
}
This seems a lot DRY'er so let's aim for something similar to this and see how we get on. @c metamacro_foreach

After examining the metamacros header I can see that there is a foreach macro that sounds like it would be perfect for this task.

The definition of metamacro_foreach looks like this: @c #define metamacro_foreach(MACRO, SEP, ...)

After reading the docs I can see that the MACRO argument should be the name of  */

  1. a macro that takes two arguments in the form of MACRO(INDEX, ARG).
  2. The INDEX parameter will be the index of the current iteration in the for loop 
  3. and the ARG parameter will be the argument for the current iteration in the for loop.

So I need to start of by defining a macro that takes these two arguments and expands to the NSParameterAssert that I want. Here's a first stab at such a macro

#define OUTLET_ASSERT(INDEX, NAME) NSParameterAssert([self NAME])

// I don't actually care to use the value of INDEX so it is ignored. This is the macro that will be used within the metamacro_foreach and will eventually expand into the required NSParameterAsserts.
// In each of the following examples I'll show the input (starting macro) above the 3 dashes and what this would theoretically expand into below the 3 dashes. I'll optionally show any macro definitions at the top of the code block.

// Here's how my OUTLET_ASSERT macro will work:

OUTLET_ASSERT(0, firstNameTextField);
  NSParameterAssert([self firstNameTextField]);


// Now let's see how we can use metamacro_foreach to write the PASAssertConnections macro that will take in a list of ivar names and expand them to the required NSParameterAsserts.

#define metamacro_foreach(MACRO, SEP, ...) \
        metamacro_foreach_cxt(metamacro_foreach_iter, SEP, MACRO, __VA_ARGS__)
        
  metamacro_foreach(OUTLET_ASSERT, ;, firstNameTextField, lastNameTextField)

  metamacro_foreach_cxt(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

// In this case I pass OUTLET_ASSERT as the macro to use on each iteration. I pass ; to use as a separator between iterations, which will terminate each NSParameterAssert. Then finally a comma separated list of ivar names that we are going to iterate over and generate the NSParameterAsserts for.

// With the previous expansion there are now two new macros that we need to look up and understand metamacro_foreach_cxt and metamacro_foreach_iter. metamacro_foreach_iter is arguably the simpler of the two but it's not needed until the end so let's see how metamacro_foreach_cxt expands.

metamacro_foreach_cxt
#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)

  metamacro_foreach_cxt(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

  metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(firstNameTextField, lastNameTextField))(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

// Great when this macro expands it introduces 2 more macros to look up, metamacro_concat and metamacro_argcount.

// metamacro_concat is the easier of the two so we'll take a look at that first.

  #define metamacro_concat(A, B) metamacro_concat_(A, B)
        
  #define metamacro_concat_(A, B) A ## B
        
metamacro_concat(metamacro_foreach_cxt, 2)

metamacro_foreach_cxt2

//Cool so metamacro_concat just expands to metamacro_concat_, which then just joins the tokens together using ##. So metamacro_concat just has the effect of joining it's two arguments into one string.

// Now we need to jump back to see how metamacro_argcount works

metamacro_argcount
#define metamacro_argcount(...) \
        metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
        
metamacro_argcount(firstNameTextField, lastNameTextField)

---
        
metamacro_at(20, firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
The metamacro_argcount macro uses another macro called metamacro_at. The metamacro_at is similar in concept to indexing into an array like myArray[index]. In plain English this macro is the same as "give me the nth item in the following list".

The metamacro_argcount macro uses a clever little trick. If we put the numbers from INDEX down to 0 into an array and then ask for the value at INDEX we would get the last number, which would be 0. If we preprend something to the beginning of this array and asked for the value at INDEX again we would now get 1.

Let's see this in Objective-C so it's easier to picture:

NSInteger index = 3;

@[                           @3, @2, @1, @0 ][index]; //=> @0 - 0 args
@[ @"argument",              @3, @2, @1, @0 ][index]; //=> @1 - 1 arg preprended
@[ @"argument", @"argument", @3, @2, @1, @0 ][index]; //=> @2 - 2 args preprended
The relationship is that when you prepend an argument to the array you shift all of the numeric values to the right by one step, which moves a higher number into the index that is being fetched. This of course only works up to the value of INDEX - so we can tell that this particular implementation of metamacros only supports 20 arguments.

NB - this implementation of metamacros requires at least one argument to be given when using metamacro_argcount.

You'll see the trick of inserting __VA_ARGS__ into argument lists at different points used a few times so it's worth making sure you understand what is happening above.

Ok so that makes sense but what about metamacro_at?

metamacro_at
#define metamacro_at(N, ...) \
        metamacro_concat(metamacro_at, N)(__VA_ARGS__)
Great there's our old friend metamacro_concat so we don't need to look up how that works again to know that this will expand like this:

metamacro_at(20, firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

---

metamacro_at20(firstNameTextField, lastNameTextField , 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
The change is very subtle. The 20 has moved from being an argument to now actually being part of the macro name. So now we need to look up metamacro_at20

#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) metamacro_head(__VA_ARGS__)
It turns out that there are variants of metamacro_at defined for 0 to 20, which allows you to access any of the first 20 arguments from the __VA_ARGS__ arguments.

This is another common trick you'll see with metamacros, at some point you have to knuckle down and write out multiple versions of the same macro to handle different length argument lists. You'll often see that metamacros are generated by other scripts that allow you to specify how many arguments you would like to support without having to hand roll all the variations of metamacro_at0..N.

To make metamacro_at a little easier to digest I'll examine one of the smaller versions of this macro.

#define metamacro_at2(_0, _1, ...) metamacro_head(__VA_ARGS__)

metamacro_at2(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmationTextField)

---

metamacro_head(passwordTextField, passwordConfirmationTextField)
The _0 and _1 arguments are basically used as placeholders to gobble up the items at indices 0 and 1 from the arguments. Then we bundle the rest of the arguments together with .... The newly trimmed __VA_ARGS__ is then passed into metamacro_head

metamacro_head
#define metamacro_head(...) \
        metamacro_head_(__VA_ARGS__, 0)

#define metamacro_head_(FIRST, ...) FIRST

metamacro_head(passwordTextField, passwordConfirmationTextField)

---

passwordTextField
metamacro_head uses the opposite trick to metamacro_at*. In this case we are only interested in the first item and we want to throw away the rest of the __VA_ARGS__ list. This is achieved by grabbing the first argument in FIRST and then collecting the rest with ....

Wow that escalated quickly. We now need to unwind out mental stack frame back to metamacro_foreach_cxt.

metamacro_foreach_cxt
Now we are more enlightened we can go back and expand both metamacro_concat and metamacro_argcount in the following:

#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)
        
metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(firstNameTextField, lastNameTextField))(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

---

metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)
Don't worry the end is now very much in sight, just a couple more painless macro expansions. The previous expansion gives us the new metamacro_foreach_cxt2 macro to check out.

metamacro_foreach_cxt2
This is another example of macro that has multiple versions defined from 0..20. Each of these foreach macros works by utilising the foreach macro that is defined to take one less argument than itself until we get all the way down to metamacro_foreach_cxt1

#define metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)
    
metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)
We are now at the point where we need to see what MACRO expands to. In this case MACRO is actually the metamacro_foreach_iter macro that we passed in near the beginning and I delayed explaining.

metamacro_foreach_iter
This macro is really just an implementation detail and as such shouldn't be used directly but we still want to see what part it plays:

#define metamacro_foreach_iter(INDEX, MACRO, ARG) MACRO(INDEX, ARG)

metamacro_foreach_iter(0, OUTLET_ASSERT, firstNameTextField)

---

OUTLET_ASSERT(0, firstNameTextField)
Nice and simple - metamacro_foreach_iter is just a helper that takes our macro OUTLET_ASSERT and the two arguments that our macro should receive and puts the pieces in the right order to be further expanded into the NSParameterAssert calls that we want.

Thankfully that was only a minor detour so let's get right back to metamacro_foreach_cxt2

#define metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)
    
metamacro_foreach_cxt2(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField, lastNameTextField)

---

metamacro_foreach_cxt1(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)
If you have gotten this far then the above is nothing special so we can progress straight to the next step:

#define metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)
    
metamacro_foreach_cxt1(metamacro_foreach_iter, ;, OUTLET_ASSERT, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)

---

    OUTLET_ASSERT(0, firstNameTextField) \
    ; \
    OUTLET_ASSERT(1, lastNameTextField)
And that's it - we've followed the metamacro_foreach macro from the beginning of it's use all the way to it's end expansion and hopefully our heads are still in one piece.

Wrapping up
At the beginning of the post I said I was aiming for

PASAssertConnections(firstNameTextField, lastNameTextField, passwordTextField, passwordConfirmation);
now I'm actually one step away from achieving this, but if this post has gotten your interest I'll leave that as a simple exercise - it's always better to learn by doing and not just skimming through blog posts hoping to learn by osmosis.

Metaprogramming is normally something that people associate with more dynamic languages like Ruby but there's a whole load of possibilities and cool tricks out there just waiting to be learned. As always I encourage you to join me in peeling back the curtain and seeing that there is normally no magic to be found in your favorite OSS projects.

#endif


#ifdef __cplusplus
  #define AtoZ_EXTERN extern "C" __attribute__((visibility ("default")))
#else
  #define AtoZ_EXTERN extern __attribute__((visibility ("default")))
#endif

#ifdef __OBJC__

//@import Cocoa;
//  @import AppKit;
@import ObjectiveC;
//  #import <Foundation/NSObjCRuntime.h>                  
@import QuartzCore;
//  #import <QuartzCore/QuartzCore.h>                   
                                                        //  @import Darwin;
//#import <ApplicationServices/ApplicationServices.h>   //  @import ApplicationServices;
//#import <AudioToolbox/AudioToolbox.h>                 //  @import AudioToolbox;
//#import <AVFoundation/AVFoundation.h>                 //  @import AVFoundation;
//#import <CoreServices/CoreServices.h>                 //  @import CoreServices;
//#import <Dispatch/Dispatch.h>                         //  @import Dispatch;
//#import <SystemConfiguration/SystemConfiguration.h>   //  @import SystemConfiguration;
//#import <WebKit/WebView.h>
//@import RoutingHTTPServer;

//#import <Zangetsu/Zangetsu.h>
//#import <RoutingHTTPServer/RoutingHTTPServer.h>

//#import "AOPProxy/AOPProxy.h"
//#import "CollectionsKeyValueFilteringX/CollectionsKeyValueFiltering.h"
//#import "JATemplate/JATemplate.h"
//#import <KVOMap/KVOMap.h>
#import <Zangetsu/Zangetsu.h>
//#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
//#import <AtoZAutoBox/AtoZAutoBox.h>
#import <AtoZAppKit/AtoZAppKit.h>
#import <AtoZBezierPath/AtoZBezierPath.h>
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/BlocksKit.h>
#import <BWTK/BWToolkitFramework.h>
#import <CFAAction/CFAAction.h>
#import <CocoaPuffs/CocoaPuffs.h>
#import <CocoatechCore/CocoatechCore.h>
#import <DrawKit/DKDrawKit.h>
#import <FunSize/FunSize.h>
#import <KSHTMLWriter/KSHTMLWriter.h>
//#import <MenuApp/MenuApp.h>
//#import <NMSSH/NMSSH.h>
#import <NoodleKit/NoodleKit.h>
#import <PhFacebook/PhFacebook.h>
//#import <Rebel/Rebel.h>
#import <TwUI/TUIKit.h>
#import <UAGithubEngine/UAGithubEngine.h>
#import <UIKit/UIKit.h>

//#import "AtoZSingleton/AtoZSingleton.h"
//#import <MapKit/MapKit.h>
//#import <RoutingHTTPServer/AZRouteResponse.h>

//#import "JREnum.h"
//#import "objswitch.h"
//#import "BaseModel.h"
//#import "AutoCoding.h"
//#import "HRCoder.h"
//#import "F.h"
///////////////////////////////////////////////////////////////
//  #import "AtoZAutoBox/AtoZAutoBox.h"
//#import "AtoZTypes.h"
//#import "AtoZMacroDefines.h"
//#import "BoundingObject.h"
#import "AtoZUmbrella.h"
//#import "AtoZGeometry.h"
#import "AtoZCategories.h"
#import "BlocksAdditions.h"
#import "AddressBookImageLoader.h"
#import "AFNetworking.h"
#import "AGNSSplitView.h"
#import "AGNSSplitViewDelegate.h"
#import "AHLayout.h"
#import "ASIHTTPRequest.h"
#import "BBMeshView.h"
#import "BETaskHelper.h"
#import "BlockDelegate.h"
#import "AtoZSwizzles.h"

//#import "ConciseKit.h"
#import "CPAccelerationTimer.h"
#import "CTBadge.h"
#import "CTGradient.h"
#import "DSObjectiveCSyntaxDefinition.h"
#import "DSPodfileSyntaxDefinition.h"
#import "DSPodspecSyntaxDefinition.h"
#import "DSRubySyntaxDefinition.h"
#import "DSSyntaxCollection.h"
#import "DSSyntaxHighlighter.h"
#import "DSSyntaxTextView.h"
#import "iCarousel.h"
#import "JSONKit.h"
#import "KGNoise.h"
#import "LoremIpsum.h"
#import "MAAttachedWindow.h"
#import "MAKVONotificationCenter.h"
#import "MASShortcut.h"  // SHortcut Manager and View
#import "NotificationCenterSpy.h"
#import "NSBag.h"
#import "NSMenu+Dark.h" 
#import "NSObject_KVOBlock.h"
#import "M13OrderedDictionary.h"
//  #import "NSTerminal.h"
#import "NSWindow_Flipr.h"
#import "NullSafe.h"
#import "ObjectMatcher.h"
#import "PXListDocumentView.h"
#import "PXListView.h"
#import "PXListViewCell.h"
#import "RuntimeReporter.h"
#import "SDToolkit.h"
#import "SelectorMatcher.h"
#import "SIAppCookieJar.h"
#import "SIAuthController.h"
#import "SIConstants.h"
#import "SIInboxDownloader.h"
#import "SIInboxModel.h"
#import "SIViewControllers.h"
#import "SIWindow.h"
#import "StandardPaths.h"
#import "StarLayer.h"
#import "StickyNoteView.h"
#import "Transition.h"
#import "TransparentWindow.h"
#import "TUIFastIndexPath.h"
#import "XLDragDropView.h"
//#import "AtoZMacroDefines.h"
//#import "AtoZUmbrella.h"
//#import "AtoZTypes.h"
//#import "AtoZGeometry.h"
#import "AtoZFunctions.h"
#import "AZLog.h"
#import "AZProxy.h"
#import "AZBaseModel.h"  // NSDocument / AZDoc
#import "SynthesizeSingleton.h"
#import "AZObserversAndBinders.h"
#import "MondoSwitch.h"
#import "AssetCollection.h"
#import "AtoZColorWell.h"
#import "AtoZContacts.h"
#import "AtoZDelegate.h"
#import "AtoZGridView.h"
#import "AtoZGridViewProtocols.h"
#import "AtoZInfinity.h"
#import "AtoZModels.h"
//#import "AtoZNodeProtocol.h"
#import "AtoZWebSnapper.h"
#import "AZApplePrivate.h"
#import "AZASIMGV.h"
#import "AZAttachedWindow.h"
#import "AZAXAuthorization.h"
#import "AZBackground.h"
#import "AZBackgroundProgressBar.h"
#import "AZBlockView.h"
#import "AZBonjourBlock.h"
#import "AZBorderlessResizeWindow.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZCalculatorController.h"
#import "AZCLI.h"
#import "AZCLICategories.h"
#import "AZColor.h"
#import "AZCoreScrollView.h"
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
#import "AZHomeBrew.h"
#import "AZHostView.h"
#import "AZHTMLParser.h"
#import "AZHTTPURLProtocol.h"
#import "AZImageToDataTransformer.h"
#import "AZIndeterminateIndicator.h"
#import "AZIndexedObjects.h"
#import "AZInfiniteCell.h"
#import "AZInstantApp.h"
#import "AZLassoView.h"
#import "AZLaunchServices.h"
#import "AZLayer.h"
#import "AZLogConsole.h"
#import "AZMacTrackBall.h"
#import "AZMedallionView.h"
#import "AZMouser.h"
#import "AZObject.h"
#import "AZPopupWindow.h"
#import "AZPrismView.h"
#import "AZProcess.h"
#import "AZProgressIndicator.h"
#import "AZPropellerView.h"
#import "AZProportionalSegmentController.h"
#import "AZQueue.h"
#import "AZScrollerLayer.h"
#import "AZScrollPaneLayer.h"
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
#import "AZTalker.h"
#import "AZTimeLineLayout.h"
#import "AZToggleArrayView.h"
#import "AZTrackingWindow.h"
//  #import "AZURLSnapshot.h"
#import "AZVeil.h"
#import "AZWeakCollections.h"
#import "AZWindowExtend.h"
#import "AZWindowTab.h"
#import "AZXMLWriter.h"
#import "NSOperationStack.h"
#import "Bootstrap.h"
#import "CalcModel.h"
#import "CAScrollView.h"
#import "CAWindow.h"
#import "DefinitionController.h"
#import "HTMLNode.h"
#import "IsometricView.h"
#import "LetterView.h"
#import "NSTextView+SyntaxColoring.h"
#import <AtoZ/AtoZEmoji.h>
#import "AZNamedColors.h"

#ifndef IMPORTMODULEHEADERSBECAUSEITWANTSTO
#define IMPORTMODULEHEADERSBECAUSEITWANTSTO
// <module-includes>:1:1: warning: umbrella header for module 'AtoZ' does not include header 'ASIDownloadCache.h' [-Wincomplete-umbrella]
#import "ASIDataDecompressor.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "ASIInputStream.h"
#import "ASINetworkQueue.h"
#import "AtoZStack.h"
#import "AtoZWebSnapperGridViewController.h"
#import "AZBeetlejuice.h"
#import "AZButton.h"
#import "AZCSSColorExtraction.h"
#import "AZHoverButton.h"
#import "AZMatteButton.h"
#import "AZMatteFocusedGradientBox.h"
#import "AZMattePopUpButton.h"
#import "AZMattePopUpButtonView.h"
#import "AZMatteSegmentedControl.h"
#import "AZURLBar.h"
#import "AZWikipedia.h"
#import "AZWindowTabViewController.h"
#import "DSURLDataSource.h"
#import "EGOCache.h"
#import "EGOImageLoadConnection.h"
#import "GTMHTTPFetcher.h"
#import "GTMNSString+HTML.h"
#import "HTMLParserViewController.h"
#import "MediaServer.h"
#import "NSColor+RGBHex.h"
#import "NSObject+AZBlockObservation.h"
#import "NSString+SymlinksAndAliases.h"
#import "NSString+PathAdditions.h"
#import "NSTerminal.h"
#import "OperationsRunnerProtocol.h"
#import "PythonOperation.h"
#import "RoundedView.h"
#import "SDCloseButtonCell.h"
#import "TUITableView+Updating.h"

#endif
//  #ifdef DEBUG
//    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//  #else
//    static const int ddLogLevel = LOG_LEVEL_WARN;
//  #endif
#endif

/*	INACTIVE
#import "AZLassoLayer.h"
*/

/*	COLOR AND IMAGE CLASSES */
/*  FACEBOOK	*/
/* CONTROLS */
/* CoreScroll */
/* ESSENTIAL */
/* FOUNDATION CLASSES */
/* MODEL */
/* old home of umbrellas */
/* STACKEXCHANGE */
/* WINDOWS */
//	#import "AtoZModels.h"
//	#import "AZFile.h"
//	#import "AZPalette.h"
//   CORE
// COREDATA
// END CORE
// TwUI
// UNUSED
// Views
//#import "AZBoxLayer.h"
//#import "azCarousel.h"
#import "AZDarkButtonCell.h"
#import "ASIDataCompressor.h"

//#import "AZFileGridView.h"
//#import "AZHTTPRouter.h"
//#import "AZMatteButton.h"
//#import "AZMatteFocusedGradientBox.h"
//#import "AZMattePopUpButton.h"
//#import "AZMattePopUpButtonView.h"
//#import "AZMatteSegmentedControl.h"
//#import "AZNotificationCenter.h"
//#import "AZOverlay.h"
//#import "AZToggleView.h"
//#import "CKSingleton.h"
//#import "CTBlockDescription.h"  in autobox now
//#import "DSURLDataSource.h"
//#import "MondoSwitch.h"
//#import "PythonOperation.h"
//#import "SNRHUDButtonCell.h"
//#import "SNRHUDScrollView.h"
//#import "SNRHUDSegmentedCell.h"
//#import "SNRHUDTextFieldCell.h"
//#import "SNRHUDTextView.h"
//#import "SNRHUDWindow.h"
//#import "TUICarouselNavigationController.h"
//#import "TUINavigationController.h"
//#import "TUIRefreshControl.h"
//#import "TUITableOulineView.h"
//#import <AtoZ
//#import <AtoZUI/AtoZUI.h>
//#import <MapKit/MapKit.h>
//#import <NanoStore/NanoStore.h>
//#import <RMKit/RMKit.h>
//#import <XPCKit/XPCKit.h>
//#import <Zangetsu/Zangetsu.h>
////#import "AZStatusItemView.h"
////#import "SNRHUDImageCell.h"
////#import "SNRHUDKit.h"
//Classes


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

@interface NSObject (AtoZEssential)

-   (id) objectForKeyedSubscript:(id)k;
- (void) setObject:(id)x forKeyedSubscript:(id<NSCopying>)k;

@property (NATOM) BOOL  faded;  // implementations for CALayer, NSView, NSWindow

@property (NATOM) id  representedObject;


@end

typedef id(^FilterBlock)(id element,NSUInteger idx, BOOL *stop);


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
@property (readonly) AZClassProxy* classProxy;
+ (id)performSelector:(SEL)sel;
@end

#define NSCDR NSCoder
#define CPROXY(x) 	[[@"a" valueForKey:@"classProxy"] valueForKey:@#x]
#define MASCOLORE(x) [x setValue:[CXPROXY(@"NSColor") valueForKey:@"randomColor"] forKey:@"logForeground"]

#define NSPRINT(x) 	[[[@"a" valueForKey:@"classProxy"] valueForKey:@"NSTerminal"]performSelectorWithoutWarnings:NSSelectorFromString(@"printString:") withObject:[x valueForKey:@"colorLogString"]]

@interface AZDummy : NSObject
+ (instancetype) sharedInstance;
//- (void) addOperation:(NSOperation*)op;
@property (RONLY) NSOperationStack *sharedStack;
@property (RONLY) NSOperationQueue *sharedQ, *sharedSQ;
@end

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

@class MASShortcutView, MASShortcut, AZLiveReload;

/*! @class      AtoZ
    @abstract   A class used to interface with AtoZ
    @discussion This class provides a means to interface with AtoZ
                Currently it provides a way to detect if AtoZ is installed and launch the AtoZHelper if it's not already running.
 */
#define ATOZ AtoZ.sharedInstance

@interface AtoZ : BaseModel

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


+      (NSS*) macroFor:(NSS*)w;
+      (NSD*) macros;
+      (void) processInfo;
//-  (NSS*) formatLogMessage:(DDLogMessage*)lm;
-      (void) appendToStdOutView:(NSS*)text;
+      (void) playSound:(id)number;
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
////@import QuartzCore;
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

