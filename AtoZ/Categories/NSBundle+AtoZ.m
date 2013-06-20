//
//  NSBundle+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSBundle+AtoZ.h"

@implementation NSBundle (AtoZ)

+( NSB*) bundleForApplicationName:(NSString *)appName {
	return [self bundleWithIdentifier:[self bundleIdentifierForApplicationName:appName]];
}

+ (NSString *) bundleIdentifierForApplicationName:(NSString *)appName
{
    NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
    NSString * appPath = [workspace fullPathForApplication:appName];
    if (appPath) {
        NSBundle * appBundle = [self.class bundleWithPath:appPath];
        return [appBundle bundleIdentifier];
    }
    return nil; 
}

- (NSA*) frameworks {
//	NSS* basePath = $UTF8(getenv("BUILDPATH")) ?: ;
	return [NSB.allFrameworks filter :^BOOL(NSB* obj){		return [obj.bundlePath contains:AZFWORKBUNDLE.bundlePath];	}];
}
- (NSA*) frameworkIdentifiers 		{ return [self.frameworks cw_mapArray:^id(NSB* p){	return p.bundleIdentifier;	}]; }
- (NSA*) frameworkInfoDictionaries	{ return [self.frameworks cw_mapArray:^id(NSB* p){	return p.infoDictionary;	}]; }
- (NSD*) infoDictionaryWithIdentifier:(NSS*)identifier	{

	NSB* theB =  [self.frameworks filterOne:^BOOL(NSB* b) { return areSame(b.bundleIdentifier, identifier); }];
	return theB ? theB.infoDictionary : nil; 
}

+ (void) loadAZFrameworks {

	[[self pathsForResourcesOfType:@"framework" inDirectory:[AZBUNDLE privateFrameworksPath]] each:^(id obj) {
		[[self bundleWithPath:obj]load];
	}];
//[[[AZFILEMANAGER visibleDirectoryContentsAtPath:[AZBUNDLE privateFrameworksPath]] each:^(id obj) {
//	[NSB frameworkBundleNamed:[obj ]
}

+ (NSBundle*) frameworkBundleNamed:(NSS*)name {
	NSS* str = [[AZBUNDLE privateFrameworksPath]withPath:[name withString:@".framework"]];
	return [NSBundle bundleWithPath:str];
//	AZLOG(fw);
}
/**	Returns the support folder for the application, used to store the Core Data	store file.  This code uses a folder named "ArtGallery" for
 the content, either in the NSApplicationSupportDirectory location or (if the former cannot be found), the system's temporary directory. */

+ (NSString*) appSuppSubPathNamed:(NSString*)name;
{
	return [[[self class] applicationSupportFolder]stringByAppendingPathComponent:name];
}

+ (NSS*)appSuppDir {

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:[[NSBundle bundleForClass:[AtoZ class]] bundleIdentifier]];
}
+ (NSS*) appSuppFolder
{
	return [self applicationSupportFolder];
}
+ (NSS*) applicationSupportFolder
{
	static NSS* appsupport = nil;
	if (!appsupport) {

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) ?:
		@[[@"~/Library/Application Support/" stringByExpandingTildeInPath]];
		NSString *applicationSupportDirectory = [paths objectAtIndex:0];
		printf("Application Support: %s", applicationSupportDirectory.UTF8String);
		NSString *appName = [NSB.mainBundle objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey]
						  ?: [[NSBundle bundleForClass:AtoZ.class] objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey] ?: @"AtoZ";
		appsupport = [applicationSupportDirectory withPath:appName];//Create App directory if not exists:
	//	NSString* bundleID = [[NSBundle bundleForClass:[AtoZ class]] bundleIdentifier];
	//	NSArray* urlPaths = [AZFILEMANAGER URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
	//	NSURL* appDirectory = [urlPaths[0] URLByAppendingPathComponent:[NSB.mainBundle objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey] isDirectory:YES];
		if (![AZFILEMANAGER fileExistsAtPath:appsupport])
			[AZFILEMANAGER createDirectoryAtPath:appsupport withIntermediateDirectories:NO attributes:nil error:nil];
	}

	return  appsupport;
}
//	//build path
//	NSArray *supports = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
//	NSString *dir = supports[0];
//	[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
//	NSString *file = [dir stringByAppendingPathComponent:identifier];
//
//		//open plist
//	NSMutableDictionary *plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:file]
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

- (NSA*)definedClasses
{
   NSMA *array = NSMA.new;		int numClasses;		Class *classes = NULL;	
	
	numClasses = objc_getClassList(NULL, 0);
//	NSLog(@"Number of classes: %d", numClasses);
	if (numClasses > 0 )
	{
		classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
		numClasses = objc_getClassList(classes, numClasses);
		for (int i = 0; i < numClasses; i++) {
			[array addObject:$UTF8(class_getName(classes[i]))];	//		NSLog(@"Class name: %s", class_getName(classes[i]));
		}
		free(classes);
	}
//	int numberOfClasses = objc_getClassList(NULL, 0);
//	Class *classes = calloc(sizeof(Class), numberOfClasses);
//	numberOfClasses = objc_getClassList(classes, numberOfClasses);
//	for (int i = 0; i < numberOfClasses; ++i) {
//		Class c = classes[i];
//		if ([NSBundle bundleForClass:c] == self) {
//			[array addObject:c];
//		}
//	}
//	free(classes);
	return [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


//- (NSA*)frameworkClasses;
//{
//
//	NSMutableArray *array = [NSMutableArray array];
//	int numberOfClasses = objc_getClassList(NULL, 0);
//	Class *classes = calloc(sizeof(Class), numberOfClasses);
//	numberOfClasses = objc_getClassList(classes, numberOfClasses);
////	for (int i = 0; i < numberOfClasses; ++i) {
////		Class c = classes[i];
////		if ([NSBundle bundleForClass:c] == self) {
////			[array addObject:c];
////		}
////	}
////	free(classes);
//	return array;
//}

- (NSS*) recursiveSearchForPathOfResourceNamed:(NSS*)name;
{
	NSFileManager *fm = NSFileManager.new; // +defaultManager is not thread safe
	NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath: [self resourcePath]];

	NSA* files = [enumerator.allObjects filter:^BOOL(NSS* filePath) {

		return !isEmpty(name.pathExtension) ? [filePath endsWith:name]
													  : [[filePath stringByDeletingPathExtension] endsWith:name];

	}];
	NSS *file = nil;
	if (files.count) file = [files filterOne:^BOOL(NSS* filePath) {  return areSame(name, filePath.lastPathComponent); }];
	if (!file && files.count) file = files[0];
	
	return file ? [[self resourcePath] stringByAppendingPathComponent:file] : nil;

}

- (NSA*)recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath{

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

- (NSA*) cacheImages;	{	static NSA* cachedImages = nil;

	[AZStopwatch named:$(@"Caching images for Bundle:%@", NSStringFromClass([self principalClass])) block:^{
	if (!cachedImages) cachedImages = ^{
		NSA*u = [@[@"pdf", @"png"] map:^(NSS *type){
			return  [[self recursivePathsForResourcesOfType:type inDirectory:[self resourcePath]] cw_mapArray:^id(NSS* path) {

				NSS*name = [path.lastPathComponent stringByDeletingPathExtension];
				return [NSIMG imageNamed:name] ? name : ^{
					NSImage *needsPath = [NSIMG.alloc  initByReferencingFile:path];
					if (needsPath) needsPath.name = name;
					return needsPath;
				}();
			}];
		}];
		AZLOG($(@"Cached %ld images: %@.",u.count, [u valueForKeyPath:@"name"] ));

	return  [NSArray arrayWithArrays:[u valueForKeyPath:@"name"]];
	}();
}];

return cachedImages;
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
//	NSArray *librarySearchPaths;
//	NSEnumerator *searchPathEnum;
//	NSString *currPath;
//	NSMutableArray *bundleSearchPaths = [NSMutableArray array];
//	NSMutableArray *allBundles = [NSMutableArray array];
// 
//	librarySearchPaths = NSSearchPathForDirectoriesInDomains(
//		NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
// 
//	searchPathEnum = [librarySearchPaths objectEnumerator];
//	while(currPath = [searchPathEnum nextObject])
//	  if([[currBundlePath pathExtension] isEqualToString:ext])
//			{
//			 [allBundles addObject:[currPath
//					   stringByAppendingPathComponent:currBundlePath]];
//			}
//	   //	{
////		[bundleSearchPaths addObject:
////			[currPath stringByAppendingPathComponent:appSupportSubpath]];
////	}
////	[bundleSearchPaths addObject:
////		[[NSBundle mainBundle] builtInPlugInsPath]];
//
////	searchPathEnum = [bundleSearchPaths objectEnumerator];
////	while(currPath = [searchPathEnum nextObject])
////	{
//		NSDirectoryEnumerator *bundleEnum;
//		NSString *currBundlePath;
//		bundleEnum = [[NSFileManager defaultManager]
//			enumeratorAtPath:currPath];
//		if(bundleEnum)
//		{
//			while(currBundlePath = [bundleEnum nextObject])
//			{
//				if([[currBundlePath pathExtension] isEqualToString:ext])
//				{
//				 [allBundles addObject:[currPath
//						   stringByAppendingPathComponent:currBundlePath]];
//				}
//			}
//		}
//	}
// 
//	return allBundles;
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
