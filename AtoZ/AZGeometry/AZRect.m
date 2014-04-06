//  THRect.m  Lumumba Framework  Created by Benjamin Schüttler on 28.09.09. Copyright 2011 Rogue Coding. All rights reserved.

#import "AtoZ.h"
#import "AZRect.h"

//#define RECTFROMVARARGS(...) do{ NSUI ct = metamacro_argcount(__VA_ARGS__);NSRect r;for (int x = 4; x > 0; x--)

@implementation AZRect  @synthesize position, orient, anchor;//, width, height;

+ (NSD*) codableProperties        { return [[super codableProperties]dictionaryByAddingEntriesFromDictionary:@{@"rect":@"NSValue"}]; }

+ (INST)           rect           { return [self rectWithRect:NSZeroRect];	} /* OK */
+ (INST)         rectOf:(id)obj   {   return !obj ? nil :

    ISA(obj,NSNumber)  ? [self.class x:((NSN*)obj).fV y:((NSN*)obj).fV w:((NSN*)obj).fV h:((NSN*)obj).fV] :
    ISA(obj,AZRect)    ? [self.class rectWithRect:((AZRect*)obj).r] :
    ISA(obj,AZPoint)   ? [self.class rectWithOrigin:((AZPoint*)obj).point andSize:NSZeroSize] :
    ISA(obj,AZSize)    ? [self.class rectWithOrigin:NSZeroPoint andSize:((AZSize*)obj).size] :
    ISA(obj,NSV)   ||
    ISA(obj,CAL)       ? [self.class rectWithRect:[[obj vFK:@"frame"]rV]] : self.class.new;
} 
/* OK */

+ (INST)           rect:(NSR)f
               oriented:(AZPOS)p  { AZRect* n = [self.class rectWithRect:f]; n.orient = p; return n; } /* OK */

+ (INST)   rectWithRect:(NSR)r    { AZRect *re = self.new;	re.rect = r;	return re; } /* OK */
+ (INST) rectWithOrigin:(NSP)o
                andSize:(NSSZ)sz  {	return [self rectWithRect:NSMakeRect(o.x, o.y, sz.width, sz.height)]; } /* OK */
+ (INST)      rectWithX:(CGF)x
                   andY:(CGF)y
                  width:(CGF)w
                 height:(CGF)h    { return [self rectWithRect:(NSR){x, y, w, h}]; } /* OK */
+ (INST)              x:(CGF)x
                      y:(CGF)y
                      w:(CGF)w
                      h:(CGF)h    { return [self rectWithRect:NSMakeRect(x, y,w,h)]; } /* OK */

+ (BOOL)      maybeRect:(id)obj   { return  !obj || ![obj class] ? NO : [@[NSN.class, AZR.class, AZSize.class,NSV.class, CAL.class] containsObject:[obj class]]; } /* OK */

+ (INST) screnFrameUnderMenu {  static AZRect *screnFrameUnderMenu = nil;

  return screnFrameUnderMenu = screnFrameUnderMenu ?: [AZRect rectWithRect:AZScreenFrameUnderMenu()];
}


- (NSSZ) size { return (NSSZ){self.w,self.h};  }

#pragma mark - Instance Methods

- (id)  initWithRect:(NSR)r   { SUPERINIT;
  self.x = r.origin.x;  
  self.y = r.origin.y;
	self.width  = r.size.width;
	self.height = r.size.height;
	return self;
}
- (id)  initWithSize:(NSSZ)s  {
	if ((self = self.init)) {
	self.width = s.width;
	self.height = s.height;
	}
	
	return self;
}
- (id) initWithFrame:(NSR)f
             inFrame:(NSR)sF  { if (!(self = [super initWithPoint:f.origin])) return nil;
	self.width   = f.size.width;
	self.height  = f.size.height;
	self.orient = AZPositionAtPerimeterInRect(f, sF);
	self.anchor = AZAnchorPtAligned(self.orient);
	return self;
}

- (id) initFromPoint:(NSP)ptOne toPoint:(NSP)ptTwo { SUPERINIT;

  self.x  = MIN(ptOne.x, ptTwo.x);
  self.y  = MIN(ptOne.y, ptTwo.y);
	self.width   = MAX(ptOne.x, ptTwo.x) - self.x;
	self.height  = MAX(ptOne.y, ptTwo.y) - self.y;

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

- (NSString*) description { return $(@"(AZRect) %@", AZStringFromRect(self.r));
//	return [NSString stringWithFormat:@"%@(%4.f,%4.f; %4.f x %4.f)",
//	  self.className, x, y, width, height];
}

-(INST) shiftedX:(CGF)xx y:(CGF)yy w:(CGF)w h:(CGF)h {
	NSR r = self.r;
	r.origin.x +=xx;
	r.origin.y +=yy;
	r.size.width +=w;
	r.size.height+=h;
	return [self.class rectWithRect:r];
}

- (NSP)origin {
	return self.point;
}

//- (void) setOrigin:(NSP)pt { x = pt.x; y = pt.y; }


//- (NSSZ)size {
//	return NSMakeSize(width, height);
//}

//- (void) setSize:(NSSZ)s {
//	width = s.width;
//	height = s.height;
//}

//- (NSP)center { return self.frameCenter; }// NSMakePoint(x + width  * 0.5, y + height * 0.5); }
//
//- (void) setCenter:(NSP)pt { self.frameCenter = pt; }
//	x = pt.x - width  * 0.5;
//	y = pt.y - height * 0.5;
//}

- (NSR)rect { return (NSR){self.origin,self.size}; }

- (void) setRect:(NSR)r {
	self.x = r.origin.x;
	self.y = r.origin.y;
	self.width = r.size.width;
	self.height = r.size.height;
}

- (id) insetRectWithPadding:(NSI)padding {
	return [[self copy] shrinkByPadding:padding];
}

- (id) shrinkBy:(id) object {
	if (object == nil) {
	return self;
	}
	
	AZRect *r = [AZRect rectOf:object];
  r.x += r.x;
	r.y += r.y;
	self.width  -= (r.x + r.width);
	self.height -= (r.y + r.height);
	
	return self;
}

- (id) shrinkByPadding:(NSI)padding {
  self.x += padding;
	self.y += padding;
	self.width  -= 2 * padding;
	self.height -= 2 * padding;
	
	return self;
}

- (id) shrinkBySizePadding:(NSSZ)padding {
	self.x += padding.width;
	self.y += padding.height;
	self.width  -= 2 * padding.width;
	self.height -= 2 * padding.height;
	
	return self;
}

- (id) growBy:(id) object {
	if (object == nil) {
	return self;
	}
	
	AZRect *padding = [AZRect rectOf:object];
	
	self.x -= padding.x;
	self.y -= padding.y;
	self.width  += (padding.x + padding.width);
	self.height += (padding.y + padding.height);
	
	return self;
}

- (id) growByPadding:(NSI)padding {
	return [self shrinkByPadding:-padding];
}

- (id) growBySizePadding:(NSSZ)padding {
	self.x -= padding.width;
	self.y -= padding.height;
	self.width  += 2 * padding.width;
	self.height += 2 * padding.height;
	
	return self;
}

- (BOOL)equals:(id) object {
	if (object == nil) {
	return NO;
	}
	
	AZRect *compare = [AZRect rectOf:object];
	
	return 
	compare.x == self.x 
	&& compare.y == self.y
	&& compare.width == self.width
	&& compare.height == self.height
	;
}

- (BOOL)contains:(id) object {

  return !object ? NO : [AZRect maybeRect:object]   ? [self containsRect:[AZRect   rectOf:object].rect ] 
                      : [AZPoint maybePoint:object] ? [self    contaiNSP:[AZPoint pointOf:object].point] : NO;
}

- (BOOL) contaiNSP:(NSP)pt { return self.x <= pt.x && self.x + self.width >= pt.x	&& self.y <= pt.y && self.y + self.height >= pt.y; }

- (BOOL) containsRect:(NSR)r { return self.x <= r.origin.x && self.y <= r.origin.y && self.width >= r.size.height && self.height >= r.size.height; }

// graphing
- (void) drawFrame { NSFrameRect(self.rect); }

- (void) fill {	NSRectFill(self.rect); }

- (id) centerOn:(id) bounds {	return [self moveTo:AZPoint.halfPoint ofRect:bounds]; }

- (id) moveTo:(id) point ofRect:(id) bounds {

	AZPoint *pt = [AZPoint pointOf:point];
	AZRect  *br = [AZRect rectOf:bounds];
	
	if (!br.area) {
	return self;
	}
	
	if (0 < pt.x && pt.x <= 1) {
	self.x = br.x + (br.width - self.width) * pt.x;
	} else {
	self.x = br.x + pt.x;
	}
	
	if (0 < pt.y && pt.y <= 1) {
	self.y = br.y + (br.height - self.height) * pt.y;
	} else {
	self.y = br.y + pt.y;
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
	self.width = br.width * pt.x;
	} else if (pt.x < 0) {
	self.width = br.width - pt.x;
	}
	
	if (0 < pt.y && pt.y <= 1) {
	self.height = br.height * pt.y;
	} else if (pt.y < 0) {
	self.height = br.height - pt.y;
	}
	
	return self;
}

-  (NSR)    r                 { return self.rect;  }
- (void) setR:        (NSR)r  { self.rect = r;     }
-  (CGF)    leftEdge          {	return [self rect].origin.x ;	}
- (void) setLeftEdge: (CGF)t 	{ NSR frame = self.rect ;	frame.origin.x = t ;	[self setRect:frame] ;	}
-  (CGF)    rightEdge 				{	return [self rect].origin.x + [self width] ;	}
- (void) setRightEdge:(CGF)t 	{ NSR frame = self.rect ;	frame.origin.x = t - [self width] ;	[self setRect:frame];	}
-  (CGF)    centerX   				{	return ([self rect].origin.x + [self width]/2) ;	}
- (void) setCenterX:  (CGF)t  { CGF center = self.centerX;	CGF adjustment = t - center ; self.minX += adjustment;	}
-  (CGF)    bottom            {	return self.rect.origin.y ;	}
- (void) setBottom:   (CGF)t  { NSRect frame = self.rect ;	frame.origin.y = t ;	[self setRect:frame] ;	}
-  (CGF)    top               {		return self.rect.origin.y + [self height] ;	}
- (void) setTop:      (CGF)t  {	NSRect frame = self.rect ;	frame.origin.y = t - [self height] ;	[self setRect:frame] ;	}
-  (CGF)    centerY           {	return (self.rect.origin.y + [self height]/2) ;}
- (void) setCenterY:  (CGF)t  {	self.minY += (t - self.centerY);		}
-  (CGF)    w                 {	return self.width ;		}
- (void) setW:        (CGF)w  {	self.width = w;	}
-  (CGF)    h                 {	return self.height ;	}
- (void) setH:        (CGF)h  {	self.height = h;}
-  (CGF)    width             {	return self.rect.size.width ;		}
- (void) setWidth:    (CGF)t  {	NSR frame = self.rect; frame.size.width = t; self.rect = frame;	}
-  (CGF)    height            {	return self.rect.size.height ;	}
- (void) setHeight:   (CGF)t  {self.rect = AZRectExceptHigh(self.rect, t);}
-  (CGF)    originX           {
    return self.rect.origin.x;
}
- (void) setOriginX:  (CGF)o 	{ self.minX = o; }
-  (CGF)    originY           {
    return self.rect.origin.y;
}
- (void) setOriginY:  (CGF)o 	{    self.minY = o; }
-  (CGF)    maxX              { return self.origin.x + self.width; }
-  (CGF)    maxY              { return self.origin.y + self.height; }
-  (CGF)    minX              { return self.origin.x;	}
-  (CGF)    minY              { return self.origin.y; 	}
//- (void) setMaxX:     (CGF)m	{ self.origin = (NSP) {m - self.width, self.minY  }; }
//- (void) setMaxY:     (CGF)m 	{ self.origin = (NSP) {self.minX, m - self.height }; }
//- (void) setMinX:     (CGF)m 	{ self.origin = (NSP) {m, self.minY }; }
//- (void) setMinY:     (CGF)m 	{ self.origin = (NSP) {self.minX, m }; }

-  (NSP) apex                 {  return NSMakePoint(self.width, self.height); }

- (void) setApex:(NSP)p move1Scale2:(NSN*)n {
//	if ([n isEqualToNumber:1]) 
}

@end

@implementation AZEdge
+ (INST) rect:(AZRect*)r along:(AZRect*)outer inside:(BOOL)isinide {	
	AZEdge *n = self.new; 			//	n.align AZClosestCorner(outer, isinide)
	return n;
}
@end

/*
@property AZA alignment;
@property AZOrient orient;
@property CGF cornerTreshHold, snapThreshold;
- (void) moveInDirection:(NSSZ)sz;

+ (AZRect*) by:(CGFloat)dim1,... {

  NSUInteger
}

return [self rectWithRect:NSMakeRect(x, y,w,h)]; }

- (id) initWithCoder:(NSCoder *)aDecoder {  self = [super initWithCoder:aDecoder];
  for (id key in self.class.codableProperties.allKeys) [self setValue:[aDecoder valueForKey:key] forKey:key];
  return self;
}
- (void) encodeWithCoder:(NSCoder *)aCoder {  [super encodeWithCoder:aCoder];
  for (id key in self.class.codableProperties.allKeys)  [aCoder encodeObject:[self vFK:key] forKey:key];
}
- (AZA) alignInsideInDirection:(NSSZ)delta { }
- (AZA) alignInside:(NSR)outerRect {
	AZRect *outer = [AZRect rectWithRect:outerRect];
	AZA e = 0;
	e |= 	self.maxY == outer.maxY ? AZAlignTop 	: 	self.minY == outer.minY ? AZAlignBottom	:
			self.minX == outer.minX ? AZAlignLeft	:	self.maxX == outer.maxX ? AZAlignRight 	: e;

	if (e != 0) return e;
	NSP myCenter = edge.center;
	CGF test = HUGE_VALF;
	CGF minDist = AZMaxDim(outer.size);

	test = AZDistanceFromPoint( myCenter, (NSP) { outer.minX, myCenter.y }); //testleft
	if  ( test < minDist) { 	minDist = test; e = AZAlignLeft;}

	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x,  0 }); //testbottom  OK
	if  ( test < minDist) { 	minDist = test; e = AZAlignBottom; }

	test = AZDistanceFromPoint( myCenter, (NSP) {outer.width, myCenter.y }); //testright
	if  ( test < minDist) { 	minDist = test; e = AZAlignRight; }

	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x, outer.height }); //testright
	if  ( test < minDist) { 	minDist = test; e = AZAlignTop; }
	return  e;
}
*/
