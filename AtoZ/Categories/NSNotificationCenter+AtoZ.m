//
//  NSNotificationCenter+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import "AtoZ.h"
#import "NSNotificationCenter+AtoZ.h"


void PostUserNote(NSString*note, ...){ azva_list_to_nsarray(note,vals);

	if (vals.count) [NSUserNotificationCenter postNote:vals[0]?:@"NULL NOTIFICATION" info:vals[1]?:@"No additional information provided.."];
}


@implementation																				NSUserNotificationCenter (MBWebSocketServer)

+ (void) postNote:(NSS*)t info:(NSS*)i {

	SEL sel = @selector(userNotificationCenter:shouldPresentNotification:);

	id<NSUserNotificationCenterDelegate> del = self.defaultUserNotificationCenter.delegate ?: (id<NSUserNotificationCenterDelegate>)self.defaultUserNotificationCenter;
	if (![del respondsToSelector:sel]) {
		IMP imp = imp_implementationWithBlock(^BOOL(id _self, SEL sel, NSUserNotificationCenter*c,NSUserNotification*n){ return YES; });
		class_addMethod([del class],sel,imp,"c@:@:@");
		//	  NSLog(@"delegate:%@ responds..... %@",self.defaultUserNotificationCenter.delegate, [del respondsToSelector:sel] ? @"YES": @"NO");
	}
	NSUserNotification *note	= NSUserNotification.new;
	note.contentImage					= NSIMG.randomMonoIcon;
	note.title								= t;
	note.informativeText			= i ?: AZAPPINFO[@"CFBundleName"] ?: [AZAPP_ID pathExtension];
	note.soundName						= NSUserNotificationDefaultSoundName;
	[self.defaultUserNotificationCenter deliverNotification:note];
	NSLog(@"Posted user notification %@", note);

}														  @end


@implementation NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject
{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
	[self postNotificationOnMainThread:notification];
}

- (void)postNotificationOnMainThreadName:(NSS*)aName object:(id)anObject userInfo:(NSD*)aUserInfo
{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[self postNotificationOnMainThread:notification];
}

@end
@implementation NSNotification (AtoZ)

- (NSS*) stringForKey:(NSS*)aKey { return [NSS stringWithData:[self.userInfo objectForKey: aKey] encoding:NSASCIIStringEncoding]; }

@end
