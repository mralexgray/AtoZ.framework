
#if !TARGET_OS_IPHONE
NS_INLINE NSS* humanReadableFileTypeForFileExtension (NSS *ext) {

	CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                             (__bridge CFStringRef)ext, NULL);
	NSS *UTIDesc = (__bridge NSS*)UTTypeCopyDescription(fileUTI); return CFRelease(fileUTI),UTIDesc;
}

#endif

NSS * NSDocumentsFolder (void);
NSS *   NSLibraryFolder (void);
NSS *       NSTmpFolder (void);
NSS *    NSBundleFolder (void);

@interface NSFileManager (AtoZ)

- tagForFileAtPath:pathorurl;
- (void) setTag:(NSUInteger)t forFileAtPath:pathorurl;


- (NSA*)    pathsOfContentsOfDirectory:(NSS*)dir;

- (NSA*) arrayWithFilesMatchingPattern:(NSS*)pattern inDirectory:(NSS*)dir;

- (NSS*)              pathForItemNamed:(NSS*)fname      inFolder:(NSS*)path;
#if !TARGET_OS_IPHONE
- (NSS*)          pathForDocumentNamed:(NSS*)fname;
- (NSS*)    pathForBundleDocumentNamed:(NSS*)fname;
#endif

//non-resursive
- (NSA*) pathsForItemsInFolder:(NSS*)path withExtension: (NSS*) ext;

- (NSA*) pathsOfFilesIn:(NSS*)p   withExtension:(NSS*)ext;

/*! [FM pathsOfFilesIn:NSHomeDirectory() matchingPattern:@"/.*"]   .dotfiles  */

- (NSA*) pathsOfFilesIn:(NSS*)p matchingPattern:(NSS*)regex;
- (NSA*) pathsOfFilesIn:(NSS*)p         passing:(BOOL(^)(NSS*))testBlock;
//recursive
- (NSA*) pathsForItemsNamed:(NSS*)ext inFolder:(NSS*)path;
- (NSA*) pathsForItemsMatchingExtension: (NSS*) ext inFolder: (NSS*) path;
- (NSA*) pathsForDocumentsMatchingExtension: (NSS*) ext;
- (NSA*) pathsForBundleDocumentsMatchingExtension: (NSS*) ext;

- (NSA*) filesInFolder: (NSS*) path;

//+ (NSImage *) imageNamed: (NSS*) aName;
//+ (NSImage *) imageFromURLString: (NSS*) urlstring;

- _IsIt_ isSymlink:(NSString*)ln;
- _IsIt_ isSymlink:(NSString*)ln to:(NSString*)p;

@end

@interface NSFileManager (OFSimpleExtensions)

- (NSD*)attributesOfItemAtPath:(NSS*)filePath traverseLink:(BOOL)traverseLink error:(NSERR*__autoreleasing*)outError;

	// Directory manipulations

- (BOOL)directoryExistsAtPath:(NSS*)path;
- (BOOL)directoryExistsAtPath:(NSS*)path traverseLink:(BOOL)traverseLink;

- (BOOL)createPathToFile:(NSS*)path attributes:(NSD*)attributes error:(NSERR*__autoreleasing*)outError;
	// Creates any directories needed to be able to create a file at the specified path.

	// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.
- (BOOL)createPathComponents:(NSA*)components attributes:(NSD*)attributes error:(NSERR*__autoreleasing*)outError;

	// Changing file access/update timestamps.

- (BOOL)touchItemAtURL:(NSURL *)url error:(NSERR*__autoreleasing*)outError;

#ifdef DEBUG
- (void) logPropertiesOfTreeAtURL:(NSURL *)url;
#endif

@end

@interface NSFileManager (Extensions)
- (NSS*) mimeTypeFromFileExtension:(NSS*)extension;
- _IsIt_ getExtendedAttributeBytes:(void*)bytes length:(NSUI)length withName:(NSS*)name forFileAtPath:(NSS*)path;
- (NSData*) extendedAttributeDataWithName:(NSS*)name forFileAtPath:(NSS*)path;
- (NSS*) extendedAttributeStringWithName:(NSS*)name forFileAtPath:(NSS*)path;  // Uses UTF8 encoding
- _IsIt_ setExtendedAttributeBytes:(const void*)bytes length:(NSUI)length withName:(NSS*)name forFileAtPath:(NSS*)path;
- _IsIt_ setExtendedAttributeData:(NSData*)data withName:(NSS*)name forFileAtPath:(NSS*)path;
- _IsIt_ setExtendedAttributeString:(NSS*)string withName:(NSS*)name forFileAtPath:(NSS*)path;  // Uses UTF8 encoding
- _IsIt_ removeItemAtPathIfExists:(NSS*)path;
- (NSA*) directoriesInDirectoryAtPath:(NSS*)path includeInvisible:(BOOL)invisible;
- (NSA*) filesInDirectoryAtPath:(NSS*)path includeInvisible:(BOOL)invisible includeSymlinks:(BOOL)symlinks;
#if TARGET_OS_IPHONE
- (void) setDoNotBackupAttributeAtPath:(NSS*)path;  // Has no effect prior to iOS 5.0.1
#endif
@end


/* ----- NSFileManager Additons : Interface ----- */

@interface NSFileManager (SGSAdditions)

- (void) createPath: (NSS*) filePath;
- (NSS*) uniqueFilePath: (NSS*) filePath;

@end
#if !TARGET_OS_IPHONE
@interface NSString (CarbonUtilities)
+ (NSS*)    stringWithFSRef:(const FSRef *)aFSRef;
- _IsIt_         getFSRef:(FSRef *)aFSRef;
- (NSS*)    resolveAliasFile;
- (NSS*) humanReadableFileTypeForFileExtension;
@end

@interface NSFileManager (UKVisibleDirectoryContents)
// Same as directoryContentsAtPath, but filters out files whose names start with ".":
-(NSA*)	visibleDirectoryContentsAtPath: (NSS*)path;
@end
#endif
