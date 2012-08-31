
//  AZSizer.h
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>
#import "AtoZ.h"



@interface Candidate : BaseModel
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
- (void) constrainLayersInLayer:(CALayer*)layer;

@property (assign, nonatomic) NSUInteger 	quantity;
@property (assign, nonatomic) NSUInteger	rows;
@property (assign, nonatomic) NSUInteger	columns;
@property (assign, nonatomic) CGFloat 		width;
@property (assign, nonatomic) CGFloat		height;
@property (readonly) NSSize		size;
@property (assign, nonatomic) NSRect		outerFrame;
@property (assign, nonatomic) int		remainder;
@property (readonly) NSArray 	*rects;
@property (readonly) NSArray 	*paths;
@property (readonly) NSArray 	*boxes;

@end

