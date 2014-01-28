//
//  NSApplication+AppInfo.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDToolkit.h"

@interface NSApplication (AppInfo)

- (NSString*) appName;
- (NSString*) appDisplayName;
- (NSString*) appVersion;
- (NSString*) appSupportSubdirectory;

- (void) registerDefaultsFromMainBundleFile:(NSString*)defaultsFilename;

@end
