
//  AZSizer.h
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AtoZ.h"
#import "AtoZUmbrella.h"

extern NSUInteger gcd(NSInteger m, NSUInteger n);

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
@interface AZSizer : BaseModel 

+ (AZSizer*) forQuantity:(NSUInteger)aNumber aroundRect:(NSRect)aFrame;
+ (AZSizer*) forQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame;
+ (NSRect) structForQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame;

+ (NSRect) rectForQuantity:(NSUInteger)q ofSize:(NSSize)s withColumns:(NSUInteger)c;

//+ (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe;
//- (void) constrainLayersInLayer:(CALayer*)layer;

@property (NATOM, ASS) AZOrient		orient;

@property (RONLY) 		  NSString* 	aspectRatio;
@property (NATOM, ASS) NSUInteger 	quantity;
@property (RONLY) NSUInteger 	capacity;
@property (NATOM, ASS) NSUInteger	rows;
@property (NATOM, ASS) NSUInteger	columns;
@property (NATOM, ASS) CGFloat 		width;
@property (NATOM, ASS) CGFloat		height;
@property (NATOM, ASS) NSSize		size;
@property (NATOM, ASS) NSRect		outerFrame;
@property (RONLY) NSInteger	remainder;
@property (NATOM, CP) NSArray 	*rects;
@property (NATOM, CP) NSMutableArray 	*positions;
@property (RONLY) NSArray 	*paths;
@property (RONLY) NSArray 	*boxes;

@end

