//
//  NSBundle+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSBundle+AtoZ.h"

@implementation NSBundle (AtoZ)

/**	Returns the support folder for the application, used to store the Core Data	store file.  This code uses a folder named "ArtGallery" for
 the content, either in the NSApplicationSupportDirectory location or (if the former cannot be found), the system's temporary directory. */

+ (NSString*) applicationSupportFolder {
	//Create App directory if not exists:
	NSFileManager* fileManager = [[NSFileManager alloc] init];
	NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
	NSArray* urlPaths = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
	NSURL* appDirectory = [[urlPaths objectAtIndex:0] URLByAppendingPathComponent:bundleID isDirectory:YES];
	//TODO: handle the error
	if (![fileManager fileExistsAtPath:[appDirectory path]]) {
		[fileManager createDirectoryAtURL:appDirectory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	return  [appDirectory path];
}
//	//build path
//    NSArray *supports = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
//    NSString *dir = supports[0];
//    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
//    NSString *file = [dir stringByAppendingPathComponent:identifier];
//
//		//open plist
//    NSMutableDictionary *plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:file]
//
//
//
//	NSString *basePath = ([paths count] > 0 ? paths[0] : NSTemporaryDirectory() );
//	return [basePath stringByAppendingPathComponent:[[NSBundle mainBundle]bundleIdentifier]];
//}

+ (NSString*) calulatedBundleIDForPath:(NSString*)path
{
	return [[self class] bundleWithPath:path] ? [[[self class] bundleWithPath:path] bundleIdentifier]
									  		  : @"unknown";
}
@end
