//
//  NSWorkspace+SystemInfo.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//


#import <AtoZ/AtoZ.h>
	
@interface NSWorkspace (SystemInfo)

+ (NSString*) systemVersion;

@end
@interface NSWorkspace (JAAdditions)
- (void) penURLInBackground:(NSURL *)url;
- (void) penURLsInBackground:(NSArray *)urls;
- (void) penURLs:(NSArray *)urls;

- (NSString *)applicationSupportDirectory;
- (NSString *)preferencesDirectory;
@end
