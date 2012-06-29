//
//  FSItem.h
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface FSItem : NSObject {
	NSString 		*__unsafe_unretained parent;
	NSString 		*__unsafe_unretained filename;
	NSDictionary 	*__unsafe_unretained attributes;
	NSArray 		*children;
	NSString 		*__unsafe_unretained path;
}

@property(unsafe_unretained, nonatomic) NSString *parent; 
@property(unsafe_unretained, nonatomic) NSString *filename;
@property(unsafe_unretained, nonatomic) NSDictionary *attributes;
@property(unsafe_unretained, nonatomic) NSArray *children;
@property(unsafe_unretained, nonatomic) NSString *path;
@property(unsafe_unretained, nonatomic) NSColor *labelColor;

@property(unsafe_unretained, readonly) NSString *prettyFilename;

@property(unsafe_unretained, nonatomic) NSImage *icon;

@property(unsafe_unretained, readonly) NSDate *modificationDate;
@property(unsafe_unretained, readonly) NSString *ownerName;
@property(unsafe_unretained, readonly) NSString *groupName;
@property(unsafe_unretained, readonly) NSString *posixPermissions;
@property(unsafe_unretained, readonly) NSDate *creationDate;
@property(unsafe_unretained, readonly) NSString *fileSize;
@property(unsafe_unretained, readonly) NSString *ownerAndGroup;

@property(readonly) BOOL isDirectory;
@property(readonly) BOOL isSymbolicLink;
@property(readonly) BOOL canBeFollowed;

//+ (FSItem *)fsItemWithDir:(NSString *)dir fileName:(NSString *)fileName;
+ (FSItem *)withPath:(NSString *)location isFolder:(BOOL)fileOrDir;
@end
