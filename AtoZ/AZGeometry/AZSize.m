//
//  THSize.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZSize.h"
#import "AtoZGeometry.h"

//#import "AZPoint.h"
//#import "AZRect.h"
@implementation AZSize

+ (AZSize*) size {
	AZSize *s = AZSize.new;
	return s;
}

+ (AZSize*) sizeOf:(id) object {
	AZSize *re = [[AZSize alloc] initWithWidth:0 height:0];
	
	if (object == nil) {
	return re;
	}
	
	if ([object isKindOfClass:[NSNumber class]]) {
	NSNumber *n = (NSNumber*) object;
	re.width  = n.floatValue;
	re.height = n.floatValue;
	} else if ([object isKindOfClass:[AZPoint class]]) {
	AZPoint *pt = (AZPoint*) object;
	re.width  = pt.x;
	re.height = pt.y;
	} else if ([object isKindOfClass:[AZSize class]]) {
	AZSize *s = (AZSize*) object;
	re.width  = s.width;
	re.height = s.height;
	} else if ([object isKindOfClass:[NSView class]]) {
	NSView *v = (NSView*) object;
	re.width = v.frame.size.width;
	re.height = v.frame.size.height;
	} else if ([object isKindOfClass:[CALayer class]]) {
	CALayer *l = (CALayer*) object;
	re.width = l.frame.size.width;
	re.height = l.frame.size.height;
	}
	
	return re;
}

+ (AZSize*) sizeWithSize:(NSSZ)s {
	return [[AZSize alloc] initWithSize:s];
}

+ (AZSize*) sizeWithWidth:(CGF)w height:(CGF)h {
	return [[AZSize alloc] initWithWidth:w height:h];
}

+ (BOOL)maybeSize:(id) object {
	if (object == nil) {
	return NO;
	}
	
	NSArray *allowedClasses = 
	@[[NSNumber class], [AZPoint class], [AZSize class], [AZRect class],
	[NSView class], [CALayer class]];
	
	for (id clazz in allowedClasses) {
	if ([object isKindOfClass:clazz]) {
	 return YES;
	}
	}
	
	return NO;
}

- (id) copy {
	return [[AZSize alloc] initWithWidth:width height:height];
}

- (id) copyWithZone:(NSZone*) zone {
	return [[AZSize allocWithZone:zone] initWithWidth:width height:height];
}

- (id) initWithWidth:(CGF)w height:(CGF)h {
	if ((self = [super init])) {
	width = w;
	height = h;
	}
	
	return self;
}

- (id) initWithSize:(NSSZ)s {
	return [self initWithWidth:s.width height:s.height];
}

@synthesize width, height;

- (CGF)min {
	return MIN(self->width, self->height);
}

- (CGF)max {
	return MAX(self->width, self->height);
}

- (CGF)wthRatio {
	return self->width / self->height;
}

- (NSSZ)size {
	return NSMakeSize(width, height);
}

- (void) setSize:(NSSZ)s {
	width = s.width;
	height = s.height;
}

- (id) growBy:(id) factor {
	if (factor == nil) {
	return self;
	}
	
	AZSize *size = [AZSize sizeOf:factor];
	
	self->width += size.width;
	self->height += size.height;
	
	return self;
}

- (id) growByWidth:(CGF)w height:(CGF)h {
	self->width += w;
	self->height += h;
	
	return self;
}

- (id) multipyBy:(id) factor {
	if (factor == nil) {
	return self;
	}
	
	AZSize *f = [AZSize sizeOf:factor];
	
	self->width *= f.width;
	self->height *= f.height;
	
	return self;
}

- (id) multipyByWidth:(CGF)w height:(CGF)h {
	self->width *= w;
	self->height *= h;
	
	return self;
}

- (id) multipyByPoint:(NSP)point {
	self->width *= point.x;
	self->height *= point.y;
	
	return self;
}

- (id) multipyBySize:(NSSZ)s {
	self->width *= s.width;
	self->height *= s.height;
	
	return self;
}

- (id) divideBy:(id) factor {
	if (factor == nil) {
	return self;
	}
	
	AZSize *f = [AZSize sizeOf:factor];
	
	self->width /= f.width;
	self->height /= f.height;
	
	return self;
}

- (id) divideByWidth:(CGF)w height:(CGF)h {
	self->width /= w;
	self->height /= h;
	
	return self;
}

- (id) divideByPoint:(NSP)point {
	self->width /= point.x;
	self->height /= point.y;
	
	return self;
}

- (id) divideBySize:(NSSZ)s {
	self->width /= s.width;
	self->height /= s.height;
	
	return self;
}

- (id) swap {
	CGF t = self->width;
	self->width = self->height;
	self->height = t;
	
	return self;
}

- (id) negate {
	self->width = -self->width;
	self->height = -self->height;
	
	return self;
}

- (id) invert {
	self->width = 1 / self->width;
	self->height = 1 / self->height;
	
	return self;
}

- (NSString*) description {
	return [NSString stringWithFormat:@"%@(%4.f x %4.f)",
	  self.className, width, height];
}

@end
