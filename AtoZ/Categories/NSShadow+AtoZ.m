//
//  NSShadow+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSShadow+AtoZ.h"

@implementation NSShadow (AtoZ)

- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur
{
self = [self init];

if (self != nil) {
	self.shadowColor = color;
	self.shadowOffset = offset;
	self.shadowBlurRadius = blur;
}

return self;
}

@end
