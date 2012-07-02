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

@interface NSCoder (AGCoder)  //(TDBindings)

+(void)encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSString*)theKey;

@end
@interface NSColor (NSColor_ColorspaceEquality)

- (BOOL) isEqualToColor:(NSColor*)inColor colorSpace:(NSString*)inColorSpace;

@end
@interface NSColor (NSColor_CSSRGB)

+ (NSColor*) colorWithCSSRGB:(NSString*)rgbString;

@end




@interface NSColor (AIColorAdditions_HLS)

//Linearly adjust a color
#define cap(x) { if (x < 0) {x = 0;} else if (x > 1) {x = 1;} }

- (NSColor *)adjustHue:(CGFloat)dHue saturation:(CGFloat)dSat brightness:(CGFloat)dBrit;

@end
//
//@implementation NSColor (AIColorAdditions_RepresentingColors)
//
//- (NSString *)hexString
//{
//    CGFloat 	red,green,blue;
//    char	hexString[7];
//    NSInteger		tempNum;
//    NSColor	*convertedColor;
//
//    convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//    [convertedColor getRed:&red green:&green blue:&blue alpha:NULL];
//    
//    tempNum = (red * 255.0f);
//    hexString[0] = intToHex(tempNum / 16);
//    hexString[1] = intToHex(tempNum % 16);
//
//    tempNum = (green * 255.0f);
//    hexString[2] = intToHex(tempNum / 16);
//    hexString[3] = intToHex(tempNum % 16);
//
//    tempNum = (blue * 255.0f);
//    hexString[4] = intToHex(tempNum / 16);
//    hexString[5] = intToHex(tempNum % 16);
//    hexString[6] = '\0';
//    
//    return [NSString stringWithUTF8String:hexString];
//}
//
////String representation: R,G,B[,A].
//- (NSString *)stringRepresentation
//{
//    NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//	CGFloat alphaComponent = [tempColor alphaComponent];
//
//	if (alphaComponent == 1.0) {
//		return [NSString stringWithFormat:@"%d,%d,%d",
//			(int)([tempColor redComponent] * 255.0),
//			(int)([tempColor greenComponent] * 255.0),
//			(int)([tempColor blueComponent] * 255.0)];
//
//	} else {
//		return [NSString stringWithFormat:@"%d,%d,%d,%d",
//			(int)([tempColor redComponent] * 255.0),
//			(int)([tempColor greenComponent] * 255.0),
//			(int)([tempColor blueComponent] * 255.0),
//			(int)(alphaComponent * 255.0)];		
//	}
//}
//
////- (NSString *)CSSRepresentation
////{
////	CGFloat alpha = [self alphaComponent];
////	if ((1.0 - alpha) >= 0.000001) {
////		NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
////		//CSS3 defines rgba() to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
////		return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
////			[NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
////			[NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
////			[NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
////			[NSString stringWithCGFloat:alpha                         maxDigits:6]];
////	} else {
////		return [@"#" stringByAppendingString:[self hexString]];
////	}
////}
//
//@end
//
//@implementation NSString (AIColorAdditions_RepresentingColors)
//
//- (NSColor *)representedColor
//{
//    CGFloat	r = 255, g = 255, b = 255;
//    CGFloat	a = 255;
//
//	const char *selfUTF8 = [self UTF8String];
//	
//	//format: r,g,b[,a]
//	//all components are decimal numbers 0..255.
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	r = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//
//	if(*selfUTF8 == ',') ++selfUTF8;
//	else                 goto scanFailed;
//
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	g = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//	if(*selfUTF8 == ',') ++selfUTF8;
//	else                 goto scanFailed;
//
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	b = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//	if (*selfUTF8 == ',') {
//		++selfUTF8;
//		a = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//
//		if (*selfUTF8) goto scanFailed;
//	} else if (*selfUTF8 != '\0') {
//		goto scanFailed;
//	}
//
//    return [NSColor colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:(a/255)] ;
//scanFailed:
//	return nil;
//}
//
//- (NSColor *)representedColorWithAlpha:(CGFloat)alpha
//{
//	//this is the same as above, but the alpha component is overridden.
//
//  NSUInteger	r, g, b;
//
//	const char *selfUTF8 = [self UTF8String];
//	
//	//format: r,g,b
//	//all components are decimal numbers 0..255.
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	r = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//
//	if (*selfUTF8 != ',') goto scanFailed;
//	++selfUTF8;
//
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	g = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//
//	if (*selfUTF8 != ',') goto scanFailed;
//	++selfUTF8;
//
//	if (!isdigit(*selfUTF8)) goto scanFailed;
//	b = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
//
//    return [NSColor colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:alpha];
//scanFailed:
//	return nil;
//}
//
//@end
//
//@implementation NSColor (AIColorAdditions_RandomColor)
//
//+ (NSColor *)randomColor
//{
//	return [NSColor colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
//	                                 green:(arc4random() % 65536) / 65536.0f
//	                                  blue:(arc4random() % 65536) / 65536.0f
//	                                 alpha:1.0f];
//}
//+ (NSColor *)randomColorWithAlpha
//{
//	return [NSColor colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
//	                                 green:(arc4random() % 65536) / 65536.0f
//	                                  blue:(arc4random() % 65536) / 65536.0f
//	                                 alpha:(arc4random() % 65536) / 65536.0f];
//}
//
//@end
//
//@implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
//
////+ (id)colorWithHTMLString:(NSString *)str
////{
////	return [self colorWithHTMLString:str defaultColor:nil];
////}
//
///*!
// * @brief Convert one or two hex characters to a float
// *
// * @param firstChar The first hex character
// * @param secondChar The second hex character, or 0x0 if only one character is to be used
// * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.
// */
//static CGFloat hexCharsToFloat(char firstChar, char secondChar)
//{
//	CGFloat				hexValue;
//	NSUInteger		firstDigit;
//	firstDigit = hexToInt(firstChar);
//	if (firstDigit != -1) {
//		hexValue = firstDigit;
//		if (secondChar != 0x0) {
//			int secondDigit = hexToInt(secondChar);
//			if (secondDigit != -1)
//				hexValue = (hexValue * 16.0f + secondDigit) / 255.0f;
//			else
//				hexValue = 0;
//		} else {
//			hexValue /= 15.0f;
//		}
//
//	} else {
//		hexValue = 0;
//	}
//
//	return hexValue;
//}
///*
//+ (id)colorWithHTMLString:(NSString *)str defaultColor:(NSColor *)defaultColor
//{
//	if (!str) return defaultColor;
//
//	NSUInteger strLength = [str length];
//	
//	NSString *colorValue = str;
//	
//	if ([str hasPrefix:@"rgb"]) {
//		NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
//		NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
//		if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
//		{
//			NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
//			return defaultColor;
//		}
//		leftParIndex++;
//		NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
//		colorValue = [colorValue substringWithRange:substrRange];
//		NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
//		if ([colorComponents count] < 3 || [colorComponents count] > 4) {
//			NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
//			return defaultColor;
//		}
//		float red, green, blue, alpha = 1.0f;
//		red = [[colorComponents objectAtIndex:0] floatValue];
//		green = [[colorComponents objectAtIndex:1] floatValue];
//		blue = [[colorComponents objectAtIndex:2] floatValue];
//		if ([colorComponents count] == 4)
//			alpha = [[colorComponents objectAtIndex:3] floatValue];
//		return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
//	}
//	
//	if ((!strLength) || ([str characterAtIndex:0] != '#')) {
//		//look it up; it's a colour name
//		NSDictionary *colorValues = [self colorNamesDictionary];
//		colorValue = [colorValues objectForKey:str];
//		if (!colorValue) colorValue = [colorValues objectForKey:[str lowercaseString]];
//		if (!colorValue) {
//#if COLOR_DEBUG
//			NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
//#endif
//			return defaultColor;
//		}
//	}
//
//	//we need room for at least 9 characters (#00ff00ff) plus the NUL terminator.
//	//this array is 12 bytes long because I like multiples of four. ;)
//	enum { hexStringArrayLength = 12 };
//	size_t hexStringLength = 0;
//	char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
//	{
//		NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
//		hexStringLength = [stringData length];
//		//subtract 1 because we don't want to overwrite that last NUL.
//		memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1));
//	}
//	const char *hexString = hexStringArray;
//
//	CGFloat		red,green,blue;
//	CGFloat		alpha = 1.0f;
//
//	//skip # if present.
//	if (*hexString == '#') {
//		++hexString;
//		--hexStringLength;
//	}
//
//	if (hexStringLength < 3) {
//#if COLOR_DEBUG
//		NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08) (string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
//#endif
//		return defaultColor;
//	}
//
//	//long specification:  #rrggbb[aa]
//	//short specification: #rgb[a]
//	//e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
//	BOOL isLong = hexStringLength > 4;
//
//	//for a long component c = 'xy':
//	//	c = (x * 0x10 + y) / 0xff
//	//for a short component c = 'x':
//	//	c = x / 0xf
//
//	char firstChar, secondChar;
//	
//	firstChar = *(hexString++);
//	secondChar = (isLong ? *(hexString++) : 0x0);
//	red = hexCharsToFloat(firstChar, secondChar);
//
//	firstChar = *(hexString++);
//	secondChar = (isLong ? *(hexString++) : 0x0);
//	green = hexCharsToFloat(firstChar, secondChar);
//
//	firstChar = *(hexString++);
//	secondChar = (isLong ? *(hexString++) : 0x0);
//	blue = hexCharsToFloat(firstChar, secondChar);
//
//	if (*hexString) {
//		//we still have one more component to go: this is alpha.
//		//without this component, alpha defaults to 1.0 (see initialiser above).
//		firstChar = *(hexString++);
//		secondChar = (isLong ? *hexString : 0x0);
//		alpha = hexCharsToFloat(firstChar, secondChar);
//	}
//
//	return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
//}
//*/
//@end
//
//@implementation NSColor (AIColorAdditions_ObjectColor)
//
//+ (NSString *)representedColorForObject: (id)anObject withValidColors: (NSArray *)validColors;
//
//@end
//
//
//@implementation NSColor (NSColor_ColorspaceEquality)
//
//- (BOOL) isEqualToColor:(NSColor*)inColor colorSpace:(NSString*)inColorSpace ;
//
//@end
//
//
//@implementation NSColor (NSColor_CSSRGB)
//
//+ (NSColor*) colorWithCSSRGB:(NSString*)rgbString;
//
//@end
