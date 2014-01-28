#import "AZInstantApp.h"

static const NSString *start = @"echo '\
\
#import <Cocoa/Cocoa.h> int main ()\
{\
	[NSAutoreleasePool new]; [NSApplication sharedApplication];\
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular]; \
	id menubar = [[NSMenu new] autorelease];\
	id appMenuItem = [[NSMenuItem new] autorelease];\
	[menubar addItem:appMenuItem];	[NSApp setMainMenu:menubar];\
	id appMenu = [[NSMenu new] autorelease];\
	id appName = [[NSProcessInfo processInfo] processName];\
	id quitMenuItem = [[[NSMenuItem alloc] initWithTitle: $(@\"Quit %@\",appname) action:@selector(terminate:) keyEquivalent:@\"q\"] autorelease];\
	[appMenu addItem:quitMenuItem];\
	[appMenuItem setSubmenu:appMenu];\
	id window = [[[NSWindow alloc] initWithContentRect:AZScreenFrame() styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];\
	[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];\
	[window setTitle:appName];\
	[window makeKeyAndOrderFront:nil];\
	[NSApp activateIgnoringOtherApps:YES];\
	[NSApp run];\
return 0;}' | gcc -framework Cocoa -x objective-c -o MinimalistCocoaApp - ; ./MinimalistCocoaApp";
@interface AZInstantApp : NSO
@end

@implementation AZInstantApp

- (id)init
{
	self = [super init];
	if (self) {
		[NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:@[start]];
	}
	return self;
}
+ (id) appWithBlock:(void(^)(void))blk {

	id whatever;
	return whatever;
}
/*
#define APPWITHBLOCKWINDOW(x)  \
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
		(x(win));\
		[NSApp run];\
	}\
}\

#define APPPOPWINDOW(x)  \
int main(int argc, char *argv[], char**argp ){\
	@autoreleasepool {\
	int mask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask;		\
  	NSApplication *app = NSApplication.sharedApplication;\
  	NSW *win = [NSWindow.alloc initWithContentRect:AZRectFromDim(300) styleMask:mask backing:NSBackingStoreBuffered defer:NO];\
	[win center];	[win setLevel: NSFloatingWindowLevel];	[win makeKeyAndOrderFront: nil]; x(win); 	[app run];	}	return 0;	}
	

+ (id) appWithBlock:(NSS*(^)(void))blk;
+ (id) appWithMenuWindowBlock:(NSS*(^)(void))blk;
+ (id) appWindowBlock:(NSS*(^)(void))blk;

*/
@end

