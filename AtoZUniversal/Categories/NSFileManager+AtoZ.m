
//  NSFileManager+AtoZ.m  Created by Alex Gray on 8/28/12.

#import <AtoZUniversal/AtoZUniversal.h>
@import os;
@import Darwin;
//#include <glob.h>
#import <sys/xattr.h>
#include <sys/types.h>
#include <dirent.h>
//#import <sys/sysctl.h>
//#import <unistd.h>
//#import <dirent.h>
//#import <sys/stat.h>
//#include <assert.h>


NSS * NSDocumentsFolder() { return [NSHomeDirectory() withPath:@"Documents"]; }
NSS * NSLibraryFolder()   { return [NSHomeDirectory() withPath:@"Library"];   }
NSS * NSTmpFolder()       {	return [NSHomeDirectory() withPath:@"tmp"];       }
NSS * NSBundleFolder()    {	return NSBundle.mainBundle.bundlePath;            }
NSS * NSDCIMFolder()      {	return @"/var/mobile/Media/DCIM";                 }


@implementation NSFileManager (AtoZ)

- _IsIt_ isSymlink:(NSString*)ln to:(NSString*)p { return [self isSymlink:ln] &&
                                                         [[self destinationOfSymbolicLinkAtPath:ln error:nil] isEqualToString:p];
}

- _IsIt_ isSymlink:(NSString*)ln { return [self attributesOfItemAtPath:ln error:nil][NSFileType] == NSFileTypeSymbolicLink; }

- tagForFileAtPath:pathorurl {

  NSURL * fileURL = ISA(pathorurl, NSURL) ? pathorurl : [NSURL fileURLWithPath:pathorurl];

  id labelValue = nil;
  NSError* error;
  if([fileURL getResourceValue:&labelValue forKey:NSURLLabelNumberKey error:&error])

  {
//    NSLog(@"The label value is %@",labelValue);
  }
  else
  {
    NSLog(@"An error occurred: %@",[error localizedDescription]);
  }
  return labelValue;

}

- (void) setTag:(NSUInteger)t forFileAtPath:pathorurl {

  NSURL * fileURL = ISA(pathorurl, NSURL) ? pathorurl : [NSURL fileURLWithPath:pathorurl];

 // NSURLLabelNumberKey values are:
  //  0 none, 1 grey, 2 green, 3 purple, 4 blue, 5 yellow, 6 red, 7 orange


  [fileURL setResourceValue:@(MIN(t,7)) forKey:NSURLLabelNumberKey error:nil];

}

- (NSA*) pathsOfContentsOfDirectory:(NSS*) dir {

	return [[AZFILEMANAGER contentsOfDirectoryAtPath:dir.stringByStandardizingPath error:nil] map:^id(id obj) {
                                            return [dir stringByAppendingPathComponent:obj].stringByStandardizingPath;
  }];
}

#pragma mark - Globbing

- (NSA*) arrayWithFilesMatchingPattern:(NSS*)pattern inDirectory:(NSS*) directory {

	NSMutableArray* files = NSMutableArray.array;	glob_t gt;

	NSString* globPathComponent = [NSString stringWithFormat: @"/%@", pattern];
	NSString* expandedDirectory = directory.stringByExpandingTildeInPath;
	const char* fullPattern = [expandedDirectory stringByAppendingPathComponent:globPathComponent].UTF8String;

	if (!glob(fullPattern, 0, NULL, &gt)) {

		for (int i=0; i<gt.gl_matchc; i++) { int len = strlen(gt.gl_pathv[i]);
			NSString* filename = [AZFILEMANAGER stringWithFileSystemRepresentation: gt.gl_pathv[i] length: len]; if (filename) [files addObject: filename];
		}
	}
	return globfree(&gt), [files copy];
}

/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk	*/

- (NSS*) pathForItemNamed:(NSS*)fname inFolder:(NSS*)path {

	NSString *file;
	NSDirectoryEnumerator *dirEnum = [self enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
		if ([[file lastPathComponent] isEqualToString:fname])
			return [path stringByAppendingPathComponent:file];
	return nil;
}
#if !TARGET_OS_IPHONE
- (NSS*)       pathForDocumentNamed:(NSS*)fname { return [self pathForItemNamed:fname inFolder:NSDocumentsFolder()];  }
- (NSS*) pathForBundleDocumentNamed:(NSS*)fname {	return [self pathForItemNamed:fname inFolder:NSBundleFolder()];     }
#endif
- (NSA*) filesInFolder:(NSS*)path {
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [self enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
	{
		BOOL isDir;
		[self fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir) [results addObject:file];
	}
	return results;
}

- (NSA*) pathsForItemsInFolder:(NSS*)path withExtension:(NSS*)ext {

	NSError *error = nil;
	return [[self contentsOfDirectoryAtPath:path error:&error] filter:^BOOL(NSS* object) {
		return [[object pathExtension] isEqualToString:ext];
	}];
}

	// Case insensitive compare, with deep enumeration
- (NSA*) pathsForItemsNamed:(NSS*)name inFolder:(NSS*)path {

	NSString *file;	 AZNewVal(results,NSMA.new); AZNewVal(dirEnum, [self enumeratorAtPath:path]);

  while (file = dirEnum.nextObject)
    if ([file.lastPathComponent isCaseInsensitiveEqualToString:name])
			[results addObject:[path withPath:file]];
	return results;

}
- (NSA*) pathsForItemsMatchingExtension:(NSS*)ext inFolder:(NSS*)path {
//	NSString *file;
//	NSMutableArray *results = [NSMutableArray array];
//	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
//	while (file = [dirEnum nextObject])
//		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
//			[results addObject:[path stringByAppendingPathComponent:file]];
//	return results;

	NSString *file;
	NSMA *results = NSMA.new;
	NSDirectoryEnumerator *dirEnum = [self enumeratorAtPath:path];

	while (file = [dirEnum nextObject]) {
	
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
			[results addObject:[path stringByAppendingPathComponent:file]];
	}
	return results;

}

- (NSA*) pathsForDocumentsMatchingExtension:(NSS*)ext {
	return [self pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

	// Case insensitive compare
- (NSA*)  pathsForBundleDocumentsMatchingExtension:(NSS*)ext                {
	return [self pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}
- (NSA*) pathsOfFilesIn:(NSS*)path matchingPattern:(NSS*)regex              {

  glob_t gt; NSMA* globber = @[].mutableCopy;

	if ((glob($(@"%@%@",path.stringByStandardizingPath,regex).UTF8String, 0, NULL, &gt))) return nil;

	for (int i = 0; i < gt.gl_matchc; i++)

		[globber addObject:[self stringWithFileSystemRepresentation:gt.gl_pathv[i] length:strlen(gt.gl_pathv[i])].copy];

	globfree(&gt);
	return globber;
}
- (NSA*) pathsOfFilesIn:(NSS*)path   withExtension:(NSS*)ext                {

	return [self pathsOfFilesIn:path passing:^BOOL(NSString*testP){
		return [testP.pathExtension isEqualToString:ext]; 
	}];
}
- (NSA*) pathsOfFilesIn:(NSS*)path         passing:(BOOL(^)(NSS*))testBlock {
	
	NSMutableArray *globber = NSMutableArray.new;
	for (NSString* file in [self contentsOfDirectoryAtPath:path.stringByStandardizingPath error:nil])
		if (testBlock(file)) [globber addObject:[path stringByAppendingPathComponent:file]];
	return globber.copy;
}

@end

#import <sys/stat.h> // For statbuf, stat, mkdir

@implementation NSFileManager (OFSimpleExtensions)

- (NSD*)attributesOfItemAtPath:(NSS*)filePath traverseLink:(BOOL)traverseLink error:(NSERR*__autoreleasing*)outError
{
#ifdef MAXSYMLINKS
	int links_followed = 0;
#endif

	for(;;) {
		NSDictionary *attributes = [self attributesOfItemAtPath:filePath error:outError];
		if (!attributes) // Error return
			return nil;

		if (traverseLink && [[attributes fileType] isEqualToString:NSFileTypeSymbolicLink]) {
#ifdef MAXSYMLINKS
			BOOL linkCountOK = (links_followed++ < MAXSYMLINKS);
			if (!linkCountOK) {
				if (outError)
					*outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:ELOOP userInfo:@{NSFilePathErrorKey: filePath}];
				return nil;
			}
#endif
			NSString *dest = [self destinationOfSymbolicLinkAtPath:filePath error:outError];
			if (!dest)
				return nil;
			if ([dest isAbsolutePath])
				filePath = dest;
			else
				filePath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:dest];
			continue;
		}

		return attributes;
	}
}

- (BOOL)directoryExistsAtPath:(NSS*)path traverseLink:(BOOL)traverseLink;
{
	NSDictionary *attributes = [self attributesOfItemAtPath:path traverseLink:traverseLink error:NULL];
	return attributes && [[attributes fileType] isEqualToString:NSFileTypeDirectory];
}

- (BOOL)directoryExistsAtPath:(NSS*)path;
{
	return [self directoryExistsAtPath:path traverseLink:NO];
}

- (BOOL)createPathToFile:(NSS*)path attributes:(NSD*)attributes error:(NSERR*__autoreleasing*)outError;
	// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.
{
	NSArray *pathComponents = [path pathComponents];
	NSUInteger componentCount = [pathComponents count];
	if (componentCount <= 1)
		return YES;

	return [self createPathComponents:[pathComponents subarrayWithRange:(NSRange){0, componentCount-1}] attributes:attributes error:outError];
}

- (BOOL)createPathComponents:(NSA*)components attributes:(NSD*)attributes error:(NSERR*__autoreleasing*)outError
{
	if ([attributes count] == 0)
		attributes = nil;

	NSUInteger dirCount = [components count];
	NSMutableArray *trimmedPaths = [NSMutableArray.alloc initWithCapacity:dirCount];

	__unused NSString *finalPath = [NSString pathWithComponents:components];

	NSMutableArray *trim = [NSMutableArray.alloc initWithArray:components];
	NSError *error = nil;
	for (NSUInteger trimCount = 0; trimCount < dirCount && !error; trimCount ++) {
		struct stat statbuf;

//		OBINVARIANT([trim count] == (dirCount - trimCount));
		NSString *trimmedPath = [NSString pathWithComponents:trim];
		const char *path = [trimmedPath fileSystemRepresentation];
		if (stat(path, &statbuf)) {
			int err = errno;
			if (err == ENOENT) {
				[trimmedPaths addObject:trimmedPath];
				[trim removeLastObject];
					// continue
			} else {
//				OBErrorWithErrnoObjectsAndKeys(&error, err, "stat", trimmedPath,
//											   NSLocalizedStringFromTableInBundle(@"Could not create directory", @"OmniFoundation", OMNI_BUNDLE, @"Error message when stat() fails when trying to create a directory tree"),
//											   finalPath, NSFilePathErrorKey, nil);

			}
		} else if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
//			OBErrorWithErrnoObjectsAndKeys(&error, ENOTDIR, "mkdir", trimmedPath,
//										   NSLocalizedStringFromTableInBundle(@"Could not create directory", @"OmniFoundation", OMNI_BUNDLE, @"Error message when mkdir() will fail because there's a file in the way"),
//										   finalPath, NSFilePathErrorKey, nil);
		} else {
			break;
		}
	}
	if (error) {
		if (outError)
			*outError = error;
		return NO;
	}

	mode_t mode;
	mode = 0777; // umask typically does the right thing
	if (attributes && [attributes objectForKey:NSFilePosixPermissions]) {
		mode = [attributes unsignedIntForKey:NSFilePosixPermissions];
		if ([attributes count] == 1)
			attributes = nil;
	}

	while ([trimmedPaths count]) {
		NSString *pathString = [trimmedPaths lastObject];
		const char *path = [pathString fileSystemRepresentation];
		if (mkdir(path, mode) != 0) {
			__unused int err = errno;
//			OBErrorWithErrnoObjectsAndKeys(outError, err, "mkdir", pathString,
//										   NSLocalizedStringFromTableInBundle(@"Could not create directory", @"OmniFoundation", OMNI_BUNDLE, @"Error message when mkdir() fails"),
//										   finalPath, NSFilePathErrorKey, nil);
			return NO;
		}

		if (attributes)
			[self setAttributes:attributes ofItemAtPath:pathString error:NULL];

		[trimmedPaths removeLastObject];
	}

	return YES;
}

#pragma mark - Changing file access/update timestamps.

- (BOOL)touchItemAtURL:(NSURL *)url error:(NSERR*__autoreleasing*)outError;
{
	NSDictionary *attributes = @{NSFileModificationDate: [NSDate date]};
	BOOL rc = [self setAttributes:attributes ofItemAtPath:[[url absoluteURL] path] error:outError];
	return rc;
}

#pragma mark - Debugging

#ifdef DEBUG

static void _appendPermissions(NSMutableString *str, NSUInteger perms, NSUInteger readMask, NSUInteger writeMask, NSUInteger execMask)
{
	[str appendString:(perms & readMask) ? @"r" : @"-"];
	[str appendString:(perms & writeMask) ? @"w" : @"-"];
	[str appendString:(perms & execMask) ? @"x" : @"-"];
}

	// This just does very, very basic file info for now, not setuid/inode/xattr or whatever.
static void _appendPropertiesOfTreeAtURL(NSFileManager *self, NSMutableString *str, NSURL *url, NSUInteger indent)
{
	NSError *error = nil;
	NSDictionary *attributes = [self attributesOfItemAtPath:[[url absoluteURL] path] error:&error];
	if (!attributes) {

    NSDictionary *userInfo = [error userInfo];
		id x = [userInfo description]  ?:@"n/a";//_mapUserInfoValueToPlistValue(CFBridgingRetain(userInfo)) : @"n/a";

    NSLog(@"Unable to get attributes of %@: %@", [url absoluteString],
                          @{@"domain":[error domain]?:@"",
                              @"code":@([error code] ?: 0),
                                         @"userInfo" : x}); return;
	}

	assert(sizeof(ino_t) == sizeof(unsigned long long));
  
	[str appendFormat:@"%llu  ", [[attributes objectForKey:NSFileSystemFileNumber] unsignedLongLongValue]];

	BOOL isDirectory = NO;
	NSString *fileType = [attributes fileType];
	if ([fileType isEqualToString:NSFileTypeDirectory]) {
		isDirectory = YES;
		[str appendString:@"d"];
	} else if ([fileType isEqualToString:NSFileTypeSymbolicLink]) {
		[str appendString:@"l"];
	} else {
		assert([fileType isEqualToString:NSFileTypeRegular]); // could add more cases if ever needed
		[str appendString:@"-"];
	}

	NSUInteger perms = [attributes filePosixPermissions];
	_appendPermissions(str, perms, S_IRUSR, S_IWUSR, S_IXUSR);
	_appendPermissions(str, perms, S_IRGRP, S_IWGRP, S_IXGRP);
	_appendPermissions(str, perms, S_IROTH, S_IWOTH, S_IXOTH);

	for (NSUInteger level = 0; level < indent + 1; level++)
		[str appendString:@"  "];

	[str appendString:[url lastPathComponent]];

	if (isDirectory)
		[str appendString:@"/"];
	[str appendString:@"\n"];

	if (isDirectory) {
		error = nil;
		NSArray *children = [self contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];
		if (!children) {
			NSLog(@"Unable to get children of %@: %@", [url absoluteString], @"arror desc here"); // [error toPropertyList]);
			return;
		}

		for (NSURL *child in children) {
			_appendPropertiesOfTreeAtURL(self, str, child, indent + 1);
		}
	}
}

- (void) ogPropertiesOfTreeAtURL:(NSURL *)url;
{
	NSMutableString *str = NSMutableString.new;
	_appendPropertiesOfTreeAtURL(self, str, url, 0);

	NSLog(@"%@:\n%@\n", [url absoluteString], str);
}

#endif

@end



@implementation NSFileManager (Extensions)

- (NSString*) mimeTypeFromFileExtension:(NSString*)extension {
	NSString* type = nil;
	extension = [extension lowercaseString];
	if (extension.length) {
		CFStringRef identifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)CFBridgingRetain(extension), NULL);
		if (identifier) {
			type = (id)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(identifier, kUTTagClassMIMEType));
			CFRelease(identifier);
		}
	}
	if (!type.length) {
		type = @"application/octet-stream";
	}
	return type;
}

- _IsIt_ getExtendedAttributeBytes:(void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path {
	if (bytes) {
		const char* utf8Name = [name UTF8String];
		const char* utf8Path = [path UTF8String];
		ssize_t result = getxattr(utf8Path, utf8Name, bytes, length, 0, 0);
		if (result == length) {
			return YES;
		}
	}
	return NO;
}

- (NSData*) extendedAttributeDataWithName:(NSString*)name forFileAtPath:(NSString*)path {
	const char* utf8Name = [name UTF8String];
	const char* utf8Path = [path UTF8String];
	ssize_t result = getxattr(utf8Path, utf8Name, NULL, 0, 0, 0);
	if (result >= 0) {
		NSMutableData* data = [NSMutableData dataWithLength:result];
		if ([self getExtendedAttributeBytes:data.mutableBytes length:data.length withName:name forFileAtPath:path]) {
			return data;
		}
	}
	return nil;
}

- (NSString*) extendedAttributeStringWithName:(NSString*)name forFileAtPath:(NSString*)path {
	NSData* data = [self extendedAttributeDataWithName:name forFileAtPath:path];
	return data ? [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

- _IsIt_ setExtendedAttributeBytes:(const void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path {
	if (bytes || !length) {
		const char* utf8Name = [name UTF8String];
		const char* utf8Path = [path UTF8String];
		int result = setxattr(utf8Path, utf8Name, bytes, length, 0, 0);
		return (result >= 0 ? YES : NO);
	}
	return NO;
}

- _IsIt_ setExtendedAttributeData:(NSData*)data withName:(NSString*)name forFileAtPath:(NSString*)path {
	return [self setExtendedAttributeBytes:data.bytes length:data.length withName:name forFileAtPath:path];
}

- _IsIt_ setExtendedAttributeString:(NSString*)string withName:(NSString*)name forFileAtPath:(NSString*)path {
	NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return data ? [self setExtendedAttributeData:data withName:name forFileAtPath:path] : NO;
}

- _IsIt_ removeItemAtPathIfExists:(NSString*)path {
	if ([self fileExistsAtPath:path]) {
		return [self removeItemAtPath:path error:NULL];
	}
	return YES;
}

- (NSA*) _itemsInDirectoryAtPath:(NSString*)path invisible:(BOOL)invisible type1:(mode_t)type1 type2:(mode_t)type2 {
	NSMutableArray* array = nil;
	const char* systemPath = [path fileSystemRepresentation];
	DIR* directory;
	if ((directory = opendir(systemPath))) {
		array = [NSMutableArray array];
		size_t baseLength = strlen(systemPath);
		struct dirent storage;
		struct dirent* entry;
		while(1) {
			if ((readdir_r(directory, &storage, &entry) != 0) || !entry) {
				break;
			}
			if (entry->d_ino == 0) {
				continue;
			}
			if (entry->d_name[0] == '.') {
				if ((entry->d_namlen == 1) || ((entry->d_namlen == 2) && (entry->d_name[1] == '.')) || !invisible) {
					continue;
				}
			}

			char* buffer = malloc(baseLength + 1 + entry->d_namlen + 1);
			bcopy(systemPath, buffer, baseLength);
			buffer[baseLength] = '/';
			bcopy(entry->d_name, &buffer[baseLength + 1], entry->d_namlen + 1);
			struct stat fileInfo;
			if (lstat(buffer, &fileInfo) == 0) {
				if (((fileInfo.st_mode & S_IFMT) == type1) || ((fileInfo.st_mode & S_IFMT) == type2)) {
					NSString* item = [self stringWithFileSystemRepresentation:entry->d_name length:entry->d_namlen];
					if (item) {
						[array addObject:item];
					}
				}
			}
			free(buffer);
		}
		closedir(directory);
	}
	return array;
}

- (NSA*) directoriesInDirectoryAtPath:(NSString*)path includeInvisible:(BOOL)invisible {
	return [self _itemsInDirectoryAtPath:path invisible:invisible type1:S_IFDIR type2:0];
}

- (NSA*) filesInDirectoryAtPath:(NSString*)path includeInvisible:(BOOL)invisible includeSymlinks:(BOOL)symlinks {
	return [self _itemsInDirectoryAtPath:path invisible:invisible type1:S_IFREG type2:(symlinks ? S_IFLNK : 0)];
}

#if TARGET_OS_IPHONE

// https://developer.apple.com/library/ios/#qa/qa1719/_index.html
- (void) setDoNotBackupAttributeAtPath:(NSString*)path {
	u_int8_t value = 1;
	int result;
	if ((result  = setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &value, sizeof(value), 0, 0)))
		NSLog(@"Failed setting do-not-backup attribute on \"%@\": %s (%i)", path, strerror(result), result);
}

#endif

@end

/* ----- NSFileManager Additons : Implementation ----- */

@implementation NSFileManager (SGSAdditions)

- (void) createPath: (NSString*) filePath
{
	if(![self fileExistsAtPath: filePath])
	{
		NSMutableString*	currentPath		= [NSMutableString string];
		NSArray*			pathComponents	= [[filePath stringByExpandingTildeInPath] pathComponents];
		for(int i = 0; i < [pathComponents count]; i++)
		{
			if(i == 1 || i == 0)
			{
				[currentPath appendString: pathComponents[i]];
			}
			else
			{
				[currentPath appendString: [NSString stringWithFormat: @"/%@", pathComponents[i]]];
			}

			if(![self fileExistsAtPath: currentPath])
			{
				[self createDirectoryAtPath: currentPath withIntermediateDirectories:YES attributes:nil error:nil];
        #if !TARGET_OS_IPHONE
				[AZWORKSPACE noteFileSystemChanged:currentPath];
        #endif
			}
		}
	}
}

- (NSString*) uniqueFilePath: (NSString*) filePath
{
	if(![self fileExistsAtPath: filePath])
	{
		return filePath;
	}

	NSString*	returnPath		= nil;
	NSString*	fileName		= [filePath stringByDeletingPathExtension];
	NSString*	fileExtension	= [filePath pathExtension];
	for(int i = 1; i < 999; i++)
	{
		returnPath = [NSString stringWithFormat: @"%@-%i.%@", fileName, i, fileExtension];

		if(![self fileExistsAtPath: returnPath])
		{
			break;
		}
	}

	if([self fileExistsAtPath: returnPath])
	{
		returnPath = nil;
	}

	return returnPath;
}

@end
#if !TARGET_OS_IPHONE
#import <Carbon/Carbon.h>

@implementation NSString (CarbonUtilities)
- (NSS*) humanReadableFileTypeForFileExtension {
  return humanReadableFileTypeForFileExtension([self containsString:@"."] ? self.pathExtension : self);
}
+ (NSS*) stringWithFSRef:(const FSRef *)aFSRef	{
	if( !aFSRef )		return nil;
	UInt8			thePath[PATH_MAX + 1];		// plus 1 for \0 terminator
	return (FSRefMakePath ( aFSRef, thePath, PATH_MAX ) == noErr) ? [NSString stringWithUTF8String: (char*) thePath] : nil;
}
- _IsIt_ getFSRef:(FSRef *)aFSRef								{
	return FSPathMakeRef( (UInt8*) [self UTF8String], aFSRef, NULL ) == noErr;
}
- (NSS*) resolveAliasFile								{
	FSRef			theRef;		Boolean		theIsTargetFolder,
	theWasAliased;				NSString		* theResolvedAlias = nil;;
	[self getFSRef:&theRef];
	if( (FSResolveAliasFile ( &theRef, YES, &theIsTargetFolder, &theWasAliased ) == noErr) )
		theResolvedAlias = (theWasAliased) ? [NSString stringWithFSRef:&theRef] : self;
	return theResolvedAlias;
}
@end

@implementation NSFileManager (UKVisibleDirectoryContents)

-(NSArray*)	visibleDirectoryContentsAtPath: (NSString*)path
{
	NSDirectoryEnumerator*	enny = [AZFILEMANAGER enumeratorAtPath: path];
	NSMA*			arr = NSMA.new;
	NSString*				currFN;
	while( (currFN = [enny nextObject]) )
	{
		[enny skipDescendents];
		if( [currFN characterAtIndex: 0] == '.' )	continue;
		FSRef           fref;		FSCatalogInfo   info;
		if( [[path withPath: currFN] getFSRef: &fref] )
			if( noErr == FSGetCatalogInfo( &fref, kFSCatInfoFinderInfo, &info, NULL, NULL, NULL ) )
			{
				FileInfo*   finderInfo = (FileInfo*)info.finderInfo;
				if( (finderInfo->finderFlags & kIsInvisible) == kIsInvisible ) continue;
			}
		[arr addObject: currFN];
	}
	return arr;
}

@end
#endif

