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

+ (NSString*) appSuppSubPathNamed:(NSString*)name;
{
	return [[[self class] applicationSupportFolder]stringByAppendingPathComponent:name];
}

+ (NSString *)appSuppDir {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:[[NSBundle bundleForClass:[AtoZ class]] bundleIdentifier]];
}
+ (NSString*) appSuppFolder {
	return [[self class] applicationSupportFolder];
}
+ (NSString*) applicationSupportFolder {
	//Create App directory if not exists:
	NSFileManager* fileManager = [NSFileManager new];
	NSString* bundleID = [[NSBundle bundleForClass:[AtoZ class]] bundleIdentifier];
	NSArray* urlPaths = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
	NSURL* appDirectory = [urlPaths[0] URLByAppendingPathComponent:bundleID isDirectory:YES];
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


- (NSArray *)frameworkClasses;
{

    NSMutableArray *array = [NSMutableArray array];
//    int numberOfClasses = objc_getClassList(NULL, 0);
//    Class *classes = calloc(sizeof(Class), numberOfClasses);
//    numberOfClasses = objc_getClassList(classes, numberOfClasses);
//    for (int i = 0; i < numberOfClasses; ++i) {
//        Class c = classes[i];
//        if ([NSBundle bundleForClass:c] == self) {
//            [array addObject:c];
//        }
//    }
//    free(classes);
    return array;
}

- (NSS *)recursiveSearchForPathOfResourceNamed:(NSString *)name;
{
	NSFileManager *fm = [[NSFileManager alloc] init]; // +defaultManager is not thread safe
	NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath: [self resourcePath]];

	NSS* file = [[enumerator allObjects] filterOne:^BOOL(NSS* filePath) {

		return (!isEmpty([name pathExtension])) ? [filePath endsWith:name]
												: [[filePath stringByDeletingPathExtension] endsWith:name];

	}];
	return file ? [[self resourcePath] stringByAppendingPathComponent:file] : nil;

}

- (NSArray *)recursivePathsForResourcesOfType:(NSString *)type inDirectory:(NSString *)directoryPath{

    NSMutableArray *filePaths = [NSMutableArray new];  // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    NSString *filePath;
    while ((filePath = [enumerator nextObject]) != nil){
        // If we have the right type of file, add it to the list Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:type])
            [filePaths addObject:[directoryPath stringByAppendingString:filePath]];
	}
    return filePaths;
}

- (NSA*) cacheImages;
{
	NSA*u = [@[@"pdf", @"png"] map:^(NSString *type){
		return  [[self recursivePathsForResourcesOfType:type inDirectory:[self resourcePath]] map:^(NSS*path) {
			NSS*name = [[path lastPathComponent]stringByDeletingPathExtension];
			return [NSImage imageNamed:name] ? name : ^{
				NSImage *needsPath = [[NSImage alloc]  initByReferencingFile:path];
				if (needsPath) needsPath.name = name;
				return needsPath;
			}();
		}];
	}];
	AZLOG($(@"Cached %ld images.",u.count));
	return  [NSArray arrayWithArrays:[u valueForKeyPath:@"name"]];
}


- (void) cacheNamedImages;
{
	NSCountedSet *typesCounter = [NSCountedSet new];
    NSArray *types = [NSImage imageFileTypes];
    NSEnumerator *e = [types objectEnumerator];
    NSString *type;
    while ((type = [e nextObject]) != nil) {
		NSArray *files = [self recursivePathsForResourcesOfType:type inDirectory:[self resourcePath]];
		NSEnumerator *e2 = [files objectEnumerator];
		NSString *imagepath;
		while ((imagepath = [e2 nextObject]) != nil) {
		   NSString *name = [[imagepath lastPathComponent] stringByDeletingPathExtension];
		   NSImage *image = [NSImage imageNamed:name];
		   if (!image) {
				image = [[NSImage alloc]  initByReferencingFile:imagepath];
				if (image) {
				   [image setName: name];
				}
			}
			if (image) [typesCounter addObject:type];
		}
    }
	LOG_EXPR(typesCounter);
}

NSString *appSupportSubpath = @"/System/Library/Frameworks";
NSString *ext = @"framework";


//+ (NSMutableArray *)systemFrameworks;
//{
//    NSArray *librarySearchPaths;
//    NSEnumerator *searchPathEnum;
//    NSString *currPath;
//    NSMutableArray *bundleSearchPaths = [NSMutableArray array];
//    NSMutableArray *allBundles = [NSMutableArray array];
// 
//    librarySearchPaths = NSSearchPathForDirectoriesInDomains(
//        NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
// 
//    searchPathEnum = [librarySearchPaths objectEnumerator];
//    while(currPath = [searchPathEnum nextObject])
//	  if([[currBundlePath pathExtension] isEqualToString:ext])
//			{
//			 [allBundles addObject:[currPath
//					   stringByAppendingPathComponent:currBundlePath]];
//			}
//	   //    {
////        [bundleSearchPaths addObject:
////            [currPath stringByAppendingPathComponent:appSupportSubpath]];
////    }
////    [bundleSearchPaths addObject:
////        [[NSBundle mainBundle] builtInPlugInsPath]];
//
////    searchPathEnum = [bundleSearchPaths objectEnumerator];
////    while(currPath = [searchPathEnum nextObject])
////    {
//        NSDirectoryEnumerator *bundleEnum;
//        NSString *currBundlePath;
//        bundleEnum = [[NSFileManager defaultManager]
//            enumeratorAtPath:currPath];
//        if(bundleEnum)
//        {
//            while(currBundlePath = [bundleEnum nextObject])
//            {
//                if([[currBundlePath pathExtension] isEqualToString:ext])
//                {
//                 [allBundles addObject:[currPath
//                           stringByAppendingPathComponent:currBundlePath]];
//                }
//            }
//        }
//    }
// 
//    return allBundles;
//}
//


- (NSString*)appIconPath {
	// Oddly, I can't find a constant for the bundle icon file.
	// Compare to kCFBundleNameKey, which is apparently "CFBundleName".
	NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
	// I do not use -pathForImageResource, in case the Resources also contains
	// an image file, for example a png, with the same name.  I want the .icns.
	NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
	NSString* iconExtension = [iconFilename pathExtension] ;  // Should be "icns", but for some reason it's in Info.plist
	return [[NSBundle mainBundle] pathForResource:iconBasename
										   ofType:iconExtension] ;
}

- (NSImage*)appIcon {
	NSImage* appIcon = [[NSImage alloc] initWithContentsOfFile:[self appIconPath]] ;
	return appIcon ;
}

@end
