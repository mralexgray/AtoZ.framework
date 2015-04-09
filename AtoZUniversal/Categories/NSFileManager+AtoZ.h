
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
- _Void_ setTag _ _UInt_ t forFileAtPath:pathorurl;

- _List_    pathsOfContentsOfDirectory: _Text_ dir;
- _List_ arrayWithFilesMatchingPattern: _Text_ pattern inDirectory: _Text_ dir;
- _Text_              pathForItemNamed: _Text_ fname      inFolder: _Text_ path;
#if !TARGET_OS_IPHONE
- _Text_          pathForDocumentNamed: _Text_ fname;
- _Text_    pathForBundleDocumentNamed: _Text_ fname;
#endif

/// non-resursive
- _List_ pathsForItemsInFolder _ _Text_ p withExtension: _Text_ x;
- _List_        pathsOfFilesIn _ _Text_ p withExtension: _Text_ x;

/*! [FM pathsOfFilesIn:NSHomeDirectory() matchingPattern:@"/.*"]   .dotfiles  */

- _List_ pathsOfFilesIn: _Text_ p matchingPattern: _Text_ regex;
- _List_ pathsOfFilesIn: _Text_ p         passing:(BOOL(^)(NSS*))testBlock;

/// recursive

- _List_                       pathsForItemsNamed _ _Text_ x inFolder _ _Text_ p;
- _List_           pathsForItemsMatchingExtension _ _Text_ x inFolder _ _Text_ p;
- _List_       pathsForDocumentsMatchingExtension _ _Text_ x;
- _List_ pathsForBundleDocumentsMatchingExtension _ _Text_ x;

- _List_                            filesInFolder: _Text_ p;

//+ (NSImage *) imageNamed: (NSS*) aName;
//+ (NSImage *) imageFromURLString: (NSS*) urlstring;

- _IsIt_ isSymlink: _Text_ ln;
- _IsIt_ isSymlink: _Text_ ln to: _Text_ p;

@end

@interface NSFileManager (OFSimpleExtensions)

- _Dict_ attributesOfItemAtPath: _Text_ filePath traverseLink: _IsIt_ traverseLink error:(NSERR*__autoreleasing*)outError;

/// Directory manipulations

- _IsIt_ directoryExistsAtPath _ _Text_ p;
- _IsIt_ directoryExistsAtPath _ _Text_ ph traverseLink _ _IsIt_ traverseLink;

- _IsIt_      createPathToFile _ _Text_ p    attributes _ _Dict_ x error:(_Errr __autoreleasing*)e;

/// Creates any directories needed to be able to create a file at the specified path.  Returns NO on failure.

- _IsIt_  createPathComponents _ _List_ x    attributes _ _Dict_ a error:(_Errr __autoreleasing*)e;

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
- _IsIt_        removeItemAtPathIfExists _ _Text_ p;
- _Data_   extendedAttributeDataWithName _ _Text_ n    forFileAtPath _ _Text_ p;
- _Text_ extendedAttributeStringWithName _ _Text_ n    forFileAtPath _ _Text_ p;  // Uses UTF8 encoding
- _IsIt_       getExtendedAttributeBytes _       (_Void*)b    length _ _UInt_ l withName _ _Text_ n forFileAtPath _ _Text_ p;
- _IsIt_       setExtendedAttributeBytes _ (const _Void*)b    length _ _UInt_ l withName _ _Text_ n forFileAtPath _ _Text_ p;
- _IsIt_        setExtendedAttributeData _ _Data_ d         withName _ _Text_ n   forFileAtPath _ _Text_ p;
- _IsIt_      setExtendedAttributeString _ _Text_ t         withName _ _Text_ n   forFileAtPath _ _Text_ p;  // Uses UTF8 encoding
- _List_          filesInDirectoryAtPath _ _Text_ p includeInvisible _ _IsIt_ i includeSymlinks _ _IsIt_ links;
- _List_    directoriesInDirectoryAtPath _ _Text_ p includeInvisible _ _IsIt_ i;
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
