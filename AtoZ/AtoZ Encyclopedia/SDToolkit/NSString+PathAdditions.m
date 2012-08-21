//
//  NSString+PathAdditions.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSString+PathAdditions.h"


@implementation NSString (PathAdditions)

- (BOOL) isEqualToPath:(NSString*)otherPath {
	FSRef firstPathRef, secondPathRef;
	
	OSStatus makeFirstRefResult = FSPathMakeRef((const UInt8*)[self fileSystemRepresentation], &firstPathRef, NULL);
	OSStatus makeSecondRefResult = FSPathMakeRef((const UInt8*)[otherPath fileSystemRepresentation], &secondPathRef, NULL);
	
	if (makeFirstRefResult != noErr || makeSecondRefResult != noErr)
		[NSException raise:NSInternalInconsistencyException format:@"Could not create refs from paths: [%@] [%@]", self, otherPath];
	
	return (FSCompareFSRefs(&firstPathRef, &secondPathRef) == noErr);
}

@end
