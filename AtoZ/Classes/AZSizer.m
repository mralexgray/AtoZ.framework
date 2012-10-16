
//  AZSizer.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZSizer.h"

NSUInteger gcd(NSInteger m, NSUInteger n) {
	int t, r;
	if (m < n) { t = m; m = n; n = t; } r = m % n; //MSLog(@"remainder for %i is %i", n, r);
	if (r == 0) return n; else return gcd(n, r);
}

@interface Candidate : BaseModel
+(instancetype) withRows:(NSUInteger)rows columns:(NSUInteger)columns remainder:(NSInteger)rem forRect:(NSRect)screen ;
@property (assign) float width;
@property (assign) float height;
@property (assign) int rows;
@property (assign) int columns;
@property (assign) float aspectRatio;
@property (assign) NSRect screen;
@property (assign) int remainder;
-(id) initWithDictionary:(NSDictionary *)d;
@end

@implementation Candidate

//@synthesize width,height,rows,columns, aspectRatio, screen, remainder;

+(instancetype) withRows:(NSUInteger)rows columns:(NSUInteger)columns remainder:(NSInteger)rem forRect:(NSRect)screen {
	Candidate *u = [[self class] instance];
	u.remainder = rem;
	u.rows 		= rows;
	u.columns 	= columns;
	u.screen 	= screen;
	u.width 	= ( screen.size.width  / (float)columns );
	u.height 	= (screen.size.height / (float)rows );
	u.aspectRatio = ( u.width / u.height );
	return u;
}

-(id) initWithDictionary:(NSDictionary *)d{
	self = [Candidate instance];
	//	if ([d valueForKey:@"width"]) 	self.width 	= [[d valueForKey:@"width"]floatValue];
	//	if ([d valueForKey:@"height"]) 	self.height	= [[d valueForKey:@"height"]floatValue];
	self.remainder = ( [d valueForKey:@"remainder"] ? [[d valueForKey:@"remainder"]intValue] : 0);
	self.rows = [[d valueForKey:@"rows"]intValue];
	self.columns = [[d valueForKey:@"columns"]intValue];
	self.screen = NSRectFromString([d valueForKey:@"screen"]);
	self.width = ( _screen.size.width  / (float)_columns );
	self.height = (_screen.size.height / (float)_rows );
	self.aspectRatio = ( _width / _height );
	return self;
}

@end

@interface AZSizer ()
@property (RDWRT)  NSUInteger	rows;
@property (RDWRT)  NSUInteger	columns;
@property (RDWRT)  CGFloat 	width;
@property (RDWRT)  CGFloat		height;
@property (NATOM, RDWRT) NSSize		size;
@property (NATOM, RDWRT) NSRect		outerFrame;

@property  (retain, nonatomic) NSMutableArray *candidates;
@end

@implementation AZSizer
//@synthesize candidates = _candidates, remainder, width, quantity, rows, columns, height, paths;
//@synthesize boxes;

//- (void) simplerItemsPerRow {
//	rows = $int(ceil(sqrt(self.quantity)));
//}
+ (NSRect) rectForQuantity:(NSUInteger)q ofSize:(NSSize)s withColumns:(NSUInteger)c;
{
	CGFloat width, height;
	width = c * s.width;
	int rows = q % c == 0 ? q / c : ceil( q / c);
	height = rows * s.width;
	return (NSRect){0,0,width, height};
}

+ (NSRect) structForQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	AZSizer *r = [[AZSizer alloc]initWithQuantity:aNumber inRect:aFrame];
	NSRect rect = NSMakeRect( r.rows, r.columns,r.width,r.height );
	return rect;
}

+ (AZSizer*) forQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	return [[AZSizer alloc]initWithQuantity:aNumber inRect:aFrame];

}

- (id) initWithQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	self = [super init]; 
	if (self) {
		_size = NSZeroSize;

		self.outerFrame = aFrame;
		self.candidates = [NSMutableArray array];
		self.quantity = aNumber;
		__block int smallR = 0, rem, runnerUp, rUpItems, x;
		x = (aNumber < 2 ? 2 : aNumber);
//		for( NSNumber *rowTry in list ) {
		[[@2 to:$int((ceil(sqrt(x)))+4)] az_each:^(NSNumber* rowTry, NSUInteger index, BOOL *stop) {

			int xx, itemsnow;
			int _rowCandidate = [rowTry intValue];
			float items;
			xx 	= gcd(x, _rowCandidate);
			items = (float)x / _rowCandidate;
			rem = ( _rowCandidate + ( x % _rowCandidate ) ) % _rowCandidate;
			itemsnow = floor(items);
			smallR = rem;			runnerUp = _rowCandidate;			rUpItems = itemsnow;
			NSUInteger rowsAccountingForRemainder =  rem != 0 ? (NSUInteger)(runnerUp + 1) : (NSUInteger)runnerUp;
			[_candidates addObject:[Candidate withRows:rowsAccountingForRemainder columns:rUpItems remainder:smallR forRect:aFrame]];

//			  [[Candidate alloc]initWithDictionary:	@{
//										@"columns"	:	$int(rUpItems),
//										@"rows"		:	rowsAccountingForRemainder,
//										@"remainder":	$int(smallR),
//										@"screen"	:	NSStringFromRect(aFrame)	}]];

		}];

		float distanceFromOne = 99.9;
		Candidate *winner;
		for (Candidate *c in _candidates) {
			float distance = (c.aspectRatio < 1 ? (1.0 - c.aspectRatio) : (c.aspectRatio - 1.0));
			if (distance < distanceFromOne) {
				winner = c;
				distanceFromOne = distance;
			}
		}
		self.orient 	= AZOrientGrid;
		self.columns	= winner.columns;
		self.rows 		= winner.rows;
		self.width 		= winner.width;
		self.height  	= winner.height;
//		self.remainder 	= winner.remainder;
		//	NSLog(@"Items:%ld Rows:%@ Columns:%@ Remainder: %@ Size: %ix%i", self.quantity, rows, columns, remainder, width.intValue, height.intValue);
	}
	return self;
}

- (NSSize) size { return _size = _width ? nanSizeCheck( (NSSize){ _width, _height })
							   : nanSizeCheck( (NSSize) { _outerFrame.size.width / _columns,
											_outerFrame.size.height / _rows} ) ;
}
+ (NSArray*) rectsForQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	aNumber = aNumber > 0 ? aNumber : 1;
	AZSizer *sizer = [AZSizer forQuantity:aNumber inRect:aFrame];
	return [sizer rects];
}

-(NSString*) 	aspectRatio
{
//	NSInteger i = gcd((int)self.size.width, (int)self.size.height);
	return	self.size.height == self.size.width	?	@"** 1 : 1 **" :
					_size.height > _size.width  ?	$(@"1 : %0.1f", (float)(_size.height/_size.width))
											    : 	$(@"%0.1f : 1", (float)(_size.width/_size.height));
}

- (NSArray*) rects {
	self.positions = [NSMA array];
	NSLog(@"Quant: %ld.	\nCap: %ld. 	\nRem:%ld  		\nAspect:%@. 	    \nRows: %ld.   \nCols:%ld",
			_quantity, 	  self.capacity, self.remainder,  self.aspectRatio , _rows, 		_columns );
	return _rects = _rects ?: ^{		NSUInteger Q = 0;	NSMutableArray *pRects = [NSMutableArray array];
		if (_orient == AZOrientGrid) {
			for ( int r = (_rows-1); r >= 0; r--){
				for ( int c = 0; c < _columns; c++ ) {
					if (Q < _quantity) {

						[pRects addRect:nanRectCheck((NSRect) { (c * _width), (r *_height), _width, _height })];  Q++;
		}	}	}	}
		else if (_orient == AZOrientPerimeter) {
			NSPoint p = NSZeroPoint; NSInteger r1, r2, c1, c2;		r1 = r2 = c1 = c2 = 1;	_size = self.size;
			while (Q < _quantity) {
				if		(r1 < _columns) { [pRects addRect:nanRectCheck( AZMakeRect(p, _size) )];	p.x += _width;  r1++; Q++;}//	[_positions addObject:AZVposi(AZPositionBottom)]; }
				else if (c1 < _rows) 	{ [pRects addRect:nanRectCheck( AZMakeRect(p, _size) )];	p.y += _height; c1++; Q++;}	//[_positions addObject:AZVposi(AZPositionRight)]; }
				else if (r2 < _columns)	{ [pRects addRect:nanRectCheck( AZMakeRect(p, _size) )]; 	p.x -= _width;  r2++; Q++;	}//[_positions addObject:AZVposi(AZPositionTop)]; }
				else  /* (c2 < _rows)*/ { [pRects addRect:nanRectCheck( AZMakeRect(p, _size) )];	p.y -= _height; c2++; Q++;}//	[_positions addObject:AZVposi(AZPositionLeft)]; }
		}	}
		return pRects;
	}().copy;
}
//NSRect 	e = ([[_s.rects objectAtNormalizedIndex:index] rectValue]);

- (NSUInteger) capacity {	return _orient == AZOrientPerimeter	? (2 * self.columns) + (2 * self.rows) - 4 
														 		:	/*_orient == AZOrientGrid */  		self.rows * self.columns;
}

- (NSInteger) remainder { return self.capacity - _quantity; }

+ (AZSizer*) forQuantity:(NSUInteger)aNumber aroundRect:(NSRect)aFrame {
	aNumber = aNumber > 0 ? aNumber : 1;
	NSRect normalFrame = nanRectCheck(aFrame);
	CGFloat percentHigh = normalFrame.size.height/ (normalFrame.size.height + normalFrame.size.width);
 	AZSizer* totalBoc 	= [[AZSizer alloc]init];
	totalBoc.orient 	= AZOrientPerimeter;
	totalBoc.quantity 	= aNumber;
	totalBoc.outerFrame = normalFrame;
	totalBoc.rows 		= ceil(  (aNumber * percentHigh)   / 2 );
	totalBoc.columns 	= (aNumber - totalBoc.rows) / 2 ;
	while (totalBoc.remainder < 0 )	totalBoc.rows 	 += 1;
	while (totalBoc.remainder > 2 ) 	totalBoc.columns -= 1;
	totalBoc.width 		= (normalFrame.size.width / totalBoc.columns);
	totalBoc.height 	= (normalFrame.size.height / totalBoc.rows);
	return  totalBoc;
}
//	NSMutableArray *privateRects = [NSMutableArray array];
//	NSPoint p = NSZeroPoint; NSUInteger r1, r2, c1, c2;
//	r1 = r2 = totalBoc.columns - 1;
//	c1 = c2 = totalBoc.rows - 1;
//	while (r1 > 1) {
//		[privateRects addObject:[NSValue valueWithRect:AZMakeRect(p, totalBoc.size)]];
//		p.x += totalBoc.size.width;
//		r1--;
//	}
//	while (c1 > 1) {
//		[privateRects addObject:[NSValue valueWithRect:AZMakeRect(p, totalBoc.size)]];
//		p.y += totalBoc.size.height;
//		c1--;
//	}
//	while (r2 > 1) {
//		[privateRects addObject:[NSValue valueWithRect:AZMakeRect(p, totalBoc.size)]];
//		p.x -= totalBoc.size.width;
//		r2--;
//	}
//	while (c2 > 1) {
//		[privateRects addObject:[NSValue valueWithRect:AZMakeRect(p, totalBoc.size)]];
//		p.y -= totalBoc.size.height;
//		c2--;
//	}
//	totalBoc.rects = privateRects.copy;

//
//
//		 (_rows-1); r >= 0; r--){
//
//	NSUInteger x = i % numberOfColumns;
//	NSUInteger y = i / numberOfColumns;
//	drawingRect.origin.x = (spaceForEachFile * x) + marginLeft;

//	NSUInteger rc, cc;  rc, cc = 1;
//	for ( int t = 0;  t < 4; t++)
//		for ( int c = 0; c < _columns; c++ ) {
//			[privateRects addObject:[NSValue valueWithRect:NSMakeRect((c * _width), (r *_height), _width, _height)]];
//		}

/*
- (id) initWithQuantity:(NSUInteger)aNumber aroundRect:(NSRect)aFrame {
	self = [super init];
	if (self) {

//		self
		self.outerFrame = aFrame;
		self.candidates = [NSMutableArray array];
		self.quantity = aNumber;
		CGFloat perimeter = AZPerimeter(aFrame);
		CGFloat outerUnit = perimeter / (float)_quantity;
		NSRect interior = NSInsetRect(_outerFrame, outerUnit/2, outerUnit/2);
		CGFloat innerUnit = AZPerimeter(interior) / (float)_quantity;
		self.width = self.height = innerUnit;
		self.rows = floor(interior.size.height / innerUnit);
		self.columns = floor(interior.size.width / innerUnit);
	}
	return self;
}
*/
//-(void) constrainLayersInLayer:(CALayer*)layer {
//	NSLog(@"constraining");
//	NSUInteger index = 0;
//	for (NSUInteger r = 0; r < _rows; r++) {
//		for (NSUInteger c = 0; c < _columns; c++) {
//	//		if ([layer sublayers].count > index) {
//            CALayer *cell = [[layer sublayers]objectAtIndex:index];
//			cell.frame = AZMakeRectFromSize(self.size);
//            cell.name = [NSString stringWithFormat:@"%ld@%ld", c, r];
//            cell.constraints = @[
//				AZConstRelSuperScaleOff(kCAConstraintWidth, (1.0/ (CGFloat)_columns), 0),
//				AZConstRelSuperScaleOff(kCAConstraintHeight,  (1.0 / (CGFloat)_rows), 0),
//				AZConstAttrRelNameAttrScaleOff(	kCAConstraintMinX, @"superlayer",
//											    kCAConstraintMaxX, (c / (CGFloat)_columns), 0),
//				AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, @"superlayer",
//												kCAConstraintMaxY, (r / (CGFloat)_rows), 0)
//			];
//			index++;
//			}
//        }
////    }
//	return;// layer;
//}
//- (NSArray*)boxes {
//	NSMutableArray *boxArray = [NSMutableArray array];
//	for ( int r = (rows.intValue-1); r >= 0; r--){
//		for ( int c = 0; c < columns.intValue; c++ ) {
//			[boxArray addObject:[NSValue valueWithRect: NSMakeRect((float)(c * width.floatValue), (float)(r * height.floatValue), width.floatValue, height.floatValue)]];
//		}
//	}
//	return boxArray;
//}

//-(NSArray *) paths {
//	NSMutableArray *_paths = [NSMutableArray array];
//	for ( int r = (rows.intValue-1); r >= 0; r--){
//		for ( int c = 0; c < columns.intValue; c++ ) {
//			NSBezierPath *path = [NSBezierPath bezierPathWithRect:
//								  NSMakeRect((float)(c * width.floatValue), (float)(r * height.floatValue), width.floatValue, height.floatValue)];
//			[_paths addObject:path];
//		}
//	}
//	return _paths;
//}

//+ (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe {

//	AGIdealSizer *a = [[AGIdealSizer alloc]initWithQuantity:someitems forRect:NSStringFromRect(aframe)];
//	return NSMakeSize(a.rows.intValue,a.columns.intValue);

//}

//+ (AGIdealSizer*) sharedInstance {
//	return [super sharedInstance];
//}

@end
/**+ (id)forQuantity:(int)numItems forRect:(NSRect)frame{
 //	int rows = ceil(sqrt(numItems));
 //	__block int smallR = 0, rem, runnerUp, rUpItems;
 __block float distanceFromOne = 99.9;
 numItems = (numItems < 2 ? 2 : numItems);
 NSArray *list = [$int(2) to:$int((ceil(sqrt(x)))+4)];
 [list enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:
 ^(id obj, NSUInteger idx, BOOL *stop) {
 int _rowCandidate = [obj intValue];
 //		 int xx, itemsnow; 	float items;
 //		 xx 	= gcd(numItems, _rows);
 
 int itemsPerRow = floor(numItems / _rows);
 int remainder = ( _rows + ( x % _rows ) ) % _rows;
 int rowsAccountingForRemainder = ( remainder != 0 ? (runnerUp + 1) : runnerUp);
 
 itemsnow = (items);
 
 smallR = rem; runnerUp = _rows; rUpItems = itemsnow;
 //		for (Candidate *c in _candidates) {
 //			float distance = (c.aspectRatio < 1 ? (1.0 - c.aspectRatio) : (c.aspectRatio - 1.0));
 //			if (distance < distanceFromOne) { winner = c; distanceFromOne = distance; }
 //			if (self.debug) NSLog(@"Candidiate: %i x %i. Aspect: %f distance: %f ", c.rows, c.columns, c.aspectRatio,distance);
 //		}
 }];
 return NSMakeRect(
 }
 //		NSDictionary *aMatch = $map($int(rUpItems), @"columns", rowsAccountingForRemainder, @"rows", $int(smallR), @"remainder",NSStringFromRect(screen),@"screen");
 //		Candidate *perfect = [[Candidate alloc]initWithDictionary:aMatch];
 //		[_candidates addObject:perfect];
 
 
 
 //		NSLog(@"Winner: %i x %i", winner.rows, winner.columns);
 //	Candidate *winner = [_candidates objectAtIndex:0];
 //		columns = $int(winner.columns);
 //		int rows = winner.rows;
 //		float width = winner.width;
 //		float height = winner.height;
 //		int remainder = winner.remainder;
 //		NSLog(@"Items:%ld Rows:%@ Columns:%@ Remainder: %@ Size: %ix%i", self.quantity, rows, columns, remainder, width.intValue, height.intValue);
 //		return;
 //	}
 
 + (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe {
 AZIdealSizer *a = [AGIdealSizer fo  :someitems forRect:NSStringFromRect(aframe)];
 return NSMakeSize(a.rows.intValue,a.columns.intValue);
 
 }
 
 + (AGIdealSizer*) sharedInstance {
 return [super sharedInstance];
 }
 
 @end
 */
