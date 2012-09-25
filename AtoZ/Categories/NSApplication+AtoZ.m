//
//  NSApplication+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSApplication+AtoZ.h"

#import "AtoZ.h"

NSString *const kShowDockIconUserDefaultsKey = @"ShowDockIcon";


@implementation NSApplication (AtoZ)

+ (id)infoValueForKey:(NSString *)key {
    if ([[NSBundle mainBundle] localizedInfoDictionary][key]) {
        return [[NSBundle mainBundle] localizedInfoDictionary][key];
    }

    return [[NSBundle mainBundle] infoDictionary][key];
}

- (BOOL)showsDockIcon {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowDockIconUserDefaultsKey];
}

    /** this should be called from the application delegate's applicationDidFinishLaunching method or from some controller object's awakeFromNib method neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a> */
	
- (void)setShowsDockIcon:(BOOL)flag {

    if (flag) {
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        // display dock icon
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
        // enable menu bar
        SetSystemUIMode(kUIModeNormal, 0);

        // switch to Dock.app
        if ([[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil] == NO) {
            NSLog(@"Could not launch application with identifier 'com.apple.dock'.");
        }

        // switch back
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    }
}


@end
