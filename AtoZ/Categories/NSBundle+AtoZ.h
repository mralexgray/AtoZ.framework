//
//  NSBundle+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (AtoZ)

- (NSA*) frameworks;
- (NSA*) frameworkIdentifiers;
- (NSA*) frameworkInfoDictionaries;
- (NSD*) infoDictionaryWithIdentifier:(NSS*)identifier;
+ (void) loadAZFrameworks;

+ (NSBundle*) frameworkBundleNamed:(NSS*)name;
+ (NSS*) appSuppFolder;
+ (NSS*) appSuppDir;
+ (NSS*) applicationSupportFolder;
+ (NSS*) appSuppSubPathNamed: (NSS*)name;

+ (NSS*) calulatedBundleIDForPath: (NSS*)path;
- (NSA*)definedClasses;

//- (NSA*) frameworkClasses;
- (NSA*) cacheImages;
- (void) cacheNamedImages;
- (NSA*)recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath;
- (NSS *)recursiveSearchForPathOfResourceNamed:(NSS*)name;

//+ (NSMutableArray *)systemFrameworks;

/*!
 @brief	Returns the path to the application's icon file, derived
 from the .icns file specified by "CFBundleIconFile" in the application's
 Info.plist.	*/
- (NSString*)appIconPath ;

/*!
 @brief	Returns the image in the file specified by -appIconPath.	*/
- (NSImage*)appIcon ;

@end
