
//  AtoZXcode.m in AtoZXcode
//  Created by Alex Gray on 10/16/13.   Copyright (c) 2013 Alex Gray. All rights reserved.

#import <AppKit/AppKit.h>

@interface AtoZXcode : NSObject @property (strong) NSBundle *bundle; @end

static AtoZXcode *sharedPlugin; @implementation AtoZXcode

+ (void) pluginDidLoad:(NSBundle*)plugin {

    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    if ([NSBundle.mainBundle.infoDictionary[@"CFBundleName"] isEqualToString:@"Xcode"])
        dispatch_once(&onceToken, ^{ sharedPlugin = [self.alloc initWithBundle:plugin]; });
}
- (id) initWithBundle:(NSBundle *)plugin {   if (self != super.init) return nil;

    self.bundle = plugin;            // reference to plugin's bundle, for resource acccess

    NSMenuItem *xMenu, *actionMenu;  // Just a sample Menu Item. Create your own menus, initialize UI, etc.
     if ((xMenu = [[NSApp mainMenu] itemWithTitle:@"File"])) {
         [xMenu.submenu addItem:NSMenuItem.separatorItem];
         [xMenu.submenu addItem:actionMenu = [NSMenuItem.alloc initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""]];
         [actionMenu setTarget:self];
    }
	NSLog(@"[%@] Plugin Loaded AOK!", _bundle.bundleIdentifier.pathExtension);
    return self;
}
- (void) doMenuAction {              // Sample Action, for menu item:

    [[NSAlert alertWithMessageText:[NSString stringWithFormat:@"Hello, from %@", _bundle.bundleIdentifier]
                      defaultButton:@"Rad!" alternateButton:@"Drat!" otherButton:nil informativeTextWithFormat:@""]runModal];
}
- (void) dealloc { [NSNotificationCenter.defaultCenter removeObserver:self]; }

@end
