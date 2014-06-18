//
//  NSBundle+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (AtoZBundles)

+ (NSA*) bundlesFromStdin;
@prop_RO NSA* plugins;
- (NSA*) pluginsConformingTo:(Protocol*)p;
+ (NSA*) bundlesConformingTo:(Protocol*)p atPath:(NSS*)path;
@end

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

/*! from "__ARCLite__" to ZoneTotalDiff  ALL exported symbols.  Useless. */
- (NSA*) definedClasses;

/*! ( ..., "/System/Library/Frameworks/AVFoundation.framework",
           "/Volumes/4X4/DerivedData/AtoZ-hfqteqfcvjfinlajqwkydsqyzpiz/Build/Products/Debug/Zangetsu.framework"
) */
+ (NSA*) allFrameworkPaths;

+ (NSB*) frameworkBundleNamed:(NSS*)name;
+ (NSS*) appSuppDir;
+ (NSS*) appSuppFolder;
+ (NSS*) applicationSupportFolder;
+ (NSS*) appSuppSubPathNamed: (NSS*)name;

/*! Tries to figure out bundle from path...
@c [NSBundle calulatedBundleIDForPath:@"/Applications/TextMate.app"] -> com.macromates.textmate */
+ (NSS*) calulatedBundleIDForPath: (NSS*)path;

+ (INST) bundleForExecutable:(NSS*)path;


- (NSA*) cacheImages;
- (void) cacheNamedImages;
- (NSA*) recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath;
- (NSS*) recursiveSearchForPathOfResourceNamed:(NSS*)name;

- (NSA*) resourcesWithExtensions:(NSA*)exts; // BROKEN



@property (RONLY) NSA* imageResources; // BROKEN
//- (NSA*) frameworkClasses;
//+ (NSMutableArray *)systemFrameworks;
/*! @brief	Returns the path to the application's icon file, derived from the .icns file specified by "CFBundleIconFile" in the application's Info.plist.	*/
@property (RONLY) NSS * appIconPath;
/*!
 @brief	Returns the image in the file specified by -appIconPath.	*/
@prop_RO NSIMG * appIcon;

// Returns first Info.plist found in bundle.
@prop_RO NSS * infoPlistPath;
@end



    #define INITPLUGIN(PROTO,NAME)   id<PROTO>NAME = CONFORMANTBUNDLEOBJ(PROTO)

#define INITWITHPATH(PROTO,NAME,PATH) id <PROTO> NAME = [[[NSBundle bundleWithPath:PATH] principalClass] new]

#define CONFORMANTBUNDLEOBJ(PROTO)   ({ __block id<PROTO> x = nil;\
[[NSBundle pathsForResourcesOfType : @"plugin" inDirectory:NSBundle.mainBundle.builtInPlugInsPath]\
        enumerateObjectsUsingBlock : ^(id obj,NSUInteger idx,BOOL*stop){\
           NSBundle * bundlePlugin = [NSBundle bundleWithPath:obj];\
                      Class pClass = bundlePlugin.principalClass;\
                             *stop = ([pClass conformsToProtocol:@protocol(PROTO)]\
                                &&   ((x = pClass.new))); }]; x; })

NS_INLINE NSA *        BundlesFromStdin() {


  NSArray *args = NSProcessInfo.processInfo.arguments;
     // Now create a bundle at the specified path (retrieved from input argument)
  if (args.count < 2) return NSLogC(@"Please provide a path for the bundle"), nil;
  return [args mapArray:^id(id o) {
    NSB *b = [NSB bundleWithPath:o];
    if (!b) return NSLogC(@"Bundle not found at path"), nil; // Dynamically load bundle INITPLUGIN(GV,gv);
    NSError *err;
    BOOL loaded = [b loadAndReturnError:&err];
    return !loaded ? NSLogC(@"Error = %@", err.localizedDescription), (id)nil :
                     NSLogC(@"Returning loaded bundle: %@",b),  b;
  }];
}
NS_INLINE NSA *       FilesAt(NSString*p) {   NSMutableArray *ps = NSMutableArray.new;
  [[NSFileManager.defaultManager contentsOfDirectoryAtPath:p error:nil]
    enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { [ps addObject:[p stringByAppendingPathComponent:obj]]; }]; return ps;
}
NS_INLINE NSA * BundlePlugins(NSBundle*b) {   NSMutableArray *bundles = NSMutableArray.new;

  [FilesAt(b.builtInPlugInsPath) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSBundle *bndl = [NSBundle bundleWithPath:obj];
    if (bndl) [bundles addObject:bndl];
  }]; return bundles;
}
NS_INLINE NSA * BundlePluginsConformingTo(NSBundle*b,    Protocol*p) { NSMutableArray *bundles = NSMutableArray.new;

  [BundlePlugins(b) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    Class x = [obj principalClass];
    if ([x conformsToProtocol:p]) [bundles addObject:x];
  }];return bundles;
}
NS_INLINE NSA * BundlesAtPathConformingTo(NSString*path, Protocol*p) { NSMutableArray *bundles = NSMutableArray.new;
  [FilesAt(path) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSBundle *tryB = [NSBundle bundleWithPath:obj];
    if (!tryB) return;
    Class x = [tryB principalClass];
    if ([x conformsToProtocol:p]) [bundles addObject:tryB];
  }];return bundles;
}



