
//  NSFileManager+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSFileManager+AtoZ.h"
#include <glob.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dirent.h>
#import <sys/stat.h>


NSString *NSDocumentsFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

NSString *NSLibraryFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
}

NSString *NSTmpFolder()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

NSString *NSBundleFolder()
{
	return [[NSBundle mainBundle] bundlePath];
}

NSString *NSDCIMFolder()
{
	return @"/var/mobile/Media/DCIM";
}
@implementation NSFileManager (AtoZ)

- (NSA*) pathsOfContentsOfDirectory:(NSString*) directory;
{
	NSArray*files = [AZFILEMANAGER contentsOfDirectoryAtPath:[[directory stringByExpandingTildeInPath] stringByResolvingSymlinksInPath] error:nil];
	return [files map:^id(id obj) {		return [[[directory stringByAppendingPathComponent:obj]stringByExpandingTildeInPath]stringByResolvingSymlinksInPath];}];
}
#pragma Globbing

- (NSA*) arrayWithFilesMatchingPattern: (NSString*) pattern inDirectory: (NSString*) directory {

	NSMutableArray* files = [NSMutableArray array];
	glob_t gt;
	NSString* globPathComponent = [NSString stringWithFormat: @"/%@", pattern];
	NSString* expandedDirectory = [directory stringByExpandingTildeInPath];
	const char* fullPattern = [[expandedDirectory stringByAppendingPathComponent: globPathComponent] UTF8String];
	if (glob(fullPattern, 0, NULL, &gt) == 0) {
		int i;
		for (i=0; i<gt.gl_matchc; i++) {
			int len = strlen(gt.gl_pathv[i]);
			NSString* filename = [[NSFileManager defaultManager] stringWithFileSystemRepresentation: gt.gl_pathv[i] length: len];
			[files addObject: filename];
		}
	}
	globfree(&gt);
	return [NSArray arrayWithArray: files];
}

/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk	*/

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path
{
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
		if ([[file lastPathComponent] isEqualToString:fname])
			return [path stringByAppendingPathComponent:file];
	return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname
{
	return [NSFileManager pathForItemNamed:fname inFolder:NSBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
	{
		BOOL isDir;
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir) [results addObject:file];
	}
	return results;
}

+ (NSArray *) pathsForItemsInFolder:(NSString *)path withExtension: (NSString *) ext
{
	NSError *error = nil;
	return [[AZFILEMANAGER contentsOfDirectoryAtPath:path error:&error] filter:^BOOL(NSS* object) {
		return [path.pathExtension isEqual:ext];
	}];
}

	// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
//	NSString *file;
//	NSMutableArray *results = [NSMutableArray array];
//	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
//	while (file = [dirEnum nextObject])
//		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
//			[results addObject:[path stringByAppendingPathComponent:file]];
//	return results;

	NSString *file;
	NSMA *results = NSMA.new;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];

	while (file = [dirEnum nextObject]) {
	
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
			[results addObject:[path stringByAppendingPathComponent:file]];
	}
	return results;

}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

	// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}

@end

#import <sys/stat.h> // For statbuf, stat, mkdir

@implementation NSFileManager (OFSimpleExtensions)

- (NSDictionary *)attributesOfItemAtPath:(NSString *)filePath traverseLink:(BOOL)traverseLink error:(NSError **)outError
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

- (BOOL)directoryExistsAtPath:(NSString *)path traverseLink:(BOOL)traverseLink;
{
	NSDictionary *attributes = [self attributesOfItemAtPath:path traverseLink:traverseLink error:NULL];
	return attributes && [[attributes fileType] isEqualToString:NSFileTypeDirectory];
}

- (BOOL)directoryExistsAtPath:(NSString *)path;
{
	return [self directoryExistsAtPath:path traverseLink:NO];
}

- (BOOL)createPathToFile:(NSString *)path attributes:(NSDictionary *)attributes error:(NSError **)outError;
	// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.
{
	NSArray *pathComponents = [path pathComponents];
	NSUInteger componentCount = [pathComponents count];
	if (componentCount <= 1)
		return YES;

	return [self createPathComponents:[pathComponents subarrayWithRange:(NSRange){0, componentCount-1}] attributes:attributes error:outError];
}

- (BOOL)createPathComponents:(NSArray *)components attributes:(NSDictionary *)attributes error:(NSError **)outError
{
	if ([attributes count] == 0)
		attributes = nil;

	NSUInteger dirCount = [components count];
	NSMutableArray *trimmedPaths = [[NSMutableArray alloc] initWithCapacity:dirCount];

	[trimmedPaths autorelease];

	NSString *finalPath = [NSString pathWithComponents:components];

	NSMutableArray *trim = [[NSMutableArray alloc] initWithArray:components];
	NSError *error = nil;
	for (NSUInteger trimCount = 0; trimCount < dirCount && !error; trimCount ++) {
		struct stat statbuf;

		OBINVARIANT([trim count] == (dirCount - trimCount));
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
	[trim release];

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
			int err = errno;
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

- (BOOL)touchItemAtURL:(NSURL *)url error:(NSError **)outError;
{
	NSDictionary *attributes = @{NSFileModificationDate: [NSDate date]};
	BOOL rc = [self setAttributes:attributes ofItemAtPath:[[url absoluteURL] path] error:outError];
	[attributes release];
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
		NSLog(@"Unable to get attributes of %@: %@", [url absoluteString], [error toPropertyList]);
		return;
	}

	OBASSERT(sizeof(ino_t) == sizeof(unsigned long long));
	[str appendFormat:@"%llu  ", [[attributes objectForKey:NSFileSystemFileNumber] unsignedLongLongValue]];

	BOOL isDirectory = NO;
	NSString *fileType = [attributes fileType];
	if ([fileType isEqualToString:NSFileTypeDirectory]) {
		isDirectory = YES;
		[str appendString:@"d"];
	} else if ([fileType isEqualToString:NSFileTypeSymbolicLink]) {
		[str appendString:@"l"];
	} else {
		OBASSERT([fileType isEqualToString:NSFileTypeRegular]); // could add more cases if ever needed
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
			NSLog(@"Unable to get children of %@: %@", [url absoluteString], [error toPropertyList]);
			return;
		}

		for (NSURL *child in children) {
			_appendPropertiesOfTreeAtURL(self, str, child, indent + 1);
		}
	}
}

- (void)logPropertiesOfTreeAtURL:(NSURL *)url;
{
	NSMutableString *str = [[NSMutableString alloc] init];
	_appendPropertiesOfTreeAtURL(self, str, url, 0);

	NSLog(@"%@:\n%@\n", [url absoluteString], str);
	[str release];
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
			type = [(id)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(identifier, kUTTagClassMIMEType)) autorelease];
			CFRelease(identifier);
		}
	}
	if (!type.length) {
		type = @"application/octet-stream";
	}
	return type;
}

- (BOOL) getExtendedAttributeBytes:(void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path {
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
	return data ? [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] : nil;
}

- (BOOL) setExtendedAttributeBytes:(const void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path {
	if (bytes || !length) {
		const char* utf8Name = [name UTF8String];
		const char* utf8Path = [path UTF8String];
		int result = setxattr(utf8Path, utf8Name, bytes, length, 0, 0);
		return (result >= 0 ? YES : NO);
	}
	return NO;
}

- (BOOL) setExtendedAttributeData:(NSData*)data withName:(NSString*)name forFileAtPath:(NSString*)path {
	return [self setExtendedAttributeBytes:data.bytes length:data.length withName:name forFileAtPath:path];
}

- (BOOL) setExtendedAttributeString:(NSString*)string withName:(NSString*)name forFileAtPath:(NSString*)path {
	NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return data ? [self setExtendedAttributeData:data withName:name forFileAtPath:path] : NO;
}

- (BOOL) removeItemAtPathIfExists:(NSString*)path {
	if ([self fileExistsAtPath:path]) {
		return [self removeItemAtPath:path error:NULL];
	}
	return YES;
}
#include <sys/types.h>
#include <dirent.h>

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
	int result = setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &value, sizeof(value), 0, 0);
	if (result) {
		LOG_ERROR(@"Failed setting do-not-backup attribute on \"%@\": %s (%i)", path, strerror(result), result);
	}
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
				[[NSWorkspace sharedWorkspace] noteFileSystemChanged:currentPath];
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