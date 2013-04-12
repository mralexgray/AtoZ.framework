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
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;


@end
@interface NSNotification (AtoZ)

- (NSS*) stringForKey:(NSS*)key;

@end
