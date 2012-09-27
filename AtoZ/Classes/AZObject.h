//
//  SampleObject.h
//  CoreAnimationListView
//
//  Created by Patrick Geiller on 07/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AZObject : NSObject <NSCoding,NSCopying,NSFastEnumeration>
{}
// Shared instance is the object modified after each key change
//+ (AZObject*)sharedInstance;

//	After being notified of change to the shared instance,
//	call this to get last modified key of last modified instance
//+ (AZObject*)lastModifiedInstance;
//+ (NSString*)lastModifiedKey;


@property (nonatomic, retain) NSString *lastModifiedKey;

@property (nonatomic, retain) AZObject *lastModifiedInstance;
@property (nonatomic, retain) AZObject *sharedInstance;
@property (nonatomic, retain) NSString *uniqueID;


@end
