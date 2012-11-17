//
//  NSEvent+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSEvent+AtoZ.h"

@implementation NSTextField (TargetAction)

- (void) setAction:(SEL)method withTarget:(id)object;
{
	[self setAction:method];
	[self setTarget:object];
}

@end

#include <objc/runtime.h>

static NSString *NSCONTROLBLOCKACTIONKEY = @"com.mrgray.NSControl.block";

@implementation NSControl (AtoZ)
@dynamic actionBlock;

- (NSControlActionBlock)actionBlock
{
//	NSControlActionBlock theBlock =
	return (NSControlActionBlock)[self associatedValueForKey:NSCONTROLBLOCKACTIONKEY];
//	return(theBlock);
}

- (void)setActionBlock:(NSControlActionBlock)inBlock
{
	self.target = self;
	self.action = @selector(callAssociatedBlock:);
	[self setAssociatedValue:inBlock forKey: NSCONTROLBLOCKACTIONKEY policy:OBJC_ASSOCIATION_COPY];
}

- (void)callAssociatedBlock:(id)inSender { self.actionBlock(inSender); }

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
