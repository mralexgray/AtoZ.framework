//
//  AZSizer.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSizer.h"
#import "AtoZ.h"


int gcd(int m, int n) {
	int t, r;
	if (m < n) { t = m; m = n; n = t; } r = m % n; //MSLog(@"remainder for %i is %i", n, r);
	if (r == 0) {
		return n;
	} else {	//		return gcd(r);
		return gcd(n, r);
	}
}


@implementation AZSizer

+ (id)forQuantity:(int)numItems forRect:(NSRect)frame{
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
