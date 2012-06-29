//
//  NSColot+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
//#import "NSString+AG.h"
//#import "NSArray+AG.h"
//#import <AGFoundation/AGFoundation.h>
//#import "AGFoundation.h"


@interface NSColor (AtoZ)

+ (NSArray *)	colorNames;
+ (NSColor *)	colorNamed:(NSString *)string;

- (BOOL) 		isBoring;
- (BOOL) 		isExciting;
+ (NSArray*) 	boringColors;

- (CGColorRef)	CGColor;
- (NSString*)	crayonName;
- (NSColor*)	closestWebColor;
- (NSColor*) 	closestNamedColor;
- (NSString*)	nameOfColor;
- (NSDictionary*) closestColor;  //name, list, and color


+ (NSColor*)	randomColor;
+ (NSColor*)	randomOpaqueColor;
+ (NSColor*) 	colorFromHexRGB:	(NSString*) 	inColorString;
+ (NSColor*) 	colorWithHTMLString:(NSString*)		hexString;
+ (NSColor*)	colorWithCGColor:	(CGColorRef) 	aColor;
+ (NSColor*)	crayonColorNamed:	(NSString *)	key;

+ (NSColor*)	colorWithName:(NSString *)colorName;

+ (NSColor*)	colorFromString: 	(NSString*) 	string;
+ (NSColor*)	colorFromHexString: (NSString*)		hexString;
- (NSString*)	toHex;


@property (readonly) NSColor *deviceRGBColor;
@property (readonly) NSColor *calibratedRGBColor;

@property (readonly) CGFloat relativeBrightness;

@property (readonly) BOOL isBright;
@property (readonly) NSColor *bright;
@property (readonly) NSColor *brighter;

@property (readonly) BOOL isDark;
@property (readonly) NSColor *dark;
@property (readonly) NSColor *darker;

@property (readonly) NSColor *redshift;
@property (readonly) NSColor *blueshift;

-(NSColor *)blend:(NSColor *)other;

@property (readonly) NSColor *whitened;
@property (readonly) NSColor *blackened;

@property (readonly) NSColor *contrastingForegroundColor;
@property (readonly) NSColor *complement;
@property (readonly) NSColor *rgbComplement;

@property (readonly) NSColor *opaque;
@property (readonly) NSColor *lessOpaque;
@property (readonly) NSColor *moreOpaque;
@property (readonly) NSColor *translucent;
@property (readonly) NSColor *watermark;

-(NSColor *)rgbDistanceToColor:(NSColor *)color;
-(NSColor *)hsbDistanceToColor:(NSColor *)color;
@property (readonly) CGFloat rgbWeight;
@property (readonly) CGFloat hsbWeight;

@property (readonly) BOOL isBlueish;
@property (readonly) BOOL isRedish;
@property (readonly) BOOL isGreenish;
@property (readonly) BOOL isYellowish;


-(NSData *) colorData;
+ (NSColor *)colorFromData:(NSData*)theData;

@end

@interface NSString (AGColorConversion)
@property (readonly) NSColor *colorValue;
@end

@interface NSArray (AGColorConversion)
@property (readonly) NSArray *colorValues;
@end

@interface NSCoder (AGCoder)  //(TDBindings)

+(void)encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSString*)theKey;

@end
@interface NSColor (NSColor_ColorspaceEquality)

- (BOOL) isEqualToColor:(NSColor*)inColor colorSpace:(NSString*)inColorSpace;

@end
@interface NSColor (NSColor_CSSRGB)

+ (NSColor*) colorWithCSSRGB:(NSString*)rgbString;

@end


