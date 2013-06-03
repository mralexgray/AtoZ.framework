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
		menubar.isDark = YES; \
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


@interface AZInstantApp : NSObject

+ (id) appWithBlock:(void(^)(void))blk;

@end
