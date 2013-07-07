//
//  AZInstantApp.h
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//



#import <Foundation/Foundation.h>

// USAGE   APPWITHBLOCK( ^{ NSLog(@"Hige vageen"); }) 


#define NEWSTICKYVIEW ^{\
	NSW *win = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:0|1|2|8 backing:2 defer:NO];\
	win.backgroundColor = CLEAR;\
	win.contentView = [AZStickyNoteView.alloc initWithFrame:win.contentRect];\
	[win setOpaque:NO];\
	[win setMovableByWindowBackground:YES];\
	[win makeKeyAndOrderFront:nil];\
	return win; \
}()\


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

//#define SINGLE_ARG(...) __VA_ARGS__

//#define APPWITHBLOCKWINDOW(_x_) REALAPPWITHBLOCKWINDOW(PARENTHIZE(_x_))

#define APPWITHBLOCKWINDOW(_x_) 																				\
int main(int argc, char *argv[]) {	@autoreleasepool {																	\
		AZSHAREDAPP; NSM *menubar,*appMenu; NSMI *appMenuItem; NSW* win; NSR r;										\
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];												\
		[menubar = NSM.new addItem:appMenuItem = NSMI.new];	[NSApp setMainMenu:menubar];						\
		[appMenu = NSM.new addItem: 																								\
			[NSMI.alloc initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"]];				\
		[appMenuItem setSubmenu:appMenu]; menubar.dark = YES; 															\
		win = [NSW.alloc initWithContentRect:r = AZRectFromDim(200) styleMask:0|1|2|8 backing:2 defer:NO];	\
		[win cascadeTopLeftFromPoint:NSMakePoint(20,20)];																	\
		[win setPropertiesWithDictionary:@{@"title" : AZPROCNAME, @"backgroundColor":RED}];						\
		NSC* c = PINK;	\
		/*\
		/ [NSC colorWithPatternImage:[NSIMG imageNamed:@"darklinen"]];										*/\
		id v = [AZSimpleView withFrame:win.contentRect color:c];															\
		[win setContentView:v];\
		[NSImageView addImageViewWithImage:[NSIMG imageNamed:@"1"] toView:win.contentView];						\
		[win setMovableByWindowBackground:YES];																				\
		[win makeKeyAndOrderFront:nil]; [NSApp activateIgnoringOtherApps:YES];										\
		_x_(win);	\
		[NSApp run];																								\
}	}


#define APPPOPWINDOW(x)  \
int main(int argc, char *argv[], char**argp ){\
	@autoreleasepool {\
	int mask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask;		\
  	NSApplication *app = NSApplication.sharedApplication;\
  	NSW *win = [NSWindow.alloc initWithContentRect:AZRectFromDim(300) styleMask:mask backing:NSBackingStoreBuffered defer:NO];\
	[win center];	[win setLevel: NSFloatingWindowLevel];	[win makeKeyAndOrderFront: nil]; x(win); 	[app run];	}	return 0;	}
	

@interface AZInstantApp : NSObject

//+ (id) appWithBlock:(void(^)(void))blk;
//+ (id) appWithMenuBlock:(void(^)(void))blk;
//+ (id) appWithWindowBlock:(void(^)(void))blk;

@end