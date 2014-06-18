
NS_INLINE NSS* humanReadableFileTypeForFileExtension (NSS *ext) {

	CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                             (__bridge CFStringRef)ext, NULL);
	NSS *UTIDesc = (__bridge NSS*)UTTypeCopyDescription(fileUTI); return CFRelease(fileUTI),UTIDesc;
}


NSS *NSDocumentsFolder(void);
NSS *NSLibraryFolder(void);
NSS *NSTmpFolder(void);
NSS *NSBundleFolder(void);

@interface NSFileManager (AtoZ)

- (NSA*) pathsOfContentsOfDirectory:(NSS*) directory;

- (NSA*) arrayWithFilesMatchingPattern: (NSS*) pattern inDirectory: (NSS*) directory;

- (NSS*) pathForItemNamed: (NSS*) fname inFolder: (NSS*) path;
- (NSS*) pathForDocumentNamed: (NSS*) fname;
- (NSS*) pathForBundleDocumentNamed: (NSS*) fname;

//non-resursive
- (NSA*) pathsForItemsInFolder:(NSS*)path withExtension: (NSS*) ext;

- (NSA*) pathsOfFilesIn:(NSS*)path withExtension:  (NSS*)ext;
- (NSA*) pathsOfFilesIn:(NSS*)path matchingPattern:(NSS*)regex;
- (NSA*) pathsOfFilesIn:(NSS*)path passing:(BOOL(^)(NSS*))testBlock;
//recursive
- (NSA*) pathsForItemsNamed:(NSS*)ext inFolder:(NSS*)path;
- (NSA*) pathsForItemsMatchingExtension: (NSS*) ext inFolder: (NSS*) path;
- (NSA*) pathsForDocumentsMatchingExtension: (NSS*) ext;
- (NSA*) pathsForBundleDocumentsMatchingExtension: (NSS*) ext;

- (NSA*) filesInFolder: (NSS*) path;

//+ (NSImage *) imageNamed: (NSS*) aName;
//+ (NSImage *) imageFromURLString: (NSS*) urlstring;

@end

@interface NSFileManager (OFSimpleExtensions)

- (NSD*)attributesOfItemAtPath:(NSS*)filePath traverseLink:(BOOL)traverseLink error:(NSError **)outError;

	// Directory manipulations

- (BOOL)directoryExistsAtPath:(NSS*)path;
- (BOOL)directoryExistsAtPath:(NSS*)path traverseLink:(BOOL)traverseLink;

- (BOOL)createPathToFile:(NSS*)path attributes:(NSD*)attributes error:(NSError **)outError;
	// Creates any directories needed to be able to create a file at the specified path.

	// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.
- (BOOL)createPathComponents:(NSA*)components attributes:(NSD*)attributes error:(NSError **)outError;

	// Changing file access/update timestamps.

- (BOOL)touchItemAtURL:(NSURL *)url error:(NSError **)outError;

#ifdef DEBUG
- (void) ogPropertiesOfTreeAtURL:(NSURL *)url;
#endif

@end

@interface NSFileManager (Extensions)
- (NSS*) mimeTypeFromFileExtension:(NSS*)extension;
- (BOOL) getExtendedAttributeBytes:(void*)bytes length:(NSUI)length withName:(NSS*)name forFileAtPath:(NSS*)path;
- (NSData*) extendedAttributeDataWithName:(NSS*)name forFileAtPath:(NSS*)path;
- (NSS*) extendedAttributeStringWithName:(NSS*)name forFileAtPath:(NSS*)path;  // Uses UTF8 encoding
- (BOOL) setExtendedAttributeBytes:(const void*)bytes length:(NSUI)length withName:(NSS*)name forFileAtPath:(NSS*)path;
- (BOOL) setExtendedAttributeData:(NSData*)data withName:(NSS*)name forFileAtPath:(NSS*)path;
- (BOOL) setExtendedAttributeString:(NSS*)string withName:(NSS*)name forFileAtPath:(NSS*)path;  // Uses UTF8 encoding
- (BOOL) removeItemAtPathIfExists:(NSS*)path;
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

@interface NSString (CarbonUtilities)
+ (NSS*)    stringWithFSRef:(const FSRef *)aFSRef;
- (BOOL)         getFSRef:(FSRef *)aFSRef;
- (NSS*)    resolveAliasFile;
- (NSS*) humanReadableFileTypeForFileExtension;
@end

@interface NSFileManager (UKVisibleDirectoryContents)
// Same as directoryContentsAtPath, but filters out files whose names start with ".":
-(NSA*)	visibleDirectoryContentsAtPath: (NSS*)path;
@end
