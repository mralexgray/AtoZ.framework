//
//  NSApplication+AppInfo.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSApplication+AppInfo.h"

@implementation NSApplication (AppInfo)

- (NSString*) appName {
	if (SDInfoPlistValueForKey(@"CFBundleName"))
		return SDInfoPlistValueForKey(@"CFBundleName");
	else
		return [[[NSFileManager defaultManager] displayNameAtPath:[[NSBundle mainBundle] bundlePath]] stringByDeletingPathExtension];
}

- (NSString*) appDisplayName {
	if (SDInfoPlistValueForKey(@"CFBundleDisplayName"))
		return SDInfoPlistValueForKey(@"CFBundleDisplayName");
	else
		return [NSApp appName];
}

- (NSString*) appVersion {
	return SDInfoPlistValueForKey(@"CFBundleVersion");
}

- (NSString*) appSupportSubdirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *appSupportFolder = [paths firstObject];
	NSString *appSupportSubdirectory = [appSupportFolder stringByAppendingPathComponent:[NSApp appDisplayName]];
	
	NSError *error = nil;
	[[NSFileManager defaultManager] createDirectoryAtPath:appSupportSubdirectory withIntermediateDirectories:YES attributes:nil error:&error];
	if (error) {
		[NSException raise:@"SDCannotCreateDir"
					format:@"Cannot create folder [%@]", appSupportSubdirectory];
		return nil;
	}
	
	return appSupportSubdirectory;
}

- (void) registerDefaultsFromMainBundleFile:(NSString*)defaultsFilename {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:[defaultsFilename stringByDeletingPathExtension]
														  ofType:[defaultsFilename pathExtension]];
	
	NSDictionary *initialValues = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:initialValues];
}

@end
