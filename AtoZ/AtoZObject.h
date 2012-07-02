//
//  AtoZObject.h
//  AtoZ
//
//  Created by Alex Gray on 6/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AtoZObject : AtoZ {

	NSString*	name;
	NSString*	description;
	float		angle;
}

// Shared instance is the object modified after each key change
+ (SampleObject*)sharedInstance;

// After being notified of change to the shared instance, call this to get last modified key of last modified instance

+ (SampleObject*)lastModifiedInstance;

+ (NSString*)lastModifiedKey;

+ (void)setLastModifiedKey:(NSString*)key forInstance:(id)object;


@property (copy)	NSString*	name;
@property (copy)	NSString*	description;
@property			float		angle;

@end
