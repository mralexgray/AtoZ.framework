
#import <AtoZ/AtoZ.h>
#import "AZSizer.h"

//NSUI gcd (NSI m, NSUI n) { NSI t, r;
//	if (m < n) { t = m; m = n; n = t; }
//	r = m % n;
//	//MSLog(@"remainder for %i is %i", n, r);
//	return r == 0 ? n : gcd(n, r);
//}
//
@interface Candidate : BaseModel
@property (assign) CGF width, height, aspectRatio;
@property (assign) NSUI rows, columns, remainder;
@property (assign) NSR frame;
@end

@implementation Candidate
+(Candidate*) withRows:(NSUI)rows columns:(NSUI)columns remainder:(NSI)rem forRect:(NSR)frame
{
	Candidate *u 	= [self instance];
	u.remainder 	= rem;
	u.rows 			= rows;
	u.columns 		= columns;
	u.frame 			= frame;
	u.width 			= ( frame.size.width   / (float) columns );
	u.height 			= ( frame.size.height  / (float) rows	);
	u.aspectRatio 	= ( u.width / u.height );
	return u;
}
-(id) initWithDictionary:(NSD*)d
{
	self 			 = [self.class instance];
	self.remainder 	 = [d integerForKey:		  @"remainder" defaultValue:0];
	self.rows 		 = [d unsignedIntegerForKey:	  @"rows"];
	self.columns 	 = [d unsignedIntegerForKey: @"columns"];
	self.frame	 	 = [d rectForKey:				  @"screen"];
	self.width 		 =  _frame.size.width  / (CGF) _columns;
	self.height 	 =  _frame.size.height / (CGF) _rows 	;
	self.aspectRatio=  _width / _height ;
	return self;
}
@end

@interface AZSizer ()
@property (RW)  NSUI		   rows,  columns;
@property (RW)  CGF		   width, height;
//@property (NATOM, RW) NSSZ  size;
@property (NATOM, STR) NSMA *candidates;
@end

@implementation AZSizer
- (NSS*) description {

	return $(@"Orient:%@, Frame:%@, Q:%ld, R:%ld C:%ld, SZ:%@",
		AZOrientToString(_orient), AZString(_outerFrame), _quantity,_rows,_columns, AZString(self.size));
}


- (id) initWithQuantity:(NSUI)aNumber inRect:(NSR)aFrame
{
	if (!(self = super.init)) return nil;
	_orient			= AZOrientGrid;	//_size 		= NSZeroSize;
	_outerFrame 	= aFrame;			_quantity 	= aNumber;
	
	__block int smallR, rem, runnerUp, rUpItems, x; 		x = MAX(aNumber, 2);		smallR = 0;
	
	_candidates = [[@2 to:@(ceil(sqrt(x))+ 4)] nmap:^id(NSN *obj, NSUI idx){
		
		int _rowCand 	= obj.intValue;				//		int xx 			= gcd( x, _rowCand );
		float items		= (float) x / _rowCand;
		rem 				= ( _rowCand + ( x % _rowCand ) ) % _rowCand;
		int itemsnow 	= floor(items);
		smallR 			= rem;
		runnerUp 		= _rowCand;
		rUpItems 		= itemsnow;
		NSUI rowsAccountingForRemainder =  rem != 0 ? (NSUI)(runnerUp + 1) : (NSUI)runnerUp;
		return [Candidate withRows:rowsAccountingForRemainder columns:rUpItems 
							  remainder:smallR 							forRect:aFrame];		}].mutableCopy;
	
	__block float distanceFromOne = 99.9; __block Candidate *winner;
	[_candidates each:^(Candidate *c) {
		float distance = (c.aspectRatio < 1 ? (1.0 - c.aspectRatio) : (c.aspectRatio - 1.0));
		if (distance < distanceFromOne) {		winner = c;	distanceFromOne = distance;		}
	}];
	_columns	= winner.columns;	_rows		= winner.rows;
	_width 	= winner.width;	_height  = winner.height;
	return self;
}
+ (AZSizer*) forQuantity: (NSUI)q ofSize:(NSSZ)s withColumns:(NSUI)c
{
	AZSizer *sizer 		=  self.instance;
	sizer.outerFrame 	= [self rectForQuantity:q ofSize:s withColumns:c];
	sizer.orient		= AZOrientGrid;
//	sizer.size 			= s;
	sizer.quantity		= q;
	sizer.columns		= c;
	sizer.rows 			= ceil(q/c);
	if (( q % c) != 0) sizer.rows++;
	sizer.width 		= s.width;
	sizer.height  		= s.height;
	return sizer;
}
+ (AZSizer*) forQuantity: (NSUI)aNumber	inRect:(NSR)aFrame
{
	return [self.alloc initWithQuantity:aNumber inRect:aFrame];
}
+ (AZSizer*) forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame
{
 	AZSizer* totalBoc	= self.new;
	NSR normalFrame 	= totalBoc.outerFrame = nanRectCheck(aFrame);
	CGF percentHigh 	= normalFrame.size.height / (normalFrame.size.height + normalFrame.size.width);
	totalBoc.orient 	= AZOrientPerimeter;
	totalBoc.quantity	= MAX(aNumber, 1);
	totalBoc.rows 		= ceil(  (aNumber * percentHigh)  / 2 );
	totalBoc.columns 	= aNumber - 	totalBoc.rows		 / 2 ;
	while ( totalBoc.remainder < 0 )	totalBoc.rows	 += 1;
	while ( totalBoc.remainder > 2 ) totalBoc.columns  -= 1;
	totalBoc.width 	= normalFrame.size.width / totalBoc.columns;
	totalBoc.height 	= normalFrame.size.height /totalBoc.rows;// - (2 * totalBoc.width)) / totalBoc.rows;
	//	totalBoc.height 	= (normalFrame.size.height / totalBoc.rows);
	return  totalBoc;
}
+ (AZSizer*) forObjects:  (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr
{
	AZSizer *sassy = arr == AZOrientGrid	  ? [self forQuantity:objects.count inRect:aFrame] 
						: arr == AZOrientPerimeter ? [self forQuantity:objects.count aroundRect:aFrame] : nil;
	if (!sassy) return nil;
	sassy.objects 	= objects;	sassy.orient 	= arr;	return sassy;
}
+ (NSA*) rectsForQuantity: (NSUI)aNumber  inRect:(NSR)aFrame	{

	return [[[self forQuantity:aNumber > 0 ? aNumber : 1 inRect:aFrame]rects] copy];
}
+ (NSR)  structForQuantity:(NSUI)aNumber  inRect:(NSR)aFrame	{

	AZSizer *r = [self.alloc initWithQuantity:aNumber inRect:aFrame];
	return 		 NSMakeRect( r.rows, r.columns, r.width, r.height );
}
+ (NSR)  rectForQuantity:  (NSUI)q		ofSize:(NSSZ)s withColumns:(NSUI)c	{

	CGF width, height; int rows;
	width 	= c * s.width;
	rows 		= q % c == 0 ? q / c : (int)ceil( q / c);
	height 	= rows * s.width;
	return AZRectBy(width, height);
}
- (NSR)  rectForPoint:		(NSP) point									{

	NSValue* rect = [self.rects filterOne:^BOOL(id object) { return NSPointInRect(point, [object rectValue]); }];
	return rect ? [rect rectValue] : NSZeroRect;
}

//#define addValuemakeRect A
#define AZMakeValueRect(A,B,C,D) AZVrect ( NSMakeRect( A,B,C,D))
//#define __add(A)  addObject:A
- (NSA*) rects	{ AZBlockSelf(_self);

	if (!_positions) self.positions = [NSMA array]; static NSSZ sizeCheck;
	return _rects = NSEqualSizes(sizeCheck, self.size) && _rects ? _rects :
	^{
//		NSLog(@"Size: %@.  Quant: %ld.	Cap: %ld. Rem:%ld Aspect:%@. Rows: %ld.  Cols:%ld", NSStringFromSize(_size), _quantity, self.capacity, self.remainder, self.aspectRatio , _rows, _columns );
		return _self.orient == AZOrientGrid ?
		^{
			NSUI Q = 0;		NSMA *pRects = NSMA.new;
			for ( int r = (_self.rows-1); r >= 0; r--){
				for ( int c = 0; c < _self.columns; c++ ) {
					if (Q < _self.quantity) {
						[pRects addRect:nanRectCheck( (NSR) { (c * _self.width), (r *_self.height), _self.width, _self.height })];  Q++;
					}	
				}	
			}
			return pRects;// withMinItems:_quantity];
		}()
		: _self.orient == AZOrientPerimeter ? ^{ NSMA* rectss = NSMA.new;
			
			for(int i = 1; i < _self.columns; i++)
				[rectss addObject: AZMakeValueRect( i * _self.width, 		0,		_self.width,		_self.height)];
			for(int i = 1; i < _self.rows - 1; i++)
				[rectss addObject: AZMakeValueRect(	NSWidth(_self.outerFrame) - _self.width, 	_self.height * i,	_self.width,	_self.height )];
			for(int i = 0; i < _self.columns; i++)
				[rectss addObject: AZMakeValueRect(	(NSWidth(_self.outerFrame) - _self.width) - (i * _self.width),
																NSHeight(_self.outerFrame) - _self.height,   _self.width,	_self.height )];
			for ( int i = 1; i < _self.rows; i++ )
				[rectss addObject: AZMakeValueRect(	0,	NSHeight(_self.outerFrame) - (i * _self.height), _self.width, _self.height )];

			return rectss;// withMinItems:self.capacity];// withMaxItems:2* _columns + ((2 * _rows) - 2)];
		}() : @[];
	}();
}
- (NSSZ) size
{
	return nanSizeCheck( (NSSZ) { _width, _height } );
//					 : nanSizeCheck( (NSSZ) { _outerFrame.size.width / _columns,
//																	_outerFrame.size.height / _rows}   );
}
- (NSS*) aspectRatio
{
	//	NSInteger i = gcd((int)self.size.width, (int)self.size.height);
	return	self.height == self.width  ?	 @"** 1 : 1 **" :
				self.height >  self.width  ? $(@"1 : %0.1f", (float)(self.height/self.width))
													: $(@"%0.1f : 1", (float)(self.width/self.height));
}
- (NSI) remainder 
{ return self.capacity - _quantity;  }
- (NSUI) capacity	
{	return _orient == AZOrientPerimeter	? (2 * self.columns) + (2 * self.rows) - 2
	:	 _orient == AZOrientGrid	  ? _columns * _rows : _quantity;
	/* _orient == AZOrientGrid *///	:  self.rows * self.columns;
}


// ancillary methods not neeeded for sizer core
+ (NSA*) rectsForColumns:  (NSUI)ct inRect:(NSR)frame 
{
	
	NSR r = AZRectExceptWide(frame, frame.size.width / (float) ct);
	return [[@0 to: @( ct-1 )] mapWithIndex:^id(id object, NSUInteger index) {
		return AZVrect(AZRectExceptOriginX(r, index * r.size.width));
	}];
}


@end

/*			[[@0 to:@(_columns)]nmap:^id(id obj, NSUI index) {
 return  AZVrect(AZRectExceptOriginX( block, (index - 1 * _width)));
 }],
 [[@1 to:@(_rows - 2)]nmap:^id(id obj, NSUI index) {
 NSR base = AZRectExceptOriginX(block, NSWidth(_outerFrame) - _width );
 return  AZVrect(AZRectExceptOriginY( base, (index * _height)));
 }],
 [[@1 to:@(_columns)]nmap:^id(id obj, NSUI index) {
 NSR base = AZRectExceptOriginY(block, NSHeight(_outerFrame) - _height);
 return  AZVrect(AZRectExceptOriginX( base, (NSWidth(_outerFrame) - (index -1 * _width))));
 }],
 [[@1 to:@(_rows - 2)] nmap:^id(id obj, NSUI index) {
 return  AZVrect(AZRectExceptOriginY( block, (NSHeight(_outerFrame) - (index * _height))));
 
 }]]]; 
 }() :nil;
 }();
 }
			NSPoint p = NSZeroPoint; NSInteger r1, r2, c1, c2;		r1 = r2 = c1 = c2 = 1;	_size = self.size;
 while (Q < _quantity + self.remainder) {
 //row 1
 if		(r1 < _columns) { [pRects addRect: nanRectCheck( AZMakeRect(p, _size) )];	p.x += _width;  r1++; Q++; }
 else if (c1 < _rows) 	{ [pRects addRect: nanRectCheck( AZMakeRect(p, _size) )];	p.y += _height; c1++; Q++; }
 else if (r2 < _columns)	{ [pRects addRect: nanRectCheck( AZMakeRect(p, _size) )]; 	p.x -= _width;  r2++; Q++; }
 else */ /* (c2 < _rows)*/// { [pRects addRect: nanRectCheck( AZMakeRect(p, _size) )];	p.y -= _height; c2++; Q++; }
//	}	}
//		return pRects;
//	}().copy;

//NSR 	e = ([[_s.rects objectAtNormalizedIndex:index] rectValue]);

//- (void) updateFrame:(NSR)rect
//{
//	AZSizer *s = [AZSizer forQuantity:self.quantity inRect:rect];
//	self.positions = s.positions.copy;
//	[s.rects eachWithIndex:^(id obj, NSInteger idx) {
//		[self setValue:obj forKey rects[idx] rectValue];
//	}]
//}


//	NSMutableArray *privateRects = [NSMutableArray array];
//	NSPoint p = NSZeroPoint; NSUI r1, r2, c1, c2;
//	r1 = r2 = totalBoc.columns - 1;
//	c1 = c2 = totalBoc.rows - 1;
//	while (r1 > 1) {
//		[privateRects addObject:AZVrect(AZMakeRect(p, totalBoc.size))];
//		p.x += totalBoc.size.width;
//		r1--;
//	}
//	while (c1 > 1) {
//		[privateRects addObject:AZVrect(AZMakeRect(p, totalBoc.size))];
//		p.y += totalBoc.size.height;
//		c1--;
//	}
//	while (r2 > 1) {
//		[privateRects addObject:AZVrect(AZMakeRect(p, totalBoc.size))];
//		p.x -= totalBoc.size.width;
//		r2--;
//	}
//	while (c2 > 1) {
//		[privateRects addObject:AZVrect(AZMakeRect(p, totalBoc.size))];
//		p.y -= totalBoc.size.height;
//		c2--;
//	}
//	totalBoc.rects = privateRects.copy;

//
//
//		 (_rows-1); r >= 0; r--){
//
//	NSUI x = i % numberOfColumns;
//	NSUI y = i / numberOfColumns;
//	drawingRect.origin.x = (spaceForEachFile * x) + marginLeft;

//	NSUI rc, cc;  rc, cc = 1;
//	for ( int t = 0;  t < 4; t++)
//		for ( int c = 0; c < _columns; c++ ) {
//			[privateRects addObject:AZVrect(NSMakeRect((c * _width), (r *_height), _width, _height))];
//		}

/*
 - (id) initWithQuantity:(NSUI)aNumber aroundRect:(NSR)aFrame {
 self = [super init];
 if (self) {
 
 //		self
 self.outerFrame = aFrame;
 self.candidates = [NSMutableArray array];
 self.quantity = aNumber;
 CGF perimeter = AZPerimeter(aFrame);
 CGF outerUnit = perimeter / (float)_quantity;
 NSR interior = NSInsetRect(_outerFrame, outerUnit/2, outerUnit/2);
 CGF innerUnit = AZPerimeter(interior) / (float)_quantity;
 self.width = self.height = innerUnit;
 self.rows = floor(interior.size.height / innerUnit);
 self.columns = floor(interior.size.width / innerUnit);
 }
 return self;
 }
 */
//-(void) constrainLayersInLayer:(CALayer*)layer {
//	NSLog(@"constraining");
//	NSUI index = 0;
//	for (NSUI r = 0; r < _rows; r++) {
//		for (NSUI c = 0; c < _columns; c++) {
//	//		if ([layer sublayers].count > index) {
//			CALayer *cell = [[layer sublayers]objectAtIndex:index];
//			cell.frame = AZMakeRectFromSize(self.size);
//			cell.name = [NSString stringWithFormat:@"%ld@%ld", c, r];
//			cell.constraints = @[
//				AZConstRelSuperScaleOff(kCAConstraintWidth, (1.0/ (CGF)_columns), 0),
//				AZConstRelSuperScaleOff(kCAConstraintHeight,  (1.0 / (CGF)_rows), 0),
//				AZConstAttrRelNameAttrScaleOff(	kCAConstraintMinX, @"superlayer",
//												kCAConstraintMaxX, (c / (CGF)_columns), 0),
//				AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, @"superlayer",
//												kCAConstraintMaxY, (r / (CGF)_rows), 0)
//			];
//			index++;
//			}
//		}
////	}
//	return;// layer;
//}
//- (NSA*)boxes {
//	NSMutableArray *boxArray = [NSMutableArray array];
//	for ( int r = (rows.intValue-1); r >= 0; r--){
//		for ( int c = 0; c < columns.intValue; c++ ) {
//			[boxArray addObject:AZVrect( NSMakeRect((float)(c * width.floatValue), (float)(r * height.floatValue), width.floatValue, height.floatValue))];
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

//+ (NSSZ) gridFor:(int)someitems inRect:(NSR)aframe {

//	AGIdealSizer *a = [[AGIdealSizer alloc]initWithQuantity:someitems forRect:NSStringFromRect(aframe)];
//	return NSMakeSize(a.rows.intValue,a.columns.intValue);

//}

//+ (AGIdealSizer*) sharedInstance {
//	return [super sharedInstance];
//}
/**+ forQuantity:(int)numItems forRect:(NSR)frame{
 //	int rows = ceil(sqrt(numItems));
 //	__block int smallR = 0, rem, runnerUp, rUpItems;
 __block float distanceFromOne = 99.9;
 numItems = (numItems < 2 ? 2 : numItems);
 NSArray *list = [$int(2) to:$int((ceil(sqrt(x)))+4)];
 [list enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:
 ^(id obj, NSUI idx, BOOL *stop) {
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
 
 + (NSSZ) gridFor:(int)someitems inRect:(NSR)aframe {
 AZIdealSizer *a = [AGIdealSizer fo  :someitems forRect:NSStringFromRect(aframe)];
 return NSMakeSize(a.rows.intValue,a.columns.intValue);
 
 }
 
 + (AGIdealSizer*) sharedInstance {
 return [super sharedInstance];
 }
 
 @end	*/

NSR AZRectForItemsWithColumns(NSA *items, NSUI cols) {

  __block NSR frame = NSZeroRect; __block __unused NSUI col; __block CGF rowWidth = 0, rowHeight = 0;

  [[items vFKP:@"size"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

    if (AZMaxDim(frame.size) > 10000) return
      NSLog(@"bailing on maxdim: %@", AZStringFromRect(frame)), *stop = YES, (void)nil;

    if (!(idx % cols)) {
      frame.size.width = MAX(frame.size.width, rowWidth);
      NSLog(@"setting width: %f of row at index:%ld", rowWidth, idx);
      rowWidth = 0;
      frame.size.height += rowHeight;
      rowHeight = 0;
    }
    rowHeight = MAX([obj sizeValue].height, rowHeight);
    rowWidth += [obj sizeValue].width;

  }];  return frame;
}

@implementation NSImage (Merge)


//- (void)contactSheetWith:(NSA*)images inRect:(NSR)rect cols:(NSUI)cols callback:(void (^)(NSImage *))callback  {
//	[NSThread performBlockInBackground:^{ AZSizer *d = [AZSizer for]
//		NSIMG* image =	[NSImage contactSheetWith:images inFrame:rect columns:cols];
//		[NSThread.mainThread performBlock:^{	callback(image); }];
//	}];
//}

+ (NSIMG*) contactSheetWith:(NSA*)imgs
                    columns:(NSUI)c {

  AZSizer *s = [AZSizer forQuantity:imgs.count
                             inRect:AZRectForItemsWithColumns(imgs, c)];
  return [self contactSheetWith:imgs
                          sized:s.size
                         spaced:NSZeroSize
                        columns:c
                       withName:NO]; // wors perfectly
                                     //	return  [self contactSheetWith:imgs
  // inFrame:AZRectForItemsWithColumns(imgs,c) columns:c]; }
}

+ (NSIMG*) contactSheetWith:(NSA*)images
                    inFrame:(NSR)rect { // columns:(NSUI)cols	{

  AZSizer *s = [AZSizer forQuantity:images.count inRect:rect];
  return
      [self contactSheetWith:images withSizer:s withName:NO]; // wors perfectly

  // this doesnt work!
  /*
    NSSZ iSize = AZSizeFromDim(rect.size.width/cols);
    AZSizer *s = [AZSizer forQuantity:images.count  ofSize:iSize
  withColumns:cols];
    NSA *rects = s.rects.copy;
    return [NSIMG imageInFrame:AZRectBy(s.rows*s.width, s.columns*s.height)
  withBlock:^(NSRect dRect) {
      //imageWithSize: drawnUsingBlock:^{
      //	[contact lockFocus];
      [images eachWithIndex:^(NSIMG* obj, NSInteger idx) {
        NSR theR = [[rects normal:idx]rectValue];
        [(NSIMG*)obj scaleImageToFillSize:theR.size];
        NSLog(@"Contact Sheet render:%@   #%ld of %ld rect:%@", obj.name, idx,
  images.count, AZStringFromRect(theR));

        ///[obj scaledToMax:AZMaxDim(iSize)]
        [obj drawCenteredinRect:theR operation:NSCompositeSourceOver
  fraction:1];
  //		if (obj.name) NSF * f = [AtoZ font:@"UbuntuTitling-Bold"
  size:AZMinDim(theR.size)*.1];
      }];
    }];
  //	[contact unlockFocus];
  //	return contact;
  //	NSAS* string = [[obj.name truncatedForRect:nameRect withFont:f]
  attributedWithSize:AZMinDim(theR.size)*.1 andColor:WHITE];
  //	nameRect = AZRectExceptWide(nameRect, theR.size.width <
  nameRect.size.width ? theR.size.width : nameRect.size.width);
  //	nameRect = AZRectOffset(nameRect, theR.origin);
  //	NSRectFillWithColor(nameRect, RED);
  //	NSR nameRect = [obj.name frameWithFont:f];
  //	[string
  drawCenteredVerticallyInRect:nameRect];//:@"UbuntuTitling-Bold"];//:nameRect /
  * NSMakeRect(2, 2, sizeAndPhoto.width - 4, 14)* / withFont:font
  andColor:WHITE];
  */
}

+ (NSIMG*) contactSheetWith:(NSA *)images
                      sized:(NSSZ)size
                     spaced:(NSSZ)spacing
                    columns:(NSUI)cols
                   withName:(BOOL)name {
  NSSZ sizeAndPhoto = AZAddSizes(spacing, size);
  sizeAndPhoto.height += name ? 18 : 0;
  AZSizer *s =
      [AZSizer forQuantity:images.count ofSize:sizeAndPhoto withColumns:cols];
  return [self contactSheetWith:images
                      withSizer:s
                       withName:name]; // wors perfectly
} // wors perfectly

+ (NSIMG*) contactSheetWith:(NSA *)images
                  withSizer:(AZSizer *)s
                   withName:(BOOL)name {

  __block NSIMG *contact;

  [AZStopwatch named:$(@"ContactSheetWith%ldImages", images.count) block:^{


     contact = [NSIMG.alloc initWithSize:s.outerFrame.size];
     [contact lockFocus];

     [images eachWithIndex:^(NSIMG *obj, NSI idx) {

        NSR theR = [[s.rects normal:idx] rectValue];

        [[obj scaledToMax:AZMaxDim(s.size)] drawCenteredinRect:theR operation:NSCompositeSourceOver fraction:1];

        if (!name) return;

        NSSZ z = [obj.name sizeWithAttributes:@{NSFontAttributeName:AZDEFAULTFONT}];

        NSR nameRect = (NSR) { theR.origin, z.width < theR.size.width ? z.width : theR.size.width, 16 };  //AZRectOffset( AZRectFromDim(AZMinDim(theR.size) * .25), theR.origin);

         NSRectFillWithColor(nameRect, RED);

         [obj.name drawInRect:nameRect withFontNamed:@"UbuntuMono-Bold" andColor:WHITE];        //:nameRect  *NSMakeRect(2, 2, sizeAndPhoto.width - 4, 14)*/ withFont:font andColor:WHITE];
     }];

     [contact unlockFocus];

  }];

  return contact;

}  // wors perfectly

+ (NSIMG*) contactSheetWith:(NSA*)imgs
          inFrameWithNames:(NSR)rect { return [self contactSheetWith:imgs withSizer:[AZSizer forQuantity:imgs.count inRect:rect] withName:YES]; }

+ (NSIMG*) contactSheetWith:(NSA *)images
                      sized:(NSSZ)size
                     spaced:(NSSZ)spacing
                    columns:(NSUI)cols {
  return [self contactSheetWith:images
                          sized:size
                         spaced:spacing
                        columns:cols
                       withName:NO];
}

+ (NSIMG*) imageByTilingImages:(NSA *)imgs
                      spacingX:(CGF)x
                      spacingY:(CGF)y
                    vertically:(BOOL)v {

  CGF mergedWidth = 0.0, mergedHeight = 0.0;
  imgs = v ? imgs.reversed : imgs;
  for (NSIMG *image in imgs) {
    NSSize size = image.size;
    if (v) {
      mergedWidth = MAX(mergedWidth, size.width);
      mergedHeight += (size.height + y);
    } else {
      mergedWidth += (size.width + x);
      mergedHeight = MAX(mergedHeight, size.height);
    }
  }
  // Add the outer margins for the single-image dimension (The multi-image
  // dimension has already had it added in the loop)
  if (v)
    mergedWidth += 2 * x; // Add left and right margins
  else
    mergedHeight += 2 * y; // Add top and bottom margins

  NSSize mergedSize = NSMakeSize(mergedWidth, mergedHeight);
  NSIMG *mergedImage = [NSImage.alloc initWithSize:mergedSize];
  [mergedImage lockFocus];
  // Draw the images into the mergedImage
  CGFloat xx = x;
  CGFloat yy = y;
  for (NSIMG *image in imgs) {
    [image drawAtPoint:NSMakePoint(xx, yy)
              fromRect:NSZeroRect
             operation:NSCompositeSourceOver
              fraction:1.0];
    if (v) {
      yy += [image size].height;
      yy += y;
    } else {
      xx += [image size].width;
      xx += x;
    }
  }
  [mergedImage unlockFocus];
  return mergedImage;
}

- (NSIMG*)  imageBorderedWithInset:(CGF)inset {
  NSIMG *image = [NSImage.alloc initWithSize:[self size]];

  [image lockFocus];

  [self drawAtPoint:NSZeroPoint
           fromRect:NSZeroRect
          operation:NSCompositeCopy
           fraction:1.0];

  NSBP *path = [NSBP bezierPath];

  //[[NSC colorWithCalibratedWhite:0.0 alpha:0.7] set] ;
  [[NSC grayColor] setStroke];
  [path setLineWidth:inset];
  // Start at left
  [path moveToPoint:NSMakePoint(inset / 2, inset / 2)];
  // Move to the right
  [path relativeLineToPoint:NSMakePoint(self.size.width - (2.5) * inset, 0)];
  // Move up
  [path relativeLineToPoint:NSMakePoint(0, self.size.height - inset)];
  // Move left
  [path relativeLineToPoint:NSMakePoint(-self.size.width + (2.5) * inset, 0)];
  // Finish
  [path closePath];
  [path stroke];
  [image unlockFocus];
  return image;
}

- (NSIMG*) imageBorderedWithOutset:(CGF)outset {
  NSSize newSize = NSMakeSize([self size].width + 2 * outset,
                              [self size].height + 2 * outset);
  NSIMG *image = [NSImage.alloc initWithSize:newSize];
  [image lockFocus];
  [self drawAtPoint:NSMakePoint(outset, outset)
           fromRect:NSZeroRect
          operation:NSCompositeCopy
           fraction:1.0];
  NSBP *path = [NSBP bezierPath];
  //[[NSC colorWithCalibratedWhite:0.0 alpha:0.7] set] ;
  [[NSC grayColor] setStroke];
  [path setLineWidth:2.0];
  // Start at left
  [path moveToPoint:NSMakePoint(1.0, 1.0)];
  // Move to the right
  [path relativeLineToPoint:NSMakePoint(newSize.width - 2.0, 0)];
  // Move up
  [path relativeLineToPoint:NSMakePoint(0, newSize.height - 2.0)];
  // Move left
  [path relativeLineToPoint:NSMakePoint(-newSize.width + 2.0, 0)];
  // Finish
  [path closePath];
  [path stroke];
  [image unlockFocus];
  return image;
}

@end

