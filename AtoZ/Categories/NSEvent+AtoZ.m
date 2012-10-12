//
//  NSEvent+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSEvent+AtoZ.h"
@implementation NSControl (AtoZ)

- (void) setAction:(SEL)method withTarget:(id)object;
{
	[self setAction:method];
	[self setTarget:object];
}

@end
@implementation NSEvent (AtoZ)
+ (void) shiftClick:(void(^)(void))block {

	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler: ^(NSEvent *event){
		NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
		if (flags ==  NSShiftKeyMask)   block(); ////NSControlKeyMask +
		return event;
	}];
}

@end
