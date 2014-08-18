#import "AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSColorList+AtoZ.h"

@implementation NSColorList (AtoZ) static NSMD *palettesD;

#pragma mark - ClassKeyGet Protocol
+ (id) objectForKeyedSubscript:(id)x  { return [self colorListNamed:x] ?: [self.class colorListInFrameworkWithFileName:x] ?: nil; }
#pragma mark - KeyGet Protocol
- (id) objectForKeyedSubscript:(id)x {  NSC * calore = [self colorWithKey:x];

    return !calore ? nil : ({
    calore = [calore deviceRGBColor];    //  NSLog(@"named:%@...%@", c, c.name);
    [calore setName:x];
    calore; });
}
#pragma mark - Random Protocol
+ (INST) random { return self.availableColorLists.randomElement; }


+ (INST)  colorListWithColors:(NSA*)cs andNames:(NSA*)ns named:(NSS*)name {

  NSCL *newList = [NSCL.alloc initWithName:name];

  [[cs pairedWith:ns] do:^(NSA* obj) { [newList setColor:obj[0] forKey:obj[1] ?: @"N/A"]; }];

  return newList;

}
//- (NSC*) swizzleColorWithKey:(NSS*)k  {
//  NSC* x = [self swizzleColorWithKey:k];
//  if (x) [x setName: [k isHexString] ? [x nameOfColor] : [k copy]];
//  return x;
//}

-  (NSA*) colors            {

  return (palettesD = palettesD ?: NSMD.new)[self.name] = palettesD[self.name]
                                ?: [self.allKeys cw_mapArray:^id(id obj) {
    return self[obj];
  }];
}

- (NSC*) randomColor { return [self  colorWithKey:self.allKeys.randomElement]; }
+ (NSA*) availableColorListNames { return [self.availableColorLists vFK:@"name"]; }

+ (NSA*) frameworkColorLists {

  return [[AZFWBNDL resourcesWithExtensions:@[@"clr"]] map:^id(id obj) {
    return [NSCL.alloc initWithName:[obj lastPathComponent].stringByDeletingPathExtension fromFile:obj];
  }];
}

+   (id) colorListWithFileName:(NSS*)f inBundle:(NSB*)b { IF_RETURN(!b); IF_RETURN(!f);

  NSS  * listP = [b pathForResource:f ofType:nil];
  return listP ? [NSCL.alloc initWithName:listP.lastPathComponent fromFile:listP]: (id)nil;
}
+   (id) colorListWithFileName:(NSS*)f
              inBundleForClass:(Class)c           { return [self colorListWithFileName:f inBundle:[NSB bundleForClass:c]];  }
+   (id) colorListInFrameworkWithFileName:(NSS*)f { return [self colorListWithFileName:f inBundle:AtoZ.bundle]; }

- (NSS*) html {

NSMS* html = $(@"<html>\
  <head>\
    <title>{name}</title>\
    <style>   body, h1, table, tr, th, td {  font-family: monospace;  }\
    table, th, td {  border: 1px #DCDCDC solid;  }\
    th {  background-color: #D8D8D8; }\
    .swatch { width: 64px;  }\
    .color_hex, .color_rgb {  text-align: center; }\
    </style>\
  </head>\
  <body>\
    <h1>%@</h1><table cellpadding=\"2\" cellspacing=\"1\" border=\"1\"> <tr> <th>Swatch</th> <th>Name</th> <th>HTML</th><th>R</th><th>G</th><th>B</th> </tr>", self.name).mC;


  for (NSC*c in self.colors) {

    [html appendFormat:@"<tr>\n<td class=\"swatch\" style=\"background-color:%@;\">&nbsp;</td>\n\
              <td>%@</td>\n<td class=\"color_hex\">%@</td>\n<td class=\"color_rgb\">%d</td>\n<td class=\"color_rgb\">%i</td>\n<td class=\"color_rgb\">%i</td>\n</tr>\n", c.hexString, c.name, c.hexString, (int)c.redComponent*255, (int)c.redComponent*255, (int)c.redComponent*255];
  }
      [html appendString:@"</table>\n  </body>\n</html>"];

  return [html tidyHTML];
}

+ (NSA*) namedColors { AZSTATIC_OBJ(NSA, cs, [self.namedColorDictionary mapToArray:^id(id k, id v) { return [[NSC colorWithHex:v[@"hex"]] objectBySettingValue:k forKey:@"name"]; }]); return cs;
}
+ (NSD*) namedColorDictionary {  static NSD* d; return d = d ?: ({ id path = [AZFILEMANAGER pathsOfFilesIn:AZFWRESOURCES matchingPattern:@"colors.json"]; path ?

    [NSJSONS JSONObjectWithData:[DATA dataWithContentsOfFile:path[0] options:0 error:nil] options:0 error:nil] : nil; });
}
@end

@implementation NSColor (AIColorAdditions)

#pragma mark -  COmparison

- (BOOL)equalToRGBColor:(NSC*)inColor         {
  NSColor *convertedA = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  NSColor *convertedB = [inColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return (([convertedA redComponent]   == [convertedB redComponent])   &&
        ([convertedA blueComponent]  == [convertedB blueComponent])  &&
        ([convertedA greenComponent] == [convertedB greenComponent]) &&
        ([convertedA alphaComponent] == [convertedB alphaComponent]));
} //  Returns YES if the colors are equal

#pragma mark - DarknessAndContrast)

- (BOOL) colorIsDark                          {
  return ([[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent] < 0.5f);
}
- (BOOL) colorIsMedium                        {
  CGFloat brightness = [[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] brightnessComponent];
  return (0.35f < brightness && brightness < 0.65f);
}
- (NSC*) darkenBy:(CGF)f                      {
  NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [NSC colorWithCalibratedHue:convertedColor.hueComponent        saturation:convertedColor.saturationComponent
                  brightness:convertedColor.brightnessComponent - f     alpha:convertedColor.alphaComponent];
} //  Percent should be -1.0 to 1.0 (negatives will make the color brighter)
- (NSC*) darkenAndAdjustSaturationBy:(CGF)f   {
  NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  return [NSC colorWithCalibratedHue:convertedColor.hueComponent
                  saturation:((convertedColor.saturationComponent == 0.0f) ? convertedColor.saturationComponent : (convertedColor.saturationComponent + f))
                  brightness:(convertedColor.brightnessComponent - f)
                      alpha:convertedColor.alphaComponent];
}
- (NSC*) colorWithInvertedLuminance           {  CGFloat h,l,s;

  NSC*convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

  [convertedColor getHue:&h saturation:&s brightness:&l alpha:NULL];  //Get our HLS

  l = 1.0f - l;  //Invert L

  return [NSC colorWithCalibratedHue:h saturation:s brightness:l alpha:1.0f];   //Return the new color
} //  Inverts the luminance - so it looks good on selected/dark backgrounds
- (NSC*) contrastingColor                     {
  if ([self colorIsMedium]) {
    if ([self colorIsDark])
      return [NSC whiteColor];
    else
      return [NSC blackColor];
  } else {
    NSC*rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    return [NSC colorWithCalibratedRed:(1.0f - [rgbColor redComponent])
                        green:(1.0f - [rgbColor greenComponent])
                        blue:(1.0f - [rgbColor blueComponent])
                        alpha:1.0f];
  }
} // Returns a color that contrasts well with this one

#define AIfmod( X, Y )  fmod((X),(Y))

#pragma mark - HLS

- (NSC*)adjustHue:(CGF)dHue saturation:(CGF)dSat brightness:(CGF)dBrit  {
  CGFloat hue, sat, brit, alpha;
  [self getHue:&hue saturation:&sat brightness:&brit alpha:&alpha];
  //  For some reason, redColor's hue is 1.0f, not 0.0f, as of Mac OS X 10.4.10 and 10.5.2.
  //  Therefore, we must normalize any multiple of 1.0 to 0.0. We do this by taking the remainder of hue ÷ 1.
  hue     = AIfmod(hue, 1.0f);
  hue     +=  dHue; AZNormalFloat ( hue );
  sat   +=  dSat; AZNormalFloat ( sat );
  brit    += dBrit; AZNormalFloat ( brit );
  return [NSC colorWithCalibratedHue:hue saturation:sat brightness:brit alpha:alpha];
} //Linearly adjust a color

#pragma mark - RepresentingColors)

- (NSS*) hexString            {
  CGFloat   red,green,blue;
  char  hexString[7];
  NSInteger   tempNum;
  NSColor *convertedColor;
  convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  [convertedColor getRed:&red green:&green blue:&blue alpha:NULL];
  tempNum = (NSInteger)(red * 255.0f);
  hexString[0] = intToHex(tempNum / 16);
  hexString[1] = intToHex(tempNum % 16);
  tempNum = (NSInteger) (green * 255.0f);
  hexString[2] = intToHex(tempNum / 16);
  hexString[3] = intToHex(tempNum % 16);
  tempNum = (NSInteger)(blue * 255.0f);
  hexString[4] = intToHex(tempNum / 16);
  hexString[5] = intToHex(tempNum % 16);
  hexString[6] = '\0';
  return @(hexString);
}
- (NSS*) stringRepresentation {
  NSColor *tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
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
} //String representation: R,G,B[,A].
- (NSS*) CSSRepresentation    {
  CGFloat alpha = [self alphaComponent];
  if ((1.0 - alpha) >= 0.000001) {
    NSC*rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    //CSS3 defines rgba() to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
    return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
          [NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
          [NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
          [NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
          [NSString stringWithCGFloat:alpha            maxDigits:6]];
  } else {
    return [@"#" stringByAppendingString:[self hexString]];
  }
}

#pragma mark - RepresentingColors
+ (NSC*) representedByString:(NSS*)_self {
  CGF r = 255, g = 255, b = 255;
  CGF a = 255;
  const char *selfUTF8 = [_self UTF8String];
  //format: r,g,b[,a]
  //all components are decimal numbers 0..255.
  if (!isdigit(*selfUTF8)) goto scanFailed;
  r = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
  if(*selfUTF8 == ',') ++selfUTF8;
  else         goto scanFailed;
  if (!isdigit(*selfUTF8)) goto scanFailed;
  g = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
  if(*selfUTF8 == ',') ++selfUTF8;
  else         goto scanFailed;
  if (!isdigit(*selfUTF8)) goto scanFailed;
  b = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
  if (*selfUTF8 == ',') {
    ++selfUTF8;
    a = (CGF)strtoul(selfUTF8, (char **)&selfUTF8, /*base*/ 10);
    if (*selfUTF8) goto scanFailed;
  } else if (*selfUTF8 != '\0') {
    goto scanFailed;
  }
  return [NSC colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:(a/255)] ;
scanFailed:
  return nil;
}
+ (NSC*)representedByString:(NSS*)_self withAlpha:(CGF)aa {
  //this is the same as above, but the alpha component is overridden.
  NSUInteger  r, g, b;
  const char *selfUTF8 = [_self UTF8String];
  //format: r,g,b all components are decimal numbers 0..255.
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
  return [NSC colorWithCalibratedRed:(r/255) green:(g/255) blue:(b/255) alpha:aa];
scanFailed:
  return nil;
}
#pragma mark - RandomColor
+ (NSC*) randomColor        {
  return [NSC colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
                      green:(arc4random() % 65536) / 65536.0f
                      blue:(arc4random() % 65536) / 65536.0f
                      alpha:1.0f];
}
+ (NSC*) randomColorWithAlpha {
  return [NSC colorWithCalibratedRed:(arc4random() % 65536) / 65536.0f
                      green:(arc4random() % 65536) / 65536.0f
                      blue:(arc4random() % 65536) / 65536.0f
                      alpha:(arc4random() % 65536) / 65536.0f];
}
#pragma mark - CSSRGB
+ (NSC*) colorWithCSSRGB:(NSS*)rgbString                    {
  /* NSColor+CSSRGB.m SPColorWell  Created by Philip Dow on 11/16/11.  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
   Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prio written permission.
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
   For non-attribution licensing options refer to http://phildow.net/licensing/ */
  static NSCharacterSet *open  = nil;  open = open  ?: [NSCharacterSet characterSetWithCharactersInString:@"("];//retain];
  static NSCharacterSet *close = nil; close = close ?: [NSCharacterSet characterSetWithCharactersInString:@")"];//retain];
  NSI iBegin    = [rgbString rangeOfCharacterFromSet:open].location;
  NSI iClose    = [rgbString rangeOfCharacterFromSet:close].location;
  if ( iBegin == NSNotFound || iClose == NSNotFound )  return nil;
  NSS *rgbSub   = [rgbString substringWithRange:NSMakeRange(iBegin+1,iClose-(iBegin+1))];
  NSA *components = [rgbSub    componentsSeparatedByString:@","];
  if ( [components count] != 3 )  return nil;
  NSA* componentValues = [components cw_mapArray:^id(NSS* aComponent) {
    NSS *cleanedComponent = [aComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [cleanedComponent length] == 0 ? nil : @([cleanedComponent fV]);
  }];
  return  [componentValues count] != 3 ? nil : [NSC colorWithCalibratedRed: [componentValues[0]fV] / 255.
                                               green: [componentValues[1]fV] / 255.
                                                blue: [componentValues[2]fV] / 255. alpha:1];
}
#pragma mark - ColorspaceEquality
- (BOOL) isEqualToColor:(NSC*)inColor colorSpace:(NSS*)inColorSpace {
  return  [self colorUsingColorSpaceName:inColorSpace] &&   [inColor colorUsingColorSpaceName:inColorSpace]
  && [[self colorUsingColorSpaceName:inColorSpace] isEqual:[inColor colorUsingColorSpaceName:inColorSpace]];
}

#pragma mark - ObjectColor)
+ (NSS*) representedColorForObject:(id)anObject withValidColors:(NSA*)validColors {
  NSArray *validColorsArray = validColors;
  if (!validColorsArray || [validColorsArray count] == 0) {
//    if (!defaultValidColors) {
//      defaultValidColors = VALID_COLORS_ARRAY;
//    }
//    validColorsArray = defaultValidColors;
  }
  return validColorsArray[([anObject hash] % ([validColorsArray count]))];
}
@end
