//
//  THSize.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZPoint, AZRect, AZGrid;

@interface AZSize : NSObject {
  CGFloat width;
  CGFloat height;
}

+(AZSize *)size;
+(AZSize *)sizeOf:(id)object;
+(AZSize *)sizeWithSize:(NSSize)size;
+(AZSize *)sizeWithWidth:(CGFloat)width height:(CGFloat)height;

+(BOOL)maybeSize:(id)object;

-(id)initWithWidth:(CGFloat)width height:(CGFloat)height;
-(id)initWithSize:(NSSize)size;

@property (assign) NSSize size;
@property (assign) CGFloat width;
@property (assign) CGFloat height;

@property (RONLY) CGFloat min;
@property (RONLY) CGFloat max;
@property (RONLY) CGFloat wthRatio;

-(id)growBy:(id)object;
-(id)growByWidth:(CGFloat)width height:(CGFloat)height;

-(id)multipyBy:(id)object;
-(id)multipyByWidth:(CGFloat)width height:(CGFloat)height;
-(id)multipyByPoint:(NSPoint)point;
-(id)multipyBySize:(NSSize)size;

-(id)divideBy:(id)object;
-(id)divideByWidth:(CGFloat)width height:(CGFloat)height;
-(id)divideByPoint:(NSPoint)point;
-(id)divideBySize:(NSSize)size;

-(id)swap;
-(id)negate;
-(id)invert;

@end
