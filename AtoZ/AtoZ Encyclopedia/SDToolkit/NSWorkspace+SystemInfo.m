//
//  NSWorkspace+SystemInfo.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSWorkspace+SystemInfo.h"


@implementation NSWorkspace (SystemInfo)

+ (NSString*) systemVersion {
    SInt32 versionMajor, versionMinor, versionBugFix;
	
	OSErr maj = Gestalt(gestaltSystemVersionMajor, &versionMajor);
	OSErr min = Gestalt(gestaltSystemVersionMinor, &versionMinor);
	OSErr bug = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
	
	if (maj != noErr || min != noErr || bug != noErr)
		return nil;
	
    return $(@"%d.%d.%d", versionMajor, versionMinor, versionBugFix);
}

@end
