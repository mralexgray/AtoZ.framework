//
//  NotificationCenterSpy.m
//
//  Created by Javier Soto on 9/13/11.
//
#import <AtoZ/AtoZ.h>
#import "NotificationCenterSpy.h"

static NotificationCenterSpy *sharedInstance = nil;

@interface NotificationCenterSpy ()

@property (NATOM, STRNG) NSA *ignoredNotes, *defaultIgnores;

@property (nonatomic, assign, getter=isSpying) BOOL spying;
- (void)toggleSpyingAllNotifications;

@end

@implementation NotificationCenterSpy

@synthesize spying;
+ (NotificationCenterSpy *)sharedNotificationCenterSpy {
	
	static dispatch_once_t sharedToken;
	dispatch_once(&sharedToken, ^{
		sharedInstance = self.new;
	});
	
	return sharedInstance;
}
+ (void)   toggle { [self toggleSpyingAllNotificationsIgnoring:@[] ignoreOverlyVerbose:YES]; }
- (NSA*) defaultIgnores { return _defaultIgnores = _defaultIgnores ?: @[@"NSApplicationWillUpdateNotification", @"NSWindowDidUpdateNotification", @"NSApplicationDidUpdateNotification"]; }

+ (void)toggleSpyingAllNotifications {
	[[self sharedNotificationCenterSpy] toggleSpyingAllNotifications];
}

+ (void)toggleSpyingAllNotificationsIgnoring:(NSA*)notes ignoreOverlyVerbose:(BOOL)ignore
{
	NSA * combined = notes ? [NSA arrayWithArrays:@[notes,self.sharedNotificationCenterSpy.defaultIgnores]] : self.sharedNotificationCenterSpy.defaultIgnores;
	self.sharedNotificationCenterSpy.ignoredNotes = ignore ? combined : notes;
	[[self sharedNotificationCenterSpy] toggleSpyingAllNotifications];
}
- (void)toggleSpyingAllNotifications {
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	if (self.spying) {
		[nc removeObserver:self];
		self.spying = NO;
	} else { 
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:nil object:nil];
		self.spying = YES;
	}
}

- (void)receivedNotification:(NSNotification *)notification
{
	if ( [self.ignoredNotes doesNotContainObject:[notification name]] )	NSLog(@"SPIED: %@", [notification name]);
	//NSLog(@"Received notification: %@ from object: %@", [notification name], [notification object]);
}

@end
