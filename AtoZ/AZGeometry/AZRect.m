//  THRect.m
//
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZRect.h"

//#import "AtoZ.h"


@implementation AZEdge


+ (INST) rect:(AZRect*)r along:(AZRect*)outer inside:(BOOL)isinide {	
	AZEdge *n = self.new; 
//	n.align AZClosestCorner(outer, isinide)
	return n;
}
//@property AZA alignment;
//@property AZOrient orient;
//@property CGF cornerTreshHold, snapThreshold;
//- (void) moveInDirection:(NSSZ)sz;
@end

@implementation AZRect
@synthesize position, orient, anchor;

static AZRect *screnFrameUnderMenu = nil; 

+ (AZRect*)screnFrameUnderMenu { return screnFrameUnderMenu = screnFrameUnderMenu ?: [AZRect rectWithRect:AZScreenFrameUnderMenu()];
}

//
//- (AZA) alignInsideInDirection:(NSSZ)delta {
//
//	
//}
//- (AZA) alignInside:(NSR)outerRect
//{
//	AZRect *outer = [AZRect rectWithRect:outerRect];
//	AZA e = 0;
//
//	e |= 	self.maxY == outer.maxY ? AZAlignTop 	: 	self.minY == outer.minY ? AZAlignBottom	:
//			self.minX == outer.minX ? AZAlignLeft	:	self.maxX == outer.maxX ? AZAlignRight 	: e;
//
//	if (e != 0) return e;
//	NSP myCenter = edge.center;
//	CGF test = HUGE_VALF;
//	CGF minDist = AZMaxDim(outer.size);
//
//	test = AZDistanceFromPoint( myCenter, (NSP) { outer.minX, myCenter.y }); //testleft
//	if  ( test < minDist) { 	minDist = test; e = AZAlignLeft;}
//
//	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x,  0 }); //testbottom  OK
//	if  ( test < minDist) { 	minDist = test; e = AZAlignBottom; }
//
//	test = AZDistanceFromPoint( myCenter, (NSP) {outer.width, myCenter.y }); //testright
//	if  ( test < minDist) { 	minDist = test; e = AZAlignRight; }
//
//	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x, outer.height }); //testright
//	if  ( test < minDist) { 	minDist = test; e = AZAlignTop; }
//	return  e;
//}
//- (CGF) maxX { return self.origin.x + self.width; }
//- (CGF) maxY { return self.origin.y + self.height; }
//- (CGF) minX { return self.origin.x;	}
//- (CGF) minY { return self.origin.y; 	}
//- (NSP) apex {  return NSMakePoint(self.width, self.height); }

+ (AZRect*) rect {
//  return [[self alloc] init];

	return self.new;
}

+ (AZRect*) rect:(NSR)frame oriented:(AZPOS)pos {
	id selfnew = self.new;
	[selfnew setRect:frame];
	[(AZRect*)selfnew setOrient:pos];
	return selfnew;
}


+ (AZRect*) rectOf:(id) object {
	if (object == nil) return nil;
	AZRect *re = [[AZRect alloc] init];
	
	if ([object isKindOfClass:NSNumber.class]) {
	NSNumber *num = (NSNumber*) object;
	CGF f = num.floatValue;
	re->x = f;
	re->y = f;
	re->width = f;
	re->height = f;
	} else if ([object isKindOfClass:AZRect.class]) {
	AZRect *r = (AZRect*) object;
	re.rect = r.rect;
	} else if ([object isKindOfClass:AZPoint.class]) {
	AZPoint *pt = (AZPoint*) object;
	re->x = pt.x;
	re->y = pt.y;
	} else if ([object isKindOfClass:AZSize.class]) {
	AZSize *s = (AZSize*) object;
	re->width = s.width;
	re->height = s.height;
	} else if ([object isKindOfClass:NSView.class]) {
	NSView *view = (NSView*) object;
	re.rect = view.frame;
	} else if ([object isKindOfClass:CALayer.class]) {
	CALayer *l = (CALayer*) object;
	re->x = l.frame.origin.x;
	re->y = l.frame.origin.y;
	re->width = l.frame.size.width;
	re->height = l.frame.size.height;
	}
	
	return re;
}

- (NSR) r { return self.rect; }
- (void) setR:(NSR)r { self.rect = r; }

+ (AZRect*) rectWithRect:(NSR)r {
	AZRect *re = [[self alloc] init];
	re.rect = r;
	return re;
}

+ (AZRect*) rectWithOrigin:(NSP)origin andSize:(NSSZ)size {
	return [self rectWithRect:NSMakeRect(origin.x, origin.y, size.width, size.height)];
}

+ (AZRect*) rectWithX:(CGF)x 
			andY:(CGF)y 
		   width:(CGF)width 
		  height:(CGF)height
{
	return [self rectWithRect:NSMakeRect(x, y, width, height)];
}

+ (BOOL)maybeRect:(id) object {
	if (object == nil) {
	return NO;
	}
	
	NSArray *allowedClasses = 
	@[NSNumber.class, AZRect.class, AZSize.class,
	 NSView.class, CALayer.class];
	
	for (id clazz in allowedClasses) {
	if ([object isKindOfClass:clazz]) {
	 return YES;
	}
	}
	
	return NO;
}

#pragma mark - Instance Methods

- (id) init {
	if ((self = super.init)) {
	x = 0;
	y = 0;
	width = 0;
	height = 0;
	}
	
	return self;
}

- (id) initWithRect:(NSR)r {
	if ((self = self.init)) {
	x = r.origin.x;
	y = r.origin.y;
	width = r.size.width;
	height = r.size.height;
	}
	
	return self;
}

- (id) initWithSize:(NSSZ)s {
	if ((self = self.init)) {
	width = s.width;
	height = s.height;
	}
	
	return self;
}

- (id) initWithFrame:(NSR)frame inFrame:(NSR)superframe {
		if (!(self = self.init)) return nil;
	width = frame.size.width;
	height = frame.size.height;
	self.orient = AZPositionAtPerimeterInRect(frame, superframe);
	self.anchor = AZAnchorPointForPosition(self.orient);
	return self;
}

- (id) initFromPoint:(NSP)ptOne toPoint:(NSP)ptTwo {

	if ((self = self.init)) {
	x = MIN(ptOne.x, ptTwo.x);
	y = MIN(ptOne.y, ptTwo.y);
		width = MAX(ptOne.x, ptTwo.x) - x;
	height = MAX(ptOne.y, ptTwo.y) - y;
	}
	
	return self;
}

- (id) copy {
	id re = super.copy;
	if ([re isKindOfClass:AZRect.class]) {
	AZRect *r = (AZRect*) re;
	r.rect = self.rect;
	}
	return re;
}

- (NSString*) description {
	return [NSString stringWithFormat:@"%@(%4.f,%4.f; %4.f x %4.f)",
	  self.className, x, y, width, height];
}

@synthesize width, height;

- (NSP)origin {
	return self.point;
}

- (void) setOrigin:(NSP)pt {
	x = pt.x;
	y = pt.y;
}

- (CGF)area {
	return width * height;
}

- (NSSZ)size {
	return NSMakeSize(width, height);
}

- (void) setSize:(NSSZ)s {
	width = s.width;
	height = s.height;
}

- (NSP)center {
	return NSMakePoint(x + width  * 0.5, 
				 y + height * 0.5);
}

- (void) setCenter:(NSP)pt {
	x = pt.x - width  * 0.5;
	y = pt.y - height * 0.5;
}

- (NSR)rect {
	return NSMakeRect(x, y, width, height);
}

- (void) setRect:(NSR)r {
	self->x = r.origin.x;
	self->y = r.origin.y;
	self->width = r.size.width;
	self->height = r.size.height;
}

- (id) insetRectWithPadding:(NSI)padding {
	return [[self copy] shrinkByPadding:padding];
}

- (id) shrinkBy:(id) object {
	if (object == nil) {
	return self;
	}
	
	AZRect *r = [AZRect rectOf:object];
	x += r.x;
	y += r.y;
	width  -= (r.x + r.width);
	height -= (r.y + r.height);
	
	return self;
}

- (id) shrinkByPadding:(NSI)padding {
	x += padding;
	y += padding;
	width  -= 2 * padding;
	height -= 2 * padding;
	
	return self;
}

- (id) shrinkBySizePadding:(NSSZ)padding {
	x += padding.width;
	y += padding.height;
	width  -= 2 * padding.width;
	height -= 2 * padding.height;
	
	return self;
}

- (id) growBy:(id) object {
	if (object == nil) {
	return self;
	}
	
	AZRect *padding = [AZRect rectOf:object];
	
	x -= padding.x;
	y -= padding.y;
	width  += (padding.x + padding.width);
	height += (padding.y + padding.height);
	
	return self;
}

- (id) growByPadding:(NSI)padding {
	return [self shrinkByPadding:-padding];
}

- (id) growBySizePadding:(NSSZ)padding {
	x -= padding.width;
	y -= padding.height;
	width  += 2 * padding.width;
	height += 2 * padding.height;
	
	return self;
}

- (BOOL)equals:(id) object {
	if (object == nil) {
	return NO;
	}
	
	AZRect *compare = [AZRect rectOf:object];
	
	return 
	compare->x == self->x 
	&& compare->y == self->y
	&& compare->width == self->width
	&& compare->height == self->height
	;
}

- (BOOL)contains:(id) object {
	if (object == nil) {
	return NO;
	}
	
	if ([AZRect maybeRect:object]) {
	return [self containsRect:[AZRect rectOf:object].rect];
	} else if ([AZPoint maybePoint:object]) {
	return [self contaiNSP:[AZPoint pointOf:object].point];
	}
	
	return NO;
}

- (BOOL)contaiNSP:(NSP)pt {
	return 
	self->x <= pt.x 
	&& self->x + self->width >= pt.x
	&& self->y <= pt.y 
	&& self->y + self->height >= pt.y
	;
}

- (BOOL)containsRect:(NSR)r {
	return 
	self->x <= r.origin.x 
	&& self->y <= r.origin.y 
	&& self->width >= r.size.height 
	&& self->height >= r.size.height
	;
}

// graphing
- (void) drawFrame {
	NSFrameRect(self.rect);
}

- (void) fill {
	NSRectFill(self.rect);
}

- (id) centerOn:(id) bounds {
	return [self moveTo:AZPoint.halfPoint ofRect:bounds];
}

- (id) moveTo:(id) point ofRect:(id) bounds {
	AZPoint *pt = [AZPoint pointOf:point];
	AZRect  *br = [AZRect rectOf:bounds];
	
	if (!br.area) {
	return self;
	}
	
	if (0 < pt.x && pt.x <= 1) {
	self->x = br.x + (br.width - width) * pt.x;
	} else {
	self->x = br.x + pt.x;
	}
	
	if (0 < pt.y && pt.y <= 1) {
	self->y = br.y + (br.height - height) * pt.y;
	} else {
	self->y = br.y + pt.y;
	}
	
	return self;
}

- (id) sizeTo:(id) point ofRect:(id) bounds {
	AZPoint *pt = [AZPoint pointOf:point];
	AZRect  *br = [AZRect rectOf:bounds];
	
	if (!br.area) {
	return self;
	}
	
	if (0 < pt.x && pt.x <= 1) {
	self->width = br.width * pt.x;
	} else if (pt.x < 0) {
	self->width = br.width - pt.x;
	}
	
	if (0 < pt.y && pt.y <= 1) {
	self->height = br.height * pt.y;
	} else if (pt.y < 0) {
	self->height = br.height - pt.y;
	}
	
	return self;
}

@end
