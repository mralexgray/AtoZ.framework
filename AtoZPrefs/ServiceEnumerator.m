//
//  ServiceEnumerator.m
//  BrewPub
//
//  Created by Josh Butts on 3/17/13.
//  Copyright (c) 2013 Josh Butts. All rights reserved.
//

#import "ServiceEnumerator.h"
#import "Service.h"

@implementation ServiceEnumerator

+ (NSMutableArray *) enumerateWithBundle:(NSBundle *)bundle {

    [self createServicesDirectory];
    NSMutableArray *services 		= NSMutableArray.new;
    NSFileManager *fileManager 	= NSFileManager.new;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:@"/usr/local/etc/AtoZPrefs" error:nil];
    for (NSString *file in files) {
		NSString *extension = [file substringFromIndex:[file length] - 5];
      if (![@"plist" isEqualToString:extension]) return;
		NSString *fullFilePath 					= [NSString stringWithFormat:@"%@%@", @"/usr/local/etc/AtoZPrefs/", file];
		NSDictionary *plistData 				= [NSDictionary.alloc initWithContentsOfFile: fullFilePath];
		NSMutableDictionary *AtoZPrefsData 	= [plistData objectForKey:@"AtoZPrefs"];
		if (AtoZPrefsData == nil) continue;
		[AtoZPrefsData setObject: file forKey:@"plist"];
		BOOL imageIsLoadable = [fileManager fileExistsAtPath:[AtoZPrefsData objectForKey:@"image"]];
		NSImage *image;
		if (imageIsLoadable)
			image = [NSImage.alloc initWithContentsOfFile:[AtoZPrefsData objectForKey:@"image"]];
		else {
			 NSString *resourcePath = [bundle resourcePath];
			 NSString *iconPath = [NSString stringWithFormat:@"%@%@%@", resourcePath, @"/", [AtoZPrefsData objectForKey:@"image"]];
			 image = [[NSImage alloc] initWithContentsOfFile: iconPath];
		}
		if (image == nil)	 continue;
		else	[AtoZPrefsData setObject:image forKey:@"image"];
		Service *service = [Service.alloc initWithOptions:AtoZPrefsData];
		[services addObject:service];
	}
   return services;
}

+ (void) createServicesDirectory {

	NSError *e;
	[NSFileManager.new createDirectoryAtURL:[NSURL URLWithString:@"/usr/local/etc/AtoZPrefs"] withIntermediateDirectories:YES attributes:nil error:&e];
	if (e) { NSBeep(); NSLog(@"%@",e); }

}

@end
