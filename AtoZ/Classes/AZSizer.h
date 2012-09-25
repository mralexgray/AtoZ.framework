
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
//+ (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe;
//- (void) constrainLayersInLayer:(CALayer*)layer;

@property (assign, nonatomic) AZOrient		orient;

@property (readonly) NSString* 	aspectRatio;
@property (assign, nonatomic) NSUInteger 	quantity;
@property (readonly) NSUInteger 	capacity;
@property (assign, nonatomic) NSUInteger	rows;
@property (assign, nonatomic) NSUInteger	columns;
@property (assign, nonatomic) CGFloat 		width;
@property (assign, nonatomic) CGFloat		height;
@property (assign, nonatomic) NSSize		size;
@property (assign, nonatomic) NSRect		outerFrame;
@property (readonly) NSInteger	remainder;
@property (nonatomic, copy) NSArray 	*rects;
@property (nonatomic, copy) NSMutableArray 	*positions;
@property (readonly) NSArray 	*paths;
@property (readonly) NSArray 	*boxes;

@end

