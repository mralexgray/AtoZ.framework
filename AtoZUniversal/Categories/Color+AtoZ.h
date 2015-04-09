


@Xtra(Colr,AtoZUniversal)

_RO _Text primaryColorName
      ___
_AT _Text name; // settable, but auto_gets

_RO _Colr contrastingForegroundColor
       __ calibratedRGBColor
      ___
_RO _IsIt isBright
       __ isDark
      ___
_RO _Flot	relativeBrightness
       __ hue // universal hue component (0 - 360)
      ___

-  _Comp_ compare _ _Colr_ b ___


- _Kind_ withBrightnessOffset     _ _Flot_ offset;
- _Kind_ withBrightnessMultiplier _ _Flot_ factor;

+ _Kind_ randomLightColor   ___
+ _Kind_ randomBrightColor  ___
+ _Kind_ randomDarkColor    ___
+ _Kind_ randomColor        ___

@XtraStop()

