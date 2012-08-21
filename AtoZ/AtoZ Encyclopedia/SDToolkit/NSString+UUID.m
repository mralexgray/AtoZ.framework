//
//  NSString+UUID.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString (UniqueAdditions)

+ (NSString*) UUIDString {
	CFUUIDRef UUID = CFUUIDCreate(NULL);
	CFStringRef str = CFUUIDCreateString(NULL, UUID);
	CFRelease(UUID);
	return [(NSString*)str autorelease];
}

@end
