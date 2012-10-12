#import "AZInstantApp.h"

static const NSString *start = @"echo '\
\
#import <Cocoa/Cocoa.h> int main ()\
{\
	[NSAutoreleasePool new]; [NSApplication sharedApplication];\
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular]; \
	id menubar = [[NSMenu new] autorelease];\
	id appMenuItem = [[NSMenuItem new] autorelease];\
	[menubar addItem:appMenuItem];    [NSApp setMainMenu:menubar];\
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
@implementation AZInstantApp

- (id)init
{
    self = [super init];
    if (self) {
        [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:@[start]];
    }
    return self;
}

@end