//
//  NSNotificationCenter+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import "AtoZUmbrella.h"
#import "AtoZTypes.h"
#import <Foundation/Foundation.h>


// PostUserNote(@"some shit happneed", @"go cry about it");

void PostUserNote(NSString*note, ...);

// [NSUserNotificationCenter postNote:@"Connection Farted" info:@"some more dumb info"];

@interface NSUserNotificationCenter (MBWebSocketServer)
+ (void) postNote:(NSS*)t info:(NSS*)i;
@end

@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject;
- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject userInfo:(NSD*)aUserInfo;


@end
@interface NSNotification (AtoZ)

- (NSS*) stringForKey:(NSS*)key;

@end
