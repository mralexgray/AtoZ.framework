//  THPoint.h
//  Lumumba Framework
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.



@class AZSize, AZRect, AZGrid, AGMatrix;
@interface AZPoint : NSObject  {  CGF x, y;  }
//+ (AZPoint*) point;
//+ (AZPoint*) pointOf:(id)object;
//+ (AZPoint*) pointWithX:(CGF)x y:(CGF)y;
//+ (AZPoint*) pointWithPoint:(NSP)pt;
//+ (AZPoint*) halfPoint;
//
//+ (BOOL)maybePoint:(id) object;
//
//- (id) initWithPoint:(NSP)pt;
//- (id) initWithX:		(CGF)x y:(CGF)y;
//
//_ROCGP cgpoint;
//@property (ASS) NSP point;
@property (ASS) CGF x, y;
//
//_ROCGF min, max;
//
//- (id) moveTo:(id) object;
//
//- (id) moveTowards:		(id)object withDistance:(CGF)relativeDistance;
//- (id) moveTowardsPoint:(NSP)pt withDistance:(CGF)relativeDistance;
//
//- (id) moveBy:			 (id) object;
//- (id) moveByPoint:	 (NSP)pt;
//- (id) moveByX:		 (CGF)x andY:(CGF)y;
//- (id) moveByNegative:(id) object;
//
//- (id) multiplyBy:(id) object;
//- (id) divideBy:	(id) object;
//
//- (id) swap;
//- (id) negate;
//- (id) invert;
//
//- (id) floor;
//- (id) round;
//- (id) ceil;
//- (id) square;
//- (id) root;
//
//- (id) ratio;
//
//- (BOOL)equals:(id) object;
//- (BOOL)equalsPoint:(NSP)point;
//
//- (BOOL)isWithin:(id) object;

@end
