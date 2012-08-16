//
//  SampleObject.m
//  CoreAnimationListView
//
//  Created by Patrick Geiller on 07/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AZObject.h"


@implementation AZObject

@synthesize name, description, color;



- (id)init
{
	if (![super init])	return nil;
	
	self.name		= @"Sample";
	self.description = @"description";
	self.color		= [NSColor blueColor];
	return	self;
}


/* 
	Key Value Bastard Observing (KVBO) is everything below.
	
	We overload setValue:forKey: to listen to all changes.

	We save self and the key name to static variables with the class method setLastModifiedKey:forInstance:

	setValue:forKey: then sets a new value for a dummy key (keyChanged) on a shared instance (a singleton for the observed class, here SampleObject).
	Changing this dummy key's value dispatches KVO notifications of our shared instance :any observer of that shared instance will receive all notifications of all changes of all instances of SampleObject.
	
	To receive KVBO notifications, register as an observer on the shared instance's dummy key.
	You'll need to setup a dummy key, its set method will be the notification recipient of KVBO.

		[myObserver bind:@"myKey" toObject:[SampleObject sharedInstance] withKeyPath:@"keyChanged" options:nil];
		
	myObserver's setMyKey will then be called for each change of any attribute of any instance.
	
*/

//
// setValue:forKey:
//	overload to dispatch change notification to our shared instance
//
- (void)setValue:(id)value forKey:(NSString*)key
{
	[super setValue:value forKey:key];
	
	// If this is the shared instance, don't go any further
	if (self == [AZObject sharedInstance])	return;
	
	// Class method - set last modified
	[AZObject setLastModifiedKey:key forInstance:self];

	// Instance method - dummy setValue to dispatch notifications 
	[[AZObject sharedInstance] setValue:self forKey:@"keyChanged"];
}



//
// sharedInstance
//	returns our the singleton instance that will be used for global observing
//
+ (AZObject*)sharedInstance
{
	static AZObject* singleton;
	@synchronized(self)
	{
		if (!singleton)
			singleton = [[AZObject alloc] init];
		return singleton;
	}
	return singleton;
}

//
// class methods for last modified key and instance - these are held as static data
//
static AZObject* lastModifiedInstance;
static NSString* lastModifiedKey;
+ (void)setLastModifiedKey:(NSString*)key forInstance:(id)object
{
	lastModifiedKey			= key;
	lastModifiedInstance	= object;
}
+ (AZObject*)lastModifiedInstance
{
	return lastModifiedInstance;
}
+ (NSString*)lastModifiedKey
{
	return lastModifiedKey;
}

// keyChanged - dummy key set by setValue:forKey: on our shared instance, used to dispatch KVO notifications
- (AZObject*)keyChanged
{
	return [AZObject sharedInstance];
}
- (void)setKeyChanged:(AZObject*)sampleObject
{
}


@end
