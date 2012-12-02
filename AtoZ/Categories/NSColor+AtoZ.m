
//  NSColot+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSColor+AtoZ.h"
#import "AtoZ.h"
#import "AZNamedColors.h"

#define AIfmod( X, Y )	fmod((X),(Y))

@interface DummyListClass : NSObject
@end
@implementation DummyListClass
@end
typedef struct {
	unsigned long value;
	const char name[24];  // Longest name is 20 chars, pad out to multiple of 8
} ColorNameRec;


//Convert hex to an int
int hexToInt(char hex)
{
	if (hex >= '0' && hex <= '9') {
		return (hex - '0');
	} else if (hex >= 'a' && hex <= 'f') {
		return (hex - 'a' + 10);
	} else if (hex >= 'A' && hex <= 'F') {
		return (hex - 'A' + 10);
	} else {
		return -1;
	}
}

//Convert int to a hex
char intToHex(NSInteger digit)
{
	if (digit > 9) {
		if (digit <= 0xf) {
			return ('a' + digit - 10);
		}
	} else if (digit >= 0) {
		return ('0' + digit);
	}

	return '\0'; //NUL
}
CGFloat LuminanceFromRGBComponents(const CGFloat *rgb)
{
	// 0.3086 + 0.6094 + 0.0820 = 1.0
	return 0.3086f*rgb[0] + 0.6094f*rgb[1] + 0.0820f*rgb[2];
}
static ColorNameRec sColorTable[] = {
	{ 0xf0f8ff, "aliceblue" },
	{ 0xfaebd7, "antiquewhite" },
	{ 0x00ffff, "aqua" },
	{ 0x7fffd4, "aquamarine" },
	{ 0xf0ffff, "azure" },
	{ 0xf5f5dc, "beige" },
	{ 0xffe4c4, "bisque" },
	{ 0x000000, "black" },
	{ 0xffebcd, "blanchedalmond" },
	{ 0x0000ff, "blue" },
	{ 0x8a2be2, "blueviolet" },
	{ 0xa52a2a, "brown" },
	{ 0xdeb887, "burlywood" },
	{ 0x5f9ea0, "cadetblue" },
	{ 0x7fff00, "chartreuse" },
	{ 0xd2691e, "chocolate" },
	{ 0xff7f50, "coral" },
	{ 0x6495ed, "cornflowerblue" },
	{ 0xfff8dc, "cornsilk" },
	{ 0xdc143c, "crimson" },
	{ 0x00ffff, "cyan" },
	{ 0x00008b, "darkblue" },
	{ 0x008b8b, "darkcyan" },
	{ 0xb8860b, "darkgoldenrod" },
	{ 0xa9a9a9, "darkgray" },
	{ 0xa9a9a9, "darkgrey" },
	{ 0x006400, "darkgreen" },
	{ 0xbdb76b, "darkkhaki" },
	{ 0x8b008b, "darkmagenta" },
	{ 0x556b2f, "darkolivegreen" },
	{ 0xff8c00, "darkorange" },
	{ 0x9932cc, "darkorchid" },
	{ 0x8b0000, "darkred" },
	{ 0xe9967a, "darksalmon" },
	{ 0x8fbc8f, "darkseagreen" },
	{ 0x483d8b, "darkslateblue" },
	{ 0x2f4f4f, "darkslategray" },
	{ 0x2f4f4f, "darkslategrey" },
	{ 0x00ced1, "darkturquoise" },
	{ 0x9400d3, "darkviolet" },
	{ 0xff1493, "deeppink" },
	{ 0x00bfff, "deepskyblue" },
	{ 0x696969, "dimgray" },
	{ 0x696969, "dimgrey" },
	{ 0x1e90ff, "dodgerblue" },
	{ 0xb22222, "firebrick" },
	{ 0xfffaf0, "floralwhite" },
	{ 0x228b22, "forestgreen" },
	{ 0xff00ff, "fuchsia" },
	{ 0xdcdcdc, "gainsboro" },
	{ 0xf8f8ff, "ghostwhite" },
	{ 0xffd700, "gold" },
	{ 0xdaa520, "goldenrod" },
	{ 0x808080, "gray" },
	{ 0x808080, "grey" },
	{ 0x008000, "green" },
	{ 0xadff2f, "greenyellow" },
	{ 0xf0fff0, "honeydew" },
	{ 0xff69b4, "hotpink" },
	{ 0xcd5c5c, "indianred" },
	{ 0x4b0082, "indigo" },
	{ 0xfffff0, "ivory" },
	{ 0xf0e68c, "khaki" },
	{ 0xe6e6fa, "lavender" },
	{ 0xfff0f5, "lavenderblush" },
	{ 0x7cfc00, "lawngreen" },
	{ 0xfffacd, "lemonchiffon" },
	{ 0xadd8e6, "lightblue" },
	{ 0xf08080, "lightcoral" },
	{ 0xe0ffff, "lightcyan" },
	{ 0xfafad2, "lightgoldenrodyellow" },
	{ 0xd3d3d3, "lightgray" },
	{ 0xd3d3d3, "lightgrey" },
	{ 0x90ee90, "lightgreen" },
	{ 0xffb6c1, "lightpink" },
	{ 0xffa07a, "lightsalmon" },
	{ 0x20b2aa, "lightseagreen" },
	{ 0x87cefa, "lightskyblue" },
	{ 0x8470ff, "lightslateblue" },
	{ 0x778899, "lightslategray" },
	{ 0x778899, "lightslategrey" },
	{ 0xb0c4de, "lightsteelblue" },
	{ 0xffffe0, "lightyellow" },
	{ 0x00ff00, "lime" },
	{ 0x32cd32, "limegreen" },
	{ 0xfaf0e6, "linen" },
	{ 0xff00ff, "magenta" },
	{ 0x800000, "maroon" },
	{ 0x66cdaa, "mediumaquamarine" },
	{ 0x0000cd, "mediumblue" },
	{ 0xba55d3, "mediumorchid" },
	{ 0x9370d8, "mediumpurple" },
	{ 0x3cb371, "mediumseagreen" },
	{ 0x7b68ee, "mediumslateblue" },
	{ 0x00fa9a, "mediumspringgreen" },
	{ 0x48d1cc, "mediumturquoise" },
	{ 0xc71585, "mediumvioletred" },
	{ 0x191970, "midnightblue" },
	{ 0xf5fffa, "mintcream" },
	{ 0xffe4e1, "mistyrose" },
	{ 0xffe4b5, "moccasin" },
	{ 0xffdead, "navajowhite" },
	{ 0x000080, "navy" },
	{ 0xfdf5e6, "oldlace" },
	{ 0x808000, "olive" },
	{ 0x6b8e23, "olivedrab" },
	{ 0xffa500, "orange" },
	{ 0xff4500, "orangered" },
	{ 0xda70d6, "orchid" },
	{ 0xeee8aa, "palegoldenrod" },
	{ 0x98fb98, "palegreen" },
	{ 0xafeeee, "paleturquoise" },
	{ 0xd87093, "palevioletred" },
	{ 0xffefd5, "papayawhip" },
	{ 0xffdab9, "peachpuff" },
	{ 0xcd853f, "peru" },
	{ 0xffc0cb, "pink" },
	{ 0xdda0dd, "plum" },
	{ 0xb0e0e6, "powderblue" },
	{ 0x800080, "purple" },
	{ 0xff0000, "red" },
	{ 0xbc8f8f, "rosybrown" },
	{ 0x4169e1, "royalblue" },
	{ 0x8b4513, "saddlebrown" },
	{ 0xfa8072, "salmon" },
	{ 0xf4a460, "sandybrown" },
	{ 0x2e8b57, "seagreen" },
	{ 0xfff5ee, "seashell" },
	{ 0xa0522d, "sienna" },
	{ 0xc0c0c0, "silver" },
	{ 0x87ceeb, "skyblue" },
	{ 0x6a5acd, "slateblue" },
	{ 0x708090, "slategray" },
	{ 0x708090, "slategrey" },
	{ 0xfffafa, "snow" },
	{ 0x00ff7f, "springgreen" },
	{ 0x4682b4, "steelblue" },
	{ 0xd2b48c, "tan" },
	{ 0x008080, "teal" },
	{ 0xd8bfd8, "thistle" },
	{ 0xff6347, "tomato" },
	{ 0x40e0d0, "turquoise" },
	{ 0xee82ee, "violet" },
	{ 0xd02090, "violetred" },
	{ 0xf5deb3, "wheat" },
	{ 0xffffff, "white" },
	{ 0xf5f5f5, "whitesmoke" },
	{ 0xffff00, "yellow" },
	{ 0x9acd32, "yellowgreen" },
};
@implementation NSColor (AtoZ)

- (NSColor*) alpha:(CGFloat)floater
{
	return [self colorWithAlphaComponent:floater];
}

- (NSColor *)inverted
{

	NSColor * original = [self colorUsingColorSpaceName:
						  NSCalibratedRGBColorSpace];
	CGFloat hue = [original hueComponent];
	if (hue >= 0.5) { hue -= 0.5; } else { hue += 0.5; }
	return [NSColor colorWithCalibratedHue:hue
								saturation:[original saturationComponent]
								brightness:(1.0 - [original brightnessComponent])
									 alpha:[original alphaComponent]];
}
+ (NSColor*) linen {
	return [NSColor colorWithPatternImage: [NSImage az_imageNamed:@"linen.png"]];
}
+ (NSColor*) linenTintedWithColor:(NSColor*)color {
	return [NSColor colorWithPatternImage:[[NSImage az_imageNamed:@"linen.png"]tintedWithColor:color]];
}
+ (NSColor*) leatherTintedWithColor:(NSColor*)color {
	return [NSColor colorWithPatternImage:[[NSImage imageNamed:@"perforated_white_leather"]tintedWithColor:color]];
}


+ (NSColor*)checkerboardWithFirstColor: (NSColor*)firstColor secondColor: (NSColor*)secondColor squareWidth: (CGFloat)width
{
	NSSize patternSize = NSMakeSize(width * 2.0, width * 2.0);
	NSRect rect = NSZeroRect;
	rect.size = patternSize;

	NSImage* pattern = [[NSImage alloc] initWithSize: patternSize];
	rect.size = NSMakeSize(width, width);
	[pattern lockFocus];

	[firstColor set];
	NSRectFill(rect);

	rect.origin.x = width;
	rect.origin.y = width;
	NSRectFill(rect);

	[secondColor set];
	rect.origin.x = 0.0;
	rect.origin.y = width;
	NSRectFill(rect);

	rect.origin.x = width;
	rect.origin.y = 0.0;
	NSRectFill(rect);

	[pattern unlockFocus];
	return [NSColor colorWithPatternImage: pattern];
}

+ (NSArray *)colorNames {
	static NSArray *sAllNames = nil;
	if (!sAllNames) {
		int count = sizeof(sColorTable) / sizeof(sColorTable[0]);
		NSMutableArray *names = [[NSMutableArray alloc] init];
		ColorNameRec *rec = sColorTable;

		for (int i = 0; i < count; ++i, ++rec)
			[names addObject:@(rec->name)];
		sAllNames = [[NSArray alloc] initWithArray:names];
	}
	return sAllNames;
}

static NSColor *ColorWithUnsignedLong(unsigned long value, BOOL hasAlpha) {
	float a = 1.0;
	// Extract alpha, if available
	if (hasAlpha) {	a = (float)(0x00FF & value) / 255.0; value >>= 8;	}
	float r = (float)(value >> 16) / 255.0;
	float g = (float)(0x00FF & (value >> 8)) / 255.0;
	float b = (float)(0x00FF & value) / 255.0;
	return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
}

//------------------------------------------------------------------------------
static NSColor *ColorWithHexDigits(NSString *str) {
	NSScanner *scanner = [NSScanner scannerWithString:[str lowercaseString]];
	NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];
	NSString *hexStr;

	[scanner scanUpToCharactersFromSet:hexSet intoString:nil];
	[scanner scanCharactersFromSet:hexSet intoString:&hexStr];

	int len = [hexStr length];
	if (len >= 6) {
		BOOL hasAlpha = (len == 8) ? YES : NO;
		unsigned long value = strtoul([hexStr UTF8String], NULL, 16);

		return ColorWithUnsignedLong(value, hasAlpha);
	}

	return nil;
}

//------------------------------------------------------------------------------
static NSColor *ColorWithCSSString(NSString *str) {
	NSString *trimmed = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *lowerStr = [trimmed lowercaseString];
	NSScanner *scanner = [NSScanner scannerWithString:lowerStr];

	if ([scanner scanString:@"rgb" intoString:NULL]) {
		[scanner scanString:@"(" intoString:NULL];
		NSString *content;
		[scanner scanUpToString:@")" intoString:&content];
		NSCharacterSet *spaceOrCommaSet = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
		NSArray *components = [content componentsSeparatedByCharactersInSet:spaceOrCommaSet];
		int count = [components count];
		float a = 1.0;

		// Alpha in CSS-mode is a 0-1 float
		if (count > 3)
			a = (float)[components[3] floatValue];

		float r = (float)strtoul([components[0] UTF8String], NULL, 10) / 255.0;
		float g = (float)strtoul([components[1] UTF8String], NULL, 10) / 255.0;
		float b = (float)strtoul([components[2] UTF8String], NULL, 10) / 255.0;

		return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
	}

	return nil;
}
+ (NSColor *)colorNamed:(NSString *)name {

	if (![name length])
		return nil;

	NSArray *allNames = [self colorNames];
	NSUInteger count = [allNames count];
	NSUInteger idx = [allNames indexOfObject:[name lowercaseString]];

	if (idx >= count) {
		// If the string contains some hex digits, try to convert
		// #RRGGBB or #RRGGBBAA
		// rgb(r,g,b) or rgba(r,g,b,a)
		NSColor *color = ColorWithHexDigits(name);

		if (!color)
			color = ColorWithCSSString(name);

		return color;
	}

	return ColorWithUnsignedLong(sColorTable[idx].value, NO);
}
+ (NSA*) boringColors{
	return  $array( @"White", @"Whitesmoke", @"Whitesmoke",@"Gainsboro", @"LightGrey", @"Silver", @"DarkGray", @"Gray", @"DimGray", @"Black", @"Translucent", @"MistyRose", @"Snow", @"SeaShell", @"Linen", @"Cornsilk", @"OldLace", @"FloralWhite", @"Ivory", @"HoneyDew", @"MintCream", @"Azure", @"AliceBlue", @"GhostWhite", @"LavenderBlush", @"mercury", @"Slver", @"Magnesium", @"Tin", @"Aluminum");
}

- (BOOL) isBoring {
	//	CGFloat r,g,b,a;
	//	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	//
	////	if ( a > .6 ) {
	////		NSLog(@"Too much alpha... BORING");
	////		return TRUE;
	////	}
	//	float total = r + g + b;
	//	if ( (total > 2.8) || (total < .2) ) {
	//		NSLog(@"Not enough Color! BORING");
	NSColor *deviceColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];

	if (( ([deviceColor saturationComponent] + [deviceColor hueComponent] + [deviceColor brightnessComponent]) > 1.6) && ( [deviceColor saturationComponent] > .3)) return FALSE;

	if (( [deviceColor brightnessComponent] 	< .3)	||  // too dark
		( [deviceColor saturationComponent] 	< .4)  // too blah
		//		( [deviceColor brightnessComponent] 	> .8)   	// too bright
		) {
		return TRUE;
	}

	//	[[self closestNamedColor] containsAnyOf:[NSColor boringColors]]) return TRUE;
	else return FALSE;
}
- (BOOL) isExciting {
	if ([self isBoring] ) return FALSE;
	//	containsAnyOf:[NSColor boringColors]]) return FALSE;
	else return TRUE;
}

- (CGColorRef)cgColor {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSColor *deviceColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	CGFloat components[4];
	[deviceColor getRed: &components[0] green: &components[1] blue:&components[2] alpha: &components[3]];
	CGColorRef output = CGColorCreate(colorSpace, components);
	CGColorSpaceRelease (colorSpace);
	return CGColorRetain(output);
	//[(id)output autorelease];
	//	return (__bridge CGColorRef)(__bridge_transfer id)output;
}
//+ (NSColor*)colorWithCGColor:(CGColorRef)aColor {
//	const CGFloat *components = CGColorGetComponents(aColor);
//	CGFloat red = components[0];
//	CGFloat green = components[1];
//	CGFloat blue = components[2];
//	CGFloat alpha = components[3];
//	return [self colorWithDeviceRed:red green:green blue:blue alpha:alpha];
//}
/**+ (NSColor)

 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Almond" HexCode:@"#EFDECD" Red:239 Green:222 Blue:205]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Apricot" HexCode:@"#FDD9B5" Red:253 Green:217 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Aquamarine" HexCode:@"#78DBE2" Red:120 Green:219 Blue:226]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Asparagus" HexCode:@"#87A96B" Red:135 Green:169 Blue:107]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Atomic Tangerine" HexCode:@"#FFA474" Red:255 Green:164 Blue:116]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Banana Mania" HexCode:@"#FAE7B5" Red:250 Green:231 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Beaver" HexCode:@"#9F8170" Red:159 Green:129 Blue:112]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Bittersweet" HexCode:@"#FD7C6E" Red:253 Green:124 Blue:110]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Black" HexCode:@"#000000" Red:0 Green:0 Blue:0]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blizzard Blue" HexCode:@"#ACE5EE" Red:172 Green:229 Blue:238]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue" HexCode:@"#1F75FE" Red:31 Green:117 Blue:254]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Bell" HexCode:@"#A2A2D0" Red:162 Green:162 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Gray" HexCode:@"#6699CC" Red:102 Green:153 Blue:204]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Green" HexCode:@"#0D98BA" Red:13 Green:152 Blue:186]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blue Violet" HexCode:@"#7366BD" Red:115 Green:102 Blue:189]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Blush" HexCode:@"#DE5D83" Red:222 Green:93 Blue:131]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Brick Red" HexCode:@"#CB4154" Red:203 Green:65 Blue:84]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Brown" HexCode:@"#B4674D" Red:180 Green:103 Blue:77]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Burnt Orange" HexCode:@"#FF7F49" Red:255 Green:127 Blue:73]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Burnt Sienna" HexCode:@"#EA7E5D" Red:234 Green:126 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cadet Blue" HexCode:@"#B0B7C6" Red:176 Green:183 Blue:198]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Canary" HexCode:@"#FFFF99" Red:255 Green:255 Blue:153]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Caribbean Green" HexCode:@"#1CD3A2" Red:28 Green:211 Blue:162]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Carnation Pink" HexCode:@"#FFAACC" Red:255 Green:170 Blue:204]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cerise" HexCode:@"#DD4492" Red:221 Green:68 Blue:146]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cerulean" HexCode:@"#1DACD6" Red:29 Green:172 Blue:214]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Chestnut" HexCode:@"#BC5D58" Red:188 Green:93 Blue:88]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Copper" HexCode:@"#DD9475" Red:221 Green:148 Blue:117]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cornflower" HexCode:@"#9ACEEB" Red:154 Green:206 Blue:235]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Cotton Candy" HexCode:@"#FFBCD9" Red:255 Green:188 Blue:217]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Dandelion" HexCode:@"#FDDB6D" Red:253 Green:219 Blue:109]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Denim" HexCode:@"#2B6CC4" Red:43 Green:108 Blue:196]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Desert Sand" HexCode:@"#EFCDB8" Red:239 Green:205 Blue:184]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Eggplant" HexCode:@"#6E5160" Red:110 Green:81 Blue:96]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Electric Lime" HexCode:@"#CEFF1D" Red:206 Green:255 Blue:29]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fern" HexCode:@"#71BC78" Red:113 Green:188 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Forest Green" HexCode:@"#6DAE81" Red:109 Green:174 Blue:129]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fuchsia" HexCode:@"#C364C5" Red:195 Green:100 Blue:197]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Fuzzy Wuzzy" HexCode:@"#CC6666" Red:204 Green:102 Blue:102]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Gold" HexCode:@"#E7C697" Red:231 Green:198 Blue:151]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Goldenrod" HexCode:@"#FCD975" Red:252 Green:217 Blue:117]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Granny Smith Apple" HexCode:@"#A8E4A0" Red:168 Green:228 Blue:160]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Gray" HexCode:@"#95918C" Red:149 Green:145 Blue:140]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green" HexCode:@"#1CAC78" Red:28 Green:172 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green Blue" HexCode:@"#1164B4" Red:17 Green:100 Blue:180]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Green Yellow" HexCode:@"#F0E891" Red:240 Green:232 Blue:145]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Hot Magenta" HexCode:@"#FF1DCE" Red:255 Green:29 Blue:206]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Inchworm" HexCode:@"#B2EC5D" Red:178 Green:236 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Indigo" HexCode:@"#5D76CB" Red:93 Green:118 Blue:203]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Jazzberry Jam" HexCode:@"#CA3767" Red:202 Green:55 Blue:103]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Jungle Green" HexCode:@"#3BB08F" Red:59 Green:176 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Laser Lemon" HexCode:@"#FEFE22" Red:254 Green:254 Blue:34]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Lavender" HexCode:@"#FCB4D5" Red:252 Green:180 Blue:213]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Lemon Yellow" HexCode:@"#FFF44F" Red:255 Green:244 Blue:79]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Macaroni and Cheese" HexCode:@"#FFBD88" Red:255 Green:189 Blue:136]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Magenta" HexCode:@"#F664AF" Red:246 Green:100 Blue:175]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Magic Mint" HexCode:@"#AAF0D1" Red:170 Green:240 Blue:209]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mahogany" HexCode:@"#CD4A4C" Red:205 Green:74 Blue:76]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Maize" HexCode:@"#EDD19C" Red:237 Green:209 Blue:156]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Manatee" HexCode:@"#979AAA" Red:151 Green:154 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mango Tango" HexCode:@"#FF8243" Red:255 Green:130 Blue:67]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Maroon" HexCode:@"#C8385A" Red:200 Green:56 Blue:90]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mauvelous" HexCode:@"#EF98AA" Red:239 Green:152 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Melon" HexCode:@"#FDBCB4" Red:253 Green:188 Blue:180]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Midnight Blue" HexCode:@"#1A4876" Red:26 Green:72 Blue:118]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mountain Meadow" HexCode:@"#30BA8F" Red:48 Green:186 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Mulberry" HexCode:@"#C54B8C" Red:197 Green:75 Blue:140]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Navy Blue" HexCode:@"#1974D2" Red:25 Green:116 Blue:210]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Neon Carrot" HexCode:@"#FFA343" Red:255 Green:163 Blue:67]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Olive Green" HexCode:@"#BAB86C" Red:186 Green:184 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange" HexCode:@"#FF7538" Red:255 Green:117 Blue:56]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange Red" HexCode:@"#FF2B2B" Red:255 Green:43 Blue:43]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orange Yellow" HexCode:@"#F8D568" Red:248 Green:213 Blue:104]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Orchid" HexCode:@"#E6A8D7" Red:230 Green:168 Blue:215]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Outer Space" HexCode:@"#414A4C" Red:65 Green:74 Blue:76]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Outrageous Orange" HexCode:@"#FF6E4A" Red:255 Green:110 Blue:74]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pacific Blue" HexCode:@"#1CA9C9" Red:28 Green:169 Blue:201]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Peach" HexCode:@"#FFCFAB" Red:255 Green:207 Blue:171]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Periwinkle" HexCode:@"#C5D0E6" Red:197 Green:208 Blue:230]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Piggy Pink" HexCode:@"#FDDDE6" Red:253 Green:221 Blue:230]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pine Green" HexCode:@"#158078" Red:21 Green:128 Blue:120]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pink Flamingo" HexCode:@"#FC74FD" Red:252 Green:116 Blue:253]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Pink Sherbert" HexCode:@"#F78FA7" Red:247 Green:143 Blue:167]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Plum" HexCode:@"#8E4585" Red:142 Green:69 Blue:133]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Heart" HexCode:@"#7442C8" Red:116 Green:66 Blue:200]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Mountain's Majesty" HexCode:@"#9D81BA" Red:157 Green:129 Blue:186]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Purple Pizzazz" HexCode:@"#FE4EDA" Red:254 Green:78 Blue:218]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Radical Red" HexCode:@"#FF496C" Red:255 Green:73 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Raw Sienna" HexCode:@"#D68A59" Red:214 Green:138 Blue:89]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Raw Umber" HexCode:@"#714B23" Red:113 Green:75 Blue:35]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Razzle Dazzle Rose" HexCode:@"#FF48D0" Red:255 Green:72 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Razzmatazz" HexCode:@"#E3256B" Red:227 Green:37 Blue:107]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red" HexCode:@"#EE204D" Red:238 Green:32 Blue:77]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red Orange" HexCode:@"#FF5349" Red:255 Green:83 Blue:73]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Red Violet" HexCode:@"#C0448F" Red:192 Green:68 Blue:143]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Robin's Egg Blue" HexCode:@"#1FCECB" Red:31 Green:206 Blue:203]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Royal Purple" HexCode:@"#7851A9" Red:120 Green:81 Blue:169]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Salmon" HexCode:@"#FF9BAA" Red:255 Green:155 Blue:170]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Scarlet" HexCode:@"#FC2847" Red:252 Green:40 Blue:71]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Screamin' Green" HexCode:@"#76FF7A" Red:118 Green:255 Blue:122]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sea Green" HexCode:@"#9FE2BF" Red:159 Green:226 Blue:191]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sepia" HexCode:@"#A5694F" Red:165 Green:105 Blue:79]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shadow" HexCode:@"#8A795D" Red:138 Green:121 Blue:93]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shamrock" HexCode:@"#45CEA2" Red:69 Green:206 Blue:162]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Shocking Pink" HexCode:@"#FB7EFD" Red:251 Green:126 Blue:253]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Silver" HexCode:@"#CDC5C2" Red:205 Green:197 Blue:194]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sky Blue" HexCode:@"#80DAEB" Red:128 Green:218 Blue:235]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Spring Green" HexCode:@"#ECEABE" Red:236 Green:234 Blue:190]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sunglow" HexCode:@"#FFCF48" Red:255 Green:207 Blue:72]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Sunset Orange" HexCode:@"#FD5E53" Red:253 Green:94 Blue:83]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tan" HexCode:@"#FAA76C" Red:250 Green:167 Blue:108]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Teal Blue" HexCode:@"#18A7B5" Red:24 Green:167 Blue:181]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Thistle" HexCode:@"#EBC7DF" Red:235 Green:199 Blue:223]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tickle Me Pink" HexCode:@"#FC89AC" Red:252 Green:137 Blue:172]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Timberwolf" HexCode:@"#DBD7D2" Red:219 Green:215 Blue:210]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tropical Rain Forest" HexCode:@"#17806D" Red:23 Green:128 Blue:109]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Tumbleweed" HexCode:@"#DEAA88" Red:222 Green:170 Blue:136]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Turquoise Blue" HexCode:@"#77DDE7" Red:119 Green:221 Blue:231]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Unmellow Yellow" HexCode:@"#FFFF66" Red:255 Green:255 Blue:102]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Purple)" HexCode:@"#926EAE" Red:146 Green:110 Blue:174]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Blue" HexCode:@"#324AB2" Red:50 Green:74 Blue:178]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Violet Red" HexCode:@"#F75394" Red:247 Green:83 Blue:148]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Vivid Tangerine" HexCode:@"#FFA089" Red:255 Green:160 Blue:137]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Vivid Violet" HexCode:@"#8F509D" Red:143 Green:80 Blue:157]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"White" HexCode:@"#FFFFFF" Red:255 Green:255 Blue:255]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Blue Yonder" HexCode:@"#A2ADD0" Red:162 Green:173 Blue:208]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Strawberry" HexCode:@"#FF43A4" Red:255 Green:67 Blue:164]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wild Watermelon" HexCode:@"#FC6C85" Red:252 Green:108 Blue:133]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Wisteria" HexCode:@"#CDA4DE" Red:205 Green:164 Blue:222]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow" HexCode:@"#FCE883" Red:252 Green:232 Blue:131]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow Green" HexCode:@"#C5E384" Red:197 Green:227 Blue:132]];
 [tempMutableArray addObject:[[Color alloc] initWithColorName:@"Yellow Orange" HexCode:@"#FFAE42" Red:255 Green:174 Blue:66]];
	*/
//+ (NSColor *) BLUE {	static NSColor*  BLUE = nil;	if( BLUE == nil )
//	BLUE = [NSColor colorWithDeviceRed:0.253 green:0.478 blue:0.761 alpha:1.000];
//	return BLUE;
//}

//+ (NSColor *) ORANGE {	static NSColor*  ORANGE = nil;	if( ORANGE == nil )
//	ORANGE = [NSColor colorWithDeviceRed:0.864 green:0.498 blue:0.191 alpha:1.000];
//	return ORANGE;
//}

//+ (NSColor *) RANDOM {
//	NSColor*  RANDOM = nil;
//	if( RANDOM == nil )
//		}

+ (NSColor *) MAUVE {	static NSColor*  MAUVE = nil;	if( MAUVE == nil )
	MAUVE = [NSColor colorWithDeviceRed:0.712 green:0.570 blue:0.570 alpha:1.000];
	return MAUVE;
}
+ (NSColor *)randomOpaqueColor {	float c[4];
	c[0] = randomComponent();	c[1] = randomComponent();	c[2] = randomComponent();	c[3] = 1.0;
	return [NSColor colorWithCalibratedRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
}
+ (NSColor *)randomColor {
	int red = rand() % 255;	int green = rand() % 255;	int blue = rand() % 255;
	return [NSColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (NSC*)randomLightColor {
	NSC *c = RANDOMCOLOR;
	return [c colorWithBrightnessMultiplier:.9];
}

+ (NSC*)randomBrightColor {
	NSC *c = RANDOMCOLOR;
	while ( !c.isBright ) c = RANDOMCOLOR;
	return c;
}

+ (NSC*)randomDarkColor {
	NSC *c = RANDOMCOLOR;
	while ( !c.isDark ) c = RANDOMCOLOR;
	return c;
}

/*
 NSColor: Instantiate from Web-like Hex RRGGBB string
 Original Source: <http://cocoa.karelia.com/Foundation_Categories/NSColor__Instantiat.m>
 (See copyright notice at <http://cocoa.karelia.com>)	*/

+ (NSColor *) colorFromHexRGB:(NSString *) inColorString {
	NSString *cleansedstring = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	NSColor *result = nil;	unsigned int colorCode = 0;		unsigned char redByte, greenByte, blueByte;
	if (nil != cleansedstring)	{
		NSScanner *scanner = [NSScanner scannerWithString:cleansedstring];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor colorWithCalibratedRed:		(float)redByte	/ 0xff
									   green:	(float)greenByte/ 0xff
										blue:	(float)blueByte	/ 0xff
									   alpha:1.0];
	return result;
}

+ (NSColor *)colorWithDeviceRGB:(NSUInteger)hex; {
	hex &= 0xFFFFFF;
	NSUInteger red   = (hex & 0xFF0000) >> 16;
	NSUInteger green = (hex & 0x00FF00) >>  8;
	NSUInteger blue  =  hex & 0x0000FF;

	return [NSColor colorWithDeviceRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}

+ (NSColor *)colorWithCalibratedRGB:(NSUInteger)hex; {
	hex &= 0xFFFFFF;
	NSUInteger red   = (hex & 0xFF0000) >> 16;
	NSUInteger green = (hex & 0x00FF00) >>  8;
	NSUInteger blue  =  hex & 0x0000FF;
	return [NSColor colorWithCalibratedRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}

+ (NSColor *)colorWithRGB:(NSUInteger)hex; {	return [NSColor colorWithCalibratedRGB:hex]; }

// NSString *hexColor = [color hexColor]

+ (NSColor *) colorWithHex:(NSString *)hexColor {
	// Remove the hash if it exists
	hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
	int length = (int)[hexColor length];
	bool triple = (length == 3);
	NSMutableArray *rgb = [[NSMutableArray alloc] init];
	// Make sure the string is three or six characters long
	if (triple || length == 6) {
		CFIndex i = 0;		UniChar character = 0;		NSString *segment = @"";		CFStringInlineBuffer buffer;
		CFStringInitInlineBuffer((__bridge CFStringRef)hexColor, &buffer, CFRangeMake(0, length));
		while ((character = CFStringGetCharacterFromInlineBuffer(&buffer, i)) != 0 ) {
			if (triple) segment = [segment stringByAppendingFormat:@"%c%c", character, character];
			else segment = [segment stringByAppendingFormat:@"%c", character];
			if ((int)[segment length] == 2) {
				NSScanner *scanner = [[NSScanner alloc] initWithString:segment];
				unsigned number;
				while([scanner scanHexInt:&number]){
					[rgb addObject:@((float)(number / (float)255))];
				}
				segment = @"";
			}
			i++;
		}
		// Pad the array out (for cases where we're given invalid input)
		while ([rgb count] != 3) [rgb addObject:@0.0f];

		return [NSColor colorWithCalibratedRed:[rgb[0] floatValue]   green:[rgb[1] floatValue]	blue:[rgb[2] floatValue]   alpha:1];
	}
	else {
		NSException* invalidHexException = [NSException exceptionWithName:@"InvalidHexException"					   reason:@"Hex color not three or six characters excluding hash"					 userInfo:nil];
		@throw invalidHexException;

	}

}

- (NSString *)crayonName {
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSString *bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListNamed:@"Crayons"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSString *key = nil;
	while ((key = [enumerator nextObject])) {
		NSColor *thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = key; }
	}
	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}
- (NSString *)pantoneName {
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSString *bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSString *key = nil;
	while ((key = [enumerator nextObject])) {
		NSColor *thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = key; }
	}
	//	 [colors localizedS
	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}
- (NSColor*)closestColorListColor {  //gross but works, restore
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;

//	NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];

	NSColorList *safe =  [NSColorList colorListNamed:@"Web Safe Colors"];
//	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];

	NSArray *avail = $array( safe);
	//	NSColorList *bestList = nil;
	NSColor *bestColor = nil;
	//	NSString *bestKey = nil;
	for (NSColorList *list  in avail) {
		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
		NSString *key = nil;
		while ((key = [enumerator nextObject])) {
			NSColor *thatColor = [list colorWithKey:key];
			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat colorDistance =
			fabs([thisColor redComponent] 	- [thatColor redComponent]);
			colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
			colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
			colorDistance = sqrt(colorDistance);
			if (colorDistance < bestDistance) {
				//				bestList = list;
				bestDistance = colorDistance;
				bestColor = thatColor;
				//				bestKey = key;
			}
		}
	}
	return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];

}
//- (NSColor*)closestColorListColor {
//	__block NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//	__block	CGFloat bestDistance = FLT_MAX;
////	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
////	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];

////	NSArray *avail = $array(colors);//, crayons);
////	NSColorList *bestList = nil;
//	__block NSColor *bestColor = nil;
////	__block NSString *bestKey = nil;
////	for (NSColorList *list  in avail) {
////		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
////		NSString *key = nil;
////		while ((key = [enumerator nextObject])) {

//	[[[NSColorList  colorListNamed:@"Web Safe Colors"] allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//			NSColor *thatColor = [[[NSColorList colorListNamed:@"Web Safe Colors"] colorWithKey:obj]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//		if (![thatColor isBoring]) {
////			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//			CGFloat colorDistance =
//				fabs([thisColor redComponent] 	- [thatColor redComponent]);
//			colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
//			colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
//			colorDistance = sqrt(colorDistance);
//			if (colorDistance < bestDistance) {
////				bestList = list;
//				bestDistance = colorDistance;
//				bestColor = thatColor;
////				bestKey = obj;
//			}
//		}
//	}];
////	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
////					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];

//	return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
//}

+ (NSArray *)colorLists {

	return  [NSColorList availableColorLists];
}

+ (NSArray *) colorListsInFramework {
	NSBundle *aBundle = [NSBundle bundleWithIdentifier:@"com.github.mralexgray.AtoZ"];
//										bundleForClass: [AtoZ class]];
	NSArray *lists = [aBundle pathsForResourcesOfType:@"clr" inDirectory:@""];
	return [lists arrayUsingBlock:^id(id obj) {
		NSString *name = [[obj lastPathComponent]stringByDeletingPathExtension];
		return [[NSColorList alloc] initWithName:name fromFile:obj];
	}];
}
+ (NSArray *) colorsInFrameworkListNamed:(NSString*)name {
	NSArray *lists = [NSColor colorListsInFramework];
	NSColorList *theList = [lists filterOne:^BOOL(id object) {
		return [[(NSColorList *)object name] isEqualToString:name] ? YES : NO;
	}];
	return [[theList allKeys]arrayUsingBlock:^id(id obj) {
		return [theList colorWithKey:obj];
	}];
}

+ (NSArray *) fengshui {
	NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]];
	NSString *res = $(@"%@/FengShui.clr",[aBundle resourcePath]);
	__block NSColorList *l = [[NSColorList alloc] initWithName:@"FengShui" fromFile:res];
	NSArray *keys = [l allKeys];
	return [keys arrayUsingBlock:^id(id obj) {
		NSString *i = obj;
		return [l colorWithKey:i];
	}];
}

+ (NSArray *) allSystemColorNames { return [[self class] systemColorNames]; }
+ (NSArray *) systemColorNames {
	return [NSArray arrayWithArrays:[[NSColorList availableColorLists]arrayUsingBlock:^id(id obj) {
		return [obj allKeys];
	}]];
}
+ (NSArray *) allColors { return [[self class] systemColors]; }
+ (NSArray *) allSystemColors { return [[self class] systemColors]; }
+ (NSArray *) systemColors {
	NSArray *contenders = [NSArray arrayWithArrays:[[NSColorList availableColorLists]arrayUsingBlock:^id(NSColorList* obj) {
		return [[obj allKeys] arrayUsingBlock:^id(NSString *key) {
			NSColor*legit = [obj colorWithKey:key];
			return legit ? legit : WHITE;
		}];
	}]];
	return [contenders filter:^BOOL(NSColor *obj) {
		return [obj isBoring] ? NO : YES;
	}];

}
+(NSA*) randomPalette {

		return [NSColor colorsInFrameworkListNamed:[[[NSColor colorListsInFramework]randomElement] valueForKey:@"name"]];
}
//- (NSColor*)closestColorListColor {
//	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//	CGFloat bestDistance = FLT_MAX;
//	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
//	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];

//	NSArray *avail = $array(colors, crayons);
//	//	NSColorList *bestList = nil;
//	NSColor *bestColor = nil;
//	NSString *bestKey = nil;
//	for (NSColorList *list  in avail) {
//		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
//		NSString *key = nil;
//		while ((key = [enumerator nextObject])) {
//			NSColor *thatColor = [list colorWithKey:key];
//			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//			CGFloat colorDistance =
//			fabs([thisColor redComponent] 	- [thatColor redComponent]);
//			colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
//			colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
//			colorDistance = sqrt(colorDistance);
//			if (colorDistance < bestDistance) {
//				//				bestList = list;
//				bestDistance = colorDistance;
//				bestColor = thatColor;
//				bestKey = key; }
//		}
//	}
//	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
//	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];

//	return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
//}

/**- (NSColor*)closestColorListColor {
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;

	NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];

	NSColorList *safe =  [NSColorList colorListNamed:@"Web Safe Colors"];
	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];

	NSArray *avail = $array( safe);
	//	NSColorList *bestList = nil;
	__block float red = [thisColor redComponent];
	__block float green = [thisColor greenComponent];
	__block float blue = [thisColor blueComponent];

	__block NSColor *bestColor = nil;
	__block CGFloat colorDistance;
	////	NSString *bestKey = nil;
	//	for (NSColorList *list  in avail) {
	//		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
	//		NSString *key = nil;
	//		while ((key = [enumerator nextObject])) {

	
	 [avail eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
	 [[obj allKeys]filterOne:^BOOL(id object) {
	 NSColor *thatColor = [[obj colorWithKey:object]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	 CGFloat colorDistance = sqrt(		fabs( red	- [thatColor redComponent]) + fabs(blue - [thatColor blueComponent])
	 + fabs(green	- [thatColor greenComponent]) );
	 if (colorDistance < bestDistance)
	 if (colorDistance < .04)
	 return YES;   //bestList = list;
	 else {
	 bestDistance = colorDistance;
	 bestColor = thatColor;
	 return  NO;
	 }
	 //				return bestColor				//				bestKey = key;
	 }return NO;
	 }
	 }
	 //, @"color", bestKey, @"key", bestList, @"list");
	 //	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	 //					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
}
*/

- (NSColor *)closestWebColor {
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	NSColor *bestColorKey = nil;
	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
	NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
	NSString *key = nil;
	while ((key = [enumerator nextObject])) {
		NSColor *thatColor = [colors colorWithKey:key];
		thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		CGFloat colorDistance = fabs([thisColor redComponent] 	- [thatColor redComponent]);
		colorDistance += fabs([thisColor blueComponent] 			- [thatColor blueComponent]);
		colorDistance += fabs([thisColor greenComponent]			- [thatColor greenComponent]);
		colorDistance = sqrt(colorDistance);
		if (colorDistance < bestDistance) {	bestDistance = colorDistance; bestColorKey = thatColor; }
	}
	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];
	return bestColorKey;
}

+ (NSColor *)crayonColorNamed:(NSString *)key
{
	return [[NSColorList colorListNamed:@"Crayons"] colorWithKey:key];
}
+ (NSColor *)colorWithName:(NSString *)colorName {
	// name lookup
	NSString *lcc = colorName.lowercaseString;
	NSColorList *list = [AZNamedColors namedColors];
	for (NSString *key in [list allKeys]) {
		if ([key.lowercaseString isEqual:lcc]) {
			return [list colorWithKey:key];
		}
	}

	for (list in [NSColorList availableColorLists]) {
		for (NSString *key in [list allKeys ]) {
			if ([key.lowercaseString isEqual:lcc]) {
				return [list colorWithKey:key];
			}
		}
	}

	return nil;
}

+ (NSColor *)colorFromString:(NSString *)string {
	if ([string hasPrefix:@"#"]) {
		return [NSColor colorFromHexString:string];
	}

	// shifting operations
	NSRange shiftRange = [string rangeOfAny:@"<! <= << <> >> => !>".wordSet];
	if (shiftRange.location != NSNotFound) {
		CGFloat p = 0.5;
		// determine the first of the operations
		NSString *op = [string substringWithRange:shiftRange];
		if ([op isEqual:@"<>"]) {
			// this will stay 50/50
		} else if ([op isEqual:@"<!"]) {
			p = 0.95;
		} else if ([op isEqual:@"<="]) {
			p = 0.85;
		} else if ([op isEqual:@"<<"]) {
			p = 0.66;
		} else if ([op isEqual:@">>"]) {
			p = 0.33;
		} else if ([op isEqual:@"=>"]) {
			p = 0.15;
		} else if ([op isEqual:@"!>"]) {
			p = 0.05;
		}

		// shift operators
		NSString *head = [string substringToIndex:
						  shiftRange.location];
		NSString *tail = [string substringFromIndex:
						  shiftRange.location + shiftRange.length];

		NSColor *first = head.trim.colorValue;
		NSColor *second = tail.trim.colorValue;

		if (first != nil && second != nil) {
			return [first blendedColorWithFraction:p ofColor:second];
		}
		if (first != nil) {
			return first;
		}
		return second;
	}

	if ([string contains:@" "]) {
		//		NSString *head = nil, *tail = nil;
		//		list(&head, &tail) = string.decapitate;
		NSArray  *comps = string.decapitate;
		NSString *head = comps[0];
		NSString *tail = comps[1];

		//[[string stringByTrimmingCharactersInSet:
		//								   [NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString];

		NSColor *tailColor = [NSColor colorFromString:tail];

		if (tailColor) {
			if ([head isEqualToString:@"translucent"]) {
				return tailColor.translucent;
			} else if ([head isEqualToString:@"watermark"]) {
				return tailColor.watermark;
			} else if ([head isEqualToString:@"bright"]) {
				return tailColor.bright;
			} else if ([head isEqualToString:@"brighter"]) {
				return tailColor.brighter;
			} else if ([head isEqualToString:@"dark"]) {
				return tailColor.dark;
			} else if ([head isEqualToString:@"darker"]) {
				return tailColor.darker;
			} else if ([head hasSuffix:@"%"]) {
				return [tailColor colorWithAlphaComponent:head.popped.floatValue / 100.0];
			}
		}
	}

	if ([string contains:@","]) {
		NSString *comp = string;
		NSString *func = @"rgb";

		if ([string contains:@"("] && [string hasSuffix:@")"]) {
			comp = [string substringBetweenPrefix:@"(" andSuffix:@")"];
			func = [[string substringBefore:@"("] lowercaseString];
		}

		NSArray *vals = [comp componentsSeparatedByString:@","];
		CGFloat values[5];
		for (int i = 0; i < 5; i++) {
			values[i] = 1.0;
		}

		for (int i = 0; i < vals.count; i++) {
			NSString *v = [vals[i] trim];
			if ([v hasSuffix:@"%"]) {
				values[i] = [[v substringBefore:@"%"] floatValue] / 100.0;
			} else {
				// should be a float
				values[i] = v.floatValue;
				if (values[i] > 1) {
					values[i] /= 255.0;
				}
			}
			values[i] = MIN(MAX(values[i], 0), 1);
		}

		if (vals.count <= 2) {
			// grayscale + alpha
			return [NSColor colorWithDeviceWhite:values[0]
										   alpha:values[1]
					];
		} else if (vals.count <= 5) {
			// rgba || hsba
			if ([func hasPrefix:@"rgb"]) {
				return [NSColor colorWithDeviceRed:values[0]
											 green:values[1]
											  blue:values[2]
											 alpha:values[3]
						];
			} else if ([func hasPrefix:@"hsb"]) {
				return [NSColor colorWithDeviceHue:values[0]
										saturation:values[1]
										brightness:values[2]
											 alpha:values[3]
						];
			} else if ([func hasPrefix:@"cmyk"]) {
				return [NSColor colorWithDeviceCyan:values[0]
											magenta:values[1]
											 yellow:values[2]
											  black:values[3]
											  alpha:values[4]
						];
			} else {
				NSLog(@"Unrecognized Prefix <%@> returning nil", func);
			}
		}
	}

	return [NSColor colorWithName:string];
}

+ (NSColor *)colorFromHexString:(NSString *)hexString
{
	BOOL useHSB = NO;
	BOOL useCalibrated = NO;

	if (hexString.length == 0) {
		return NSColor.blackColor;
	}

	hexString = hexString.trim.uppercaseString;

	if ([hexString hasPrefix:@"#"]) {
		hexString = hexString.shifted;
	}

	if ([hexString hasPrefix:@"!"]) {
		useCalibrated = YES;
		hexString = hexString.shifted;
	}

	if ([hexString hasPrefix:@"*"]) {
		useHSB = YES;
		hexString = hexString.shifted;
	}

	int mul = 1;
	int max = 3;
	CGFloat v[4];

	// full opacity by default
	v[3] = 1.0;

	if (hexString.length == 8 || hexString.length == 4) {
		max++;
	}

	if (hexString.length == 6 || hexString.length == 8) {
		// #RRGGBB || #RRGGBBAA
		mul = 2;
	} else if (hexString.length == 3 || hexString.length == 4) {
		// #RGB || #RGBA
		mul = 1;
	} else {
		return nil;
	}

	for (int i = 0; i < max; i++) {
		NSString *sub = [hexString substringWithRange:NSMakeRange(i * mul, mul)];
		NSScanner *scanner = [NSScanner scannerWithString:sub];
		uint value = 0;
		[scanner scanHexInt: &value];
		v[i] = (float) value / (float) 0xFF;
	}

	// only at full color

	if (useHSB) {
		if (useCalibrated) {
			return [NSColor colorWithCalibratedHue:v[0]
										saturation:v[1]
										brightness:v[2]
											 alpha:v[3]
					];

		}

		return [NSColor colorWithDeviceHue:v[0]
								saturation:v[1]
								brightness:v[2]
									 alpha:v[3]
				];
	}

	if (useCalibrated) {
		return [NSColor colorWithCalibratedRed:v[0]
										 green:v[1]
										  blue:v[2]
										 alpha:v[3]
				];
	}

	return [NSColor colorWithDeviceRed:v[0]
								 green:v[1]
								  blue:v[2]
								 alpha:v[3]
			];
}

- (NSColor *)deviceRGBColor {
	return [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
}

- (NSColor *)calibratedRGBColor {
	return [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (NSString *)toHex
{
	CGFloat r,g,b,a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];

	int ri = r * 0xFF;
	int gi = g * 0xFF;
	int bi = b * 0xFF;

	return [[NSString stringWithFormat:@"%02x%02x%02x", ri, gi, bi] uppercaseString];
}
- (NSColor *)closestNamedColor {

	NSColor *color = [self closestColorListColor];
	//	 objectForKey:@"name"];// valueForKey:@"name"];
	return color;
}

- (NSString*)nameOfColor{

	//	NSColor *color = [self closestColorListColor];
	NSColor *thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat bestDistance = FLT_MAX;
	//	NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
	NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];

	NSArray *avail = $array(crayons);
	//	NSColorList *bestList = nil;
	NSColor *bestColor = nil;
	NSString *bestKey = nil;
	for (NSColorList *list  in avail) {
		NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
		NSString *key = nil;
		while ((key = [enumerator nextObject])) {
			NSColor *thatColor = [list colorWithKey:key];
			thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			CGFloat colorDistance =
			fabs([thisColor redComponent] 	- [thatColor redComponent]);
			colorDistance += fabs([thisColor blueComponent] 	- [thatColor blueComponent]);
			colorDistance += fabs([thisColor greenComponent]	- [thatColor greenComponent]);
			colorDistance = sqrt(colorDistance);
			if (colorDistance < bestDistance) {
				//				bestList = list;
				bestDistance = colorDistance;
//				bestColor = thatColor;
				bestKey = key; }
		}
	}
	//	bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
	//					localizedStringForKey:bestColorKey	value:bestColorKey 	table:@"Crayons"];

	return bestKey;//, @"color", bestKey, @"key", bestList, @"list");

}

// Convenienct Methods to mess a little with the color values
- (CGFloat)luminance {
	CGFloat r, g, b, a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	// 0.3086 + 0.6094 + 0.0820 = 1.0
	return (0.3086f*r) + (0.6094f*g) + (0.0820f*b);
}

- (CGFloat)relativeBrightness {
	CGFloat r, g, b, a;
	[[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
	return sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
}

- (BOOL)isBright {
	return self.relativeBrightness > 0.57;
}

- (NSColor *)bright {
	return [NSColor colorWithDeviceHue:self.hueComponent
							saturation:0.3
							brightness:1.0
								 alpha:self.alphaComponent];
}

- (NSColor *)brighter {
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSColor colorWithDeviceHue:h
							saturation:s
							brightness:MIN(1.0, MAX(b * 1.10, b + 0.05))
								 alpha:a];
}

- (NSColor *)darker {
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSColor colorWithDeviceHue:h
							saturation:s
							brightness:MAX(0.0, MIN(b * 0.9, b - 0.05))
								 alpha:a];
}

- (NSColor *)muchDarker {
	CGFloat h,s,b,a;
	[[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
	return [NSColor colorWithDeviceHue:h
							saturation:s
							brightness:MAX(0.0, MIN(b * 0.7, b - 0.1))
								 alpha:a];
}

- (BOOL)isDark {
	return self.relativeBrightness < 0.42;
}

- (NSColor *)dark {
	return [NSColor colorWithDeviceHue:self.hueComponent
							saturation:0.8
							brightness:0.3
								 alpha:self.alphaComponent];
}
- (NSColor *)redshift {
	CGFloat h,s,b,a;
	[self.deviceRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
	h += h > 0.5 ? 0.1 : -0.1;
	if (h < 1) {
		h++;
	} else if (h > 1) {
		h--;
	}
	return [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a];

}

- (NSColor *)blueshift {
	CGFloat c = self.hueComponent;
	c += c < 0.5 ? 0.1 : -0.1;
	return [NSColor colorWithDeviceHue:c
							saturation:self.saturationComponent
							brightness:self.brightnessComponent
								 alpha:self.alphaComponent];
}

- (NSColor *)blend:(NSColor *)other {
	return [self blendedColorWithFraction:0.5 ofColor:other];
}

- (NSColor *)whitened {
	return [self blend:NSColor.whiteColor];
}

- (NSColor *)blackened {
	return [self blend:NSColor.blackColor];
}

- (NSColor *)contrastingForegroundColor {
	NSColor *c = self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create contrastingForegroundColor for color %@", self);
		return NSColor.blackColor;
	}
	if (!c.isBright) {
		return NSColor.whiteColor;
	}
	return NSColor.blackColor;
}

- (NSColor *)complement {
	NSColor *c = self.colorSpaceName == NSPatternColorSpace ? [self.patternImage quantize][0] : self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create complement for color %@", self);
		return self;
	}

	CGFloat h,s,b,a;
	[c getHue:&h saturation:&s brightness:&b alpha:&a];
	h += 0.5;
	if (h > 1) {
		h -= 1.0;
	}
	NSC *newish = 	[NSColor colorWithDeviceHue:h saturation:s	brightness:b alpha:a];
	return self.colorSpaceName == NSPatternColorSpace ? [NSColor colorWithPatternImage:[self.patternImage tintedWithColor:newish]]: newish;
}

- (NSColor *)rgbComplement {
	NSColor *c = self.calibratedRGBColor;
	if (!c) {
		NSLog(@"Cannot create complement for color %@", self);
		return self;
	}

	CGFloat r,g,b,a;
	[c getRed:&r green:&g blue:&b alpha:&a];
	return [NSColor colorWithDeviceRed:1.0 - r
								 green:1.0 - g
								  blue:1.0 - b
								 alpha:a];
}
// convenience for alpha shifting
- (NSColor *)opaque {
	return [self colorWithAlphaComponent:1.0];
}

- (NSColor *)lessOpaque {
	return [self colorWithAlphaComponent:MAX(0.0, self.alphaComponent * 0.8)];
}

- (NSColor *)moreOpaque {
	return [self colorWithAlphaComponent:MIN(1.0, self.alphaComponent / 0.8)];
}

- (NSColor *)translucent {
	return [self colorWithAlphaComponent:0.65];
}

- (NSColor *)watermark {
	return [self colorWithAlphaComponent:0.25];
}
// comparison methods

-(NSColor *)rgbDistanceToColor:(NSColor *)color {
	if (!color) {
		return nil;
	}

	CGFloat mr,mg,mb,ma, or,og,ob,oa;
	[self.calibratedRGBColor  getRed:&mr green:&mg blue:&mb alpha:&ma];
	[color.calibratedRGBColor getRed:&or green:&og blue:&ob alpha:&oa];

	return [NSColor colorWithCalibratedRed:ABS(mr - or)
									 green:ABS(mg - og)
									  blue:ABS(mb - ob)
									 alpha:ABS(ma - oa)
			];
}

-(NSColor *)hsbDistanceToColor:(NSColor *)color {
	CGFloat mh,ms,mb,ma, oh,os,ob,oa;
	[self.calibratedRGBColor  getHue:&mh saturation:&ms brightness:&mb alpha:&ma];
	[color.calibratedRGBColor getHue:&oh saturation:&os brightness:&ob alpha:&oa];

	// as the hue is circular 0.0 lies next to 1.0
	// and thus 0.5 is the most far away from both
	// distance values exceeding 0.5 will result in a fewer real distance
	CGFloat hd = ABS(mh - oh);
	if (hd > 0.5) {
		hd = 1 - hd;
	}

	return [NSColor colorWithCalibratedHue:hd
								saturation:ABS(ms - os)
								brightness:ABS(mb - ob)
									 alpha:ABS(ma - oa)
			];
}

-(CGFloat)rgbWeight {
	CGFloat r,g,b,a;
	[self.calibratedRGBColor getRed:&r green:&g blue:&b alpha:&a];

	return (r + g + b) / 3.0;
}

-(CGFloat)hsbWeight {
	CGFloat h,s,b,a;
	[self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];

	return (h + s + b) / 3.0;
}

-(BOOL)isBlueish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return b - MAX(r,g) > 0.2;
}

-(BOOL)isRedish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return r - MAX(b,g) > 0.2;
}

-(BOOL)isGreenish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return g - MAX(r,b) > 0.2;
}

-(BOOL)isYellowish {
	CGFloat r,g,b,a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return ABS(r - g) < 0.1 && MIN(r,g) - b > 0.2;
}

@end

@implementation NSCoder (AGCoder)
+(void)encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSString*)theKey {
	if(theColor != nil)	{
		const CGFloat* components = CGColorGetComponents(theColor);
		[encoder encodeFloat:components[0] forKey:[NSString stringWithFormat:@"%@.red", theKey]];
		[encoder encodeFloat:components[1] forKey:[NSString stringWithFormat:@"%@.green", theKey]];
		[encoder encodeFloat:components[2] forKey:[NSString stringWithFormat:@"%@.blue", theKey]];
		[encoder encodeFloat:components[3] forKey:[NSString stringWithFormat:@"%@.alpha", theKey]];
	}	else	{		// Encode nil as NSNull
		[encoder encodeObject:[NSNull null] forKey:theKey];
	}
}

@end
#import <string.h>

static NSArray *defaultValidColors = nil;
#define VALID_COLORS_ARRAY [[NSArray alloc] initWithObjects:@"aqua", @"aquamarine", @"blue", @"blueviolet", @"brown", @"burlywood", @"cadetblue", @"chartreuse", @"chocolate", @"coral", @"cornflowerblue", @"crimson", @"cyan", @"darkblue", @"darkcyan", @"darkgoldenrod", @"darkgreen", @"darkgrey", @"darkkhaki", @"darkmagenta", @"darkolivegreen", @"darkorange", @"darkorchid", @"darkred", @"darksalmon", @"darkseagreen", @"darkslateblue", @"darkslategrey", @"darkturquoise", @"darkviolet", @"deeppink", @"deepskyblue", @"dimgrey", @"dodgerblue", @"firebrick", @"forestgreen", @"fuchsia", @"gold", @"goldenrod", @"green", @"greenyellow", @"grey", @"hotpink", @"indianred", @"indigo", @"lawngreen", @"lightblue", @"lightcoral", @"lightgreen", @"lightgrey", @"lightpink", @"lightsalmon", @"lightseagreen", @"lightskyblue", @"lightslategrey", @"lightsteelblue", @"lime", @"limegreen", @"magenta", @"maroon", @"mediumaquamarine", @"mediumblue", @"mediumorchid", @"mediumpurple", @"mediumseagreen", @"mediumslateblue", @"mediumspringgreen", @"mediumturquoise", @"mediumvioletred", @"midnightblue", @"navy", @"olive", @"olivedrab", @"orange", @"orangered", @"orchid", @"palegreen", @"paleturquoise", @"palevioletred", @"peru", @"pink", @"plum", @"powderblue", @"purple", @"red", @"rosybrown", @"royalblue", @"saddlebrown", @"salmon", @"sandybrown", @"seagreen", @"sienna", @"silver", @"skyblue", @"slateblue", @"slategrey", @"springgreen", @"steelblue", @"tan", @"teal", @"thistle", @"tomato", @"turquoise", @"violet", @"yellowgreen", nil]

static const CGFloat ONE_THIRD = 1.0f/3.0f;
static const CGFloat ONE_SIXTH = 1.0f/6.0f;
static const CGFloat TWO_THIRD = 2.0f/3.0f;

static NSMutableDictionary *RGBColorValues = nil;

//two parts of a single path:
//	defaultRGBTxtLocation1/VERSION/defaultRGBTxtLocation2
//static NSString *defaultRGBTxtLocation1 = @"/usr/share/emacs";
//static NSString *defaultRGBTxtLocation2 = @"etc/rgb.txt";

//#ifdef DEBUG_BUILD
//#define COLOR_DEBUG TRUE
//#else
//#define COLOR_DEBUG FALSE
//#endif

//@implementation NSDictionary (AIColorAdditions_RGBTxtFiles)

//see /usr/share/emacs/(some version)/etc/rgb.txt for an example of such a file.
//the pathname does not need to end in 'rgb.txt', but it must be a file in UTF-8 encoding.
//the keys are colour names (all converted to lowercase); the values are RGB NSColors.
/**+ (id)dictionaryWithContentsOfRGBTxtFile:(NSString *)path
 {
 NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
 if (!data) return nil;

 char *ch = [data mutableBytes]; //we use mutable bytes because we want to tokenise the string by replacing separators with '\0'.
 NSUInteger length = [data length];
 struct {
 const char *redStart, *greenStart, *blueStart, *nameStart;
 const char *redEnd,   *greenEnd,   *blueEnd;
 float red, green, blue;
 unsigned reserved: 23;
 unsigned inComment: 1;
 char prevChar;
 } state = {
 .prevChar = '\n',
 .redStart = NULL, .greenStart = NULL, .blueStart = NULL, .nameStart = NULL,
 .inComment = NO,
 };

 NSDictionary *result = nil;

 //the rgb.txt file that comes with Mac OS X 10.3.8 contains 752 entries.
 //we create 3 autoreleased objects for each one.
 //best to not pollute our caller's autorelease pool.

 NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];

 for (unsigned i = 0; i < length; ++i) {
 if (state.inComment) {
 if (ch[i] == '\n') state.inComment = NO;
 } else if (ch[i] == '\n') {
 if (state.prevChar != '\n') { //ignore blank lines
 if (	! ((state.redStart   != NULL)
 && (state.greenStart != NULL)
 && (state.blueStart  != NULL)
 && (state.nameStart  != NULL)))
 {
 #if COLOR_DEBUG
 NSLog(@"Parse error reading rgb.txt file: a non-comment line was encountered that did not have all four of red (%p), green (%p), blue (%p), and name (%p) - index is %u",
 state.redStart,
 state.greenStart,
 state.blueStart,
 state.nameStart, i);
 #endif
 goto end;
 }

 NSRange range = {
 .location = state.nameStart - ch,
 .length   = (&ch[i]) - state.nameStart,
 };
 NSString *name = [NSString stringWithData:[data subdataWithRange:range] encoding:NSUTF8StringEncoding];
 NSColor *color = [NSColor colorWithCalibratedRed:state.red
 green:state.green
 blue:state.blue
 alpha:1.0f];
 [mutableDict setObject:color forKey:name];
 NSString *lowercaseName = [name lowercaseString];
 if (![mutableDict objectForKey:lowercaseName]) {
 //only add the lowercase version if it isn't already defined
 [mutableDict setObject:color forKey:lowercaseName];
 }

 state.redStart = state.greenStart = state.blueStart = state.nameStart =
 state.redEnd   = state.greenEnd   = state.blueEnd   = NULL;
 } //if (prevChar != '\n')
 } else if ((ch[i] != ' ') && (ch[i] != '\t')) {
 if (state.prevChar == '\n' && ch[i] == '#') {
 state.inComment = YES;
 } else {
 if (!state.redStart) {
 state.redStart = &ch[i];
 state.red = (float)(strtod(state.redStart, (char **)&state.redEnd) / 255.0f);
 } else if ((!state.greenStart) && state.redEnd && (&ch[i] >= state.redEnd)) {
 state.greenStart = &ch[i];
 state.green = (float)(strtod(state.greenStart, (char **)&state.greenEnd) / 255.0f);
 } else if ((!state.blueStart) && state.greenEnd && (&ch[i] >= state.greenEnd)) {
 state.blueStart = &ch[i];
 state.blue = (float)(strtod(state.blueStart, (char **)&state.blueEnd) / 255.0f);
 } else if ((!state.nameStart) && state.blueEnd && (&ch[i] >= state.blueEnd)) {
 state.nameStart  = &ch[i];
 }
 }
 }
 state.prevChar = ch[i];
 } //for (unsigned i = 0; i < length; ++i)

 //why not use -copy? because this is subclass-friendly.
 //you can call this method on NSMutableDictionary and get a mutable dictionary back.
 result = [[self alloc] initWithDictionary:mutableDict];
 end:

 return result;
 }	*/
//@end

//@implementation NSColor (AIColorAdditions_RGBTxtFiles)
/*
 + (NSDictionary *)colorNamesDictionary
 {
 if (!RGBColorValues) {
 RGBColorValues = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
 [NSColor colorWithHTMLString:@"#000"],	@"black",
 [NSColor colorWithHTMLString:@"#c0c0c0"], @"silver",
 [NSColor colorWithHTMLString:@"#808080"], @"gray",
 [NSColor colorWithHTMLString:@"#808080"], @"grey",
 [NSColor colorWithHTMLString:@"#fff"],	@"white",
 [NSColor colorWithHTMLString:@"#800000"], @"maroon",
 [NSColor colorWithHTMLString:@"#f00"],	@"red",
 [NSColor colorWithHTMLString:@"#800080"], @"purple",
 [NSColor colorWithHTMLString:@"#f0f"],	@"fuchsia",
 [NSColor colorWithHTMLString:@"#008000"], @"green",
 [NSColor colorWithHTMLString:@"#0f0"],	@"lime",
 [NSColor colorWithHTMLString:@"#808000"], @"olive",
 [NSColor colorWithHTMLString:@"#ff0"],	@"yellow",
 [NSColor colorWithHTMLString:@"#000080"], @"navy",
 [NSColor colorWithHTMLString:@"#00f"],	@"blue",
 [NSColor colorWithHTMLString:@"#008080"], @"teal",
 [NSColor colorWithHTMLString:@"#0ff"],	@"aqua",
 nil];
 NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:defaultRGBTxtLocation1 error:NULL];
 for (NSString *middlePath in paths) {
 NSString *path = [defaultRGBTxtLocation1 stringByAppendingPathComponent:[middlePath stringByAppendingPathComponent:defaultRGBTxtLocation2]];
 NSDictionary *extraColors = [NSDictionary dictionaryWithContentsOfRGBTxtFile:path];
 [RGBColorValues addEntriesFromDictionary:extraColors];
 if (extraColors) {
 #if COLOR_DEBUG
 NSLog(@"Got colour values from %@", path);
 #endif
 break;
 }
 }
 }
 return RGBColorValues;
 }*/
//@end

@implementation NSColor (AIColorAdditions_Comparison)

//Returns YES if the colors are equal
- (BOOL)equalToRGBColor:(NSColor *)inColor
{
	NSColor	*convertedA = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	NSColor	*convertedB = [inColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

	return (([convertedA redComponent]   == [convertedB redComponent])   &&
			([convertedA blueComponent]  == [convertedB blueComponent])  &&
			([convertedA greenComponent] == [convertedB greenComponent]) &&
			([convertedA alphaComponent] == [convertedB alphaComponent]));
}

@end

@implementation NSColor (AIColorAdditions_DarknessAndContrast)

//Returns YES if this color is dark
- (BOOL)colorIsDark
{
	return ([[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent] < 0.5f);
}

- (BOOL)colorIsMedium
{
	CGFloat brightness = [[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent];
	return (0.35f < brightness && brightness < 0.65f);
}

//Percent should be -1.0 to 1.0 (negatives will make the color brighter)
- (NSColor *)darkenBy:(CGFloat)amount
{
	NSColor	*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

	return [NSColor colorWithCalibratedHue:[convertedColor hueComponent]
								saturation:[convertedColor saturationComponent]
								brightness:([convertedColor brightnessComponent] - amount)
									 alpha:[convertedColor alphaComponent]];
}

- (NSColor *)darkenAndAdjustSaturationBy:(CGFloat)amount
{
	NSColor	*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

	return [NSColor colorWithCalibratedHue:[convertedColor hueComponent]
								saturation:(([convertedColor saturationComponent] == 0.0f) ? [convertedColor saturationComponent] : ([convertedColor saturationComponent] + amount))
								brightness:([convertedColor brightnessComponent] - amount)
									 alpha:[convertedColor alphaComponent]];
}

//Inverts the luminance of this color so it looks good on selected/dark backgrounds
- (NSColor *)colorWithInvertedLuminance
{
	CGFloat h,l,s;

	NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

	//Get our HLS
	[convertedColor getHue:&h saturation:&s brightness:&l alpha:NULL];

	//Invert L
	l = 1.0f - l;

	//Return the new color
	return [NSColor colorWithCalibratedHue:h saturation:s brightness:l alpha:1.0f];
}

//Returns a color that contrasts well with this one
- (NSColor *)contrastingColor
{
	if ([self colorIsMedium]) {
		if ([self colorIsDark])
			return [NSColor whiteColor];
		else
			return [NSColor blackColor];

	} else {
		NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		return [NSColor colorWithCalibratedRed:(1.0f - [rgbColor redComponent])
										 green:(1.0f - [rgbColor greenComponent])
										  blue:(1.0f - [rgbColor blueComponent])
										 alpha:1.0f];
	}
}

@end

@implementation NSColor (AIColorAdditions_HLS)

//Linearly adjust a color
#define cap(x) { if (x < 0) {x = 0;} else if (x > 1) {x = 1;} }

- (NSColor *)adjustHue:(CGFloat)dHue saturation:(CGFloat)dSat brightness:(CGFloat)dBrit
{
	CGFloat hue, sat, brit, alpha;

	[self getHue:&hue saturation:&sat brightness:&brit alpha:&alpha];

	//For some reason, redColor's hue is 1.0f, not 0.0f, as of Mac OS X 10.4.10 and 10.5.2. Therefore, we must normalize any multiple of 1.0 to 0.0. We do this by taking the remainder of hue ÷ 1.
	hue = AIfmod(hue, 1.0f);

	hue += dHue;
	cap(hue);
	sat += dSat;
	cap(sat);
	brit += dBrit;
	cap(brit);

	return [NSColor colorWithCalibratedHue:hue saturation:sat brightness:brit alpha:alpha];
}

@end

@implementation NSColor (AIColorAdditions_RepresentingColors)

- (NSString *)hexString
{
	CGFloat 	red,green,blue;
	char	hexString[7];
	NSInteger		tempNum;
	NSColor	*convertedColor;

	convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[convertedColor getRed:&red green:&green blue:&blue alpha:NULL];

	tempNum = (red * 255.0f);
	hexString[0] = intToHex(tempNum / 16);
	hexString[1] = intToHex(tempNum % 16);

	tempNum = (green * 255.0f);
	hexString[2] = intToHex(tempNum / 16);
	hexString[3] = intToHex(tempNum % 16);

	tempNum = (blue * 255.0f);
	hexString[4] = intToHex(tempNum / 16);
	hexString[5] = intToHex(tempNum % 16);
	hexString[6] = '\0';

	return @(hexString);
}

//String representation: R,G,B[,A].
- (NSString *)stringRepresentation
{
	NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat alphaComponent = [tempColor alphaComponent];

	if (alphaComponent == 1.0) {
		return [NSString stringWithFormat:@"%d,%d,%d",
				(int)([tempColor redComponent] * 255.0),
				(int)([tempColor greenComponent] * 255.0),
				(int)([tempColor blueComponent] * 255.0)];

	} else {
		return [NSString stringWithFormat:@"%d,%d,%d,%d",
				(int)([tempColor redComponent] * 255.0),
				(int)([tempColor greenComponent] * 255.0),
				(int)([tempColor blueComponent] * 255.0),
				(int)(alphaComponent * 255.0)];
	}
}

//- (NSString *)CSSRepresentation
//{
//	CGFloat alpha = [self alphaComponent];
//	if ((1.0 - alpha) >= 0.000001) {
//		NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//		//CSS3 defines rgba() to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
//		return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
//			[NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:alpha						 maxDigits:6]];
//	} else {
//		return [@"#" stringByAppendingString:[self hexString]];
//	}
//}

@end

@implementation NSString (AIColorAdditions_RepresentingColors)

- (NSColor *)representedColor
{
	CGFloat	r = 255, g = 255, b = 255;
	CGFloat	a = 255;

	const char *selfUTF8 = [self UTF8String];

	//format: r,g,b[,a]
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8)) goto scanFailed;
	r = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);

	if(*selfUTF8 == ',') ++selfUTF8;
	else				 goto scanFailed;

	if (!isdigit(*selfUTF8)) goto scanFailed;
	g = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if(*selfUTF8 == ',') ++selfUTF8;
	else				 goto scanFailed;

	if (!isdigit(*selfUTF8)) goto scanFailed;
	b = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
	if (*selfUTF8 == ',') {
		++selfUTF8;
		a = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);

		if (*selfUTF8) goto scanFailed;
	} else if (*selfUTF8 != '\0') {
		goto scanFailed;
	}

	return [NSColor colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:(a/255)] ;
scanFailed:
	return nil;
}

- (NSColor *)representedColorWithAlpha:(CGFloat)alpha
{
	//this is the same as above, but the alpha component is overridden.

	NSUInteger	r, g, b;

	const char *selfUTF8 = [self UTF8String];

	//format: r,g,b
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8)) goto scanFailed;
	r = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);

	if (*selfUTF8 != ',') goto scanFailed;
	++selfUTF8;

	if (!isdigit(*selfUTF8)) goto scanFailed;
	g = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);

	if (*selfUTF8 != ',') goto scanFailed;
	++selfUTF8;

	if (!isdigit(*selfUTF8)) goto scanFailed;
	b = strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);

	return [NSColor colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:alpha];
scanFailed:
	return nil;
}

@end

@implementation NSColor (AIColorAdditions_RandomColor)

+ (NSColor *)randomColor
{
	return [NSColor colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
									 green:(arc4random() % 65536) / 65536.0f
									  blue:(arc4random() % 65536) / 65536.0f
									 alpha:1.0f];
}
+ (NSColor *)randomColorWithAlpha
{
	return [NSColor colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
									 green:(arc4random() % 65536) / 65536.0f
									  blue:(arc4random() % 65536) / 65536.0f
									 alpha:(arc4random() % 65536) / 65536.0f];
}

@end


//
//  NSColor+CSSRGB.m
//  SPColorWell
//
//  Created by Philip Dow on 11/16/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

/*

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this list
 of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or other
 materials provided with the distribution.

 * Neither the name of the author nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior
 written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 DAMAGE.
	*/

/*
 For non-attribution licensing options refer to http://phildow.net/licensing/	*/


@implementation NSColor (NSColor_CSSRGB)

+ (NSColor*) colorWithCSSRGB:(NSString*)rgbString
{
	static NSCharacterSet *open  = nil;  open = open  ?: [NSCharacterSet characterSetWithCharactersInString:@"("];//retain];
	static NSCharacterSet *close = nil; close = close ?: [NSCharacterSet characterSetWithCharactersInString:@")"];//retain];

	NSI iBegin 		= [rgbString rangeOfCharacterFromSet:open].location;
	NSI iClose 		= [rgbString rangeOfCharacterFromSet:close].location;
	if ( iBegin == NSNotFound || iClose == NSNotFound )  return nil;
	NSS *rgbSub 	= [rgbString substringWithRange:NSMakeRange(iBegin+1,iClose-(iBegin+1))];
	NSA *components = [rgbSub 	 componentsSeparatedByString:@","];
	if ( [components count] != 3 )  return nil;

	NSA* componentValues = [components cw_mapArray:^id(NSS* aComponent) {
		NSString *cleanedComponent = [aComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		return [cleanedComponent length] == 0 ? nil : @([cleanedComponent floatValue]);
	}];
	return  [componentValues count] != 3 ? nil : [NSC colorWithCalibratedRed: [componentValues[0]fV] / 255.
																	   green: [componentValues[1]fV] / 255.
																		blue: [componentValues[2]fV] / 255. alpha:1];
}

@end

@implementation NSColor (NSColor_ColorspaceEquality)

- (BOOL) isEqualToColor:(NSC*)inColor colorSpace:(NSS*)inColorSpace
{
	return  [self colorUsingColorSpaceName:inColorSpace] &&	  [inColor colorUsingColorSpaceName:inColorSpace]
		&& [[self colorUsingColorSpaceName:inColorSpace] isEqual:[inColor colorUsingColorSpaceName:inColorSpace]];
}

@end

//@implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)

//+ (id)colorWithHTMLString:(NSString *)str
//{
//	return [self colorWithHTMLString:str defaultColor:nil];
//}

/*!
 * @brief Convert one or two hex characters to a float
 *
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.	*/

 /*
static CGFloat hexCharsToFloat(char firstChar, char secondChar)
{
	CGFloat				hexValue;
	NSUInteger		firstDigit;
	firstDigit = hexToInt(firstChar);
	if (firstDigit != -1) {
		hexValue = firstDigit;
		if (secondChar != 0x0) {
			int secondDigit = hexToInt(secondChar);
			if (secondDigit != -1)
				hexValue = (hexValue * 16.0f + secondDigit) / 255.0f;
			else
				hexValue = 0;
		} else {
			hexValue /= 15.0f;
		}

	} else {
		hexValue = 0;
	}

	return hexValue;
}

 + (id)colorWithHTMLString:(NSString *)str defaultColor:(NSColor *)defaultColor
 {
 if (!str) return defaultColor;

 NSUInteger strLength = [str length];

 NSString *colorValue = str;

 if ([str hasPrefix:@"rgb"]) {
 NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
 NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
 if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
 {
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
 return defaultColor;
 }
 leftParIndex++;
 NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
 colorValue = [colorValue substringWithRange:substrRange];
 NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
 if ([colorComponents count] < 3 || [colorComponents count] > 4) {
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
 return defaultColor;
 }
 float red, green, blue, alpha = 1.0f;
 red = [[colorComponents objectAtIndex:0] floatValue];
 green = [[colorComponents objectAtIndex:1] floatValue];
 blue = [[colorComponents objectAtIndex:2] floatValue];
 if ([colorComponents count] == 4)
 alpha = [[colorComponents objectAtIndex:3] floatValue];
 return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
 }

 if ((!strLength) || ([str characterAtIndex:0] != '#')) {
 //look it up; it's a colour name
 NSDictionary *colorValues = [self colorNamesDictionary];
 colorValue = [colorValues objectForKey:str];
 if (!colorValue) colorValue = [colorValues objectForKey:[str lowercaseString]];
 if (!colorValue) {
 #if COLOR_DEBUG
 NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
 #endif
 return defaultColor;
 }
 }

 //we need room for at least 9 characters (#00ff00ff) plus the NUL terminator.
 //this array is 12 bytes long because I like multiples of four. ;)
 enum { hexStringArrayLength = 12 };
 size_t hexStringLength = 0;
 char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
 {
 NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
 hexStringLength = [stringData length];
 //subtract 1 because we don't want to overwrite that last NUL.
 memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1));
 }
 const char *hexString = hexStringArray;

 CGFloat		red,green,blue;
 CGFloat		alpha = 1.0f;

 //skip # if present.
 if (*hexString == '#') {
 ++hexString;
 --hexStringLength;
 }

 if (hexStringLength < 3) {
 #if COLOR_DEBUG
 NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08) (string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
 #endif
 return defaultColor;
 }

 //long specification:  #rrggbb[aa]
 //short specification: #rgb[a]
 //e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
 BOOL isLong = hexStringLength > 4;

 //for a long component c = 'xy':
 //	c = (x * 0x10 + y) / 0xff
 //for a short component c = 'x':
 //	c = x / 0xf

 char firstChar, secondChar;

 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 red = hexCharsToFloat(firstChar, secondChar);

 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 green = hexCharsToFloat(firstChar, secondChar);

 firstChar = *(hexString++);
 secondChar = (isLong ? *(hexString++) : 0x0);
 blue = hexCharsToFloat(firstChar, secondChar);

 if (*hexString) {
 //we still have one more component to go: this is alpha.
 //without this component, alpha defaults to 1.0 (see initialiser above).
 firstChar = *(hexString++);
 secondChar = (isLong ? *hexString : 0x0);
 alpha = hexCharsToFloat(firstChar, secondChar);
 }

 return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
 }

@end
*/
@implementation NSColor (AIColorAdditions_ObjectColor)

+ (NSString *)representedColorForObject: (id)anObject withValidColors: (NSArray *)validColors
{
	NSArray *validColorsArray = validColors;

	if (!validColorsArray || [validColorsArray count] == 0) {
		if (!defaultValidColors) {
			defaultValidColors = VALID_COLORS_ARRAY;
		}
		validColorsArray = defaultValidColors;
	}

	return validColorsArray[([anObject hash] % ([validColorsArray count]))];
}

@end


//  UIColor+Utilities.m
//  ColorAlgorithm

//  Created by Quenton Jones on 6/11/11.

@implementation NSColor (Utilities)

+ (NSArray *)calveticaPalette {
	return @[CV_PALETTE_1, CV_PALETTE_2, CV_PALETTE_3, CV_PALETTE_4, CV_PALETTE_5, CV_PALETTE_6, CV_PALETTE_7, CV_PALETTE_8, CV_PALETTE_9, CV_PALETTE_10, CV_PALETTE_11, CV_PALETTE_12, CV_PALETTE_13, CV_PALETTE_14, CV_PALETTE_15, CV_PALETTE_16, CV_PALETTE_17, CV_PALETTE_18, CV_PALETTE_19, CV_PALETTE_20, CV_PALETTE_21];
}

- (NSColor *)closestColorInCalveticaPalette {
	return [self closestColorInPalette:[NSColor calveticaPalette]];
}

- (NSColor *)closestColorInPalette:(NSArray *)palette {
	float bestDifference = MAXFLOAT;
	NSColor *bestColor = nil;

	float *lab1 = [self colorToLab];
	float C1 = sqrtf(lab1[1] * lab1[1] + lab1[2] * lab1[2]);

	for (NSColor *color in palette) {
		float *lab2 = [color colorToLab];
		float C2 = sqrtf(lab2[1] * lab2[1] + lab2[2] * lab2[2]);

		float deltaL = lab1[0] - lab2[0];
		float deltaC = C1 - C2;
		float deltaA = lab1[1] - lab2[1];
		float deltaB = lab1[2] - lab2[2];
		float deltaH = sqrtf(deltaA * deltaA + deltaB * deltaB - deltaC * deltaC);

		float deltaE = sqrtf(powf(deltaL / K_L, 2) + powf(deltaC / (1 + K_1 * C1), 2) + powf(deltaH / (1 + K_2 * C1), 2));
		if (deltaE < bestDifference) {
			bestColor = color;
			bestDifference = deltaE;
		}

		free(lab2);
	}

	NSLog(@"Color Difference: %f", bestDifference);
	NSLog(@"Color: %@", bestColor);

	free(lab1);
	return bestColor;
}

- (float *)colorToLab {
	// Don't allow grayscale colors.
	if (CGColorGetNumberOfComponents(self.CGColor) != 4) {
		return nil;
	}

	float *rgb = (float *)malloc(3 * sizeof(float));
	const CGFloat *components = CGColorGetComponents(self.CGColor);

	rgb[0] = components[0];
	rgb[1] = components[1];
	rgb[2] = components[2];

	//NSLog(@"Color (RGB) %@: r: %i g: %i b: %i", self, (int)(rgb[0] * 255), (int)(rgb[1] * 255), (int)(rgb[2] * 255));

	float *lab = [NSColor rgbToLab:rgb];
	free(rgb);

	//NSLog(@"Color (Lab) %@: L: %f a: %f b: %f", self, lab[0], lab[1], lab[2]);

	return lab;
}

+ (float *)rgbToLab:(float *)rgb {
	float *xyz = [NSColor rgbToXYZ:rgb];
	float *lab = [NSColor xyzToLab:xyz];

	free(xyz);
	return lab;
}

+ (float *)rgbToXYZ:(float *)rgb {
	float *newRGB = (float *)malloc(3 * sizeof(float));

	for (int i = 0; i < 3; i++) {
		float component = rgb[i];

		if (component > 0.04045f) {
			component = powf((component + 0.055f) / 1.055f, 2.4f);
		} else {
			component = component / 12.92f;
		}

		newRGB[i] = component;
	}

	newRGB[0] = newRGB[0] * 100.0f;
	newRGB[1] = newRGB[1] * 100.0f;
	newRGB[2] = newRGB[2] * 100.0f;

	float *xyz = (float *)malloc(3 * sizeof(float));
	xyz[0] = (newRGB[0] * 0.4124f) + (newRGB[1] * 0.3576f) + (newRGB[2] * 0.1805f);
	xyz[1] = (newRGB[0] * 0.2126f) + (newRGB[1] * 0.7152f) + (newRGB[2] * 0.0722f);
	xyz[2] = (newRGB[0] * 0.0193f) + (newRGB[1] * 0.1192f) + (newRGB[2] * 0.9505f);

	free(newRGB);
	return xyz;
}

+ (float *)xyzToLab:(float *)xyz {
	float *newXYZ = (float *)malloc(3 * sizeof(float));
	newXYZ[0] = xyz[0] / X_REF;
	newXYZ[1] = xyz[1] / Y_REF;
	newXYZ[2] = xyz[2] / Z_REF;

	for (int i = 0; i < 3; i++) {
		float component = newXYZ[i];

		if (component > 0.008856) {
			component = powf(component, 0.333f);
		} else {
			component = (7.787 * component) + (16 / 116);
		}

		newXYZ[i] = component;
	}

	float *lab = (float *)malloc(3 * sizeof(float));
	lab[0] = (116 * newXYZ[1]) - 16;
	lab[1] = 500 * (newXYZ[0] - newXYZ[1]);
	lab[2] = 200 * (newXYZ[1] - newXYZ[2]);

	free(newXYZ);
	return lab;
}

@end

@implementation NSColorList (AtoZ)
- (NSColor*) randomColor;
{
	return [self  colorWithKey:[[self allKeys] randomElement]];
}
+ (id) colorListWithFileName:(NSString *)fileName inBundle:(NSBundle *)aBundle {
	NSColorList *list = nil;
	if (aBundle != nil) {
		NSString *listPath;
		if ((listPath = [aBundle pathForResource: fileName ofType:nil]) != nil) {
			list = [[NSColorList alloc] initWithName:listPath.lastPathComponent fromFile:listPath];
		}
	}
	return list;
}

+ (id) colorListWithFileName:(NSString *) fileName inBundleForClass:(Class) aClass {
	return [self colorListWithFileName: fileName inBundle: [NSBundle bundleForClass: aClass]];
}

+ (id) colorListInFrameworkWithFileName:(NSString *) fileName {
	NSBundle *aBundle = [NSBundle bundleForClass: [DummyListClass class]];
	return [self colorListWithFileName: fileName inBundle: aBundle];
}
@end

@implementation NSString (THColorConversion)

- (NSColor *)colorValue {
	return [NSColor colorFromString:self];
}
-(NSData *) colorData {
	NSData *theData=[NSArchiver archivedDataWithRootObject:self];
	return theData;
}

+ (NSColor * )colorFromData:(NSData*)theData {
	NSColor * color =  [NSUnarchiver unarchiveObjectWithData:theData];
	return  color;
}

@end
//
//@implementation NSArray (THColorConversion)
//
//- (NSArray *)colorValues {
//	return [self arrayPerformingSelector:@selector(colorValue)];
//}
//
//@end
