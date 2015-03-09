
#import <AtoZ/AtoZ.h>
#import "NSColor+AtoZ_Private.h"
#import "NSColor+AtoZ.h"
#import "AZNamedColors.h"

JREnumDefine(AZeColor);

static NSC * ColorWithUnsignedLong(unsigned long value, BOOL hasAlpha) {

  float a = hasAlpha ? (float)(0x00FF & value)  / 255.0 : 1.0;   // Extract alpha, if available
    if (hasAlpha) value >>= 8;
  float r = (float)       (value >> 16)   / 255.0,
  g = (float)(0x00FF & (value >> 8))  / 255.0,
  b = (float)(0x00FF & value)       / 255.0;    return [NSC r:r g:g b:b a:a];
}
static NSC * ColorWithHexDigits(NSS *str) {    NSString *hexStr;

  NSScanner     *scanner = [NSScanner      scannerWithString:           str.lowercaseString];
  NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];

  [scanner scanUpToCharactersFromSet:hexSet intoString:   nil];
  [scanner scanCharactersFromSet:    hexSet intoString:&hexStr];

  if (hexStr.length < 6) return nil;
  BOOL    hasAlpha = hexStr.length == 8;
  unsigned long value = strtoul(hexStr.UTF8String, NULL, 16);
  return ColorWithUnsignedLong(value, hasAlpha);
}
static NSC * ColorWithCSSString(NSS *str) {

  NSString  *trimmed = [str stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
  NSString *lowerStr = trimmed.lowercaseString;
  NSScanner *scanner = [NSScanner scannerWithString:lowerStr];

  if ([scanner scanString:@"rgb" intoString:NULL]) {
    [scanner scanString:@"(" intoString:NULL];
    NSString *content;
    [scanner scanUpToString:@")" intoString:&content];
    NSCharacterSet *spaceOrCommaSet = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
    NSArray *components = [content componentsSeparatedByCharactersInSet:spaceOrCommaSet];
    int count = components.count;
    float a = count > 3 ? (float)[[components objectAtIndex:3] fV] : 1.0,
        r = (float)strtoul([components stringAtIdx:0].UTF8String, NULL, 10) / 255.0,
        g = (float)strtoul([components stringAtIdx:1].UTF8String, NULL, 10) / 255.0,
        b = (float)strtoul([components stringAtIdx:2].UTF8String, NULL, 10) / 255.0;

    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
  }

  return nil;
}
static CGF   LuminanceFromRGBComponents(const CGF *rgb) { return .3086f*rgb[0] + .6094f*rgb[1] + .0820f*rgb[2]; /* 0.3086 + 0.6094 + 0.0820 = 1.0 */ }

@implementation NSColor (AtoZ) static NSMD *bestMatches, *colorsFromStruct; static NSCL *safe, *named;

+ (NSA*) subtlePatterns { AZSTATIC_OBJ(NSA, subtles, [@11 mapTimes:^id(NSNumber *num) {
  return [self colorWithPatternImage:[NSIMG imageNamed:$(@"subtle-pattern-%@", num.increment)]];

  }]);
  return subtles;
}
+ (INST) subtlePattern  { return self.subtlePatterns.randomElement; }

#pragma mark - PROTOCOLS

+ (INST) random { return RANDOMCOLOR; }
- (NSComparisonResult)compare:(NSC *)o { return [@(self.hueComponent) compare:@(o.hueComponent)]; }

#pragma mark - ASSOCIATIONS

//- (void) setNameOfColor:(NSS*)nameOfColor {
//  [self setAssociatedValue:nameOfColor forKey:@"associatedName" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//}

SYNTHESIZE_ASC_OBJ(name, setName);
- (NSG*) gradient {

  return [self associatedValueForKey:@"_gradient" orSetTo:
    [NSG.alloc initWithColorsAndLocations:self.brighter.brighter,    0.,
                                          self.brighter,              .13,
                                          self,                       .5,
                                          self.darker,                .8,
                                          self.darker.darker.darker, 1., nil]];
}

#pragma mark - READONLY PROPERTIES  🔖

- _IsIt_ isExciting   { return !self.isBoring;}
- _IsIt_ isBoring     {   NSC *deviceColor = self.inRGB; return

  ((deviceColor.saturationComponent + deviceColor.hueComponent + deviceColor.brightnessComponent) > 1.6) &&
   (deviceColor.saturationComponent > .3) ? NO :
   (deviceColor.brightnessComponent < .3) ||  // too dark
   (deviceColor.saturationComponent < .4);  // too blah //   ( [deviceColor brightnessComponent]   > .8)     // too brig ) { return TRUE;}  //  [[self closestNamedColor] containsAnyOf:[NSC boringColors]]) return TRUE;   else return FALSE;
}
- (CGCLRREF) cgColor  {  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();  CGFloat components[4];
  [ [self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed: &components[0] green: &components[1] blue:&components[2] alpha: &components[3]];
  CGColorRef output = CGColorCreate(colorSpace, components);  CGColorSpaceRelease (colorSpace); return CGColorRetain(output);
}

#pragma mark - READONLY TRANSMOGRIFIERS 🎨

- (INST) inRGB        { return [self colorUsingColorSpaceName:NSDeviceRGBColorSpace]; }
- (INST) inverted     {
  NSC* original = [self colorUsingColorSpaceName:
              NSCalibratedRGBColorSpace];
  CGFloat hue = [original hueComponent];
  if (hue >= 0.5) { hue -= 0.5; } else { hue += 0.5; }
  return [NSC colorWithCalibratedHue:hue
                  saturation:[original saturationComponent]
                  brightness:(1.0 - [original brightnessComponent])
                      alpha:[original alphaComponent]];
}

#pragma mark - MUTATORS 🎯

- (INST) alpha:(CGF)f { return [self colorWithAlphaComponent:f];  }
- (INST) colorWithSaturation:(CGF)sat { return [self colorWithSaturation:sat brightness:self.brightnessComponent]; }
- (INST) colorWithSaturationMultiplier:(CGF)factor {   CGFloat h,s,b,a;

  [self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSColor colorWithCalibratedHue:h saturation:fclamp(0, s * factor, 1) brightness:b alpha:a];
}

#pragma mark - ETC

+ (NSA*) randomPaletteAnimationBlock:(colorFadeBlock)target { NSA* r = RANDOMPAL;

  NSA* pal = [self gradientPalletteLooping:r steps:1000]; NSLog(@"number of colors in fade: %ld", pal.count);
  __block NSUI ct = 0;
  return [NSTimer scheduledTimerWithTimeInterval:.2 block:^(NSTimer *timer) {
    NSColor*u =[pal normal:ct]; ct++; target(u);
  } repeats:YES], pal;
}
+ (NSA*) gradientPalletteLooping:(NSA*)colors steps:(NSUI)steps         {

  NSC          *blend = [colors.first blend:colors.last];         // find the point betweenfirst and last...
  NSUI     blendSteps = (NSUI)ceil(.2 *colors.count);   // use 10 % of the steps to blend
  NSA __unused * blendFromStart = [NSC gradientPalletteBetween:@[blend,colors.first]  steps:MAX(2,blendSteps/2)],
        __unused * blendFromEnd = [NSC gradientPalletteBetween:@[colors.last, blend]  steps:MAX(2,blendSteps/2)];
  NSLog(@"featirebroken %@", AZSELSTR);
  return [NSA arrayWithArrays:@[colors]];
  //@[blendFromStart,
    //                          [self gradientPalletteBetween:colors steps:steps-blendSteps],
      //                        blendFromEnd]];
}
+ (NSA*) gradientPalletteBetween:(NSA*)colors steps:(NSUI)steps         {

  int count = colors.count; CGF locations[colors.count];

  for (int i = 0; i < count; i++) locations[i] = (CGF)((float)i/(float)count);

  NSG *gradient = [NSG.alloc initWithColors:colors atLocations:locations colorSpace:NSCSRGB];

  NSSize imageSize = NSMakeSize(100, 4); NSBIR *bitmapRep =

  [NSBIR.alloc initWithBitmapDataPlanes:NULL pixelsWide:(NSUI)imageSize.width
                                             pixelsHigh:(NSUI)imageSize.height
                                          bitsPerSample:8 samplesPerPixel:4
                                               hasAlpha:YES      isPlanar:NO  // <--- important !
                                         colorSpaceName:NSCalibratedRGBColorSpace
                                            bytesPerRow:0    bitsPerPixel:0];
  __block NSA *cs;

  [NSGC state:^{
   [NSGC setCurrentContext:[NSGC graphicsContextWithBitmapImageRep:bitmapRep]];
   [gradient drawFromPoint:(NSP){0,2} toPoint:(NSP){100,2} options:0];
    cs = [@(steps)mapTimes:^id(NSNumber *ii) {
      int indc = ceil(( ( ii.fV / (float)steps) * 100));
      return [bitmapRep colorAtX:indc y:3];
    }];
  }];
  return cs;
}

#pragma mark - CLASS METHODS

+ (NSA*) colorNames {  return NSCL.namedColorDictionary.allKeys;

/* static NSArray *sAllNames = nil;
  if (!sAllNames) {     int count = sizeof(sColorTable) / sizeof(sColorTable[0]); NSMutableArray *names = NSMA.new;   ColorNameRec *rec = sColorTable;
    for (int i = 0; i < count; ++i, ++rec)  [names addObject:$UTF8(rec->name)];
    sAllNames = names.copy;
//    [names release];
  } return sAllNames; } // aliceblue,antiquewhite,aqua...*/

}

#pragma mark - COLORLISTS

+ (NSA*) colorListNames { return [self.colorLists.allValues vFKP:@"name"]; }

+ (NSMD*) colorLists {

  AZNewStatic(colorListD,NSMD.new);

  return colorListD = colorListD.count ? colorListD :
  [[[AZBUNDLE pathsForResourcesOfType:@"clr" inDirectory:@""] map:^id(id object) {
      return [NSColorList.alloc initWithName:[object baseName] fromFile:object];
    }]   mapToDictionaryKeys:^id(NSCL* list) {  return list.name; }].mC;
} /* AOK */ /* { Monaco = "NSColorList 0x7fab5ae49bb0 name:Monaco device:(null) file:/Volumes/4X4/DerivedData/AtoZ/Products/Debug/AtoZ.framework/Resources/Monaco.clr loaded:1";, ... } */

-  (NSC*) closestColorListColor                 {  //gross but works, restore
  if (!bestMatches) bestMatches = NSMD.new;
  if (!safe)      safe      = [NSColorList colorListNamed:@"Web Safe Colors"];
  //    if (!named)     named     = [AZNamedColors na];
  __block CGF bestDistance = FLT_MAX;
  NSC* best = [[NSA arrayWithArrays:@[safe.colors]] reduce:AZNULL withBlock:^id(id sum, NSC* aColor) {
    CGF contender = [self rgbDistanceTo:aColor];
    if ( contender < bestDistance ) { bestDistance = contender; sum = aColor; }
    return sum;
  }];
  if (best) bestMatches[self] = best;
  return best;
}
+  (NSA*)          colorsInListNamed:(NSS*)n { return [self.colorLists[n] colors]; } /*AOK same as ((id)NSC.class)[@"colorLists.flatui.colors"] */
+  (NSA*) colorsInFrameworkListNamed:(NSS*)n { return [self colorsInListNamed:n]; }
+  (NSA*) fengshui  { return [self colorsInListNamed:@"FengShui"].shuffeled; }
+  (NSA*) flatUI    { return [self colorsInListNamed:@"flatui"].shuffeled; }

#pragma mark - FACTORIES

+ (NSC*) colorWithString:(NSS*)name {   if (![name length]) return nil;   NSD* named; NSO *match;

  return ((named = [NSCL.namedColorDictionary objectForKey:name]) && (match = named[@"rgb"])) ?

  [self colorWithDeviceRed:[((NSA*)match)[0]fV] green:[((NSA*)match)[1]fV] blue:[((NSA*)match)[2]fV] alpha:1] :

  ((match = named[@"hex"])) ? [self colorWithHex:(NSS*)match] : nil;

//  NSArray *allNames = self.colorNames;
//  NSUI count = allNames.count;
//  NSUI   idx = [allNames indexOfObject:name.lowercaseString];
  // If the string contains some hex digits, try to convert #RRGGBB or #RRGGBBAA  rgb(r,g,b) or rgba(r,g,b,a)
//  return idx >= count ? ColorWithHexDigits(name) : ColorWithCSSString(name) ?: ColorWithUnsignedLong(sColorTable[idx].value, NO);
}
+ (NSC*) colorFromAZeColor:(AZeColor)c { return [self colorWithString:[AZeColorToString(c)stringByRemovingPrefix:@"AZeColor"].lowercaseString];
  //  return [self colorFromString:$UTF8(sColorTable[c])];
}
+ (NSC*) linen      {
  return [NSC colorWithPatternImage: [NSImage imageNamed:@"linen.png"]];
}
+ (NSC*) randomColor    {
  int red = rand() % 255; int green = rand() % 255; int blue = rand() % 255;
  return [NSC colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
+ (NSC*) randomLightColor   { return [RANDOMCOLOR colorWithBrightnessMultiplier:.9]; }
+ (NSC*) randomBrightColor  { NSC *c; while ( !(c = RANDOMCOLOR).isBright ) {}  return c; }
+ (NSC*) randomDarkColor    { NSC *c; while ( !(c = RANDOMCOLOR).isDark   ) {}  return c; }

+ (NSC*) linenTintedWithColor:     (NSC*)color {
  static NSIMG *theLinen = nil;  theLinen = theLinen ?: [NSImage imageNamed:@"linen.png"];
  return [NSC colorWithPatternImage:[theLinen tintedWithColor:color]];
}
+ (NSC*) leatherTintedWithColor:     (NSC*)color {
  return [NSC colorWithPatternImage:[[NSImage imageNamed:@"perforated_white_leather"]tintedWithColor:color]];
}
+ (NSC*) checkerboardWithFirstColor: (NSC*)one secondColor: (NSC*)two squareWidth:(CGF)x  {
  NSSize patternSize = NSMakeSize(x * 2.0, x * 2.0);
  NSRect rect = NSZeroRect;
  rect.size = patternSize;
  NSImage* pattern = [NSImage.alloc initWithSize: patternSize];
  rect.size = AZSizeFromDim(x);
  [pattern lockFocus];
  [one set];                      NSRectFill(rect);
  rect.origin.x = x;  rect.origin.y = x;  NSRectFill(rect);
  [two set];
  rect.origin.x = 0.0;  rect.origin.y = x;  NSRectFill(rect);
  rect.origin.x = x;  rect.origin.y = 0.0;  NSRectFill(rect);
  [pattern unlockFocus];
  return [NSC colorWithPatternImage: pattern];
}

#pragma mark - UNCATEGORIZED

+ (NSA*) gradientPalletteBetween:(NSC*)one c2:(NSC*)two steps:(NSUI)steps {
  CGF sr = one.redComponent, sg = one.greenComponent, sb = one.blueComponent;
  CGF er = two.redComponent, eg = two.greenComponent, eb = two.blueComponent;

  //  CGF (^percent)(int) = {step  * 100;//CGF index = 100 * percent;
  return [[@0 to:@(steps)]map:^id(id obj) {
    CGF count = 100;
    CGF index = ([obj fV]/steps) * 100;//CGF index = 100 * percent;
    int cutoff = 7;
    CGFloat delta =  count > cutoff ? delta = 1.0 / count : 1.0 / cutoff;
    count =  count > cutoff ? count : cutoff;
    CGFloat s = delta * (count - index);
    CGFloat e = delta * index;
    CGFloat red = sr * s + er * e;
    CGFloat green = sg * s + eg * e;
    CGFloat blue = sb * s + eb * e;
    return [NSC colorWithDeviceRed:red green:green blue:blue alpha:1];
  }];
}

//+ (NSD*) colorsAndNames {  return [NSD dictionaryWithObjects:self. forKeys:self.colorNames]; }
//+ (NSA*) colorsWithNames {  return [self.colorNames map:^id(id obj) {  return [self colorNamed:obj]; }]; }
//+ (NSC*) colorNamed:(NSS*) name {
//  if (![name length]) return nil;
  //  NSArray *allNames = [self colorNames];
  //  NSUInteger count = [allNames count];
  //  NSUInteger idx = [allNames indexOfObject:[name lowercaseString]];
  //  if (idx >= count) {
  // If the string contains some hex digits, try to convert
  // #RRGGBB or #RRGGBBAA
  // rgb(r,g,b) or rgba(r,g,b,a)
  //    NSC*color = ColorWithHexDigits(name);
  //    if (!color)
  //      color = ColorWithCSSString(name);
  //    return color;
  //  }
  //  return ColorWithUnsignedLong(sColorTable[idx].value, NO);
//}
+ (NSA*) boringColors{
  return  @[ @"White",  @"Whitesmoke",  @"Whitesmoke",@"Gainsboro", @"LightGrey", @"Silver",  @"DarkGray",  @"Gray",  @"DimGray", @"Black", @"Translucent", @"MistyRose", @"Snow",  @"SeaShell",  @"Linen", @"Cornsilk",  @"OldLace", @"FloralWhite", @"Ivory", @"HoneyDew",  @"MintCream", @"Azure", @"AliceBlue", @"GhostWhite",  @"LavenderBlush", @"mercury", @"Slver", @"Magnesium", @"Tin", @"Aluminum"];
}
+ (NSC*) randomOpaqueColor {  float c[4];
  c[0] = randomComponent(); c[1] = randomComponent(); c[2] = randomComponent(); c[3] = 1.0;
  return [NSC colorWithCalibratedRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
}
+ (void) drawColors:(NSA*)colors inRect:(NSR)r  {

  [[AZSizer forQuantity:colors.count inRect:r].rects eachWithIndex:^(NSVAL*obj, NSI idx) {
      NSRectFillWithColor(obj.rV, [colors normal:idx]);
  }];
  //  [AZGRAPHICSCTX state:^{
//  }];
}
+ (NSA*) randomColors:(NSUI)ct    { return [@(ct) mapTimes:^id(NSNumber *num) { return RANDOMCOLOR; }]; }

/*  NSColor: Instantiate from Web-like Hex RRGGBB string
 Original Source: <http://cocoa.karelia.com/Foundation_Categories/NSColor__Instantiat.m>
 (See copyright notice at <http://cocoa.karelia.com>) */
+ (NSC*) colorFromHexRGB:     (NSS*) inColorString  {
  NSS *cleansedstring = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
  NSC*result = nil; unsigned int colorCode = 0;   unsigned char redByte, greenByte, blueByte;
  if (nil != cleansedstring)  {
    NSScanner *scanner = [NSScanner scannerWithString:cleansedstring];
    (void) [scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte   = (unsigned char) (colorCode >> 16);
  greenByte = (unsigned char) (colorCode >> 8);
  blueByte  = (unsigned char) (colorCode);  // masks off high bits
  result = [NSC colorWithCalibratedRed:   (float)redByte  / 0xff
                       green: (float)greenByte/ 0xff
                        blue: (float)blueByte / 0xff
                       alpha:1.0];
  return result;
}
+ (NSC*) colorWithDeviceRGB:    (NSUI)hex         {
  hex &= 0xFFFFFF;
  NSUInteger red   = (hex & 0xFF0000) >> 16;
  NSUInteger green = (hex & 0x00FF00) >>  8;
  NSUInteger blue  =  hex & 0x0000FF;
  return [NSC colorWithDeviceRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}
+ (NSC*) colorWithCalibratedRGB:(NSUI)hex         {
  hex &= 0xFFFFFF;
  NSUInteger red   = (hex & 0xFF0000) >> 16;
  NSUInteger green = (hex & 0x00FF00) >>  8;
  NSUInteger blue  =  hex & 0x0000FF;
  return [NSC colorWithCalibratedRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha: 1.0];
}
+ (NSC*) colorWithRGB:        (NSUI)hex         { return [NSC colorWithCalibratedRGB:hex]; }
// NSS *hexColor = [color hexColor]
+ (NSC*) colorWithHex:        (NSS*) hexColor     {
  // Remove the hash if it exists
  hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
  int length = (int)[hexColor length];
  bool triple = (length == 3);
  NSMutableArray *rgb = NSMA.new;
  // Make sure the string is three or six characters long
  if (triple || length == 6) {
    CFIndex i = 0;    UniChar character = 0;    NSS *segment = @"";   CFStringInlineBuffer buffer;
    CFStringInitInlineBuffer((__bridge CFStringRef)hexColor, &buffer, CFRangeMake(0, length));
    while ((character = CFStringGetCharacterFromInlineBuffer(&buffer, i)) != 0 ) {
      if (triple) segment = [segment stringByAppendingFormat:@"%c%c", character, character];
      else segment = [segment stringByAppendingFormat:@"%c", character];
      if ((int)[segment length] == 2) {
        NSScanner *scanner = [NSScanner.alloc initWithString:segment];
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
    return [NSC colorWithCalibratedRed:[rgb[0] fV]   green:[rgb[1] fV]  blue:[rgb[2] fV]   alpha:1];
  }
  else {
    NSException* invalidHexException = [NSException exceptionWithName:@"InvalidHexException"             reason:@"Hex color not three or six characters excluding hash"          userInfo:nil];
    @throw invalidHexException;
  }
}
- (NSS*) crayonName                         {
  NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  CGFloat bestDistance = FLT_MAX;
  NSS *bestColorKey = nil;
  NSColorList *colors = [NSColorList colorListNamed:@"Crayons"];
  NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
  NSS *key = nil;
  while ((key = [enumerator nextObject])) {
    NSC*thatColor = [colors colorWithKey:key];
    thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat colorDistance = fabs([thisColor redComponent]   - [thatColor redComponent]);
    colorDistance += fabs([thisColor blueComponent]       - [thatColor blueComponent]);
    colorDistance += fabs([thisColor greenComponent]      - [thatColor greenComponent]);
    colorDistance = sqrt(colorDistance);
    if (colorDistance < bestDistance) { bestDistance = colorDistance; bestColorKey = key; }
  }
  bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
             localizedStringForKey:bestColorKey value:bestColorKey  table:@"Crayons"];
  return bestColorKey;
}
- (NSS*) pantoneName                      {
  NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  CGFloat bestDistance = FLT_MAX;
  NSS *bestColorKey = nil;
  NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];
  NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
  NSS *key = nil;
  while ((key = [enumerator nextObject])) {
    NSC*thatColor = [colors colorWithKey:key];
    thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat colorDistance = fabs([thisColor redComponent]   - [thatColor redComponent]);
    colorDistance += fabs([thisColor blueComponent]       - [thatColor blueComponent]);
    colorDistance += fabs([thisColor greenComponent]      - [thatColor greenComponent]);
    colorDistance = sqrt(colorDistance);
    if (colorDistance < bestDistance) { bestDistance = colorDistance; bestColorKey = key; }
  }
  //   [colors localizedS
  bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Crayons.clr"]
             localizedStringForKey:bestColorKey value:bestColorKey  table:@"Crayons"];
  return bestColorKey;
}
-  (CGF) rgbDistanceTo:       (NSC*)another       {
  NSC *rgbself, *rgbAnother; rgbself = self.deviceRGBColor; rgbAnother = another.deviceRGBColor;
  CGF   colorDistance  = fabs(rgbself.redComponent  - rgbAnother.redComponent  );
  colorDistance += fabs(rgbself.blueComponent   - rgbAnother.blueComponent );
  colorDistance += fabs(rgbself.greenComponent - rgbAnother.greenComponent);
  return sqrt(colorDistance);
}

//  self.colorLists[name] = colorListD[name] ?: [self.colorLists filterOne:^BOOL(id object) { return SameString(name,[(NSCL*)object name]);  }]; return palettesD[name] ? list.colors : nil;

+  (NSA*) allSystemColorNames                 { return [self.class systemColorNames]; } // BORING
+  (NSA*) systemColorNames { // ( "72.5-7", cyan, limegreen, 660033,  FF3399, alternateSelectedControlTextColor ) etc
  return [NSA arrayWithArrays:[NSCL.availableColorLists map:^id(NSCL* obj) {  return obj.allKeys; }]];
}
+  (NSA*) allColors                         {

  return  [NSA arrayWithArrays:[[[NSC vFKP:@"colorLists"]allValues]
                           map:^(NSCL *obj){ return obj.colors; }]];
}
+  (NSA*) allSystemColors                     { return [[self class] systemColors]; }
+  (NSA*) systemColors                      {

  return [NSA arrayWithArrays:[NSColorList.availableColorLists map:^id(NSCL* obj) {
    return [obj.allKeys map:^id(NSS *key) { NSC* c = [obj colorWithKey:key]; return !c.isBoring ? c : nil; }];
  }]];
}

+ (NSCL*) createColorlistWithColors:(NSA*)cs andNames:(NSA*)ns named:(NSS*)name {

  return [NSCL colorListWithColors:cs andNames:ns named:name];
//  NSColorList *testList = [NSColorList.alloc initWithName:name];
//  [cs each:^(id obj) {
//    [testList setColor: obj forKey: ns[[cs indexOfObject:obj]] ?: @"N/A"];
//  }];
//  return testList;
}

+ (void) logPalettes        {

/* FIX XOLUMNSWIDE
  [(NSO*)[[self.colorLists.allValues vFKP:@"name"] reduce:@"".mutableCopy withBlock:^id(id sum, id obj) {
    return sum = $(@"%@\n%@\n%@",sum, obj,
              [[NSC colorsInListNamed:obj] stringValueInColumnsCharWide:30]);
  }]log];
*/
  //  [self.colorLists each:^(id key, id value) { [[obj colors] each:^(NSC* color) { COLORLOG(color ?: nil, @"%@", color.name);

}
+ (NSC*) white:(CGF)percent             { return [self colorWithDeviceWhite:percent alpha:1]; }

+ (NSC*) white:(CGF)percent a:(CGF)alpha    { return [self colorWithDeviceWhite:percent alpha:alpha]; }
+ (NSA*) randomPalette                { return self.randomList.colors; }
+ (NSCL*) randomList                { return self.colorLists.randomValue; }
+ (NSC*)   crayonColorNamed:(NSS*)key     { return [[NSColorList colorListNamed:@"Crayons"] colorWithKey:key];  }
+ (NSArray*)allNamedColors { return [NSA arrayWithArrays:[NSCL.availableColorLists vFK:@"colors"]]; }

//  AZSTATIC_OBJ(NSD,allC,  each:^(id obj) {
//    [[obj allKeys] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, NSUInteger idx, BOOL *stop) {
//       colors[[key lowercaseString]] = [obj colorWithKey:key];
//    }];
//  }];
//  return (allC = [colors dictionaryByAddingEntriesFromDictionary:[AZNamedColors namedColors].dictionary]);

+ (NSC*)      colorWithName:(NSS*)colorName   { return self.allNamedColors[colorName.lowercaseString]; }
//  // name lookup
//  NSS *lcc = colorName.lowercaseString; __block NSC*match;
//  return [self.allNamedColors obj ]
//
////  [AZNamedColors.namedColors.dictionary dictionaryByAddingEntriesFromDictionary:
//    if ([key.lowercaseString isEqual:lcc]) {
//      return [list colorWithKey:key];
//    }
//  }
//  for (list in []) {
//    for (NSS *key in [list allKeys ]) {
//      if ([key.lowercaseString isEqual:lcc]) {
//        return [list colorWithKey:key];
//      }
//    }
//  }
//  return nil;
//}
+ (NSC*)    colorFromString:(NSS*)string    {
  if ([string hasPrefix:@"#"]) {
    return [NSC colorFromHexString:string];
  }
  // shifting operations
  NSRange shiftRange = [string rangeOfAny:@"<! <= << <> >> => !>".wordSet];
  if (shiftRange.location != NSNotFound) {
    CGFloat p = 0.5;
    // determine the first of the operations
    NSS *op = [string substringWithRange:shiftRange];
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
    NSS *head = [string substringToIndex:
             shiftRange.location];
    NSS *tail = [string substringFromIndex:
             shiftRange.location + shiftRange.length];
    NSC*first = head.trim.colorValue;
    NSC*second = tail.trim.colorValue;
    if (first != nil && second != nil) {
      return [first blendedColorWithFraction:p ofColor:second];
    }
    if (first != nil) {
      return first;
    }
    return second;
  }
  if ([string contains:@" "]) {
    //    NSS *head = nil, *tail = nil;
    //    list(&head, &tail) = string.decapitate;
    NSArray  *comps = string.decapitate;
    NSS *head = comps[0];
    NSS *tail = comps[1];
    //[[string stringByTrimmingCharactersInSet:
    //                   [NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString];
    NSC*tailColor = [NSC colorFromString:tail];
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
        return [tailColor colorWithAlphaComponent:head.popped.fV / 100.0];
      }
    }
  }
  if ([string contains:@","]) {
    NSS *comp = string;
    NSS *func = @"rgb";
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
      NSS *v = [vals[i] trim];
      if ([v hasSuffix:@"%"]) {
        values[i] = [[v substringBefore:@"%"] fV] / 100.0;
      } else {
        // should be a float
        values[i] = v.fV;
        if (values[i] > 1) {
          values[i] /= 255.0;
        }
      }
      values[i] = MIN(MAX(values[i], 0), 1);
    }
    if (vals.count <= 2) {
      // grayscale + alpha
      return [NSC colorWithDeviceWhite:values[0]
                        alpha:values[1]
            ];
    } else if (vals.count <= 5) {
      // rgba || hsba
      if ([func hasPrefix:@"rgb"]) {
        return [NSC colorWithDeviceRed:values[0]
                         green:values[1]
                          blue:values[2]
                         alpha:values[3]
              ];
      } else if ([func hasPrefix:@"hsb"]) {
        return [NSC colorWithDeviceHue:values[0]
                      saturation:values[1]
                      brightness:values[2]
                         alpha:values[3]
              ];
      } else if ([func hasPrefix:@"cmyk"]) {
        return [NSC colorWithDeviceCyan:values[0]
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
  return [NSC colorWithName:string];
}
+ (NSC*) colorFromHexString:(NSS*)hexString {
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
    NSS *sub = [hexString substringWithRange:NSMakeRange(i * mul, mul)];
    NSScanner *scanner = [NSScanner scannerWithString:sub];
    uint value = 0;
    [scanner scanHexInt: &value];
    v[i] = (float) value / (float) 0xFF;
  }
  // only at full color
  if (useHSB) {
    if (useCalibrated) {
      return [NSC colorWithCalibratedHue:v[0]
                      saturation:v[1]
                      brightness:v[2]
                          alpha:v[3]
            ];
    }
    return [NSC colorWithDeviceHue:v[0]
                  saturation:v[1]
                  brightness:v[2]
                     alpha:v[3]
          ];
  }
  if (useCalibrated) {
    return [NSC colorWithCalibratedRed:v[0]
                        green:v[1]
                        blue:v[2]
                        alpha:v[3]
          ];
  }
  return [NSC colorWithDeviceRed:v[0]
                   green:v[1]
                    blue:v[2]
                   alpha:v[3]
        ];
}
- (NSC*) closestWebColor              {
  NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  CGFloat bestDistance = FLT_MAX;
  NSC*bestColorKey = nil;
  NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
  NSEnumerator *enumerator = [[colors allKeys] objectEnumerator];
  NSS *key = nil;
  while ((key = [enumerator nextObject])) {
    NSC*thatColor = [colors colorWithKey:key];
    thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat colorDistance = fabs([thisColor redComponent]   - [thatColor redComponent]);
    colorDistance += fabs([thisColor blueComponent]       - [thatColor blueComponent]);
    colorDistance += fabs([thisColor greenComponent]      - [thatColor greenComponent]);
    colorDistance = sqrt(colorDistance);
    if (colorDistance < bestDistance) { bestDistance = colorDistance; bestColorKey = thatColor; }
  }
  //  bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
  //          localizedStringForKey:bestColorKey  value:bestColorKey  table:@"Crayons"];
  return bestColorKey;
}
- (NSC*)  deviceWhiteColor    {
  return [self colorUsingColorSpaceName:NSDeviceWhiteColorSpace];
}
- (NSC*)  deviceRGBColor    {
  return [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
}
- (NSC*) calibratedRGBColor {
  NSC* cali = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return cali;
}
- (NSS*) toHex            {
  CGFloat r,g,b,a;
  [[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
  int ri = r * 0xFF;
  int gi = g * 0xFF;
  int bi = b * 0xFF;
  return [[NSString stringWithFormat:@"%02x%02x%02x", ri, gi, bi] uppercaseString];
}
- (NSC*) closestNamedColor  {
  NSC*color = [self closestColorListColor];
  //   objectForKey:@"name"];// valueForKey:@"name"];
  return color;
}

/*
 + (BOOL) resolveClassMethod:(SEL)sel {

 if ([self.colorListNames containsObject:NSStringFromSelector(sel)])
 Class selfMetaClass = objc_getMetaClass([[self className] UTF8String]);
 class_addMethod([selfMetaClass, aSEL, (IMP) dynamicMethodIMP, "v@:");
 return YES;
 }
 return [super resolveClassMethod aSEL];
 class_addMethod(self.class, sel, (IMP) dynamicMethodIMP, "v@:");
 return YES;
 2009-10-19 | © 2009 Apple Inc. All Rights Reserved. 16
 ￼￼￼@dynamic propertyName;
 ￼
 void dynamicMethodIMP(id self, SEL _cmd) {
 // implementation ....
 }
 ￼￼￼￼
 Dynamic Method Resolution
 Dynamic Loading
 }
 return [super resolveInstanceMethod:aSEL];
 }
 */
- (NSS*) nameOfColor        { IF_RETURNIT(self.name); IF_RETURNIT(self[@"name"]);

//  if ([self hasAssociatedValueForKey:@"associatedName"]) return [self associatedValueForKey:@"associatedName"];

  //  NSC*color = [self closestColorListColor];
  //  NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
  //  NSColorList *bestList = nil;

  NSC  * __unused thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  CGF bestDistance = FLT_MAX;

  AZSTATIC_OBJ(NSArray,avail,({  NSCL* list = [NSCL colorListNamed:@"Classic Crayons"]?:[NSCL colorListNamed:@"Web Safe Colors"];

      list ? [list colors] : nil; }));   // NSCL,crayons,({  }));

  if (!avail) return nil; NSC * __unused bestColor = nil; NSS * bestKey = nil;

  for (__strong NSC *c in avail) {
//  for (NSColorList *list  in avail) {
//    NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
//    NSS *key = nil;
//    while ((key = [enumerator nextObject])) {
//      NSC*thatColor = [list colorWithKey:key];
      c = [c colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
      CGF
      colorDistance  = fabs(c.redComponent  - c.redComponent);
      colorDistance += fabs(c.blueComponent   - c.blueComponent);
      colorDistance += fabs(c.greenComponent  - c.greenComponent);
      colorDistance  = sqrt(colorDistance);
      if (colorDistance < bestDistance) {    // bestList  = list;
        bestDistance = colorDistance;        // bestColor = thatColor;
        bestKey = [c name];
      } // key; }
    }
//  }
  //  bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
  //          localizedStringForKey:bestColorKey  value:bestColorKey  table:@"Crayons"];
  return bestKey;//, @"color", bestKey, @"key", bestList, @"list");
}
// Convenienct Methods to mess a little with the color values



-  (CGF) luminance        {
  CGFloat r, g, b, a;
  [[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
  // 0.3086 + 0.6094 + 0.0820 = 1.0
  return (0.3086f*r) + (0.6094f*g) + (0.0820f*b);
}
-  (CGF) relativeBrightness   {
  CGFloat r, g, b, a;
  [[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
  return sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
}
- _IsIt_ isBright         {
  return self.relativeBrightness > 0.57;
}
- (NSC*) bright           {
  return [NSC colorWithDeviceHue:self.hueComponent
                saturation:0.3
                brightness:1.0
                   alpha:self.alphaComponent];
}
- (NSC*) brighter         { CGFloat h,s,b,a;

  [self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSC colorWithDeviceHue:h
                saturation:s
                brightness:MIN(1.0, MAX(b * 1.10, b + 0.05))
                   alpha:a];
}
- (NSC*) darker           {
  CGFloat h,s,b,a;
  [self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSC colorWithDeviceHue:h
                saturation:s
                brightness:MAX(0.0, MIN(b * 0.9, b - 0.05))
                   alpha:a];
}
- (NSC*) muchDarker         {
  CGFloat h,s,b,a;
  [[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSC colorWithDeviceHue:h
                saturation:s
                brightness:MAX(0.0, MIN(b * 0.7, b - 0.1))
                   alpha:a];
}
- _IsIt_ isDark           {
  return self.relativeBrightness < 0.42;
}
- (NSC*) dark             {
  return [NSC colorWithDeviceHue:self.hueComponent
                saturation:0.8
                brightness:0.3
                   alpha:self.alphaComponent];
}
- (NSC*) redshift         {
  CGFloat h,s,b,a;
  [self.deviceRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  h += h > 0.5 ? 0.1 : -0.1;
  if (h < 1) {
    h++;
  } else if (h > 1) {
    h--;
  }
  return [NSC colorWithDeviceHue:h saturation:s brightness:b alpha:a];
}
- (NSC*) blueshift        {
  CGFloat c = self.hueComponent;
  c += c < 0.5 ? 0.1 : -0.1;
  return [NSC colorWithDeviceHue:c
                saturation:self.saturationComponent
                brightness:self.brightnessComponent
                   alpha:self.alphaComponent];
}
- (NSC*) blend:(NSC*)other  {
  return [self blendedColorWithFraction:0.5 ofColor:other];
}
- (NSC*) whitened         {
  return [self blend:NSColor.whiteColor];
}
- (NSC*) blackened        {
  return [self blend:NSColor.blackColor];
}
- (NSC*) contrastingForegroundColor {
  NSC*c = self.calibratedRGBColor;
  if (!c) {
    NSLog(@"Cannot create contrastingForegroundColor for color %@", self);
    return NSColor.blackColor;
  }
  if (!c.isBright) {
    return NSColor.whiteColor;
  }
  return NSColor.blackColor;
}
- (NSC*) complement         {
  NSC*c = self.colorSpaceName == NSPatternColorSpace ? [self.patternImage quantize][0] : self.calibratedRGBColor;
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
  NSC *newish =   [NSC colorWithDeviceHue:h saturation:s  brightness:b alpha:a];
  return self.colorSpaceName == NSPatternColorSpace ? [NSC colorWithPatternImage:[self.patternImage tintedWithColor:newish]]: newish;
}
- (NSC*) rgbComplement      {
  NSC*c = self.calibratedRGBColor;
  if (!c) {
    NSLog(@"Cannot create complement for color %@", self);
    return self;
  }
  CGFloat r,g,b,a;
  [c getRed:&r green:&g blue:&b alpha:&a];
  return [NSC colorWithDeviceRed:1.0 - r
                   green:1.0 - g
                    blue:1.0 - b
                   alpha:a];
}
// convenience for alpha shifting
- (NSC*) opaque           {
  return [self colorWithAlphaComponent:1.0];
}
- (NSC*) lessOpaque         {
  return [self colorWithAlphaComponent:MAX(0.0, self.alphaComponent * 0.8)];
}
- (NSC*) moreOpaque         {
  return [self colorWithAlphaComponent:MIN(1.0, self.alphaComponent / 0.8)];
}
- (NSC*) translucent      {
  return [self colorWithAlphaComponent:0.65];
}
- (NSC*) watermark        {
  return [self colorWithAlphaComponent:0.25];
}
// comparison methods
- (NSC*) rgbDistanceToColor:(NSC*)color {
  if (!color) {
    return nil;
  }
  CGFloat mr,mg,mb,ma, orr,og,ob,oa;
  [self.calibratedRGBColor  getRed:&mr green:&mg blue:&mb alpha:&ma];
  [color.calibratedRGBColor getRed:&orr green:&og blue:&ob alpha:&oa];
  return [NSC colorWithCalibratedRed:ABS(mr - orr)
                      green:ABS(mg - og)
                      blue:ABS(mb - ob)
                      alpha:ABS(ma - oa)
        ];
}
- (NSC*) colorWithSaturation:(CGF)sat brightness:(CGF)bright {
  return [NSC colorWithDeviceHue:self.hueComponent saturation:sat brightness:bright alpha:self.alphaComponent];
}
- (NSC*) hsbDistanceToColor:(NSC*)color {
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
  return [NSC colorWithCalibratedHue:hd
                  saturation:ABS(ms - os)
                  brightness:ABS(mb - ob)
                      alpha:ABS(ma - oa)
        ];
}
-  (CGF) rgbWeight {
  CGFloat r,g,b,a;
  [self.calibratedRGBColor getRed:&r green:&g blue:&b alpha:&a];
  return (r + g + b) / 3.0;
}
-  (CGF) hsbWeight {
  CGFloat h,s,b,a;
  [self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  return (h + s + b) / 3.0;
}
- _IsIt_ isBlueish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return b - MAX(r,g) > 0.2;
}
- _IsIt_ isRedish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return r - MAX(b,g) > 0.2;
}
- _IsIt_ isGreenish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return g - MAX(r,b) > 0.2;
}
- _IsIt_ isYellowish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return ABS(r - g) < 0.1 && MIN(r,g) - b > 0.2;
}
@end
@implementation NSCoder (AGCoder)

- (void) encode: me withKeys:(NSA*)ks {  [self encode:me withKeysForProps:[NSD dictionaryWithObjects:ks forKeys:ks]]; }
- (void) encode: me withKeysForProps:(NSD*)ksAndDs { [ksAndDs each:^(id key, id prop) { id x = [me vFK:key]; !x ?: [self encodeObject:x forKey:prop]; }]; }
- (void) decode: me withKeysForProps:(NSD*)ksAndDs { [ksAndDs each:^(id key, id prop) { id x = [self decodeObjectForKey:key]; !x ?: [me sV:x fK:prop]; }]; }
- (void) decode: me withKeys:(NSA*)ks { [self decode:me withKeysForProps:[NSD dictionaryWithObjects:ks forKeys:ks]]; }
+ (void) encodeColor:(CGColorRef)theColor  withCoder:(NSCoder*)encoder withKey:(NSS*)theKey {
  if(theColor != nil) {
    const CGFloat* components = CGColorGetComponents(theColor);
    [encoder encodeFloat:components[0] forKey:[NSString stringWithFormat:@"%@.red", theKey]];
    [encoder encodeFloat:components[1] forKey:[NSString stringWithFormat:@"%@.green", theKey]];
    [encoder encodeFloat:components[2] forKey:[NSString stringWithFormat:@"%@.blue", theKey]];
    [encoder encodeFloat:components[3] forKey:[NSString stringWithFormat:@"%@.alpha", theKey]];
  } else  {   // Encode nil as NSNull
    [encoder encodeObject:[NSNull null] forKey:theKey];
  }
}
@end

@implementation NSColor (Utilities)
+   (NSA*) calveticaPalette                   {
  return @[CV_PALETTE_1, CV_PALETTE_2, CV_PALETTE_3, CV_PALETTE_4, CV_PALETTE_5, CV_PALETTE_6, CV_PALETTE_7, CV_PALETTE_8, CV_PALETTE_9, CV_PALETTE_10, CV_PALETTE_11, CV_PALETTE_12, CV_PALETTE_13, CV_PALETTE_14, CV_PALETTE_15, CV_PALETTE_16, CV_PALETTE_17, CV_PALETTE_18, CV_PALETTE_19, CV_PALETTE_20, CV_PALETTE_21];
}
-   (NSC*) closestColorInCalveticaPalette         {
  return [self closestColorInPalette:[NSC calveticaPalette]];
}
-   (NSC*) closestColorInPalette:(NSA*)palette  {

  //  UIColor+Utilities.m  ColorAlgorith  Created by Quenton Jones on 6/11/11.

  CGF bestDifference = MAXFLOAT;
  NSC*bestColor = nil;
  CGF *lab1 = [self colorToLab];
  CGF C1 = sqrtf(lab1[1] * lab1[1] + lab1[2] * lab1[2]);
  for (NSC*color in palette) {
    CGF *lab2 = [color colorToLab];
    CGF C2 = sqrtf(lab2[1] * lab2[1] + lab2[2] * lab2[2]);
    CGF deltaL = lab1[0] - lab2[0];
    CGF deltaC = C1 - C2;
    CGF deltaA = lab1[1] - lab2[1];
    CGF deltaB = lab1[2] - lab2[2];
    CGF deltaH = sqrtf(deltaA * deltaA + deltaB * deltaB - deltaC * deltaC);
    CGF deltaE = sqrtf(powf(deltaL / K_L, 2) + powf(deltaC / (1 + K_1 * C1), 2) + powf(deltaH / (1 + K_2 * C1), 2));
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
- (CGF*) colorToLab                       {
  // Don't allow grayscale colors.
  if (CGColorGetNumberOfComponents(self.CGColor) != 4) {
    return nil;
  }
  CGF *rgb = (CGF *)malloc(3 * sizeof(CGF));
  const CGFloat *components = CGColorGetComponents(self.CGColor);
  rgb[0] = components[0];
  rgb[1] = components[1];
  rgb[2] = components[2];
  //NSLog(@"Color (RGB) %@: r: %i g: %i b: %i", self, (int)(rgb[0] * 255), (int)(rgb[1] * 255), (int)(rgb[2] * 255));
  CGF *lab = [NSC rgbToLab:rgb];
  free(rgb);
  //NSLog(@"Color (Lab) %@: L: %f a: %f b: %f", self, lab[0], lab[1], lab[2]);
  return lab;
}
+ (CGF*) rgbToLab:(CGF*)rgb {
  CGF *xyz = [NSC rgbToXYZ:rgb];
  CGF *lab = [NSC xyzToLab:xyz];
  free(xyz);
  return lab;
}
+ (CGF*) rgbToXYZ:(CGF*)rgb {
  CGF *newRGB = (CGF *)malloc(3 * sizeof(CGF));
  for (int i = 0; i < 3; i++) {
    CGF component = rgb[i];
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
  CGF *xyz = (CGF *)malloc(3 * sizeof(CGF));
  xyz[0] = (newRGB[0] * 0.4124f) + (newRGB[1] * 0.3576f) + (newRGB[2] * 0.1805f);
  xyz[1] = (newRGB[0] * 0.2126f) + (newRGB[1] * 0.7152f) + (newRGB[2] * 0.0722f);
  xyz[2] = (newRGB[0] * 0.0193f) + (newRGB[1] * 0.1192f) + (newRGB[2] * 0.9505f);
  free(newRGB);
  return xyz;
}
+ (CGF*) xyzToLab:(CGF*)xyz {
  CGF *newXYZ = (CGF *)malloc(3 * sizeof(CGF));
  newXYZ[0] = xyz[0] / X_REF;
  newXYZ[1] = xyz[1] / Y_REF;
  newXYZ[2] = xyz[2] / Z_REF;
  for (int i = 0; i < 3; i++) {
    CGF component = newXYZ[i];
    if (component > 0.008856) {
      component = powf(component, 0.333f);
    } else {
      component = (7.787 * component) + (16 / 116);
    }
    newXYZ[i] = component;
  }
  CGF *lab = (CGF *)malloc(3 * sizeof(CGF));
  lab[0] = (116 * newXYZ[1]) - 16;
  lab[1] = 500 * (newXYZ[0] - newXYZ[1]);
  lab[2] = 200 * (newXYZ[1] - newXYZ[2]);
  free(newXYZ);
  return lab;
}
@end



@implementation NSString (THColorConversion)
- (NSC*) colorValue                   {
  return [NSC colorFromString:self];
}
- (DTA*) colorData                    {
  NSData *theData=[NSArchiver archivedDataWithRootObject:self];
  return theData;
}
+ (NSC*) colorFromData:(NSData*)theD  { return [NSUnarchiver unarchiveObjectWithData:theD]; }
@end


@interface NSColor (AMAdditions_AppKitPrivate)
+ (NSC*) toolTipColor;
+ (NSC*) toolTipTextColor;
@end

@implementation NSColor (AMAdditions)
+ (NSC*) lightYellowColor     {
  return [NSColor colorWithCalibratedHue:0.2 saturation:0.2 brightness:1.0 alpha:1.0];
}
+ (NSC*) am_toolTipColor      {
  NSColor *result;
  if ([NSColor respondsToSelector:@selector(toolTipColor)]) {
    result = [NSColor toolTipColor];
  } else {
    result = [NSColor lightYellowColor];
  }
  return result;
}
+ (NSC*) am_toolTipTextColor  {
  NSColor *result;
  if ([NSColor respondsToSelector:@selector(toolTipTextColor)]) {
    result = [NSColor toolTipTextColor];
  } else {
    result = [NSColor blackColor];
  }
  return result;
}
- (NSC*) accentColor     {
  NSColor *result;
  CGFloat hue;
  CGFloat saturation;
  CGFloat brightness;
  CGFloat alpha;
  [[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
  if (brightness <= 0.3) {
    [[[NSColor colorForControlTint:[NSColor currentControlTint]] colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    saturation = 1.0;
    brightness = 1.0;
  } else {
    //if (saturation > 0.3) {
    brightness = brightness/2.0;
    //}
    saturation = 1.0;
  }
  result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
  return result;
}
- (NSC*) lighterColor    {
  NSColor *result;
  CGFloat hue;
  CGFloat saturation;
  CGFloat brightness;
  CGFloat alpha;
  [[self  colorUsingColorSpaceName:NSDeviceRGBColorSpace] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
  if (brightness > 0.4) {
    if (brightness < 0.90) {
      brightness += 0.1+(brightness*0.3);
    } else {
      brightness = 1.0;
      if (saturation > 0.12) {
        saturation = MAX(0.0, saturation-0.1-(saturation/2.0));
      } else {
        saturation += 0.25;
      }
    }
  } else {
    brightness = 0.6;
  }
  result = [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha];
  return result;
}
- (NSC*) disabledColor   {
  int alpha = [self alphaComponent];
  return [self colorWithAlphaComponent:alpha*0.5];
}

@end

#define COLOR_COMPONENT_SCALE_FACTOR 255.0f
#define COMPONENT_DOMAIN_DEGREES 60.0f
#define COMPONENT_MAXIMUM_DEGREES 360.0f
#define COMPONENT_OFFSET_DEGREES_GREEN 120.0f
#define COMPONENT_OFFSET_DEGREES_BLUE 240.0f
#define COMPONENT_PERCENTAGE 100.0f

/* 

@implementation NSColor (HSVExtras) // NSColor+HSVExtras.m MMPieChart Demo

- (RgbColor) rgbColor { return [NSC rgbColorFromColor:self]; }
- (HsvColor) hsvColor { return [NSC hsvColorFromColor:self]; }

+ (HsvColor)    hsvColorFromColor:(NSC*)color {

  return [self hsvColorFromRgbColor:[self rgbColorFromColor:color]];
}
+ (RgbColor)    rgbColorFromColor:(NSC*)color {

    const CGF *colorComponents  = CGColorGetComponents(color.CGColor);
    return (RgbColor){(int)colorComponents[0] * COLOR_COMPONENT_SCALE_FACTOR,
                      (int)colorComponents[1] * COLOR_COMPONENT_SCALE_FACTOR,
                      (int)colorComponents[2] * COLOR_COMPONENT_SCALE_FACTOR,
                           colorComponents[0],
                           colorComponents[1],
                           colorComponents[2] };
}
+ (HsvColor) hsvColorFromRgbColor:(RgbColor)color { HsvColor hsvColor;
    
    CGF maximumValue = MAX(color.r, color.g); maximumValue = MAX(maximumValue, color.b);
    CGF minimumValue = MIN(color.r, color.g); minimumValue = MIN(minimumValue, color.b);

    CGF range = maximumValue - minimumValue; hsvColor.hueValue = 0;

    if (maximumValue == minimumValue) {} /// continue

    else if (maximumValue == color.r) {
        hsvColor.hueValue = (int)roundf(COMPONENT_DOMAIN_DEGREES * (color.g - color.b) / range);
        if (hsvColor.hueValue < 0) hsvColor.hueValue += COMPONENT_MAXIMUM_DEGREES;
    }
    else if (maximumValue == color.g)
        hsvColor.hueValue = (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.b - color.r) / range)
                                        + COMPONENT_OFFSET_DEGREES_GREEN));
    else if (maximumValue == color.b)
        hsvColor.hueValue = (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.r - color.g) / range)
                                        + COMPONENT_OFFSET_DEGREES_BLUE));
    
    hsvColor.saturationValue = 0;
    if (!maximumValue) {  } /// continue

    else hsvColor.saturationValue = (int)roundf(((1.0f - (minimumValue / maximumValue)) * COMPONENT_PERCENTAGE));
    
    hsvColor.brightnessValue      = (int)roundf((maximumValue * COMPONENT_PERCENTAGE));
    
    hsvColor.hue        = (CGF)hsvColor.hueValue        / COMPONENT_MAXIMUM_DEGREES;
    hsvColor.saturation = (CGF)hsvColor.saturationValue / COMPONENT_PERCENTAGE;
    hsvColor.brightness = (CGF)hsvColor.brightnessValue / COMPONENT_PERCENTAGE;
    
    return hsvColor;
}

- _IsIt_ canProvideRGBComponents {  CGColorSpaceModel ref = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));

  return (ref == kCGColorSpaceModelRGB || ref == kCGColorSpaceModelMonochrome);
}

- (CGF) red    { NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -red");  const CGFloat *c = CGColorGetComponents(self.CGColor);	return c[0]; }
- (CGF) green  {	NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -green");	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome ? c[0] :	c[1];
}
- (CGF) blue   { NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -blue"); const CGFloat *c = CGColorGetComponents(self.CGColor);
  return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome ? c[0] : c[2];
}
- (CGF) white  {	NSAssert(CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);	return c[0];
}

- (CGF) alpha       {	return CGColorGetAlpha(self.CGColor);                 }
- (CGF) hue         { return [NSColor hsvColorFromColor:self].hue;          }
- (CGF) saturation  { return [NSColor hsvColorFromColor:self].saturation;   }
- (CGF) brightness  { return [NSColor hsvColorFromColor:self].brightness;   }
- (CGF) value       {	return self.brightness;                               }


@end
*/

#ifdef php
function swatch() { $r = ceil(rand(0,255));    $g = ceil(rand(0,255));    $b = ceil(rand(0,255));    return array($r,$g,$b); } //Return an RGB array
$s = array(); for($i=0; $i<400; $i++) { list($r,$g,$b) = swatch(); $s[] = rgbtohsv($r,$g,$b); }//Create an array of random RGB colours converted to HSV
foreach($s as $k => $v) { $hue[$k] = $v[0];$sat[$k] = $v[1]; $val[$k] = $v[2];} //Split each array up into H, S and V arrays
array_multisort($hue,SORT_ASC, $sat,SORT_ASC, $val,SORT_ASC,$s); //Sort in ascending order by H, then S, then V and recompile the array
//Display
foreach($s as $k => $v) { list($hue,$sat,$val) = $v; list($r,$g,$b) = hsvtorgb($hue,$sat,$val); echo "<div style='border:1px solid #000;padding:4px;background:rgb($r,$g,$b);'>$r,$g,$b</div>"; }
#endif


/*!

 #define _COLOR(V, N) \
 [self setColor :[@"#" stringByAppendingString : @#V].colorValue \
 forKey : @#N]
 // _COLOR(FFFFFF00, Transparent);
 _COLOR(F0F8FF, AliceBlue);
 _COLOR(FAEBD7, AntiqueWhite);
 _COLOR(AFB837, AppleGreen);
 _COLOR(00FFFF, Aqua);
 _COLOR(7FFFD 4, Aquamarine);
 _COLOR(F0FFFF, Azure);
 _COLOR(F5F5DC, Beige);
 _COLOR(FFE4C4, Bisque);
 _COLOR(000000, Black);
 _COLOR(FFEBCD, BlanchedAlmond);
 _COLOR(0000FF, Blue);
 _COLOR(8A2BE2, BlueViolet);
 _COLOR(A52A2A, Brown);
 _COLOR(DEB887, BurlyWood);
 _COLOR(5F 9EA0, CadetBlue);
 _COLOR(7FFF 00, Chartreuse);
 _COLOR(D2691E, Chocolate);
 _COLOR(FF7F50, Coral);
 _COLOR(6495ED, CornflowerBlue);
 _COLOR(FFF8DC, Cornsilk);
 _COLOR(DC143C, Crimson);
 _COLOR(00FFFF, Cyan);
 _COLOR(0000 8B, DarkBlue);
 _COLOR(00 8B8B, DarkCyan);
 _COLOR(B8860B, DarkGoldenRod);
 _COLOR(A9A9A9, DarkGray);
 _COLOR(006400, DarkGreen);
 _COLOR(BDB76B, DarkKhaki);
 _COLOR(8B008B, DarkMagenta);
 _COLOR(556B2F, DarkOliveGreen);
 _COLOR(FF8C00, Darkorange);
 _COLOR(9932CC, DarkOrchid);
 _COLOR(8B0000, DarkRed);
 _COLOR(E9967A, DarkSalmon);
 _COLOR(8FBC8F, DarkSeaGreen);
 _COLOR(483D 8B, DarkSlateBlue);
 _COLOR(2F 4F 4F, DarkSlateGray);
 _COLOR(00CED1, DarkTurquoise);
 _COLOR(9400D 3, DarkViolet);
 _COLOR(FF1493, DeepPink);
 _COLOR(00BFFF, DeepSkyBlue);
 _COLOR(696969, DimGray);
 _COLOR(1E90FF, DodgerBlue);
 _COLOR(B22222, FireBrick);
 _COLOR(FFFAF0, FloralWhite);
 _COLOR(228B22, ForestGreen);
 _COLOR(FF00FF, Fuchsia);
 _COLOR(DCDCDC, Gainsboro);
 _COLOR(F8F8FF, GhostWhite);
 _COLOR(FFD700, Gold);
 _COLOR(DAA520, GoldenRod);
 _COLOR(808080, Gray);
 _COLOR(00 8000, Green);
 _COLOR(ADFF2F, GreenYellow);
 _COLOR(F0FFF0, HoneyDew);
 _COLOR(FF69B4, HotPink);
 _COLOR(CD5C5C, IndianRed);
 _COLOR(4B0082, Indigo);
 _COLOR(FFFFF0, Ivory);
 _COLOR(F0E68C, Khaki);
 _COLOR(E6E6FA, Lavender);
 _COLOR(FFF0F5, LavenderBlush);
 _COLOR(7CFC00, LawnGreen);
 _COLOR(FFFACD, LemonChiffon);
 _COLOR(ADD8E6, LightBlue);
 _COLOR(F08080, LightCoral);
 _COLOR(E0FFFF, LightCyan);
 _COLOR(FAFAD2, LightGoldenRodYellow);
 _COLOR(D3D3D3, LightGrey);
 _COLOR(90EE90, LightGreen);
 _COLOR(FFB6C1, LightPink);
 _COLOR(FFA07A, LightSalmon);
 _COLOR(20B2AA, LightSeaGreen);
 _COLOR(87CEFA, LightSkyBlue);
 _COLOR(778899, LightSlateGray);
 _COLOR(B0C4DE, LightSteelBlue);
 _COLOR(FFFFE0, LightYellow);
 _COLOR(00FF 00, Lime);
 _COLOR(32CD32, LimeGreen);
 _COLOR(FAF0E6, Linen);
 _COLOR(FF00FF, Magenta);
 _COLOR(800000, Maroon);
 _COLOR(66CDAA, MediumAquaMarine);
 _COLOR(0000CD, MediumBlue);
 _COLOR(BA55D3, MediumOrchid);
 _COLOR(9370D 8, MediumPurple);
 _COLOR(3CB371, MediumSeaGreen);
 _COLOR(7B68EE, MediumSlateBlue);
 _COLOR(00FA9A, MediumSpringGreen);
 _COLOR(48D 1CC, MediumTurquoise);
 _COLOR(C71585, MediumVioletRed);
 _COLOR(191970, MidnightBlue);
 _COLOR(F5FFFA, MintCream);
 _COLOR(FFE4E1, MistyRose);
 _COLOR(FFE4B5, Moccasin);
 _COLOR(FFDEAD, NavajoWhite);
 _COLOR(0000 80, Navy);
 _COLOR(FDF5E6, OldLace);
 _COLOR(808000, Olive);
 _COLOR(6B8E23, OliveDrab);
 _COLOR(FFA500, Orange);
 _COLOR(FF4500, OrangeRed);
 _COLOR(DA70D6, Orchid);
 _COLOR(EEE8AA, PaleGoldenRod);
 _COLOR(98FB98, PaleGreen);
 _COLOR(AFEEEE, PaleTurquoise);
 _COLOR(D87093, PaleVioletRed);
 _COLOR(FFEFD5, PapayaWhip);
 _COLOR(FFDAB9, PeachPuff);
 _COLOR(CD853F, Peru);
 _COLOR(FFC0CB, Pink);
 _COLOR(DDA0DD, Plum);
 _COLOR(B0E0E6, PowderBlue);
 _COLOR(800080, Purple);
 _COLOR(FF0000, Red);
 _COLOR(BC8F8F, RosyBrown);
 _COLOR(4169E1, RoyalBlue);
 _COLOR(8B4513, SaddleBrown);
 _COLOR(FA8072, Salmon);
 _COLOR(F4A460, SandyBrown);
 _COLOR(2E8B57, SeaGreen);
 _COLOR(FFF5EE, SeaShell);
 _COLOR(A0522D, Sienna);
 _COLOR(C0C0C0, Silver);
 _COLOR(87CEEB, SkyBlue);
 _COLOR(6A5ACD, SlateBlue);
 _COLOR(708090, SlateGray);
 _COLOR(FFFAFA, Snow);
 _COLOR(00FF 7F, SpringGreen);
 _COLOR(4682B4, SteelBlue);
 _COLOR(D2B48C, Tan);
 _COLOR(00 8080, Teal);
 _COLOR(D8BFD8, Thistle);
 _COLOR(FF6347, Tomato);
 _COLOR(40E0D 0, Turquoise);
 _COLOR(EE82EE, Violet);
 _COLOR(F5DEB3, Wheat);
 _COLOR(FFFFFF, White);
 _COLOR(F5F5F5, WhiteSmoke);
 _COLOR(FFFF00, Yellow);
 _COLOR(9ACD32, YellowGreen);
 #undef _COLOR
 }
 - init {
 if (instance != nil) {
 [NSException
 raise:NSInternalInconsistencyException
 format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
 [self className],
 NSStringFromSelector(_cmd),
 [self className],
 NSStringFromSelector(@selector(instance))
 ];
 } else if ((self = [super init])) {
 instance = self;
 [self _initColors];
 }
 return instance;
 }
 + (NSS*)nameOfColor:(NSColor *)color {
 return [self nameOfColor:color savingDistance:nil];
 }
 + (NSS*)nameOfColor:(NSColor *)color savingDistance:(NSColor **)distance {
 if (!color)
 // failsave return
 return nil;
 NSColorList *list = [self namedColors];
 NSString *re = nil;
 // min distance color
 NSColor *mdc = nil;
 // min distance value
 CGFloat mdv = 1.0;
 for (NSString *key in [list allKeys]) {
 NSColor *c = [list colorWithKey:key];
 NSColor *cd = [c hsbDistanceToColor:color];
 CGFloat dv = cd.hsbWeight;
 if (dv < mdv) {
 mdv = dv;
 mdc = cd;
 re = key;
 if (dv == 0)
 break;
 }
 }
 if (distance)
 *distance = mdc;
 return re;
 }
 
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)selector { //look up method signature
  NSMethodSignature *signature = [super methodSignatureForSelector:selector];  if (!signature)
    if ([NSA.class instancesRespondToSelector:selector])signature = [class instanceMethodSignatureForSelector:selector];
  return signature;
}
- (void) orwardInvocation:(NSInvocation *)invocation{ [invocation invokeWithTarget:nil]; }

  + dictionaryWithContentsOfRGBTxtFile:(NSS*) path

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
 NSMutableDictionary *mutableDict = @{}.mutableCopy;
 for (unsigned i = 0; i < length; ++i) {
 if (state.inComment) {
 if (ch[i] == '\n') state.inComment = NO;
 } else if (ch[i] == '\n') {
 if (state.prevChar != '\n') { //ignore blank lines
 if ( ! ((state.redStart   != NULL)
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
 NSS *name = [NSString stringWithData:[data subdataWithRange:range] encoding:NSUTF8StringEncoding];
 NSC*color = [NSColor colorWithCalibratedRed:state.red
 green:state.green
 blue:state.blue
 alpha:1.0f];
 [mutableDict setObject:color forKey:name];
 NSS *lowercaseName = [name lowercaseString];
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
 result = [self.alloc initWithDictionary:mutableDict];
 end:
 return result;
 }//@end

 @implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
 + colorWithHTMLString:(NSS*) str                     {
 return [self colorWithHTMLString:str defaultColor:nil];
 }
 / * !
 * @brief Convert one or two hex characters to a float
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0. * /
 static CGF hexCharsToFloat ( char firstChar, char secondChar )     {
 CGFloat        hexValue;
 NSUInteger   firstDigit;
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
 + colorWithHTMLString:(NSS*) str defaultColor:(NSC*)defaultColor {
 if (!str) return defaultColor;
 NSUInteger strLength = [str length];
 NSS *colorValue = str;
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
 red = [[colorComponents objectAtIndex:0] fV];
 green = [[colorComponents objectAtIndex:1] fV];
 blue = [[colorComponents objectAtIndex:2] fV];
 if ([colorComponents count] == 4)
 alpha = [[colorComponents objectAtIndex:3] fV];
 return [NSC colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
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
 CGFloat    red,green,blue;
 CGFloat    alpha = 1.0f;
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
 // c = (x * 0x10 + y) / 0xff
 //for a short component c = 'x':
 // c = x / 0xf
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
 
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace]; NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];  NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 //- (NSC*)closestColorListColor {
 // __block NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 // __block CGFloat bestDistance = FLT_MAX;
 //// NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
 //// NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 // NSArray *avail = $array(colors);//, crayons);
 // NSColorList *bestList = nil;
 __block NSC*bestColor = nil;
 // __block NSS *bestKey = nil;
 // for (NSColorList *list  in avail) {
 //   NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 //   NSS *key = nil;
 //   while ((key = [enumerator nextObject])) {
 [[[NSColorList  colorListNamed:@"Web Safe Colors"] allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 NSC*thatColor = [[[NSColorList colorListNamed:@"Web Safe Colors"] colorWithKey:obj]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 if (![thatColor isBoring]) {
 //     thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance =
 fabs([thisColor redComponent]  - [thatColor redComponent]);
 colorDistance += fabs([thisColor blueComponent]  - [thatColor blueComponent]);
 colorDistance += fabs([thisColor greenComponent] - [thatColor greenComponent]);
 colorDistance = sqrt(colorDistance);
 if (colorDistance < bestDistance) {
 //       bestList = list;
 bestDistance = colorDistance;
 bestColor = thatColor;
 //       bestKey = obj;
 }
 }
 // }];
 // bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //         localizedStringForKey:bestColorKey  value:bestColorKey  table:@"Crayons"];
 return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
 }
 NSCL *clist = [[self colorsInListNamed:name] filterOne:^BOOL(NSCL* list) { return Same(list.name, name); }];
 return [clist.allKeys map:^id(id obj) {
 NSC* c = [[clist colorWithKey:obj] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
 c.name = obj; return c;
 }];
 }();
 - (NSC*)closestColorListColor {
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat bestDistance = FLT_MAX;
 NSColorList *colors = [NSColorList colorListNamed:@"Web Safe Colors"];
 NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 NSArray *avail = $array(colors, crayons);
 // NSColorList *bestList = nil;
 NSC*bestColor = nil;
 NSS *bestKey = nil;
 for (NSColorList *list  in avail) {
 NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 NSS *key = nil;
 while ((key = [enumerator nextObject])) {
 NSC*thatColor = [list colorWithKey:key];
 thatColor = [thatColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance =
 fabs([thisColor redComponent]  - [thatColor redComponent]);
 colorDistance += fabs([thisColor blueComponent]  - [thatColor blueComponent]);
 colorDistance += fabs([thisColor greenComponent] - [thatColor greenComponent]);
 colorDistance = sqrt(colorDistance);
 if (colorDistance < bestDistance) {
 //       bestList = list;
 bestDistance = colorDistance;
 bestColor = thatColor;
 bestKey = key; }
 }
 }
 // bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //         localizedStringForKey:bestColorKey  value:bestColorKey  table:@"Crayons"];
 return bestColor;//, @"color", bestKey, @"key", bestList, @"list");
 }
 - (NSC*)closestColorListColor {
 NSC*thisColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat bestDistance = FLT_MAX;
 NSColorList *colors = [NSColorList colorListInFrameworkWithFileName:@"RGB.clr"];
 NSColorList *safe =  [NSColorList colorListNamed:@"Web Safe Colors"];
 NSColorList *crayons = [NSColorList colorListNamed:@"Crayons"];
 NSArray *avail = $array( safe);
 // NSColorList *bestList = nil;
 __block float red = [thisColor redComponent];
 __block float green = [thisColor greenComponent];
 __block float blue = [thisColor blueComponent];
 __block NSC*bestColor = nil;
 __block CGFloat colorDistance;
 //// NSS *bestKey = nil;
 // for (NSColorList *list  in avail) {
 //   NSEnumerator *enumerator = [[list allKeys] objectEnumerator];
 //   NSS *key = nil;
 //   while ((key = [enumerator nextObject])) {

 [avail eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
 [[obj allKeys]filterOne:^BOOL(id object) {
 NSC*thatColor = [[obj colorWithKey:object]colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
 CGFloat colorDistance = sqrt(    fabs( red - [thatColor redComponent]) + fabs(blue - [thatColor blueComponent])
 + fabs(green - [thatColor greenComponent]) );
 if (colorDistance < bestDistance)
 if (colorDistance < .04)
 return YES;   //bestList = list;
 else {
 bestDistance = colorDistance;
 bestColor = thatColor;
 return  NO;
 }
 //       return bestColor        //        bestKey = key;
 }return NO;
 }
 }
 //, @"color", bestKey, @"key", bestList, @"list");
 // bestColorKey = [[NSBundle bundleWithPath:@"/System/Library/Colors/Web Safe Colors.clr"]
 //         localizedStringForKey:bestColorKey  value:bestColorKey  table:@"Crayons"];
 }
 @implementation NSArray (THColorConversion)
 - (NSA*)colorValues {
 return [self arrayPerformingSelector:@selector(colorValue)];
 }
 @end


 //+ (NSC*)colorWithCGColor:(CGColorRef)aColor {
 // const CGFloat *components = CGColorGetComponents(aColor);
 // CGFloat red = components[0];
 // CGFloat green = components[1];
 // CGFloat blue = components[2];
 // CGFloat alpha = components[3];
 // return [self colorWithDeviceRed:red green:green blue:blue alpha:alpha];
 //}
 / * *+ (NSColor)
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Almond" HexCode:@"#EFDECD" Red:239 Green:222 Blue:205]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Apricot" HexCode:@"#FDD9B5" Red:253 Green:217 Blue:181]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Aquamarine" HexCode:@"#78DBE2" Red:120 Green:219 Blue:226]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Asparagus" HexCode:@"#87A96B" Red:135 Green:169 Blue:107]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Atomic Tangerine" HexCode:@"#FFA474" Red:255 Green:164 Blue:116]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Banana Mania" HexCode:@"#FAE7B5" Red:250 Green:231 Blue:181]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Beaver" HexCode:@"#9F8170" Red:159 Green:129 Blue:112]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Bittersweet" HexCode:@"#FD7C6E" Red:253 Green:124 Blue:110]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Black" HexCode:@"#000000" Red:0 Green:0 Blue:0]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blizzard Blue" HexCode:@"#ACE5EE" Red:172 Green:229 Blue:238]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blue" HexCode:@"#1F75FE" Red:31 Green:117 Blue:254]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blue Bell" HexCode:@"#A2A2D0" Red:162 Green:162 Blue:208]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blue Gray" HexCode:@"#6699CC" Red:102 Green:153 Blue:204]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blue Green" HexCode:@"#0D98BA" Red:13 Green:152 Blue:186]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blue Violet" HexCode:@"#7366BD" Red:115 Green:102 Blue:189]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Blush" HexCode:@"#DE5D83" Red:222 Green:93 Blue:131]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Brick Red" HexCode:@"#CB4154" Red:203 Green:65 Blue:84]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Brown" HexCode:@"#B4674D" Red:180 Green:103 Blue:77]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Burnt Orange" HexCode:@"#FF7F49" Red:255 Green:127 Blue:73]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Burnt Sienna" HexCode:@"#EA7E5D" Red:234 Green:126 Blue:93]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Cadet Blue" HexCode:@"#B0B7C6" Red:176 Green:183 Blue:198]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Canary" HexCode:@"#FFFF99" Red:255 Green:255 Blue:153]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Caribbean Green" HexCode:@"#1CD3A2" Red:28 Green:211 Blue:162]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Carnation Pink" HexCode:@"#FFAACC" Red:255 Green:170 Blue:204]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Cerise" HexCode:@"#DD4492" Red:221 Green:68 Blue:146]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Cerulean" HexCode:@"#1DACD6" Red:29 Green:172 Blue:214]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Chestnut" HexCode:@"#BC5D58" Red:188 Green:93 Blue:88]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Copper" HexCode:@"#DD9475" Red:221 Green:148 Blue:117]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Cornflower" HexCode:@"#9ACEEB" Red:154 Green:206 Blue:235]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Cotton Candy" HexCode:@"#FFBCD9" Red:255 Green:188 Blue:217]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Dandelion" HexCode:@"#FDDB6D" Red:253 Green:219 Blue:109]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Denim" HexCode:@"#2B6CC4" Red:43 Green:108 Blue:196]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Desert Sand" HexCode:@"#EFCDB8" Red:239 Green:205 Blue:184]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Eggplant" HexCode:@"#6E5160" Red:110 Green:81 Blue:96]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Electric Lime" HexCode:@"#CEFF1D" Red:206 Green:255 Blue:29]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Fern" HexCode:@"#71BC78" Red:113 Green:188 Blue:120]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Forest Green" HexCode:@"#6DAE81" Red:109 Green:174 Blue:129]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Fuchsia" HexCode:@"#C364C5" Red:195 Green:100 Blue:197]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Fuzzy Wuzzy" HexCode:@"#CC6666" Red:204 Green:102 Blue:102]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Gold" HexCode:@"#E7C697" Red:231 Green:198 Blue:151]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Goldenrod" HexCode:@"#FCD975" Red:252 Green:217 Blue:117]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Granny Smith Apple" HexCode:@"#A8E4A0" Red:168 Green:228 Blue:160]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Gray" HexCode:@"#95918C" Red:149 Green:145 Blue:140]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Green" HexCode:@"#1CAC78" Red:28 Green:172 Blue:120]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Green Blue" HexCode:@"#1164B4" Red:17 Green:100 Blue:180]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Green Yellow" HexCode:@"#F0E891" Red:240 Green:232 Blue:145]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Hot Magenta" HexCode:@"#FF1DCE" Red:255 Green:29 Blue:206]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Inchworm" HexCode:@"#B2EC5D" Red:178 Green:236 Blue:93]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Indigo" HexCode:@"#5D76CB" Red:93 Green:118 Blue:203]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Jazzberry Jam" HexCode:@"#CA3767" Red:202 Green:55 Blue:103]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Jungle Green" HexCode:@"#3BB08F" Red:59 Green:176 Blue:143]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Laser Lemon" HexCode:@"#FEFE22" Red:254 Green:254 Blue:34]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Lavender" HexCode:@"#FCB4D5" Red:252 Green:180 Blue:213]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Lemon Yellow" HexCode:@"#FFF44F" Red:255 Green:244 Blue:79]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Macaroni and Cheese" HexCode:@"#FFBD88" Red:255 Green:189 Blue:136]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Magenta" HexCode:@"#F664AF" Red:246 Green:100 Blue:175]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Magic Mint" HexCode:@"#AAF0D1" Red:170 Green:240 Blue:209]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Mahogany" HexCode:@"#CD4A4C" Red:205 Green:74 Blue:76]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Maize" HexCode:@"#EDD19C" Red:237 Green:209 Blue:156]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Manatee" HexCode:@"#979AAA" Red:151 Green:154 Blue:170]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Mango Tango" HexCode:@"#FF8243" Red:255 Green:130 Blue:67]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Maroon" HexCode:@"#C8385A" Red:200 Green:56 Blue:90]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Mauvelous" HexCode:@"#EF98AA" Red:239 Green:152 Blue:170]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Melon" HexCode:@"#FDBCB4" Red:253 Green:188 Blue:180]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Midnight Blue" HexCode:@"#1A4876" Red:26 Green:72 Blue:118]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Mountain Meadow" HexCode:@"#30BA8F" Red:48 Green:186 Blue:143]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Mulberry" HexCode:@"#C54B8C" Red:197 Green:75 Blue:140]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Navy Blue" HexCode:@"#1974D2" Red:25 Green:116 Blue:210]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Neon Carrot" HexCode:@"#FFA343" Red:255 Green:163 Blue:67]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Olive Green" HexCode:@"#BAB86C" Red:186 Green:184 Blue:108]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Orange" HexCode:@"#FF7538" Red:255 Green:117 Blue:56]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Orange Red" HexCode:@"#FF2B2B" Red:255 Green:43 Blue:43]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Orange Yellow" HexCode:@"#F8D568" Red:248 Green:213 Blue:104]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Orchid" HexCode:@"#E6A8D7" Red:230 Green:168 Blue:215]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Outer Space" HexCode:@"#414A4C" Red:65 Green:74 Blue:76]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Outrageous Orange" HexCode:@"#FF6E4A" Red:255 Green:110 Blue:74]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Pacific Blue" HexCode:@"#1CA9C9" Red:28 Green:169 Blue:201]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Peach" HexCode:@"#FFCFAB" Red:255 Green:207 Blue:171]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Periwinkle" HexCode:@"#C5D0E6" Red:197 Green:208 Blue:230]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Piggy Pink" HexCode:@"#FDDDE6" Red:253 Green:221 Blue:230]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Pine Green" HexCode:@"#158078" Red:21 Green:128 Blue:120]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Pink Flamingo" HexCode:@"#FC74FD" Red:252 Green:116 Blue:253]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Pink Sherbert" HexCode:@"#F78FA7" Red:247 Green:143 Blue:167]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Plum" HexCode:@"#8E4585" Red:142 Green:69 Blue:133]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Purple Heart" HexCode:@"#7442C8" Red:116 Green:66 Blue:200]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Purple Mountain's Majesty" HexCode:@"#9D81BA" Red:157 Green:129 Blue:186]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Purple Pizzazz" HexCode:@"#FE4EDA" Red:254 Green:78 Blue:218]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Radical Red" HexCode:@"#FF496C" Red:255 Green:73 Blue:108]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Raw Sienna" HexCode:@"#D68A59" Red:214 Green:138 Blue:89]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Raw Umber" HexCode:@"#714B23" Red:113 Green:75 Blue:35]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Razzle Dazzle Rose" HexCode:@"#FF48D0" Red:255 Green:72 Blue:208]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Razzmatazz" HexCode:@"#E3256B" Red:227 Green:37 Blue:107]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Red" HexCode:@"#EE204D" Red:238 Green:32 Blue:77]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Red Orange" HexCode:@"#FF5349" Red:255 Green:83 Blue:73]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Red Violet" HexCode:@"#C0448F" Red:192 Green:68 Blue:143]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Robin's Egg Blue" HexCode:@"#1FCECB" Red:31 Green:206 Blue:203]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Royal Purple" HexCode:@"#7851A9" Red:120 Green:81 Blue:169]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Salmon" HexCode:@"#FF9BAA" Red:255 Green:155 Blue:170]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Scarlet" HexCode:@"#FC2847" Red:252 Green:40 Blue:71]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Screamin' Green" HexCode:@"#76FF7A" Red:118 Green:255 Blue:122]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Sea Green" HexCode:@"#9FE2BF" Red:159 Green:226 Blue:191]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Sepia" HexCode:@"#A5694F" Red:165 Green:105 Blue:79]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Shadow" HexCode:@"#8A795D" Red:138 Green:121 Blue:93]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Shamrock" HexCode:@"#45CEA2" Red:69 Green:206 Blue:162]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Shocking Pink" HexCode:@"#FB7EFD" Red:251 Green:126 Blue:253]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Silver" HexCode:@"#CDC5C2" Red:205 Green:197 Blue:194]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Sky Blue" HexCode:@"#80DAEB" Red:128 Green:218 Blue:235]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Spring Green" HexCode:@"#ECEABE" Red:236 Green:234 Blue:190]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Sunglow" HexCode:@"#FFCF48" Red:255 Green:207 Blue:72]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Sunset Orange" HexCode:@"#FD5E53" Red:253 Green:94 Blue:83]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Tan" HexCode:@"#FAA76C" Red:250 Green:167 Blue:108]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Teal Blue" HexCode:@"#18A7B5" Red:24 Green:167 Blue:181]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Thistle" HexCode:@"#EBC7DF" Red:235 Green:199 Blue:223]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Tickle Me Pink" HexCode:@"#FC89AC" Red:252 Green:137 Blue:172]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Timberwolf" HexCode:@"#DBD7D2" Red:219 Green:215 Blue:210]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Tropical Rain Forest" HexCode:@"#17806D" Red:23 Green:128 Blue:109]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Tumbleweed" HexCode:@"#DEAA88" Red:222 Green:170 Blue:136]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Turquoise Blue" HexCode:@"#77DDE7" Red:119 Green:221 Blue:231]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Unmellow Yellow" HexCode:@"#FFFF66" Red:255 Green:255 Blue:102]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Violet Purple)" HexCode:@"#926EAE" Red:146 Green:110 Blue:174]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Violet Blue" HexCode:@"#324AB2" Red:50 Green:74 Blue:178]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Violet Red" HexCode:@"#F75394" Red:247 Green:83 Blue:148]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Vivid Tangerine" HexCode:@"#FFA089" Red:255 Green:160 Blue:137]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Vivid Violet" HexCode:@"#8F509D" Red:143 Green:80 Blue:157]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"White" HexCode:@"#FFFFFF" Red:255 Green:255 Blue:255]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Wild Blue Yonder" HexCode:@"#A2ADD0" Red:162 Green:173 Blue:208]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Wild Strawberry" HexCode:@"#FF43A4" Red:255 Green:67 Blue:164]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Wild Watermelon" HexCode:@"#FC6C85" Red:252 Green:108 Blue:133]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Wisteria" HexCode:@"#CDA4DE" Red:205 Green:164 Blue:222]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Yellow" HexCode:@"#FCE883" Red:252 Green:232 Blue:131]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Yellow Green" HexCode:@"#C5E384" Red:197 Green:227 Blue:132]];
 [tempMutableArray addObject:[Color.alloc initWithColorName:@"Yellow Orange" HexCode:@"#FFAE42" Red:255 Green:174 Blue:66]];

 + (NSC*) BLUE {  static NSC*  BLUE = nil;  if( BLUE == nil )
 BLUE = [NSC colorWithDeviceRed:0.253 green:0.478 blue:0.761 alpha:1.000];
 return BLUE;
 }
 + (NSC*) ORANGE {  static NSC*  ORANGE = nil;  if( ORANGE == nil )
 ORANGE = [NSC colorWithDeviceRed:0.864 green:0.498 blue:0.191 alpha:1.000];
 return ORANGE;
 }
 + (NSC*) RANDOM {
 NSC*  RANDOM = nil;
 if( RANDOM == nil )
 }

 # import <AIUtilities/AIUtilities.h>

SYNTHESIZE_ASC_OBJ_BLOCKOBJ(name, setName,
  ^id(id bSelf, id o){ return o = o ? o : [bSelf nameOfColor]; },// [(NSC*)bSelf setName:z]; return z;}(); },
  ^id(id x,id z){ return z; });
- (NSS*) name { NSS* name = objc_getAssociatedObject(self,_cmd);    if (name == nil) { [(NSC*)self setName:name = [self nameOfColor]]; }  return name;}
- (void) setName:(NSString *)name { NSAssert([name ISKINDA:NSS.class], @"name must be string"); objc_setAssociatedObject(self,@selector(name), name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSA*) colorNames { if (!colorsFromStruct) {    colorsFromStruct = NSMD.new;  NSInteger count = 0;
  while( count++ < 149 )
      [colorsFromStruct setValue:ColorWithUnsignedLong(sColorTable[count].value, NO) forKey:$UTF8(sColorTable[count].name)];
//      addObject: [NSString stringWithFormat: @"%f", c_array[count]]];
//    stringFromArray = [array componentsJoinedByString:@","];
//    [array release];
  }
  return colorsFromStruct.allKeys;
}
- (NSC*)coloratPercent:(float)percent betweenColor:(NSC*)one andColor:(NSC*)two


  two parts of a single path:
    defaultRGBTxtLocation1/VERSION/defaultRGBTxtLocation2
  static NSS *defaultRGBTxtLocation1 = @"/usr/share/emacs";
  static NSS *defaultRGBTxtLocation2 = @"etc/rgb.txt";
  #ifdef DEBUG_BUILD
  #define COLOR_DEBUG TRUE
  #else
  #define COLOR_DEBUG FALSE
  #endif
  @implementation NSDictionary (AIColorAdditions_RGBTxtFiles)
  see /usr/share/emacs/(some version)/etc/rgb.txt for an example of such a file.
  the pathname does not need to end in 'rgb.txt', but it must be a file in UTF-8 encoding.
  the keys are colour names (all converted to lowercase); the values are RGB NSColors.

*/

