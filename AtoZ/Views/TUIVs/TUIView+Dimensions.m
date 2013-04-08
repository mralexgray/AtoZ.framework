//
//  TUIView+Dimensions.m
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "TUIView+Dimensions.h"

@implementation TUIView (Dimensions)


- (CGF)width {	return [self frame].size.width ;		}

- (CGF)height {	return [self frame].size.height ;	}

- (void)setWidth:(CGF)t {
	NSRect frame = [self frame] ;
	frame.size.width = t ;
	[self setFrame:frame] ;
}

- (void)setHeight:(CGF)t 	{ 	self.frame = AZRectExceptHigh(self.frame, t); }

- (NSSize)size 				{	return  self.bounds.size; }

- (void)setSize:(NSSize)size
{
	NSR frame = self.frame ;
	frame.size.width  = size.width ;
	frame.size.height = size.height ;
	self.frame = frame;
}

@end

@implementation TUIView (BezierPaths)
- (NSBP*) path {  NSBP* path = [self associatedValueForKey:@"bPath"];

	return path ?: [NSBP bezierPathWithRect:self.bounds];
}

- (void) setPath:(NSBezierPath *)path {

	[self setAssociatedValue:path forKey:@"bPath" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end

@implementation TUIView (Subviews)

- (void) setSubviews:  (NSA*) subs {

	[subs each:^(id obj) {
		[self addSubview:obj];
	}];
}

@end
