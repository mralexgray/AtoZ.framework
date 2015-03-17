
//fprintf(stderr, "__TEXT,__info_plist section not found\n"),1;

#import <AtoZUniversal/AtoZUniversal.h>
#import <mach-o/getsect.h>

@implementation NSBundle (AtoZBundles)

+ (NSA*) bundlesFromStdin { return BundlesFromStdin(); }
- (NSA*)          plugins { return BundlePlugins(self); }
- (NSA*) pluginsConformingTo:(Protocol*)p   { return BundlePluginsConformingTo(self, p); }
+ (NSA*) bundlesConformingTo:(Protocol*)p
                      atPath:(NSS*)path     { return BundlesAtPathConformingTo(path,p); }
@end

@Impl NSBundle (AtoZ)

+ resourceOfClass:(Class)rClass inBundleWithClass:(Class)k withName:(NSString*)n init:(SEL)method {

  NSB *b = [self bundleForClass:k];
  NSS* path = [b pathForResource:n ofType:nil];
  if (!path) return nil;
  return [rClass.alloc performSelectorWithoutWarnings:method withObject:path];
}

+            infoPlist { // NOt sure whatthis does

#ifdef __LP64__
  const struct section_64 *__info_plist;
#else
  const struct section *__info_plist;
#endif
  if (!(__info_plist = getsectbyname("__TEXT", "__info_plist")))  return nil;
  
	DTA    * plist = [DTA dataWithBytesNoCopy:(void*)__info_plist->addr length:__info_plist->size freeWhenDone:NO],
  * xmlSignature = [DTA dataWithBytesNoCopy:"<?xml"                   length:5                  freeWhenDone:NO];
  
  return [[plist subdataWithRange:NSMakeRange(0, xmlSignature.length)] isEqualToData:xmlSignature]

  ? plist.UTF8String

  : [NSPropertyListSerialization propertyListFromData:plist mutabilityOption:NSPropertyListImmutable
                                               format:NULL  errorDescription:NULL];
  
  // printf("binary __info_plist section:\n----------------------------\n%s\n", .UTF8String);printf("\nmainBundle infoDictionary:\n--------------------------\n%s\n",  [NSBundle.mainBundle.infoDictionary description].UTF8String);//prinf("raw __info_plist section:\n-------------------------\n%s\n",
}
- (NSS*) infoPlistPath {

  NSS* file;
//  return [AZFILEMANAGER pathsForItemsNamed:@"Info.plist" inFolder:self.bundlePath].firstObject;
  AZNewVal(dirEnum, [AZFILEMANAGER enumeratorAtPath:self.bundlePath]);
  while ((file = dirEnum.nextObject))
    if ([file.lastPathComponent compare:@"Info.plist" options:NSCaseInsensitiveSearch range:NSMakeRange( 0, file.lastPathComponent.length )] == NSOrderedSame)
      return [self.bundlePath stringByAppendingPathComponent:file];
  return nil;
//  pathsForItemsNamed:@"Info.plist" inFolder:self.bundlePath].firstObject;

}
#if !TARGET_OS_IPHONE

+ (NSB*) bundleForApplicationName:(NSS*)appName { return [self bundleWithIdentifier:[self bundleIdentifierForApplicationName:appName]]; }

+ (NSS*) bundleIdentifierForApplicationName:(NSS*)appName {
  
  NSS   * appPath = [AZWORKSPACE fullPathForApplication:appName];

  return !appPath ? nil : [[self.class   bundleWithPath:appPath] bundleIdentifier];
}
#endif
+ (NSS*)      appSuppSubPathNamed:(NSS*)name { return [self.class.applicationSupportFolder stringByAppendingPathComponent:name]; }
+ (INST)      bundleForExecutable:(NSS*)path {

  __block NSBundle *b = [self bundleWithPath:path];  if(b) return b;

  [path.pathComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *next = [NSString pathWithComponents:
                     [path.pathComponents subarrayToIndex:path.pathComponents.count-idx]];
    *stop = ((b = [self bundleWithPath:next]));
  }];
  return b;
}

+ (NSS*) calulatedBundleIDForPath:(NSS*)path { id x;

  return ((x = [self bundleWithPath:path])) ? [x bundleIdentifier] : @"unknown";
}
- (NSA*) definedClasses {


  NSMA *array = NSMA.new;		int numClasses;		Class *classes = NULL;	
	
	numClasses = objc_getClassList(NULL, 0); NSLog(@"Number of classes: %i", numClasses);

  if (numClasses) {
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


/**	Returns the support folder for the application, used to store the Core Data	store file.  This code uses a folder named "ArtGallery" for
 the content, either in the NSApplicationSupportDirectory location or (if the former cannot be found), the system's temporary directory. */

+ (NSS*) appSuppDir               {
  
	NSA *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSS *basePath = paths.count ? paths.first : NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:[NSBundle bundleForClass:NSClassFromString(@"AtoZ")].bundleIdentifier];
}
+ (NSS*) appSuppFolder            {	return [self applicationSupportFolder]; }
+ (NSS*) applicationSupportFolder {

	static NSS* appsupport = nil;
	if (!appsupport) {
    
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) ?:
		@[[@"~/Library/Application Support/" stringByExpandingTildeInPath]];
		NSString *applicationSupportDirectory = [paths objectAtIndex:0];
		printf("Application Support: %s", applicationSupportDirectory.UTF8String);
		NSString *appName = [NSB.mainBundle objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey]
    ?: [[NSBundle bundleForClass:NSClassFromString(@"AtoZ")] objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey] ?: @"AtoZ";
		appsupport = [applicationSupportDirectory stringByAppendingPathComponent:appName];//Create App directory if not exists:
    //	NSString* bundleID = [[NSBundle bundleForClass:[AtoZ class]] bundleIdentifier];
    //	NSArray* urlPaths = [AZFILEMANAGER URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    //	NSURL* appDirectory = [urlPaths[0] URLByAppendingPathComponent:[NSB.mainBundle objectForInfoDictionaryKey:(NSS*)kCFBundleNameKey] isDirectory:YES];
		if (![AZFILEMANAGER fileExistsAtPath:appsupport])
			[AZFILEMANAGER createDirectoryAtPath:appsupport withIntermediateDirectories:NO attributes:nil error:nil];
	}
  
	return  appsupport;
}


/// Doesnt work with extensiuons.  DOES recurse.
- (NSS*) recursiveSearchForPathOfResourceNamed:(NSS*)name {
	NSFileManager *fm = NSFileManager.new; // +defaultManager is not thread safe
	NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath: [self resourcePath]];
  
	NSA* files = [enumerator.allObjects filter:^BOOL(NSS* filePath) {
    
		return !IsEmpty(name.pathExtension) ? [filePath hasSuffix:name]
    : [[filePath stringByDeletingPathExtension] hasSuffix:name];
    
	}];
	NSS *file = nil;
	if (files.count) file = [files filterOne:^BOOL(NSS* filePath) {  return Same(name, filePath.lastPathComponent); }];
	if (!file && files.count) file = files[0];
	
	return file ? [[self resourcePath] stringByAppendingPathComponent:file] : nil;
  
}

- (NSA*) recursivePathsForResourcesOfType:(NSS*)type inDirectory:(NSS*)directoryPath{
  
	NSMutableArray *filePaths = [NSMutableArray new];  // Enumerators are recursive
	NSDirectoryEnumerator *enumerator = [AZFILEMANAGER enumeratorAtPath:directoryPath];
	NSString *filePath;
	while ((filePath = enumerator.nextObject) != nil){
		// If we have the right type of file, add it to the list Make sure to prepend the directory path
		if(SameString(filePath.pathExtension,type))
			[filePaths addObject:[directoryPath stringByAppendingString:filePath]];
	}
	return filePaths;
}

#if !TARGET_OS_IPHONE

- (NSA*) cacheImages	{	 

  AZNew(NSMA,cachedImages);
  
//	[AZStopwatch named:$(@"Cached %lu images in bundle:%@",cachedImages.count,self.bundlePath) block:^{

//    if (!cachedImages) cachedImages = ^{
    for (NSS *type in @[@"pdf", @"png", @"jpg", @"jpeg"]) {
      [[self recursivePathsForResourcesOfType:type inDirectory:self.resourcePath] each:^(NSS* path) {
        NSS*name = path.lastPathComponent.stringByDeletingPathExtension;
        if (![NSIMG imageNamed:name])  {
            NSIMG *needsPath = [NSIMG.alloc initByReferencingURL:[NSURL fileURLWithPath:path]];
            if (!needsPath.name) needsPath.name = name;
            [cachedImages addObject:name];
        }
      }];
    }
//  }];
//      AZLOG($(@"Cached %ld images: %@.",u.count, [u valueForKeyPath:@"name"] ));
//      return  [NSArray arrayWithArrays:[u valueForKeyPath:@"name"]];
//    }();
//  }];
  
  return cachedImages;
}
#endif

- (NSA*) resourcesWithExtensions:(NSA*)exts {

  return [NSA arrayWithArrays:[exts map:^id(id obj) { NSString *file; NSMA *results = NSMA.new;

    NSDirectoryEnumerator *dirEnum = [AZFILEMANAGER enumeratorAtPath:self.resourcePath];

    while (file = [dirEnum nextObject]) {
	
      if ([file.pathExtension caseInsensitiveCompare:obj] == NSOrderedSame)
        [results addObject:[self.resourcePath stringByAppendingPathComponent:file]];
    }
    return results;
  }]];
  
//    return [ pathsForItemsMatchingExtension:obj inFolder:self.resourcePath];
  //    return [self recursivePathsForResourcesOfType:obj inDirectory:nil] ?: @[];
//  }]];
///  AZNewVal(rsrcs, NSMA.new);
//  for (NSS* ext in exts) {
//    id x = [self pathsForResourcesOfType:ext inDirectory:nil];
//    for (NSS *filePath in x) {
//      id img; if ((img = [NSIMG.alloc initByReferencingURL:[NSURL fileURLWithPath:filePath]])) [rsrcs addObject:img];
//    }
//  }
//  return rsrcs;
//  return [exts reduce:NSMA.new withBlock:^id(NSMA* sum, id obj) {
//    [sum addObjectsFromArray:({ id x = [self pathsForResourcesOfType:obj inDirectory:nil];
//    
//     x ? [x map:^id(id url) {
//      return [NSIMG imageFromURL:[NSURL fileURLWithPath:url]];
//    }] : @[]; })];
//    return sum;
//  }];
}
- (NSA*) imageResources {

  return [[self resourcesWithExtensions:
#if IOS_ONLY
  @[@"PDF", @"pdf", @"PICT", @"PIC", @"pic", @"PCT", @"pct", @"PICT", @"pict", @"EPSF", @"PS", @"ps", @"EPSI", @"epsi", @"EPSF", @"epsf", @"EPI", @"epi", @"EPS", @"eps", @"BMPf", @"'qtif'", @"PNTG", @".SGI", @"TPIC", @"BMP", @"'8BPS'", @"'icns'", @"'TIFF'", @"'jp2", @"'", @"'GIFf'", @"'PNGf'", @"'JPEG'", @"FPIX", @"fpix", @"FPX", @"fpx", @"QTI", @"qti", @"QTIF", @"qtif", @"RJPG", @"rjpg", @"RJPEG", @"rjpeg", @"PVR", @"pvr", @"PFM", @"pfm", @"PPM", @"ppm", @"PGM", @"pgm", @"PBM", @"pbm", @"MPO", @"mpo", @"HDR", @"hdr", @"EXR", @"exr", @"MAC", @"mac", @"PNT", @"pnt", @"PNTG", @"pntg", @"RGB", @"rgb", @"SGI", @"sgi", @"TARGA", @"targa", @"TGA", @"tga", @"CUR", @"cur", @"BMP", @"bmp", @"ICO", @"ico", @"PSB", @"psb", @"PSD", @"psd", @"ORF", @"orf", @"MRW", @"mrw", @"RWL", @"rwl", @"RW2", @"rw2", @"RAW", @"raw", @"RAF", @"raf", @"CRW", @"crw", @"ICNS", @"icns", @"EFX", @"efx", @"JFAX", @"jfax", @"JFX", @"jfx", @"G3", @"g3", @"FAX", @"fax", @"TIFF", @"tiff", @"DCR", @"dcr", @"ERF", @"erf", @"ARW", @"arw", @"SR2", @"sr2", @"SRF", @"srf", @"SRW", @"srw", @"PEF", @"pef", @"NRW", @"nrw", @"NEF", @"nef", @"3FR", @"3fr", @"FFF", @"fff", @"MOS", @"mos", @"CR2", @"cr2", @"DNG", @"dng", @"TIF", @"tif", @"JPF", @"jpf", @"JP2", @"jp2", @"GIF", @"gif", @"PNG", @"png", @"JPS", @"jps", @"JFIF", @"jfif", @"JPE", @"jpe", @"JPEG", @"jpeg", @"JPG", @"jpg"
  ]]
    map:^id(id obj) { return [NSIMG imageWithContentsOfFile:obj];  }];
#else
    NSIMG.imageFileTypes] map:^id(id obj) { return [NSIMG.alloc initByReferencingURL:[NSURL fileURLWithPath:obj]];  }];
#endif

}


#if !TARGET_OS_IPHONE

- _Void_ cacheNamedImages {
	AZNew(NSCS,typesCounter);
	AZNewVal(types,NSIMG.imageFileTypes);

	NSENUM *e = types.objectEnumerator; NSS *type;

	while (!!(type = e.nextObject)) {
  
		NSA *files = [self recursivePathsForResourcesOfType:type inDirectory:self.resourcePath];
		NSEnumerator *e2 = files.objectEnumerator; NSS *imagepath;
		while ((imagepath = e2.nextObject) != nil) {
      NSString *name = [imagepath.lastPathComponent stringByDeletingPathExtension];
      NSImage *image = [NSImage imageNamed:name];
      if (image || !(image = [NSImage.alloc  initByReferencingFile:imagepath])) continue;
			[image          setName:name];
      [typesCounter addObject:type];
		}
  }	NSLog(@"Named Images:%@",typesCounter);
}

- (NSS*) appIconPath {
	// Oddly, I can't find a constant for the bundle icon file.
	// Compare to kCFBundleNameKey, which is apparently "CFBundleName".
	NSString* iconFilename = AZAPPINFO[@"CFBundleIconFile"] ;
	// I do not use -pathForImageResource, in case the Resources also contains
	// an image file, for example a png, with the same name.  I want the .icns.
	NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
	NSString* iconExtension = [iconFilename pathExtension] ;  // Should be "icns", but for some reason it's in Info.plist
	return [[NSBundle mainBundle] pathForResource:iconBasename
                                         ofType:iconExtension] ;
}

- (IMG*) appIcon {

  return [NSIMG imageNamed:AZAPPINFO[@"CFBundleIconFile"]];

//	NSImage* appIcon = [NSImage.alloc initWithContentsOfFile:[self appIconPath]] ;
//	return appIcon ;
}
#endif

+ (NSA*) allFrameworkPaths { return self.allFrameworks[@"bundlePath"]; }

@end

/*

//NSString *appSupportSubpath = @"/System/Library/Frameworks";
//NSString *ext = @"framework";

- (NSA*)frameworkClasses;
{
	NSMutableArray *array = [NSMutableArray array];
	int numberOfClasses = objc_getClassList(NULL, 0);
	Class *classes = calloc(sizeof(Class), numberOfClasses);
	numberOfClasses = objc_getClassList(classes, numberOfClasses);
//	for (int i = 0; i < numberOfClasses; ++i) {
//		Class c = classes[i];
//		if ([NSBundle bundleForClass:c] == self) {
//			[array addObject:c];
//		}
//	}
//	free(classes);
	return array;
}

	//build path
	NSArray *supports = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *dir = supports[0];
	[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
	NSString *file = [dir stringByAppendingPathComponent:identifier];

		//open plist
	NSMutableDictionary *plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:file]
	NSString *basePath = ([paths count] > 0 ? paths[0] : NSTemporaryDirectory() );
	return [basePath stringByAppendingPathComponent:[[NSBundle mainBundle]bundleIdentifier]];
}
+ (NSMutableArray *)systemFrameworks;
{
	NSArray *librarySearchPaths;
	NSEnumerator *searchPathEnum;
	NSString *currPath;
	NSMutableArray *bundleSearchPaths = [NSMutableArray array];
	NSMutableArray *allBundles = [NSMutableArray array];
 
	librarySearchPaths = NSSearchPathForDirectoriesInDomains(
		NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
 
	searchPathEnum = [librarySearchPaths objectEnumerator];
	while(currPath = [searchPathEnum nextObject])
	  if([[currBundlePath pathExtension] isEqualToString:ext])
			{
			 [allBundles addObject:[currPath
					   stringByAppendingPathComponent:currBundlePath]];
			}
	   //	{
//		[bundleSearchPaths addObject:
//			[currPath stringByAppendingPathComponent:appSupportSubpath]];
//	}
//	[bundleSearchPaths addObject:
//		[[NSBundle mainBundle] builtInPlugInsPath]];

//	searchPathEnum = [bundleSearchPaths objectEnumerator];
//	while(currPath = [searchPathEnum nextObject])
//	{
		NSDirectoryEnumerator *bundleEnum;
		NSString *currBundlePath;
		bundleEnum = [[NSFileManager defaultManager]
			enumeratorAtPath:currPath];
		if(bundleEnum)
		{
			while(currBundlePath = [bundleEnum nextObject])
			{
				if([[currBundlePath pathExtension] isEqualToString:ext])
				{
				 [allBundles addObject:[currPath
						   stringByAppendingPathComponent:currBundlePath]];
				}
			}
		}
	}
 
	return allBundles;
}


+ (instancetype) calulatedBundleIDForExecutable:(NSString*)path { 
	
	NSBundle *b = [self bundleWithPath:path]; 	if (b) return b;
	NSString *pp = path.copy;
	for (NSS*sss in path.pathComponents) { 
		if ((b = [self bundleWithPath:pp = [pp stringByDeletingLastPathComponent]])) break;
	}
	return b;
}
*/