//
//  TUIView+Dimensions.m
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "TUIView+Dimensions.h"

@implementation TUIView (Dimensions)

- (CGF)originX { return [self frame].origin.x; }
- (CGF)originY { return [self frame].origin.y; }

- (void)setOriginX:(CGF)x {
	if (x != self.originX) [self setFrame:AZRectExceptOriginX(self.frame,x)];//,self.superview.needsDisplay =YES;
}
- (void)setOriginY:(CGF)y {
	if (y != self.originY) [self setFrame: AZRectExceptOriginY(self.frame,y)];//,self.superview.needsDisplay =YES;
}


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
