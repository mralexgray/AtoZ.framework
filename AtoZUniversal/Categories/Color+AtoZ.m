

#import "Color+AtoZ.h"

@XtraPlan(Colr,AtoZUniversal)

SYNTHESIZE_ASC_OBJ(name, setName);

- (NSComparisonResult)compare:(id)object {

  return self.hue > [object hue] ? NSOrderedAscending : self.hue < [object hue] ? NSOrderedDescending : NSOrderedSame;

}

-  (CGF) relativeBrightness   {
  CGFloat r, g, b, a;
  [self.calibratedRGBColor getRed:&r green:&g blue:&b alpha:&a];
  return sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
}

- _IsIt_ isBright { return self.relativeBrightness > 0.57; }
- _IsIt_ isDark   { return self.relativeBrightness < 0.42; }

- _Colr_ calibratedRGBColor { return
#if MAC_ONLY
    [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace]; }
#else 
  self; }
#endif

- _Colr_ contrastingForegroundColor { NSC*c = self.calibratedRGBColor;

  return !c ? NSLog(@"Cannot create contrastingForegroundColor for color %@", self), NSColor.blackColor :
         !c.isBright ? NSColor.whiteColor : NSColor.blackColor;
}
- _Flot_ hue                { CGFloat h;

#if MAC_ONLY
  h = self.hueComponent;
#else
  CGFloat s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
#endif
 return h * 360;
}
- _Text_ primaryColorName   {  CGFloat h = self.hue; return

#define pCLR_UNKNOWN  @"???"
#define pCLR_RED      @"RED"
#define pCLR_ORANGE   @"ORANGE"
#define pCLR_YELLOW   @"YELLOW"
#define pCLR_GREEN    @"GREEN"
#define pCLR_BLUE     @"BLUE"
#define pCLR_PURPLE   @"PURPLE"


  h <  60 ? pCLR_RED     : h < 120 ? pCLR_ORANGE  : h < 180 ? pCLR_YELLOW  :
  h < 240 ? pCLR_GREEN   : h < 300 ? pCLR_BLUE    : h < 360 ? pCLR_PURPLE  : pCLR_UNKNOWN;
}
+ _Kind_ randomColor        {

  int red = rand() % 255; int green = rand() % 255; int blue = rand() % 255;
  return [NSC colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
+ _Kind_ randomLightColor   { return [RANDOMCOLOR withBrightnessMultiplier:.9]; }
+ _Kind_ randomBrightColor  { NSC *c; while ( !(c = RANDOMCOLOR).isBright ) {}  return c; }
+ _Kind_ randomDarkColor    { NSC *c; while ( !(c = RANDOMCOLOR).isDark   ) {}  return c; }

double _fclamp(double lower, double value, double upper) { return fmin(fmax(lower, value), upper); }


- _Kind_ withBrightnessOffset     __Flot_ offset {

  _Colr hsbaColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  _Flot h,s,b,a;    [hsbaColor getHue:&h saturation:&s brightness:&b alpha:&a];
  return [self.class colorWithCalibratedHue:h saturation:s brightness:_fclamp(0.0, b+offset, 1.0) alpha:a];
}
- _Kind_ withBrightnessMultiplier __Flot_ factor {

    _Colr hsbaColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    _Flot h,s,b,a;
    [hsbaColor getHue:&h saturation:&s brightness:&b alpha:&a];
    
    return [NSColor colorWithCalibratedHue:h saturation:s brightness:_fclamp(0.0, b*factor, 1.0) alpha:a];
}

￭
