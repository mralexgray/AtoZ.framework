//
//  AZSizer.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

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


+ (AZSizer*) forQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame;
+ (NSRect) structForQuantity:(NSUInteger)aNumber inRect:(NSRect)aFrame;
//+ (NSSize) gridFor:(int)someitems inRect:(NSRect)aframe;

@property (assign) NSUInteger quantity;
@property (assign) int		rows;
@property (assign) int		columns;
@property (assign) float 	width;
@property (assign) float	height;
@property (assign) int		remainder;
@property (readonly) NSArray 	*rects;
@property (readonly) NSArray 	*paths;
@property (readonly) NSArray 	*boxes;

@end

