//
//  NSNotificationCenter+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject;
- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject userInfo:(NSD*)aUserInfo;


@end
@interface NSNotification (AtoZ)

- (NSS*) stringForKey:(NSS*)key;

@end
