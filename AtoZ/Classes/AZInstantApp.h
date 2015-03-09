//
//  AZInstantApp.h
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


// USAGE   APPWITHBLOCK( ^{ NSLog(@"Hige vageen"); }) 


#define NEWSTICKYVIEW(_NAME_) NSW * _NAME_ = [NSW.alloc initWithContentRect:AZRandomRectInRect(AZScreenFrameUnderMenu()) styleMask:NSTexturedBackgroundWindowMask backing:2 defer:NO];  [_NAME_ makeKeyAndOrderFront:nil]


//NSW * _NAME_; ({ _NAME_ = 
/*	_NAME_.backgroundColor = CLEAR;\ */\
//	_NAME_.contentView = [AZStickyNoteView.alloc initWithFrame:win.contentRect];\
/*	[_NAME_ setOpaque:NO];\ */\
//	[_NAME_ setMovableByWindowBackground:YES];\
//	[_NAME_ makeKeyAndOrderFront:nil];  }); _NAME_


#define APPWITHBLOCK(x) \
int main(int argc, char *argv[]) {\
	@autoreleasepool {\
		AZSHAREDAPP; NSM *menubar,*appMenu; NSMI *appMenuItem; NSW* win; NSR r;\
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];\
		[menubar = NSM.new addItem:appMenuItem = NSMI.new];\
		[NSApp setMainMenu:menubar];\
		[appMenu = NSM.new addItem: \
			[NSMI.alloc initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"]];\
		[appMenuItem setSubmenu:appMenu];\
		menubar.dark = YES; \
		r = AZRectFromDim(200);\
		win = [NSW.alloc initWithContentRect:r styleMask:0|1|2|8 backing:2 defer:NO];\
		[win cascadeTopLeftFromPoint:NSMakePoint(20,20)];\
		[win setTitle:AZPROCNAME]; \
		win.backgroundColor = RED;\
		[NSImageView addImageViewWithImage:[NSIMG imageNamed:@"1"] toView:win.contentView];\
		[win setMovableByWindowBackground:YES];\
		[win makeKeyAndOrderFront:nil];\
		[NSApp activateIgnoringOtherApps:YES];\
		x();\
		[NSApp run];\
	}\
}\

#define PARENTHIZE(_x_) (_x_)

/* usage  - NOTICE THE EXTRA PARENS... necessary for dumb macro expansion with commas...

APPWITHBLOCKWINDOW(( ^(NSW*win){	win.contentView = [AZSimpleView withFrame:win.contentRect color:GREEN]; }));

*/

#define APPWITHBLOCKWINDOW(x)                                                                     \
int main(int argc, char *argv[]) {                                                                \
	@autoreleasepool {                                                                              \
		AZSHAREDAPP;                                                                                  \
		NSM 	*menubar,	*appMenu; 																					                          \
		NSMI 	*appMenuItem; 																								                           \
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];									             \
		[menubar = NSM.new addItem:appMenuItem = NSMI.new];													                   \
		[NSApp setMainMenu: menubar];																					                         \
		[appMenu = NSM.new addItem: 																				                           \
			[NSMI.alloc initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"]];         \
		[appMenuItem setSubmenu:appMenu];																			\
		NSR 	 r = AZRectFromDim(200);																				\
		NSW *win	= [NSW.alloc initWithContentRect:r styleMask:0|1|2|8 backing:2 defer:NO];			\
		[win cascadeTopLeftFromPoint:(NSP){20,20}];																\
		[win setTitle:AZPROCNAME]; 																					\
		win.backgroundColor = RED;																						\
/* [NSImageView addImageViewWithImage:[NSIMG imageNamed:@"1"] toView:win.contentView];		*/\
		[win setMovableByWindowBackground:YES];																	\
		[win 			 makeKeyAndOrderFront:nil];																	\
		[NSApp  activateIgnoringOtherApps:YES];																	\
		(x(win));																											\
		[NSApp run];																										\
	}																															\
}


#define APPPOPWINDOW(x)  \
int main(int argc, char *argv[], char**argp ){\
	@autoreleasepool {\
	int mask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask;		\
  	NSApplication *app = NSApplication.sharedApplication;\
  	NSW *win = [NSWindow.alloc initW4/+ (id) appWithBlock:(void(^)(void))blk;
//+ (id) appWithMenuBlock:(void(^)(void))blk;
//+ (id) appWithWindowBlock:(void(^)(void))blk;
//@end


NS_INLINE int fakeMain(int argc, char *argv[]) {

  return 1;
}

/*! A full fledged Cocoa app in TWO lines!   @code    #import <AtoZ/AtoZ.h>
                                                      AZINSTANTAPP(  win.bgC = YELLOW;  )           */

#define AZINSTANTAPP_INTERNAL(...)  \
int main(int argc, char *argv[]) { @autoreleasepool { AZSHAREDAPP;           \
\
    NSM	* menubar, * appMenu; NSMI * appMenuItem;           \
		[menubar = NSM.new addItem:appMenuItem = NSMI.new];													                      \
		[NSApp setMainMenu:menubar];	        																				                    \
		[appMenu = NSM.new addItem:\
    [NSMI.alloc initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"]];\
		[appMenuItem setSubmenu:appMenu];\
		NSW *win = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:1|2|8 backing:2 defer:YES];\
    win.alphaValue = 0; \
/*		[win cascadeTopLeftFromPoint:(NSP){20,20}];                                                       */\
		[win setTitle:AZPROCNAME];	win.backgroundColor = RED; [win setMovableByWindowBackground:YES];\
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];\
    /* [win makeKeyAndOrderFront:nil]; */\
    [NSApp  activateIgnoringOtherApps:YES];\
    [win fadeIn];\
    /* ({ */\
    (__VA_ARGS__)(); \
    /* });*/\
    [NSApp run];\
  }\
}
//#define ENCLOSEINVOIDBLOCK(...) ^{ __VA_ARGS__; }

#define AZINSTANTAPP(...)  AZINSTANTAPP_INTERNAL(__VA_ARGS__)

//ENCLOSEINVOIDBLOCK(x) AZScreenFrameUnderMenu()

