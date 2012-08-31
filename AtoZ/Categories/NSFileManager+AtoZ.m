
//  NSFileManager+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "NSFileManager+AtoZ.h"
#include <glob.h>

NSString *NSDocumentsFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

NSString *NSLibraryFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
}

NSString *NSTmpFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

NSString *NSBundleFolder()
{
	return [[NSBundle mainBundle] bundlePath];
}

NSString *NSDCIMFolder()
{
	return @"/var/mobile/Media/DCIM";
}


@implementation NSFileManager (AtoZ)


#pragma Globbing

- (NSArray*) arrayWithFilesMatchingPattern: (NSString*) pattern inDirectory: (NSString*) directory {

    NSMutableArray* files = [NSMutableArray array];
    glob_t gt;
    NSString* globPathComponent = [NSString stringWithFormat: @"/%@", pattern];
    NSString* expandedDirectory = [directory stringByExpandingTildeInPath];
    const char* fullPattern = [[expandedDirectory stringByAppendingPathComponent: globPathComponent] UTF8String];
    if (glob(fullPattern, 0, NULL, &gt) == 0) {
        int i;
        for (i=0; i<gt.gl_matchc; i++) {
            int len = strlen(gt.gl_pathv[i]);
            NSString* filename = [[NSFileManager defaultManager] stringWithFileSystemRepresentation: gt.gl_pathv[i] length: len];
            [files addObject: filename];
        }
    }
    globfree(&gt);
    return [NSArray arrayWithArray: files];
}

/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */



+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path
{
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
		if ([[file lastPathComponent] isEqualToString:fname])
			return [path stringByAppendingPathComponent:file];
	return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
	{
		BOOL isDir;
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir) [results addObject:file];
	}
	return results;
}

	// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
			[results addObject:[path stringByAppendingPathComponent:file]];
	return results;
}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

	// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}

@end
