//
//  BBMeshView.h
//  AtoZ
//
//  Created by Alex Gray on 11/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>


#define XVERTS 6
#define YVERTS 5

@interface BBMeshView : NSView {
	CALayer * draggingLayer;
	CGPoint hitPoint, hitVertexA, hitVertexB, hitVertexC;
	int vertexIndexA, vertexIndexB, vertexIndexC;
}

- (BOOL)point:(CGPoint)p inTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c;
- (CAL*)addMeshVertexLayer;
- (CGImageRef)cgImageFromNSImage:(NSImage*)anImage;
- (CGImageRef)createCGImageFromData:(NSData*)data;
- (CGPoint)destinationPointFromSourcePoint:(CGPoint)srcP
											sourceTrianglePointA:(CGPoint)sa
											sourceTrianglePointB:(CGPoint)sb
											sourceTrianglePointC:(CGPoint)sc
								 destinationTrianglePointA:(CGPoint)da
								 destinationTrianglePointB:(CGPoint)db
								 destinationTrianglePointC:(CGPoint)dc;
- (NSImage*) meshVertextImage;
- (float)areaOfTriangleWithPoints:(CGPoint)p1 b:(CGPoint)p2 c:(CGPoint)p3;
- (float)dotA:(CGPoint)a b:(CGPoint)b;
- (void) drawGridLines;
- (void) drawTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c;
- (void) findHitTriangle:(CGPoint)p;
- (void) meshHitNotification:(NSNotification*)note;
- (void) postHitNotification;
- (void) setupGrid:_;
                              
// 19 methods


@end

