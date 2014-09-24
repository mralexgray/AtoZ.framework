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
+ (NSA*) bundlesConformingTo:(Protocol*)p atPath:(NSS*)path;
- (NSA*) pluginsConformingTo:(Protocol*)p;
@prop_RO NSA* plugins;
@end

@interface NSBundle (AtoZ)

+ (void) loadAZFrameworks;

/*! @see __TEXT", "__info_plist etc */ + infoPlist;

/// :@"Fraise" => NSBundle </Volumes/4X4/Applications/Fraise.app> (not yet loaded)
+ (NSB*) bundleForApplicationName:(NSS*)appName;

///  :@"Fraise" -> org.fraise.Fraise
+ (NSS*) bundleIdentifierForApplicationName:(NSS*)appName;

//- (NSD*)     infoDictionaryWithIdentifier:(NSS*)identifier;

/// (  "NSBundle </Users/localadmin/Library/Frameworks/AtoZBezierPath.framework> (loaded)", ... "NSBundle </Users/localadmin/Library/Frameworks/Zangetsu.framework> (loaded)" )
+ (NSA*) azFrameworkBundles;

///  ( AtoZ, AtoZAppKit, .. UIKit, Zangetsu )
+ (NSA*) azFrameworkNames;

/// ( "us.pandamonia.BlocksKit", ... "com.twitter.TwUI" )
+ (NSA*) azFrameworkIds;

/// conveniencer for azFrameworkIds.kvc(@"infoDictionary")
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

+ resourceOfClass:(Class)rClass inBundleWithClass:(Class)k withName:(NSString*)n init:(SEL)method;
- (NSA*) cacheImages;
- (void) cacheNamedImages;
- (NSA*) recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath;
- (NSS*) recursiveSearchForPathOfResourceNamed:(NSS*)name;

// [AZFWORKBUNDLE resourcesWithExtensions:@[@"caf"]]; ->  ( ...,  "/Users/localadmin/Library/Frameworks/AtoZ.framework/Resources/Sounds/short_low_high.caf", ... )
- (NSA*) resourcesWithExtensions:(NSA*)exts; // OK


@property (RONLY) NSA* imageResources; // BROKEN
/*! @brief	Returns the path to the application's icon file, derived from the .icns file specified by "CFBundleIconFile" in the application's Info.plist.	*/
@property (RONLY) NSS * appIconPath;
/*!
 @brief	Returns the image in the file specified by -appIconPath.	*/
@prop_RO NSIMG * appIcon;

// Returns first Info.plist found in bundle.
@prop_RO NSS * infoPlistPath;
@end


//- (NSA*) frameworkClasses;
//+ (NSMutableArray *)systemFrameworks;

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



