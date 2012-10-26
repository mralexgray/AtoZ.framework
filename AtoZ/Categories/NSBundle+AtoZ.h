//
//  NSBundle+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (AtoZ)

+ (NSS*) appSuppFolder;
+ (NSS*) appSuppDir;
+ (NSS*) applicationSupportFolder;
+ (NSS*) appSuppSubPathNamed: (NSS*)name;

+ (NSS*) calulatedBundleIDForPath: (NSS*)path;
- (NSA*) frameworkClasses;
- (NSA*) cacheImages;
- (void) cacheNamedImages;
- (NSArray *)recursivePathsForResourcesOfType:(NSString *)type inDirectory:(NSString *)directoryPath;

@end
