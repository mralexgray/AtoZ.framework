//
//  NSBundle+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (AtoZ)

/*
 BuildMachineOSBuild = 13A598;
    CFBundleDevelopmentRegion = English;
    CFBundleExecutable = "dump_info_plist";
    CFBundleIdentifier = "ch.pitaya.dump_info_plist";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = "dump_info_plist";
    CFBundleShortVersionString = "1.2.3";
    CFBundleVersion = "1.2.3";
    DTCompiler = "com.apple.compilers.llvm.clang.1_0";
    DTPlatformBuild = 5A2053;
    DTPlatformVersion = GM;
    DTSDKBuild = 13A595;
    DTSDKName = "macosx10.9";
    DTXcode = 0501;
    DTXcodeBuild = 5A2053;
*/
+   (id) infoPlist;
+ (void) loadAZFrameworks;
+ (NSB*) bundleForApplicationName:					(NSS*)appName;
//- (NSD*) infoDictionaryWithIdentifier:			(NSS*)identifier;
+ (NSS*) bundleIdentifierForApplicationName:	(NSS*)appName;

+ (NSA*) azFrameworkBundles;
+ (NSA*) azFrameworks;
+ (NSA*) azFrameworkIds;
+ (NSA*) azFrameworkInfos;
+ (NSD*) azFrameworkInfoForId:(NSS*)bId;

- (NSA*) definedClasses;

+ (NSA*) allFrameworkPaths;
+ (NSB*) frameworkBundleNamed:(NSS*)name;
+ (NSS*) appSuppDir;
+ (NSS*) appSuppFolder;
+ (NSS*) applicationSupportFolder;
+ (NSS*) appSuppSubPathNamed: (NSS*)name;
+ (NSS*) calulatedBundleIDForPath: (NSS*)path;

- (NSA*) cacheImages;
- (void) cacheNamedImages;
- (NSA*) recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath;
- (NSS*) recursiveSearchForPathOfResourceNamed:(NSS*)name;

- (NSA*) resourcesWithExtensions:(NSA*)exts;
@property (RONLY) NSA* imageResources;
//- (NSA*) frameworkClasses;
//+ (NSMutableArray *)systemFrameworks;
/*! @brief	Returns the path to the application's icon file, derived from the .icns file specified by "CFBundleIconFile" in the application's Info.plist.	*/
@property (RONLY) NSS * appIconPath;
/*!
 @brief	Returns the image in the file specified by -appIconPath.	*/
@property (RONLY) NSIMG * appIcon;

@end
