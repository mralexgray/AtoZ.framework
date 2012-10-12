//
//  NSApplication+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kShowDockIconUserDefaultsKey;

@interface NSApplication (AtoZ)

+ (id)		infoValueForKey:(NSString *)key;
- (BOOL)	showsDockIcon;
- (void)	setShowsDockIcon:(BOOL)flag;
@end
