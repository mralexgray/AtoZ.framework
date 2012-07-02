//
//  THPoint.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZSize, AZRect, AZGrid, AGMatrix;

@interface AZPoint : NSObject {
  CGFloat x;
  CGFloat y;
}


+(AZPoint *)point;
+(AZPoint *)pointOf:(id)object;
+(AZPoint *)pointWithX:(CGFloat)x y:(CGFloat)y;
+(AZPoint *)pointWithPoint:(NSPoint)pt;
+(AZPoint *)halfPoint;

+(BOOL)maybePoint:(id)object;

-(id)initWithPoint:(NSPoint)pt;
-(id)initWithX:(CGFloat)x y:(CGFloat)y;

@property (assign) NSPoint point;
@property (readonly) CGPoint cgpoint;
@property (assign) CGFloat x;
@property (assign) CGFloat y;

@property (readonly) CGFloat min;
@property (readonly) CGFloat max;

-(id)moveTo:(id)object;

-(id)moveTowards:(id)object withDistance:(CGFloat)relativeDistance;
-(id)moveTowardsPoint:(NSPoint)pt withDistance:(CGFloat)relativeDistance;

-(id)moveBy:(id)object;
-(id)moveByPoint:(NSPoint)pt;
-(id)moveByX:(CGFloat)x andY:(CGFloat)y;
-(id)moveByNegative:(id)object;

-(id)multiplyBy:(id)object;
-(id)divideBy:(id)object;

-(id)swap;
-(id)negate;
-(id)invert;

-(id)floor;
-(id)round;
-(id)ceil;
-(id)square;
-(id)root;

-(id)ratio;

-(BOOL)equals:(id)object;
-(BOOL)equalsPoint:(NSPoint)point;

-(BOOL)isWithin:(id)object;

@end