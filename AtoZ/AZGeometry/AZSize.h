//  THSize.h
//  Lumumba Framework
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.


@class AZPoint, AZRect, AZGrid;
@interface AZSize : NSObject { 	CGF width, height;	}

+ (AZSize*) size;
+ (AZSize*) sizeOf:(id)object;
+ (AZSize*) sizeWithSize:(NSSZ)size;
+ (AZSize*) sizeWithWidth:(CGF)width height:(CGF)height;

+ (BOOL)maybeSize:(id) object;

- (id) initWithWidth:(CGF)width height:(CGF)height;
- (id) initWithSize:(NSSZ)size;

@property (ASS) CGF 	width, height;
@property (ASS) NSSZ size;
_RO CGF wthRatio, min,	max;

- (id) growBy:		 (id) object;
- (id) growByWidth:(CGF)width height:(CGF)height;

- (id) multipyBy:		 (id) object;
- (id) multipyByWidth:(CGF)width height:(CGF)height;
- (id) multipyByPoint:(NSP)point;
- (id) multipyBySize: (NSSZ)size;

- (id) divideBy: 		(id) object;
- (id) divideByWidth:(CGF)width height:(CGF)height;
- (id) divideByPoint:(NSP)point;
- (id) divideBySize: (NSSZ)size;

- (id) swap;
- (id) negate;
- (id) invert;

@end
