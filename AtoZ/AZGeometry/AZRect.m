//  THRect.m
//
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
#import "AtoZ.h"
#import "AZRect.h"
#import <Zangetsu/Zangetsu.h>


@implementation AZEdge
+ (INST) rect:(AZRect*)r along:(AZRect*)outer inside:(BOOL)isinide {	
	AZEdge *n = self.new; 			//	n.align AZClosestCorner(outer, isinide)
	return n;
}
@end

@implementation AZRect { NSR _rect; } // @synthesize rect =
@synthesize r = _rect;
// STOPGAP  BELOW
- (NSR) bounds { return AZRectFromSizeOfRect(_rect); }
- (void) setBounds:(NSR)bounds { _rect = AZRectExceptSize(_rect,bounds.size); }

- (NSR) frame { return _rect; }
- (void) setFrame:(NSR)frame { _rect = frame; }

// STOPGAP  END

+ (INST) withRect:(NSR)r { AZRect *re = self.class.new;	re->_rect = r;	return re; }

+ (INST) x:(CGF)x y:(CGF)y w:(CGF)w h:(CGF)h { return [self withRect:NSMakeRect(x, y,w,h)]; }


// @synthesize bounds, origin; position, orient, anchor;

-(INST) shiftedX:(CGF)xx y:(CGF)yy w:(CGF)w h:(CGF)h {

	NSR r = _rect;
	r.origin.x +=xx;
	r.origin.y +=yy;
	r.size.width +=w;
	r.size.height+=h;
	return [self.class withRect:r];
}
static AZRect *screnFrameUnderMenu = nil;
+ (AZRect*)screnFrameUnderMenu { return screnFrameUnderMenu = screnFrameUnderMenu ?: [AZRect withRect:AZScreenFrameUnderMenu()]; }

//-  (CGF) leftEdge 				{	return [self rect].origin.x ;	}
//- (void) setLeftEdge: (CGF)t 	{ NSR frame = self.rect ;	frame.origin.x = t ;	[self setRect:frame] ;	}
//-  (CGF) rightEdge 				{	return [self rect].origin.x + [self width] ;	}
//- (void) setRightEdge:(CGF)t 	{ NSR frame = self.rect ;	frame.origin.x = t - [self width] ;	[self setRect:frame];	}
//-  (CGF) centerX   				{	return ([self rect].origin.x + [self width]/2) ;	}
//- (void) setCenterX:  (CGF)t 	{ CGF center = self.centerX;	CGF adjustment = t - center ; self.minX += adjustment;	}
//-  (CGF) bottom 					{	return self.rect.origin.y ;	}
//- (void) setBottom:	 (CGF)t 	{ NSRect frame = self.rect ;	frame.origin.y = t ;	[self setRect:frame] ;	}
//-  (CGF) top 						{		return self.rect.origin.y + [self height] ;	}
//- (void) setTop:		 (CGF)t 	{	NSRect frame = self.rect ;	frame.origin.y = t - [self height] ;	[self setRect:frame] ;	}
//-  (CGF) centerY 					{	return (self.rect.origin.y + [self height]/2) ;}
//- (void) setCenterY:	 (CGF)t 	{	self.minY += (t - self.centerY);		}
//-  (CGF) w 							{	return self.width ;		}
//- (void) setW:			 (CGF)w 	{	self.width = w;	}
//-  (CGF) h 							{	return self.height ;	}
//- (void) setH:			 (CGF)h 	{	self.height = h;}

//-  (CGF) width 					{	return self.rect.size.width ;		}
//- (void) setWidth:	 (CGF)t 	{	NSR frame = self.rect; frame.size.width = t; self.rect = frame;	}
//-  (CGF) height 					{	return self.rect.size.height ;	}
//- (void) setHeight:	 (CGF)t 	{self.rect = AZRectExceptHigh(self.rect, t);}
//-  (CGF) originX					{
//    return self.rect.origin.x;
//}
//- (void) setOriginX:	 (CGF)o 	{ self.minX = o; }
//-  (CGF) originY 					{
//    return self.rect.origin.y;
//}
//- (void) setOriginY:	 (CGF)o 	{    self.minY = o; }
//-  (CGF) maxX 						{ return self.origin.x + self.width; }
//- (void) setMaxX:		 (CGF)m	{ self.origin = (NSP) {m - self.width, self.minY  }; }
//-  (CGF) maxY 						{ return self.origin.y + self.height; }
//- (void) setMaxY:     (CGF)m 	{ self.origin = (NSP) {self.minX, m - self.height }; }
//-  (CGF) minX 						{ return self.origin.x;	}
//- (void) setMinX:		 (CGF)m 	{ self.origin = (NSP) {m, self.minY }; }
//-  (CGF) minY 						{ return self.origin.y; 	}
//- (void) setMinY:		 (CGF)m 	{ self.origin = (NSP) {self.minX, m }; }
//-  (NSP) apex 						{  return NSMakePoint(self.width, self.height); }

//- (void) setApex:(NSP)p move1Scale2:(NSN*)n {
//	if ([n isEqualToNumber:1]) 
//}
/*
+ (AZRect*) r { return self.rect; }
+ (AZRect*) rect { return [self rectWithRect:NSZeroRect];	}

+ (AZRect*) rect:(NSR)frame oriented:(AZPOS)pos { AZRect* n = [self rectWithRect:frame]; n.orient = pos; return n; }

*/
//+ (AZRect*) rectOf:(id) object {
//	if (object == nil) return nil;
//	AZRect *re = AZRect.new;
//	
//	if ([object isKindOfClass:NSNumber.class]) {
//	NSNumber *num = (NSNumber*) object;
//	CGF f = num.floatValue;
//	re->x = f;
//	re->y = f;
//	re->width = f;
//	re->height = f;
//	} else if ([object isKindOfClass:AZRect.class]) {
//	AZRect *r = (AZRect*) object;
//	re.rect = r.rect;
//	} else if ([object isKindOfClass:AZPoint.class]) {
//	AZPoint *pt = (AZPoint*) object;
//	re->x = pt.x;
//	re->y = pt.y;
//	} else if ([object isKindOfClass:AZSize.class]) {
//	AZSize *s = (AZSize*) object;
//	re->width = s.width;
//	re->height = s.height;
//	} else if ([object isKindOfClass:NSView.class]) {
//	NSView *view = (NSView*) object;
//	re.rect = view.frame;
//	} else if ([object isKindOfClass:CALayer.class]) {
//	CALayer *l = (CALayer*) object;
//	re->x = l.frame.origin.x;
//	re->y = l.frame.origin.y;
//	re->width = l.frame.size.width;
//	re->height = l.frame.size.height;
//	}
//	
//	return re;
//}
//
//- (NSR) r { return self.rect; }
//- (void) setR:(NSR)r { self.rect = r; }
//+ (AZRect*) rect:(NSR)r { AZRect *re = self.new;	re.rect = r;	return re; }
//
//+ (AZRect*) rectWithOrigin:(NSP)origin andSize:(NSSZ)size {
//	return [self rectWithRect:NSMakeRect(origin.x, origin.y, size.width, size.height)];
//}

//+ (AZRect*) rectWithX:(CGF)x andY:(CGF)y width:(CGF)width height:(CGF)height {
//	return [self withRect:(NSRect){x, y, width, height}];
//}


//#define RECTFROMVARARGS(...) do{ \
//\
//  NSUI ct = metamacro_argcount(__VA_ARGS__);\
//  NSRect r;\
//  for (int x = 4; x > 0; x--)
//+ (AZRect*) by:(CGFloat)dim1,... {
//
//  NSUInteger
//}
//
//return [self rectWithRect:NSMakeRect(x, y,w,h)]; }
/*
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
	self.x = 0;
	self.y = 0;
	width = 0;
	height = 0;
	}
	
	return self;
}

- (id) initWithRect:(NSR)r {
	if ((self = self.init)) {
	self.x = r.origin.x;
	self.y = r.origin.y;
	self.width = r.size.width;
	self.height = r.size.height;
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
	self.anchor = AZAnchorPtAligned(self.orient);
	return self;
}

- (id) initFromPoint:(NSP)ptOne toPoint:(NSP)ptTwo {

	if ((self = self.init)) {
	CGF x = MIN(ptOne.x, ptTwo.x);
	CGF y = MIN(ptOne.y, ptTwo.y);
  
  CGF width = MAX(ptOne.x, ptTwo.x) - x;
	CGF height = MAX(ptOne.y, ptTwo.y) - y;
  self.frame = (NSR){x,y, width,height}; 
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

//- (void) setOrigin:(NSP)pt {
//	x = pt.x;
//	y = pt.y;
//}

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
*/
@end


//- (AZA) alignInsideInDirection:(NSSZ)delta { }
//- (AZA) alignInside:(NSR)outerRect {
//	AZRect *outer = [AZRect rectWithRect:outerRect];
//	AZA e = 0;
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

//@property AZA alignment;
//@property AZOrient orient;
//@property CGF cornerTreshHold, snapThreshold;
//- (void) moveInDirection:(NSSZ)sz;
