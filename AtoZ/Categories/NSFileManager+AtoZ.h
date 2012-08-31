
//  NSFileManager+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>

NSString *NSDocumentsFolder();
NSString *NSLibraryFolder();
NSString *NSTmpFolder();
NSString *NSBundleFolder();

@interface NSFileManager (AtoZ)
- (NSArray*) arrayWithFilesMatchingPattern: (NSString*) pattern inDirectory: (NSString*) directory;
+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path;
+ (NSString *) pathForDocumentNamed: (NSString *) fname;
+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname;

+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path;
+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext;
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext;

+ (NSArray *) filesInFolder: (NSString *) path;

+ (NSImage *) imageNamed: (NSString *) aName;
+ (NSImage *) imageFromURLString: (NSString *) urlstring;

@end
