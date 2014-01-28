

NSString *NSDocumentsFolder(void);
NSString *NSLibraryFolder(void);
NSString *NSTmpFolder(void);
NSString *NSBundleFolder(void);

@interface NSFileManager (AtoZ)

- (NSA*) pathsOfContentsOfDirectory:(NSString*) directory;

- (NSA*) arrayWithFilesMatchingPattern: (NSString*) pattern inDirectory: (NSString*) directory;

+ (NSS*) pathForItemNamed: (NSS*) fname inFolder: (NSS*) path;
+ (NSS*) pathForDocumentNamed: (NSS*) fname;
+ (NSS*) pathForBundleDocumentNamed: (NSS*) fname;

//non-resursive
+ (NSA*) pathsForItemsInFolder:(NSS*)path withExtension: (NSS*) ext;

+ (NSA*) pathsOfFilesIn:(NSString*)path withExtension:  (NSString*)ext;
+ (NSA*) pathsOfFilesIn:(NSString*)path matchingPattern:(NSString*)regex;
+ (NSA*) pathsOfFilesIn:(NSString*)path passing:(BOOL(^)(NSString*))testBlock;
//recursive
+ (NSA*) pathsForItemsMatchingExtension: (NSS*) ext inFolder: (NSS*) path;
+ (NSA*) pathsForDocumentsMatchingExtension: (NSS*) ext;
+ (NSA*) pathsForBundleDocumentsMatchingExtension: (NSS*) ext;

+ (NSA*) filesInFolder: (NSS*) path;

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
- (void)logPropertiesOfTreeAtURL:(NSURL *)url;
#endif

@end

@interface NSFileManager (Extensions)
- (NSString*) mimeTypeFromFileExtension:(NSString*)extension;
- (BOOL) getExtendedAttributeBytes:(void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path;
- (NSData*) extendedAttributeDataWithName:(NSString*)name forFileAtPath:(NSString*)path;
- (NSString*) extendedAttributeStringWithName:(NSString*)name forFileAtPath:(NSString*)path;  // Uses UTF8 encoding
- (BOOL) setExtendedAttributeBytes:(const void*)bytes length:(NSUInteger)length withName:(NSString*)name forFileAtPath:(NSString*)path;
- (BOOL) setExtendedAttributeData:(NSData*)data withName:(NSString*)name forFileAtPath:(NSString*)path;
- (BOOL) setExtendedAttributeString:(NSString*)string withName:(NSString*)name forFileAtPath:(NSString*)path;  // Uses UTF8 encoding
- (BOOL) removeItemAtPathIfExists:(NSString*)path;
- (NSA*) directoriesInDirectoryAtPath:(NSString*)path includeInvisible:(BOOL)invisible;
- (NSA*) filesInDirectoryAtPath:(NSString*)path includeInvisible:(BOOL)invisible includeSymlinks:(BOOL)symlinks;
#if TARGET_OS_IPHONE
- (void) setDoNotBackupAttributeAtPath:(NSString*)path;  // Has no effect prior to iOS 5.0.1
#endif
@end


/* ----- NSFileManager Additons : Interface ----- */

@interface NSFileManager (SGSAdditions)

- (void) createPath: (NSString*) filePath;
- (NSString*) uniqueFilePath: (NSString*) filePath;

@end

@interface NSString (CarbonUtilities)
+(NSString*)    stringWithFSRef:(const FSRef *)aFSRef;
-(BOOL)         getFSRef:(FSRef *)aFSRef;
-(NSString*)    resolveAliasFile;
@end

@interface NSFileManager (UKVisibleDirectoryContents)
// Same as directoryContentsAtPath, but filters out files whose names start with ".":
-(NSArray*)	visibleDirectoryContentsAtPath: (NSString*)path;
@end
