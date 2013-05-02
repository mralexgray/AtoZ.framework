
//  NSColot+AtoZ.h
//  AtoZ

#import "JREnum.h"

JREnumDeclare(AZeColor, AZeColoraliceblue, AZeColorantiquewhite, AZeColoraqua, AZeColoraquamarine, AZeColorazure, AZeColorbeige, AZeColorbisque, AZeColorblack, AZeColorblanchedalmond, AZeColorblue, AZeColorblueviolet, AZeColorbrown, AZeColorburlywood, AZeColorcadetblue, AZeColorchartreuse, AZeColorchocolate, AZeColorcoral, AZeColorcornflowerblue, AZeColorcornsilk, AZeColorcrimson, AZeColorcyan, AZeColordarkblue, AZeColordarkcyan, AZeColordarkgoldenrod, AZeColordarkgray, AZeColordarkgrey, AZeColordarkgreen, AZeColordarkkhaki, AZeColordarkmagenta, AZeColordarkolivegreen, AZeColordarkorange, AZeColordarkorchid, AZeColordarkred, AZeColordarksalmon, AZeColordarkseagreen, AZeColordarkslateblue, AZeColordarkslategray, AZeColordarkslategrey, AZeColordarkturquoise, AZeColordarkviolet, AZeColordeeppink, AZeColordeepskyblue, AZeColordimgray, AZeColordimgrey, AZeColordodgerblue, AZeColorfirebrick, AZeColorfloralwhite, AZeColorforestgreen, AZeColorfuchsia, AZeColorgainsboro, AZeColorghostwhite, AZeColorgold, AZeColorgoldenrod, AZeColorgray, AZeColorgrey, AZeColorgreen, AZeColorgreenyellow, AZeColorhoneydew, AZeColorhotpink, AZeColorindianred, AZeColorindigo, AZeColorivory, AZeColorkhaki, AZeColorlavender, AZeColorlavenderblush, AZeColorlawngreen, AZeColorlemonchiffon, AZeColorlightblue, AZeColorlightcoral, AZeColorlightcyan, AZeColorlightgoldenrodyellow, AZeColorlightgray, AZeColorlightgrey, AZeColorlightgreen, AZeColorlightpink, AZeColorlightsalmon, AZeColorlightseagreen, AZeColorlightskyblue, AZeColorlightslateblue, AZeColorlightslategray, AZeColorlightslategrey, AZeColorlightsteelblue, AZeColorlightyellow, AZeColorlime, AZeColorlimegreen, AZeColorlinen, AZeColormagenta, AZeColormaroon, AZeColormediumaquamarine, AZeColormediumblue, AZeColormediumorchid, AZeColormediumpurple, AZeColormediumseagreen, AZeColormediumslateblue, AZeColormediumspringgreen, AZeColormediumturquoise, AZeColormediumvioletred, AZeColormidnightblue, AZeColormintcream, AZeColormistyrose, AZeColormoccasin, AZeColornavajowhite, AZeColornavy, AZeColoroldlace, AZeColorolive, AZeColorolivedrab, AZeColororange, AZeColororangered, AZeColororchid, AZeColorpalegoldenrod, AZeColorpalegreen, AZeColorpaleturquoise, AZeColorpalevioletred, AZeColorpapayawhip, AZeColorpeachpuff, AZeColorperu, AZeColorpink, AZeColorplum, AZeColorpowderblue, AZeColorpurple, AZeColorred, AZeColorrosybrown, AZeColorroyalblue, AZeColorsaddlebrown, AZeColorsalmon, AZeColorsandybrown, AZeColorseagreen, AZeColorseashell, AZeColorsienna, AZeColorsilver, AZeColorskyblue, AZeColorslateblue, AZeColorslategray, AZeColorslategrey, AZeColorsnow, AZeColorspringgreen, AZeColorsteelblue, AZeColortan, AZeColorteal, AZeColorthistle, AZeColortomato, AZeColorturquoise, AZeColorviolet, AZeColorvioletred, AZeColorwheat, AZeColorwhite, AZeColorwhitesmoke, AZeColoryellow, AZeColoryellowgreen); 
//#import "NSString+AG.h"
//#import "NSArray+AG.h"
//#import <AGFoundation/AGFoundation.h>
//#import "AGFoundation.h"

@interface NSColor (AtoZ)
@property (NATOM,STRNG) NSS*	name;
@property (RONLY)	BOOL	isBoring, isExciting;
@property (RONLY)	NSS*	nameOfColor, *crayonName;
@property (RONLY)	NSC*	closestWebColor, *closestNamedColor,	*closestColorListColor;
@property (RONLY)	CGCR 	cgColor;
@property (RONLY)	NSC* 	inverted;
@property (RONLY) NSC*	deviceRGBColor;
@property (RONLY) NSC*	calibratedRGBColor;
@property (RONLY) CGF	luminance;
@property (RONLY) CGF 	relativeBrightness;
@property (RONLY) BOOL 	isBright;
@property (RONLY) NSC*	bright;
@property (RONLY) NSC*	brighter;
@property (RONLY) BOOL 	isDark;
@property (RONLY) NSC*	dark;
@property (RONLY) NSC*	darker;
@property (RONLY) NSC*	muchDarker;
@property (RONLY) NSC*	redshift;
@property (RONLY) NSC*	blueshift;

-(NSC*)blend:(NSC*)other;

@property (RONLY) NSC*	whitened;
@property (RONLY) NSC*	blackened;

@property (RONLY) NSC*	contrastingForegroundColor;
@property (RONLY) NSC*	complement;
@property (RONLY) NSC*	rgbComplement;

@property (RONLY) NSC*	opaque;
@property (RONLY) NSC*	lessOpaque;
@property (RONLY) NSC*	moreOpaque;
@property (RONLY) NSC*	translucent;
@property (RONLY) NSC*	watermark;
@property (RONLY)	CGFloat rgbWeight;
@property (RONLY)	CGFloat hsbWeight;

@property (RONLY)	BOOL isBlueish;
@property (RONLY)	BOOL isRedish;
@property (RONLY)	BOOL isGreenish;
@property (RONLY)	BOOL isYellowish;

+ (NSMD*) colorLists;
+ (NSCL*) randomList;


+ (NSA*) gradientPalletteBetween:(NSC*)c1 and:(NSC*)c2 steps:(NSUI)steps;
+ (NSA*) gradientPalletteBetween:(NSA*)colors steps:(NSUI)steps;
+ (NSA*) gradientPalletteLooping:(NSA*)colors steps:(NSUI)steps;
+ (NSC*) linen;
+ (NSC*) linenTintedWithColor: (NSC*) color;
+ (NSC*) leatherTintedWithColor:(NSC*)color;
+ (NSC*) checkerboardWithFirstColor:(NSC*)firstColor secondColor:(NSC*)secondColor squareWidth:(CGF)width;
//+ (NSA*) colorNames;
+ (NSC*) colorNamed:(NSS*)string;
//+ (NSA*) colorsWithNames;
//+ (NSD*) colorsAndNames;
+ (void) logPalettes;
+ (NSC*) white:(CGF)percent;
+ (NSC*) white:(CGF)percent a:(CGF)alpha;
+ (NSC*) r:(CGF)red g:(CGF)green b:(CGF)blue a:(CGF)trans;

- (NSC*) alpha:(CGF)floater;
//- (NSDictionary*)	closestColor;  //name, list, and color
+  (NSA*) boringColors;
+ (NSCL*) createColorlistWithColors:(NSA*)cs andNames:(NSA*)ns named:(NSS*)name;
+  (NSA*) fengshui;
//+  (NSA*) colorsInFrameworkListNamed:(NSString*)name;
//+  (NSA*) colorListsInFramework;
+  (NSA*) colorsInListNamed:(NSS*)name;
+  (NSA*) allColors;
+  (NSA*) randomPalette;
+  (NSA*) systemColors;
+  (NSA*) systemColorNames;

+  (NSC*) randomLightColor;
+  (NSC*) randomBrightColor;
+  (NSC*) randomDarkColor;
+  (NSC*) randomColor;
+  (NSC*) randomOpaqueColor;
+  (NSC*) colorFromHexRGB: (NSString*) inColorString;
//+ (NSC*)	colorWithCGColor: (CGColorRef) aColor;
+ (NSC*)	crayonColorNamed: (NSString*) key;

+ (NSC*)	colorWithName:(NSString*)colorName;
+ (NSC*)	colorFromString: 	(NSString*)	string;
+ (NSC*)	colorFromHexString: (NSString*)	hexString;
- (NSS*)	toHex;
- (NSC*) rgbDistanceToColor:(NSC*)color;
- (NSC*) colorWithSaturation:(CGF)sat brightness:(CGF)bright;
- (NSC*) hsbDistanceToColor:(NSC*)color;

//@property (RONLY)	BOOL isBasicallyWhite;
//@property (RONLY)	BOOL isBasicallyBlack;

@end

//@interface NSColor (AIColorAdditions_HTMLSVGCSSColors)
//+ (NSC*)	colorWithHTMLString:(NSString*)	hexString;
//@end

@interface NSString (THColorConversion)
- (NSC*)	colorValue;
- (NSData*)	 colorData;
+ (NSC*)	colorFromData:(NSData*)theData;
@end

@interface NSArray (THColorConversion)
- (NSA*)colorValues;
@end

@interface NSCoder (AGCoder)	 //(TDBindings)

+(void)encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSString*)theKey;

@end
@interface NSColor (NSColor_ColorspaceEquality)

- (BOOL)	isEqualToColor:(NSC*)inColor colorSpace:(NSString*)inColorSpace;

@end
@interface NSColor (NSColor_CSSRGB)

+ (NSC*)	colorWithCSSRGB:(NSString*)rgbString;

@end

#define AZNormalFloat(x) { if (x < 0) {x = 0;} else if (x > 1) {x = 1;} }

/*
@interface NSColor (AIColorAdditions_HLS)
//Linearly adjust a color

- (NSC*)adjustHue:(CGFloat)dHue saturation:(CGFloat)dSat brightness:(CGFloat)dBrit;

@end
*/

#define CV_PALETTE_1 	[NSC r:.9372  g:.6313 b:.5019  a:1]
#define CV_PALETTE_2		[NSC r:.8980  g:.4588 b:.3098  a:1]
#define CV_PALETTE_3		[NSC r:.8353  g:.1215 b:.0  	 a:1]
#define CV_PALETTE_4		[NSC r:.6470  g:.8157 b:.8627  a:1]
#define CV_PALETTE_5		[NSC r:.4784  g:.7098 b:.7804  a:1]
#define CV_PALETTE_6		[NSC r:.1529  g:.5294 b:.6431  a:1]
#define CV_PALETTE_7		[NSC r:.7019  g:.7176 b:.8117  a:1]
#define CV_PALETTE_8		[NSC r:.5490  g:.5686 b:.7019  a:1]
#define CV_PALETTE_9		[NSC r:.2666  g:.2980 b:.5176  a:1]
#define CV_PALETTE_10	[NSC r:.6392  g:.8274 b:.7412  a:1]
#define CV_PALETTE_11	[NSC r:.4666  g:.7255 b:.6     a:1]
#define CV_PALETTE_12	[NSC r:.1333  g:.5529 b:.3490  a:1]
#define CV_PALETTE_13	[NSC r:.7647  g:.8235 b:.5255  a:1]
#define CV_PALETTE_14	[NSC r:.6314  g:.7176 b:.3333  a:1]
#define CV_PALETTE_15	[NSC r:.4 	  g:.5412 b:.0 	 a:1]
#define CV_PALETTE_16	[NSC r:.7921  g:.6706 b:.8274  a:1]
#define CV_PALETTE_17	[NSC r:.6745  g:.5059 b:.7255  a:1]
#define CV_PALETTE_18	[NSC r:.4706  g:.1961 b:.5529  a:1]
#define CV_PALETTE_19	[NSC r:.9255  g:.7921 b:.5098  a:1]
#define CV_PALETTE_20	[NSC r:.8784  g:.6706 b:.3176  a:1]
#define CV_PALETTE_21	[NSC r:.8039  g:.4666 b:0 		 a:1]

/*
 efa180 = .9372, .6313, .5019
 e5754f = .8980, .4588, .3098
 d51f00 = .8353, .1215, 0

 a5d0dc = .6470, .8157, .8627
 7ab5c7 = .4784, .7098, .7804
 2787a4 = .1529, .5294, .6431

 b3b7cf = .7019, .7176, .8117
 8c91b3 = .5490, .5686, .7019
 444c84 = .2666, .2980, .5176

 a3d3bd = .6392, .8274, .7412
 77b999 = .4666, .7255, .6
 228d59 = .1333, .5529, .3490

 c3d286 = .7647, .8235, .5255
 a1b755 = .6314, .7176, .3333
 668a00 = .4, .5412, 0

 caabd3 = .7921, .6706, .8274
 ac81b9 = .6745, .5059, .7255
 78328d = .4706, .1961, .5529

 ecca82 = .9255, .7921, .5098
 e0ab51 = .8784, .6706, .3176
 cd7700 = .8039, .4666, 0	*/

#define K_L 	1
#define K_1 	0.045f
#define K_2 	0.015f
#define X_REF 	95.047f
#define Y_REF 	100.0f
#define Z_REF 	108.883f

@interface NSColor (Utilities)
// The Calvetica specific colors.
+ (NSA*)calveticaPalette;
// Determines which color in the Calvetica palette most closely matches the recipient color.
- (NSC*)closestColorInCalveticaPalette;
// Determines which color in the array of colors most closely matches recipient color.
- (NSC*)closestColorInPalette:(NSA*)palette;
// Converts the recipient UIColor to the L*a*b* color space.
- (float*)colorToLab;
// Converts a color from the RGB color space to the L*a*b* color space.
+ (float*)rgbToLab:(float*)rgb;
// Converts a color from the RGB color space to the XYZ color space.
+ (float*)rgbToXYZ:(float*)rgb;
// Coverts a color from the XYZ color space to the L*a*b* color space.
+ (float*)xyzToLab:(float*)xyz;
@end

@interface NSColorList (AtoZ)
- (NSA*) colors;
- (NSC*)	randomColor;
+ (id)	colorListWithFileName:(NSString*)fileName inBundle:(NSBundle*)aBundle;
+ (id)	colorListWithFileName:(NSString*)	fileName inBundleForClass:(Class)	aClass;
+ (id)	colorListInFrameworkWithFileName:(NSString*)	fileName;
@end
/*
@implementation NSColor (AIColorAdditions_RepresentingColors)
- (NSString*)hexString
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
	return [NSString stringWithUTF8String:hexString];
}
//String representation: R,G,B[,A].
- (NSString*)stringRepresentation
{
	NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat alphaComponent = [tempColor alphaComponent];
	if (alphaComponent == 1.0)	{
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
//- (NSString*)CSSRepresentation
//{
//	CGFloat alpha = [self alphaComponent];
//	if ( (1.0 - alpha)	>= 0.000001)	{
//		NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//		//CSS3 defines rgba()	to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
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
- (NSC*)representedColor
{
	CGFloat	r = 255, g = 255, b = 255;
	CGFloat	a = 255;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b[,a]
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 == ',')	{
		++selfUTF8;
		a = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
		if (*selfUTF8)	goto scanFailed;
	} else if (*selfUTF8 != '\0')	{
		goto scanFailed;
	}
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:(a/255)] ;
scanFailed:
	return nil;
}
- (NSC*)representedColorWithAlpha:(CGFloat)alpha
{
	//this is the same as above, but the alpha component is overridden.
  NSUInteger	r, g, b;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:alpha];
scanFailed:
	return nil;
}
@end
@implementation NSColor (AIColorAdditions_RandomColor)
+ (NSC*)randomColor
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:1.0f];
}
+ (NSC*)randomColorWithAlpha
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:(arc4random()	% 65536)	/ 65536.0f];
}
@end
@implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
//+ (id)colorWithHTMLString:(NSString*)str
//{
//	return [self colorWithHTMLString:str defaultColor:nil];
//}
/ * !
 * @brief Convert one or two hex characters to a float
 *
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.
 * /
static CGFloat hexCharsToFloat(char firstChar, char secondChar)
{
	CGFloat				hexValue;
	NSUInteger		firstDigit;
	firstDigit = hexToInt(firstChar);
	if (firstDigit != -1)	{
		hexValue = firstDigit;
		if (secondChar != 0x0)	{
			int secondDigit = hexToInt(secondChar);
			if (secondDigit != -1)
				hexValue = (hexValue * 16.0f + secondDigit)	/ 255.0f;
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

+ (id)colorWithHTMLString:(NSString*)str defaultColor:(NSC*)defaultColor
{
	if (!str)	return defaultColor;
	NSUInteger strLength = [str length];
	NSString *colorValue = str;
	if ([str hasPrefix:@"rgb"])	{
		NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
		NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
		if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
		{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
			return defaultColor;
		}
		leftParIndex++;
		NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
		colorValue = [colorValue substringWithRange:substrRange];
		NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
		if ([colorComponents count] < 3 || [colorComponents count] > 4)	{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
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
	if ((!strLength)	|| ([str characterAtIndex:0] != '#'))	{
		//look it up; it's a colour name
		NSDictionary *colorValues = [self colorNamesDictionary];
		colorValue = [colorValues objectForKey:str];
		if (!colorValue)	colorValue = [colorValues objectForKey:[str lowercaseString]];
		if (!colorValue)	{
#if COLOR_DEBUG
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
#endif
			return defaultColor;
		}
	}
	//we need room for at least 9 characters (#00ff00ff)	plus the NUL terminator.
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
	if (*hexString == '#')	{
		++hexString;
		--hexStringLength;
	}
	if (hexStringLength < 3)	{
#if COLOR_DEBUG
		NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08)	(string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
#endif
		return defaultColor;
	}
	//long specification:  #rrggbb[aa]
	//short specification: #rgb[a]
	//e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
	BOOL isLong = hexStringLength > 4;
	//for a long component c = 'xy':
	//	c = (x * 0x10 + y)	/ 0xff
	//for a short component c = 'x':
	//	c = x / 0xf
	char firstChar, secondChar;
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	red = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	green = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	blue = hexCharsToFloat(firstChar, secondChar);
	if (*hexString)	{
		//we still have one more component to go: this is alpha.
		//without this component, alpha defaults to 1.0 (see initialiser above).
		firstChar = *(hexString++);
		secondChar = (isLong ? *hexString : 0x0);
		alpha = hexCharsToFloat(firstChar, secondChar);
	}
	return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

@end
@implementation NSColor (AIColorAdditions_ObjectColor)
+ (NSString*)representedColorForObject: (id)anObject withValidColors: (NSA*)validColors;
@end
*/

