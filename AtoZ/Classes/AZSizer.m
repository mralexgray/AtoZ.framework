//
//  AZSizer.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSizer.h"
#import "AtoZ.h"

int gcd(int m, int n) {	int t, r;
	if (m < n) { t = m; m = n; n = t; } r = m % n; //MSLog(@"remainder for %i is %i", n, r);
	if (r == 0) return n; else return gcd(n, r);
}

@implementation Candidate
@synthesize width,height,rows,columns, aspectRatio, screen, remainder;
-(id) initWithDictionary:(NSDictionary *)d{
	self = [Candidate instance];
	//	if ([d valueForKey:@"width"]) 	self.width 	= [[d valueForKey:@"width"]floatValue];
	//	if ([d valueForKey:@"height"]) 	self.height	= [[d valueForKey:@"height"]floatValue];
	self.remainder = ( [d valueForKey:@"remainder"] ? [[d valueForKey:@"remainder"]intValue] : 0);
	self.rows = [[d valueForKey:@"rows"]intValue];
	self.columns = [[d valueForKey:@"columns"]intValue];
	self.screen = NSRectFromString([d valueForKey:@"screen"]);
	self.width = ( self.screen.size.width  / (float)self.columns );
	self.height = (self.screen.size.height / (float)self.rows );
	self.aspectRatio = ( self.width / self.height );
	return self;
}

@end

@interface AZSizer ()
@property  (retain, nonatomic) NSMutableArray *candidates;
@end

@implementation AZSizer
@synthesize candidates = _candidates, remainder, width, quantity, rows, columns, height, rects, paths;
@synthesize boxes;

//- (void) simplerItemsPerRow {
//	rows = $int(ceil(sqrt(self.quantity)));
//}

+ (NSRect) structForQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	AZSizer *r = [[AZSizer alloc]initWithQuantity:aNumber inRect:aFrame];
	NSRect rect = NSMakeRect( r.rows, r.columns,r.width,r.height );
	return rect;
}

+ (AZSizer*) forQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	AZSizer *r = [[AZSizer alloc]initWithQuantity:aNumber inRect:aFrame];
	return r;
}

- (id) initWithQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame {
	self = [super init]; 
	if (self) {
		self.candidates = [NSMutableArray array];
		self.quantity = aNumber;
		int smallR = 0, rem, runnerUp, rUpItems, x;
		x = (aNumber < 2 ? 2 : aNumber);
		NSArray *list = [$int(2) to:$int((ceil(sqrt(x)))+4)];
		for( id rowTry in list ) {
			int xx, itemsnow;
			int _rows = [rowTry intValue];
			float items;
			xx 	= gcd(x, _rows);
			items = (float)x / _rows;
			rem = ( _rows + ( x % _rows ) ) % _rows;
			itemsnow = floor(items);
			smallR = rem;
			runnerUp = _rows;
			rUpItems = itemsnow;
			NSNumber *rowsAccountingForRemainder = ( rem != 0 ? $int(runnerUp + 1) : $int(runnerUp));
			NSDictionary *match = [[NSDictionary alloc]initWithDictionary:$map(
																			  $int(rUpItems), @"columns",
																			  rowsAccountingForRemainder, @"rows",
																			  $int(smallR), @"remainder",
																			  NSStringFromRect(aFrame), @"screen"  )];
			Candidate *perfect = [[Candidate alloc]initWithDictionary:match];
			[self.candidates addObject:perfect];
		}
		float distanceFromOne = 99.9;
		Candidate *winner;
		for (Candidate *c in self.candidates) {
			float distance = (c.aspectRatio < 1 ? (1.0 - c.aspectRatio) : (c.aspectRatio - 1.0));
			if (distance < distanceFromOne) {
				winner = c;
				distanceFromOne = distance;
			}
		}
		self.columns	= winner.columns;
		self.rows 		= winner.rows;
		self.width 		= winner.width;
		self.height  	= winner.height;
		self.remainder 	= winner.remainder;
		
		//	NSLog(@"Items:%ld Rows:%@ Columns:%@ Remainder: %@ Size: %ix%i", self.quantity, rows, columns, remainder, width.intValue, height.intValue);
	}
	return self;
}

+ (NSArray*) rectsForQuantity:(int)aNumber inRect:(NSRect)aFrame {
	AZSizer *sizer = [AZSizer forQuantity:aNumber inRect:aFrame];
	NSMutableArray *_rects = [NSMutableArray array];
	for ( int r = (sizer.rows-1); r >= 0; r--){
		for ( int c = 0; c < sizer.columns; c++ ) {
			[_rects addObject:[NSValue valueWithRect:NSMakeRect((c * sizer.width), (r *sizer.height), sizer.width, sizer.height)]];
		}
	}
	return _rects;
}

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
//
//	AGIdealSizer *a = [[AGIdealSizer alloc]initWithQuantity:someitems forRect:NSStringFromRect(aframe)];
//	return NSMakeSize(a.rows.intValue,a.columns.intValue);
//
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
