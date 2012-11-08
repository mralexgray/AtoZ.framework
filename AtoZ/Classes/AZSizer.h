
//  AZSizer.h
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AtoZ.h"
#import "AtoZUmbrella.h"

extern NSUInteger gcd(NSInteger m, NSUInteger n);


@interface AZSizer : BaseModel 

+ (AZSizer*) forObjects:  (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr;
+ (instancetype) forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame;
+ (instancetype) forQuantity: (NSUI)aNumber     inRect:(NSR)aFrame;
+ (NSRect) structForQuantity: (NSUI)aNumber     inRect:(NSR)aFrame;
+ (NSRect)   rectForQuantity: (NSUI)q 	        ofSize:(NSSize)s  	withColumns:(NSUI)c;

//+ (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe;
//- (void) constrainLayersInLayer:(CALayer*)layer;

@property (NATOM, ASS) AZOrient		orient;

@property (NATOM, RDWRT) NSRect		outerFrame;

@property (RONLY) 		 NSUInteger	 	rows, 		columns,		capacity;
@property (RONLY) 		 NSInteger		remainder;
@property (RONLY) 		 CGFloat 		width, 		height;
@property (NATOM, RONLY) NSSize			size;
@property (RONLY) 		 NSArray 		*paths, 	*boxes;
@property (RONLY) 		 NSS			*aspectRatio;

@property (weak) NSA* objects;
@property (NATOM, ASS) 	NSUInteger 	quantity;
@property (NATOM, CP) 	NSA 	*rects;
@property (NATOM, CP) 	NSMA 	*positions;

- (NSValue*) rectForPoint:(NSP) point;
//- (void) updateFrame:(NSRect)rect;
@end

