//
//  SampleObject.h
//  CoreAnimationListView
//
//  Created by Patrick Geiller on 07/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZObject : NSObject

// Shared instance is the object modified after each key change
+ (AZObject*)sharedInstance;
// After being notified of change to the shared instance, call this to get last modified key of last modified instance
+ (AZObject*)lastModifiedInstance;
+ (NSString*)lastModifiedKey;
+ (void)setLastModifiedKey:(NSString*)key forInstance:(id)object;


@property (nonatomic, retain)	NSString*	name;
@property (nonatomic, retain)	NSString*	description;
@property (nonatomic, retain)	NSColor*	color;


@end
