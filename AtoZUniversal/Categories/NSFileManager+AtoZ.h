
#if !TARGET_OS_IPHONE
NS_INLINE NSS* humanReadableFileTypeForFileExtension (NSS *ext) {

	CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                             (__bridge CFStringRef)ext, NULL);
	NSS *UTIDesc = (__bridge NSS*)UTTypeCopyDescription(fileUTI); return CFRelease(fileUTI),UTIDesc;
}

#endif

_Text NSDocumentsFolder _Void_;
_Text   NSLibraryFolder _Void_;
_Text       NSTmpFolder _Void_;
_Text    NSBundleFolder _Void_;

@interface NSFileManager (AtoZ)

-                     tagForFileAtPath:pathorurl;
- _Void_ setTag:_UInt_ t forFileAtPath:pathorurl;

- _List_    pathsOfContentsOfDirectory: _Text_ dir;
- _List_ arrayWithFilesMatchingPattern: _Text_ pattern inDirectory: _Text_ dir;
- _Text_              pathForItemNamed: _Text_ fname      inFolder: _Text_ path;
#if !TARGET_OS_IPHONE
- _Text_          pathForDocumentNamed: _Text_ fname;
- _Text_    pathForBundleDocumentNamed: _Text_ fname;
#endif

/// non-resursive
- _List_ pathsForItemsInFolder:_Text_ p withExtension: _Text_ x;
- _List_        pathsOfFilesIn:_Text_ p withExtension: _Text_ x;

/*! [FM pathsOfFilesIn:NSHomeDirectory() matchingPattern:@"/.*"]   .dotfiles  */

- _List_ pathsOfFilesIn: _Text_ p matchingPattern: _Text_ regex;
- _List_ pathsOfFilesIn: _Text_ p         passing:(BOOL(^)(NSS*))testBlock;

/// recursive

- _List_                       pathsForItemsNamed:_Text_ x inFolder:_Text_ p;
- _List_           pathsForItemsMatchingExtension:_Text_ x inFolder:_Text_ p;
- _List_       pathsForDocumentsMatchingExtension:_Text_ x;
- _List_ pathsForBundleDocumentsMatchingExtension:_Text_ x;

- _List_                            filesInFolder: _Text_ p;

//+ (NSImage *) imageNamed: (NSS*) aName;
//+ (NSImage *) imageFromURLString: (NSS*) urlstring;

- _IsIt_ isSymlink: _Text_ ln;
- _IsIt_ isSymlink: _Text_ ln to: _Text_ p;

@end

@interface NSFileManager (OFSimpleExtensions)

- _Dict_ attributesOfItemAtPath: _Text_ filePath traverseLink: _IsIt_ traverseLink error:(NSERR*__autoreleasing*)outError;

/// Directory manipulations

- _IsIt_ directoryExistsAtPath:_Text_ p;
- _IsIt_ directoryExistsAtPath:_Text_ ph traverseLink:_IsIt_ traverseLink;

- _IsIt_      createPathToFile:_Text_ p    attributes:_Dict_ x error:(_Errr __autoreleasing*)e;

/// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.

- _IsIt_  createPathComponents:_List_ x    attributes:_Dict_ a error:(_Errr __autoreleasing*)e;

/// Changing file access/update timestamps.

- _IsIt_ touchItemAtURL:_NUrl_ u error:(_Errr __autoreleasing*)e;

#ifdef DEBUG
- _Void_ logPropertiesOfTreeAtURL:(NSURL*)url;
#endif

@end

@interface NSFileManager (Extensions)
#if !TARGET_OS_IPHONE
- (NSS*) mimeTypeFromFileExtension: _Text_ extension;
#endif
- _IsIt_        removeItemAtPathIfExists:_Text_ p;
- _Data_   extendedAttributeDataWithName:_Text_ n    forFileAtPath:_Text_ p;
- _Text_ extendedAttributeStringWithName:_Text_ n    forFileAtPath:_Text_ p;  // Uses UTF8 encoding
- _IsIt_       getExtendedAttributeBytes:   (_Void*)b       length:_UInt_ l        withName:_Text_ n forFileAtPath:_Text_ p;
- _IsIt_       setExtendedAttributeBytes:(_C _Void*)b       length:_UInt_ l        withName:_Text_ n forFileAtPath:_Text_ p;
- _IsIt_        setExtendedAttributeData:_Data_ d         withName:_Text_ n   forFileAtPath:_Text_ p;
- _IsIt_      setExtendedAttributeString:_Text_ t         withName:_Text_ n   forFileAtPath:_Text_ p;  // Uses UTF8 encoding
- _List_          filesInDirectoryAtPath:_Text_ p includeInvisible:_IsIt_ i includeSymlinks:_IsIt_ links;
- _List_    directoriesInDirectoryAtPath:_Text_ p includeInvisible:_IsIt_ i;
#if TARGET_OS_IPHONE
- _Void_ setDoNotBackupAttributeAtPath: _Text_ path;  // Has no effect prior to iOS 5.0.1
#endif
@end


/* ----- NSFileManager Additons : Interface ----- */

@interface NSFileManager (SGSAdditions)

- _Void_ createPath: _Text_ filePath;
- _Text_ uniqueFilePath: _Text_ filePath;

@end
#if !TARGET_OS_IPHONE
@interface NSString (CarbonUtilities)
+ _Text_    stringWithFSRef:(const FSRef *)aFSRef;
- _IsIt_         getFSRef:(FSRef *)aFSRef;
- _Text_    resolveAliasFile;
- _Text_ humanReadableFileTypeForFileExtension;
@end

@interface NSFileManager (UKVisibleDirectoryContents)
// Same as directoryContentsAtPath, but filters out files whose names start with ".":
-(NSA*)	visibleDirectoryContentsAtPath: (NSS*)path;
@end
#endif
