//
//  AZGrid.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZGrid.h"
#import <AtoZ/AtoZ.h>
#import "AZBlockView.h"

_EnumPlan(AZGridStyle);
_EnumPlan(AZGridOrder);

@interface AZGrid ()
- (void) _init;
@end
@implementation AZGrid

-   (id) initWithFrame:(NSR)frame {

	if (!(self = [AZGrid.alloc initWithUnitSize:NSMakeSize(20.0f, 20.0f)  color:GRAY3 shouldDraw:YES]))return nil;
		BLKVIEW* w = [BLKVIEW viewWithFrame:frame opaque:YES drawnUsingBlock:^(BNRBlockView *v, NSRect r) {
		if (![v hasAssociatedValueForKey:@"grid"])
			[v setAssociatedValue:self forKey:@"grid" policy:OBJC_ASSOCIATION_ASSIGN];
		[[v associatedValueForKey:@"grid"] drawRect:r];
	}];
	[NSEVENTLOCALMASK: NSScrollWheelMask handler:^NSEvent *(NSEvent *e){ 
		int dx, dy;
		dx = floor(ABS(e.deltaX/5.0));
		dy = floor(ABS(e.deltaY/5.0));
		if (dx || dy){
			self.unitSize = (NSSZ){_unitSize.width + dx,_unitSize.height + dy}; 
			[w setNeedsDisplay:YES];
			NSLog(@"Newsize:%@", AZStringFromSize(_unitSize));
		}
		return e;
	}];
	return (AZGrid*)w;
}


- (id)initWithUnitSize:(NSSize)newUnitSize color:(NSColor *)newColor		shouldDraw:(BOOL)newShouldDraw
{
	self = [self init];
	if (newColor)
	{
		self.unitSize = newUnitSize;
		self.color = newColor;
		self.shouldDraw = newShouldDraw;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	return [self initWithUnitSize:[coder decodeSizeForKey:@"gridUnitSize"]
							color:[coder decodeObjectForKey:@"gridColor"]
					   shouldDraw:[coder decodeBoolForKey:@"gridShouldDraw"]];
}

- (void) encodeWithCoder:(NSCoder *)coder
{
	[coder encodeBool:[self shouldDraw] forKey:@"gridShouldDraw"];
	[coder encodeObject:[self color] forKey:@"gridColor"];
	[coder encodeSize:[self unitSize] forKey:@"gridUnitSize"];
}

- (void) drawRect:(NSRect)drawingRect
{
	if (!self.shouldDraw)
		return;
	
	NSSize dimensions 		= drawingRect.size;
	CGFloat lineWidth 		= [NSBP defaultLineWidth];
	BOOL oldShouldAntialias = [AZGRAPHICSCTX shouldAntialias];
	
	[AZGRAPHICSCTX setShouldAntialias:NO];
	[NSBP setDefaultLineWidth:0.0f];
	NSRectFillWithColor(drawingRect, WHITE);
	[self.color set];
	
	for (CGFloat i = 0.0f; i < dimensions.width + self.unitSize.width; i += self.unitSize.width)
	{
		[NSBP strokeLineFromPoint:NSMakePoint(i, 0.0f)
								  toPoint:NSMakePoint(i, dimensions.height)];
	}
	
	for (CGFloat i = 0.0f; i < dimensions.height + self.unitSize.height; i += self.unitSize.height)
	{
		[NSBP strokeLineFromPoint:NSMakePoint(0.0f, i)
								  toPoint:NSMakePoint(dimensions.width, i)];
	}
	
	[NSBP setDefaultLineWidth:lineWidth];
	
	[AZGRAPHICSCTX setShouldAntialias:oldShouldAntialias];
}

- (void) setDefaultParameters
{

	if (![AZUSERDEFS objectForKey:@"AZGridColorDataKey"])
	{
		self.shouldDraw = NO;
		self.unitSize = NSMakeSize(1.0f, 1.0f);
		self.color = [NSColor colorWithCalibratedWhite:0.2f alpha:0.5f];
	}
	else
	{
		self.shouldDraw = [AZUSERDEFS boolForKey:@"AZGridShouldDrawKey"];
		self.unitSize = NSMakeSize([AZUSERDEFS floatForKey:@"AZGridUnitWidthKey"], [AZUSERDEFS floatForKey:@"AZGridUnitHeightKey"]);
		self.color = [NSKeyedUnarchiver unarchiveObjectWithData:[AZUSERDEFS objectForKey:@"AZGridColorDataKey"]];
	}
}

- (id)copyWithZone:(NSZone *)zone	{

	return [[AZGrid allocWithZone:zone] initWithUnitSize:self.unitSize color:self.color shouldDraw:self.shouldDraw];
}

- (void) _init {
	parallels = 1;
	style = AZGridStyleCompact;
	order = AZGridOrderRowMajor;
	[self setDefaultParameters];

}
- (id) init {
	if ((self = [super init])) {
	[self _init];
	array = NSMA.new;
	}
	return self;
}

- (id) initWithCapacity:(NSUInteger)numItems {
	if ((self = [super init])) {
	[self _init];
	array = [NSMutableArray.alloc initWithCapacity:numItems];
	}
	return self;
}

- (NSUInteger)parallels					 {	return parallels;}
- (void) setParallels:(NSUInteger)v {		self->parallels = MAX(1, parallels);	}
- (NSUInteger)style 						{	return style;
}

- (void) setStyle:(NSUInteger)v {
	if (v > 2) {
	self->style = 0;
	} else {
	self->style = v;
	}
}

- (NSUInteger)order {
	return order;
}

- (void) setOrder:(NSUInteger)o {
	if (o <= 1) {
	self->order = o;
	}
}

- (NSUInteger)count {
	return array.count;
}

- (NSMA*) elements {
	return array;
}

- (void) addObject:(id) anObject {
	[array addObject:anObject];
}

- (void) insertObject:(id) anObject atIndex:(NSUInteger)index {
	[array insertObject:anObject atIndex:index];
}

- (void) removeAllObjects {
	[array removeAllObjects];
}

- (void) removeObjectAtIndex:(NSUInteger)index {
	[array removeObjectAtIndex:index];
}

- (id) objectAtIndex:(NSUInteger)index {
	return array[index];
}

- (AZSize*) size {
	NSSZ s = NSMakeSize(0, 0);
	
	if (style == AZGridStyleHorizontal) {
	s.width = ceil(self.count / parallels);
	s.height = parallels;
	} else if (style == AZGridStyleVertical) {
	s.width = parallels;
	s.height = ceil(self.count / parallels);
	} else /* AZGridStyleCompact */ {
	float d = ceil(sqrt(self.count));
	s.width = d;
	s.height = d;
	}
	
	return [AZSize sizeWithSize:s];
}

- (CGF)width {
	return self.size.width;
}

- (CGF)height {
	return self.size.height;
}

- (CGF)min {
	return self.size.min;
}

- (CGF)max {
	return self.size.max;
}

- (NSP) pointAtIndex:(NSUInteger)index {
	if (self.count == 0) {
	return NSZeroPoint;
	}
	
	AZSize *s = self.size;
	CGF x, y;
	
	if (order == AZGridOrderColumnMajor) {
	// column major order
	x = floor(index / s.height);
	y = index % (int)s.height;
	} else {
	// row major order
	x = index % (int)s.width;
	y = floor(index / s.width);
	}
	
	return NSMakePoint(x, y); //[AZPoint pointWithPoint:];
}

- (NSNumber*) indexAtPoint:(NSP)point {
	if (self.count == 0) {
	return nil;
	}
	
	AZSize *s = self.size;
	NSI x = floor(point.x);
	NSI y = floor(point.y);

	if (x < 0 || x >= s.width || y < 0 || y >= s.height) {
	return nil;
	}
	
	if (order == AZGridOrderRowMajor) {
	// left to right -> top to bottom
	return [NSNumber numberWithUnsignedInt:point.y * s.width + point.x];
	} else if (order == AZGridOrderColumnMajor) {
	// top to bottom -> left to right
	return [NSNumber numberWithUnsignedInt:point.x * s.height + point.y];
	}
	
	return nil;
}

- (id) objectAtPoint:(NSP)point {
	NSNumber *index = [self indexAtPoint:point];
	if (index == nil) {
	return nil;
	}
	
	return [self objectAtIndex:index.unsignedIntValue];;
}

- (NSString*) description {
	AZSize *s = self.size;
	return [NSString stringWithFormat:@"%@(%.f, %.f; %ld)",
	  self.className,
	  s.width,
	  s.height,
	  self.count];
}

@end
