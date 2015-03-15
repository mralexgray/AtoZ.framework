
#import "NSColorList+AtoZ.h"

#define REDGRAD  		[NSG.alloc initWithColorsAndLocations:\
							[NSC r:241./255. g:152./255. b:139./255. a:1.0], 0.,\
							[NSC r:228./255. g:116./255. b:102./255. a:1.0], .5,\
							[NSC r:192./255. g: 86./255. b: 73./255. a:1.0], 1., nil]

#define ORANGEGRAD 	[NSG.alloc initWithColorsAndLocations:\
							[NSC r:248./255. g:201./255. b:148./255. a:1.0], 0.,\
							[NSC r:237./255. g:174./255. b:107./255. a:1.0], .5,\
							[NSC r:210./255. g:143./255. b: 77./255. a:1.0], 1., nil]

#define YELLOWGRAD 	[NSG.alloc initWithColorsAndLocations:\
							[NSC r:240./255. g:229./255. b:164./255. a:1.], 0.,\
							[NSC r:227./255. g:213./255. b:119./255. a:1.], .5,\
							[NSC r:201./255. g:188./255. b: 92./255. a:1.], 1., nil]

#define GREENGRAD  	[NSG.alloc initWithColorsAndLocations:\
							[NSC r:209./255. g:236./255. b:156./255. a:1.0], 0.0,\
							[NSC r:175./255. g:215./255. b:119./255. a:1.0], 0.5,\
							[NSC r:142./255. g:182./255. b:102./255. a:1.0], 1.0, nil]

#define BLUEGRAD  	[NSG.alloc initWithColorsAndLocations:\
							[NSC r:165./255. g:216./255. b:249./255. a:1.], 0.0,\
							[NSC r:118./255. g:185./255. b:232./255. a:1.0], 0.5,\
							[NSC r:90./255. g:152./255. b:201./255. a:1.0], 1.0, nil]

#define PURPLEGRAD  	[NSG.alloc initWithColorsAndLocations:\
							[NSC r:232./255. g:191./255. b:248./255. a:1.0], 0.0,\
							[NSC r:202./255. g:152./255. b:224./255. a:1.0], 0.5,\
							[NSC r:163./255. g:121./255. b:186./255. a:1.0], 1.0, nil]

#define GRAYGRAD  	[NSG.alloc initWithColorsAndLocations:\
							[NSColor white:212./255. a:1.], 0.0,\
							[NSColor white:182./255. a:1.], 0.5,\
							[NSColor white:151./255. a:1.], 1.0, nil]


#define CGSHADOW(A)                 CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.0, A})

#define     kTranslucentGrayColor CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.5, 1.0})
#define     kTranslucentLightGrayColor cgGREY
#define    kAlmostInvisibleWhiteColor CGColorCreate( kCGColorSpaceGenericGray, {1, 0.05, 1.0})

#define NOISY(C)                     [C colorWithNoiseWithOpacity:.2 andBlendMode:kCGBlendModeMultiply]
#define RANDOMNOISYCOLOR             NOISY(RANDOMCOLOR)
#define LINEN                          [NSColor linen]
#define RANDOMLINEN                   [NSC linenTintedWithColor:RANDOMCOLOR]
#define CHECKERS                       [NSC checkerboardWithFirstColor: BLACK secondColor: WHITE squareWidth:25]


// GENERICSABLE(NSColor)
// ClassKeyGet NSC.class[@"red"]


@interface Colr (AtoZ) <Random, ClassKeyGet>



@prop_RO  	BOOL	 isBoring,   isExciting,
                           isBright,   isDark,
                           isBlueish,  isRedish,   isGreenish,   isYellowish;

@prop_RO 	 CGF	 luminance, relativeBrightness,
                           rgbWeight,	hsbWeight;

@prop_RO	  CGCR 	 cgColor;

@prop_RO 	 NSC * closestWebColor, * closestNamedColor,  * closestColorListColor,
                         * lessOpaque,      * opaque,             * moreOpaque,
                         * darker,          * dark,               * muchDarker,
                         * deviceRGBColor,  * calibratedRGBColor,
                         * deviceWhiteColor,
                         * brighter,        * bright,
                         * redshift,        * blueshift,
                         * whitened,        * blackened,
                         * rgbComplement,   *	complement,
                         * contrastingForegroundColor,
                         * translucent,
                         * watermark,
                         * inverted,
                         * inRGB;// just guarantees colorspace.ie for white

@property            NSS * name; // settable, but auto_gets

@prop_RO    NSS * crayonName, * toHex;

@prop_RO	   NSG * gradient;

+ (NSA*) subtlePatterns;
+ (INST) subtlePattern;

//+   (id) colorWithHTMLString:(NSS*)str defaultColor:(NSC*)d;
//+ (NSC*)	colorWithHTMLString:(NSS*)hex;
+ (NSA*) allNamedColors;

/* lists all like...  BlueSkyTulips = "NSColorList 0x7fb2963794d0 
										  name:BlueSkyTulips device:(null)
										  file:/Volumes/2T/ServiceData/Develo...Build/Products/Debug/AtoZ.framework/Resources/BlueSkyTulips.clr
										loaded:1"; */
+ (NSMD*) colorLists;
+  (NSA*) colorListNames;
+ (NSCL*) randomList;
+  (void) logPalettes;
+ (NSCL*) createColorlistWithColors:(NSA*)cs andNames:(NSA*)ns named:(NSS*)name;
+  (NSA*) fengshui;
+  (NSA*) flatUI;
+  (NSA*) colorsInListNamed:(NSS*)name;
+  (NSA*) randomPalette;
+  (NSA*) systemColors;
+  (NSA*) systemColorNames;

/* Color animator helpers */

typedef void(^colorFadeBlock)(NSC*c);

+ (NSA*) randomPaletteAnimationBlock:(colorFadeBlock)target; /* 1000 step animation lock */

/* gradients from palettes */
+ (NSA*) gradientPalletteBetween:(NSC*)c1 c2:(NSC*)c2 steps:(NSUI)steps;
+ (NSA*) gradientPalletteBetween:(NSA*)colors steps:(NSUI)steps;
+ (NSA*) gradientPalletteLooping:(NSA*)colors steps:(NSUI)steps;

#pragma mark - Conveience

+ (NSC*) white:(CGF)percent;
+ (NSC*) white:(CGF)percent a:(CGF)alpha;
+ (NSC*) linen;
+ (NSC*) linenTintedWithColor:(NSC*)c;
+ (NSC*) leatherTintedWithColor:(NSC*)c;
+ (NSC*) checkerboardWithFirstColor:(NSC*)one secondColor:(NSC*)two squareWidth:(CGF)dim;
+ (NSA*) colorNames; // preferred "CSS" color names method
+ (NSA*) allSystemColorNames; // i guess this is names of installed clr names;
//+ (NSC*) colorNamed:(NSS*)string;
+ (NSA*) boringColors;
+ (NSC*) randomLightColor;
+ (NSC*) randomBrightColor;
+ (NSC*) randomDarkColor;
+ (NSC*) randomColor;
+ (NSA*) randomColors:(NSUI)ct;
+ (void) drawColors:(NSA*)colors inRect:(NSR)r;
+ (NSC*) randomOpaqueColor;
+ (NSC*) colorFromHexRGB:(NSS*)clrStr;
+ (NSC*) crayonColorNamed:(NSS*)key;
+ (NSC*) colorWithName:(NSS*)colorName;
+ (NSC*) colorFromString:(NSS*)string;
+ (NSC*) colorFromHexString:(NSS*)hexString;

- (NSC*) alpha:(CGF)percent;
- (NSC*) blend:(NSC*)other;
- (NSC*) rgbDistanceToColor:(NSC*)color;
- (NSC*) colorWithSaturation:(CGF)sat brightness:(CGF)bright;
- (NSC*) hsbDistanceToColor:(NSC*)color;
- (NSComparisonResult)compare:(NSC*)other;
/// Returns the color with its saturation, in the HSBA model, multiplied by a certain amount.
/// Note that the saturation is clamped between 0 and 1.
- (NSC*)colorWithSaturationMultiplier:(CGF)factor;
- (NSC*)colorWithSaturation:(CGF)sat;

@end

@interface NSString (THColorConversion)

@prop_RO _Colr colorValue;
@prop_RO _Data colorData;

+ _Colr_ colorFromData:_Data_ data;

@end
@interface NSArray (THColorConversion)  @prop_RO NSA * colorValues;
@end

@interface NSCoder (AGCoder)	 //(TDBindings)

- (void) encode:x withKeysForProps:(NSD*)ksAndDs;
- (void) decode:x withKeysForProps:(NSD*)ksAndDs;
- (void) decode:x         withKeys:(NSA*)ks;
- (void) encode:x         withKeys:(NSA*)ks;

+ (void) encodeColor:(CGCLRREF)cgC withCoder:(NSCoder*)e withKey:(NSS*)k;
@end

@interface NSColor (NSColor_ColorspaceEquality) - _IsIt_ isEqualToColor:(NSC*)inColor colorSpace:(NSS*)space;
@end

JREnumDeclare(AZeColor, AZeColoraliceblue, AZeColorantiquewhite, AZeColoraqua, AZeColoraquamarine, AZeColorazure, AZeColorbeige, AZeColorbisque, AZeColorblack, AZeColorblanchedalmond, AZeColorblue, AZeColorblueviolet, AZeColorbrown, AZeColorburlywood, AZeColorcadetblue, AZeColorchartreuse, AZeColorchocolate, AZeColorcoral, AZeColorcornflowerblue, AZeColorcornsilk, AZeColorcrimson, AZeColorcyan, AZeColordarkblue, AZeColordarkcyan, AZeColordarkgoldenrod, AZeColordarkgray, AZeColordarkgrey, AZeColordarkgreen, AZeColordarkkhaki, AZeColordarkmagenta, AZeColordarkolivegreen, AZeColordarkorange, AZeColordarkorchid, AZeColordarkred, AZeColordarksalmon, AZeColordarkseagreen, AZeColordarkslateblue, AZeColordarkslategray, AZeColordarkslategrey, AZeColordarkturquoise, AZeColordarkviolet, AZeColordeeppink, AZeColordeepskyblue, AZeColordimgray, AZeColordimgrey, AZeColordodgerblue, AZeColorfirebrick, AZeColorfloralwhite, AZeColorforestgreen, AZeColorfuchsia, AZeColorgainsboro, AZeColorghostwhite, AZeColorgold, AZeColorgoldenrod, AZeColorgray, AZeColorgrey, AZeColorgreen, AZeColorgreenyellow, AZeColorhoneydew, AZeColorhotpink, AZeColorindianred, AZeColorindigo, AZeColorivory, AZeColorkhaki, AZeColorlavender, AZeColorlavenderblush, AZeColorlawngreen, AZeColorlemonchiffon, AZeColorlightblue, AZeColorlightcoral, AZeColorlightcyan, AZeColorlightgoldenrodyellow, AZeColorlightgray, AZeColorlightgrey, AZeColorlightgreen, AZeColorlightpink, AZeColorlightsalmon, AZeColorlightseagreen, AZeColorlightskyblue, AZeColorlightslateblue, AZeColorlightslategray, AZeColorlightslategrey, AZeColorlightsteelblue, AZeColorlightyellow, AZeColorlime, AZeColorlimegreen, AZeColorlinen, AZeColormagenta, AZeColormaroon, AZeColormediumaquamarine, AZeColormediumblue, AZeColormediumorchid, AZeColormediumpurple, AZeColormediumseagreen, AZeColormediumslateblue, AZeColormediumspringgreen, AZeColormediumturquoise, AZeColormediumvioletred, AZeColormidnightblue, AZeColormintcream, AZeColormistyrose, AZeColormoccasin, AZeColornavajowhite, AZeColornavy, AZeColoroldlace, AZeColorolive, AZeColorolivedrab, AZeColororange, AZeColororangered, AZeColororchid, AZeColorpalegoldenrod, AZeColorpalegreen, AZeColorpaleturquoise, AZeColorpalevioletred, AZeColorpapayawhip, AZeColorpeachpuff, AZeColorperu, AZeColorpink, AZeColorplum, AZeColorpowderblue, AZeColorpurple, AZeColorred, AZeColorrosybrown, AZeColorroyalblue, AZeColorsaddlebrown, AZeColorsalmon, AZeColorsandybrown, AZeColorseagreen, AZeColorseashell, AZeColorsienna, AZeColorsilver, AZeColorskyblue, AZeColorslateblue, AZeColorslategray, AZeColorslategrey, AZeColorsnow, AZeColorspringgreen, AZeColorsteelblue, AZeColortan, AZeColorteal, AZeColorthistle, AZeColortomato, AZeColorturquoise, AZeColorviolet, AZeColorvioletred, AZeColorwheat, AZeColorwhite, AZeColorwhitesmoke, AZeColoryellow, AZeColoryellowgreen); 


#define CV_PALETTE_1 	[NSC r:.9372  g:.6313 b:.5019  a:1]
#define CV_PALETTE_2	[NSC r:.8980  g:.4588 b:.3098  a:1]
#define CV_PALETTE_3	[NSC r:.8353  g:.1215 b:.0  	 a:1]
#define CV_PALETTE_4	[NSC r:.6470  g:.8157 b:.8627  a:1]
#define CV_PALETTE_5	[NSC r:.4784  g:.7098 b:.7804  a:1]
#define CV_PALETTE_6	[NSC r:.1529  g:.5294 b:.6431  a:1]
#define CV_PALETTE_7	[NSC r:.7019  g:.7176 b:.8117  a:1]
#define CV_PALETTE_8	[NSC r:.5490  g:.5686 b:.7019  a:1]
#define CV_PALETTE_9	[NSC r:.2666  g:.2980 b:.5176  a:1]
#define CV_PALETTE_10	[NSC r:.6392  g:.8274 b:.7412  a:1]
#define CV_PALETTE_11	[NSC r:.4666  g:.7255 b:.6     a:1]
#define CV_PALETTE_12	[NSC r:.1333  g:.5529 b:.3490  a:1]
#define CV_PALETTE_13	[NSC r:.7647  g:.8235 b:.5255  a:1]
#define CV_PALETTE_14	[NSC r:.6314  g:.7176 b:.3333  a:1]
#define CV_PALETTE_15	[NSC r:.4 	  g:.5412 b:.0  	 a:1]
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

#define K_L 	    1
#define K_1 	     .045f
#define K_2 	     .015f
#define X_REF 	 95.047f
#define Y_REF 	100.0f
#define Z_REF 	108.883f

@interface NSColor (Utilities)
+ (NSA*) calveticaPalette;                 // The Calvetica specific colors.
- (NSC*) closestColorInCalveticaPalette;   // Determines which color in the Calvetica palette most closely matches the recipient color.
- (NSC*) closestColorInPalette:(NSA*)pal;  // Determines which color in the array of colors most closely matches recipient color.
- (CGF*) colorToLab;         // Converts the recipient UIColor to the L*a*b* color space.
+ (CGF*) rgbToLab:(CGF*)rgb; // Converts a color from the RGB color space to the L*a*b* color space.
+ (CGF*) rgbToXYZ:(CGF*)rgb; // Converts a color from the RGB color space to the XYZ color space.
+ (CGF*) xyzToLab:(CGF*)xyz; // Coverts a color from the XYZ color space to the L*a*b* color space.
@end

@interface NSColor (AMAdditions)
+ (NSC*) lightYellowColor;
+ (NSC*) am_toolTipColor;
+ (NSC*) am_toolTipTextColor;
- (NSC*) accentColor;
- (NSC*) lighterColor;
- (NSC*) disabledColor;
@end

//  NSColor+HSVExtras.h MMPieChart Demo Created by Manuel de la Mata Sáez on 07/02/14.  Copyright (c) 2014 Manuel de la Mata Sáez. All rights reserved.

//typedef struct { int hueValue; int saturationValue; int brightnessValue; CGF hue; CGF saturation; CGF brightness; } HsvColor;
//typedef struct { int rVal; int gVal; int bVal; CGF r; CGF g; CGF b; } RgbColor;

//@interface NSColor (HSVExtras)
//
//+ (HsvColor) hsvColorFromColor:(NSC*)c;
//+ (RgbColor) rgbColorFromColor:(NSC*)c;
//
//@prop_RO HsvColor hsvColor;
//@prop_RO RgbColor rgbColor;
//@prop_RO      CGF hue,
//                  saturation,
//                  brightness,
//                  value,
//                  red, green, blue, white, alpha;
//@end
//
//+  (NSA*) colorsInFrameworkListNamed:(NSString*)name;
//+  (NSA*) colorListsInFramework;
//+  (NSA*) allColors;			// NOT WORKING
//+ (NSA*) colorsWithNames;
//+ (NSD*) colorsAndNames;
//- (NSDictionary*)	closestColor;  //name, list, and color
//+ (NSC*)	colorWithCGColor: (CGColorRef) aColor;
//@prop_RO	BOOL isBasicallyWhite;
//@prop_RO	BOOL isBasicallyBlack;
//#define AZNormalFloat(x) { if (x < 0) {x = 0;} else if (x > 1) {x = 1;} }

