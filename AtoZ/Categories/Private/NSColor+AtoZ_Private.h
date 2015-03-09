

/*
typedef struct {  NSUI value; const char name[24];} ColorNameRec;   // Longest name is 20 chars, pad out to multiple of 8

static ColorNameRec sColorTable[] = {

  { 0xf0f8ff, "aliceblue"     }, { 0xfaebd7, "antiquewhite" }, { 0x00ffff, "aqua"             },
  { 0x7fffd4, "aquamarine"    }, { 0xf0ffff, "azure"        }, { 0xf5f5dc, "beige"            },
  { 0xffe4c4, "bisque"        }, { 0x000000, "black"        }, { 0xffebcd, "blanchedalmond"   },
  { 0x0000ff, "blue"          }, { 0x8a2be2, "blueviolet"   }, { 0xa52a2a, "brown"            },
  { 0xdeb887, "burlywood"     }, { 0x5f9ea0, "cadetblue"    }, { 0x7fff00, "chartreuse"       },
  { 0xd2691e, "chocolate"     }, { 0xff7f50, "coral"        }, { 0x6495ed, "cornflowerblue"   },
  { 0xfff8dc, "cornsilk"      }, { 0xdc143c, "crimson"      }, { 0x00ffff, "cyan"             },
  { 0x00008b, "darkblue"      }, { 0x008b8b, "darkcyan"     }, { 0xb8860b, "darkgoldenrod"    },
  { 0xa9a9a9, "darkgray"      }, { 0xa9a9a9, "darkgrey"     }, { 0x006400, "darkgreen"        },
  { 0xbdb76b, "darkkhaki"     }, { 0x8b008b, "darkmagenta"  }, { 0x556b2f, "darkolivegreen"   },
  { 0xff8c00, "darkorange"    }, { 0x9932cc, "darkorchid"   }, { 0x8b0000, "darkred"          },
  { 0xe9967a, "darksalmon"    }, { 0x8fbc8f, "darkseagreen" }, { 0x483d8b, "darkslateblue"    },
  { 0x2f4f4f, "darkslategray" }, { 0x2f4f4f, "darkslategrey"}, { 0x00ced1, "darkturquoise"    },
  { 0x9400d3, "darkviolet"    }, { 0xff1493, "deeppink"     }, { 0x00bfff, "deepskyblue"      },
  { 0x696969, "dimgray"       }, { 0x696969, "dimgrey"      }, { 0x1e90ff, "dodgerblue" },
  { 0xb22222, "firebrick" },    { 0xfffaf0, "floralwhite" },      { 0x228b22, "forestgreen" },  { 0xff00ff, "fuchsia" },          { 0xdcdcdc, "gainsboro" },
  { 0xf8f8ff, "ghostwhite" },   { 0xffd700, "gold" },             { 0xdaa520, "goldenrod" },    { 0x808080, "gray" },           { 0x808080, "grey" },
  { 0x008000, "green" },        { 0xadff2f, "greenyellow" },      { 0xf0fff0, "honeydew" },     { 0xff69b4, "hotpink" },          { 0xcd5c5c, "indianred" },
  { 0x4b0082, "indigo" },       { 0xfffff0, "ivory" },            { 0xf0e68c, "khaki" },        { 0xe6e6fa, "lavender" },         { 0xfff0f5, "lavenderblush" },
  { 0x7cfc00, "lawngreen" },    { 0xfffacd, "lemonchiffon" },     { 0xadd8e6, "lightblue" },    { 0xf08080, "lightcoral" },       { 0xe0ffff, "lightcyan" },
  { 0xfafad2, "lightgoldenrodyellow" }, {0xd3d3d3, "lightgray" }, { 0xd3d3d3, "lightgrey" },    { 0x90ee90, "lightgreen" },       { 0xffb6c1, "lightpink" },
  { 0xffa07a, "lightsalmon" },  { 0x20b2aa, "lightseagreen" },    { 0x87cefa, "lightskyblue" }, { 0x8470ff, "lightslateblue" },     { 0x778899, "lightslategray" },
  { 0x778899, "lightslategrey"},{ 0xb0c4de, "lightsteelblue" },   { 0xffffe0, "lightyellow" },  { 0x00ff00, "lime" },           { 0x32cd32, "limegreen" },
  { 0xfaf0e6, "linen" },        { 0xff00ff, "magenta" },          { 0x800000, "maroon" },       { 0x66cdaa, "mediumaquamarine" },   { 0x0000cd, "mediumblue" },
  { 0xba55d3, "mediumorchid" }, { 0x9370d8, "mediumpurple" },     { 0x3cb371, "mediumseagreen"},{ 0x7b68ee, "mediumslateblue" },      { 0x00fa9a, "mediumspringgreen" },
  { 0x48d1cc, "mediumturquoise"},{0xc71585, "mediumvioletred" },  { 0x191970, "midnightblue" }, { 0xf5fffa, "mintcream" },          { 0xffe4e1, "mistyrose" },
  { 0xffe4b5, "moccasin" },     { 0xffdead, "navajowhite" },      { 0x000080, "navy" },         { 0xfdf5e6, "oldlace" },          { 0x808000, "olive" },
  { 0x6b8e23, "olivedrab" },    { 0xffa500, "orange" },           { 0xff4500, "orangered" },    { 0xda70d6, "orchid" },           { 0xeee8aa, "palegoldenrod" },
  { 0x98fb98, "palegreen" },    { 0xafeeee, "paleturquoise" },    { 0xd87093, "palevioletred"}, { 0xffefd5, "papayawhip" },       { 0xffdab9, "peachpuff" },
  { 0xcd853f, "peru" },         { 0xffc0cb, "pink" },             { 0xdda0dd, "plum" },         { 0xb0e0e6, "powderblue" },       { 0x800080, "purple" },
  { 0xff0000, "red" },          { 0xbc8f8f, "rosybrown" },        { 0x4169e1, "royalblue" },    { 0x8b4513, "saddlebrown" },        { 0xfa8072, "salmon" },
  { 0xf4a460, "sandybrown" },   { 0x2e8b57, "seagreen" },         { 0xfff5ee, "seashell" },     { 0xa0522d, "sienna" },           { 0xc0c0c0, "silver" },
  { 0x87ceeb, "skyblue" },      { 0x6a5acd, "slateblue" },        { 0x708090, "slategray" },    { 0x708090, "slategrey" },          { 0xfffafa, "snow" },
  { 0x00ff7f, "springgreen" },  { 0x4682b4, "steelblue" },        { 0xd2b48c, "tan" },          { 0x008080, "teal" },           { 0xd8bfd8, "thistle" },
  { 0xff6347, "tomato" },       { 0x40e0d0, "turquoise" },        { 0xee82ee, "violet" },       { 0xd02090, "violetred" },          { 0xf5deb3, "wheat" },
  { 0xffffff, "white" },        { 0xf5f5f5, "whitesmoke" },       { 0xffff00, "yellow" },       { 0x9acd32, "yellowgreen" },
};

*/
/**
#import <string.h>

static NSArray *defaultValidColors = nil;

#define VALID_COLORS_ARRAY @[             @"aqua",            @"aquamarine",        @"blue",          @"blueviolet",          @"brown",         \
  @"burlywood",     @"cadetblue",       @"chartreuse",        @"chocolate",       @"coral",       @"cornflowerblue",      @"crimson",         \
  @"cyan",          @"darkblue",        @"darkcyan",        @"darkgoldenrod",     @"darkgreen",     @"darkgrey",          @"darkkhaki",       \
  @"darkmagenta",   @"darkolivegreen",    @"darkorange",        @"darkorchid",        @"darkred",       @"darksalmon",          @"darkseagreen",      \
  @"darkslateblue",   @"darkslategrey",     @"darkturquoise",     @"darkviolet",        @"deeppink",      @"deepskyblue",       @"dimgrey",         \
  @"dodgerblue",      @"firebrick",       @"forestgreen",     @"fuchsia",         @"gold",          @"goldenrod",         @"green",         \
  @"greenyellow",   @"grey",            @"hotpink",         @"indianred",       @"indigo",        @"lawngreen",         @"lightblue",       \
  @"lightcoral",      @"lightgreen",        @"lightgrey",       @"lightpink",       @"lightsalmon",   @"lightseagreen",       @"lightskyblue",      \
  @"lightslategrey",  @"lightsteelblue",    @"lime",            @"limegreen",       @"magenta",       @"maroon",            @"mediumaquamarine",    \
  @"mediumblue",      @"mediumorchid",      @"mediumpurple",      @"mediumseagreen",    @"mediumslateblue", @"mediumspringgreen",   @"mediumturquoise",   \
  @"mediumvioletred", @"midnightblue",      @"navy",            @"olive",         @"olivedrab",     @"orange",            @"orangered",       \
  @"orchid",        @"palegreen",       @"paleturquoise",     @"palevioletred",     @"peru",          @"pink",              @"plum",            \
  @"powderblue",      @"purple",          @"red",           @"rosybrown",       @"royalblue",     @"saddlebrown",       @"salmon",          \
  @"sandybrown",      @"seagreen",        @"sienna",          @"silver",          @"skyblue",       @"slateblue",         @"slategrey",       \
  @"springgreen",   @"steelblue",       @"tan",           @"teal",            @"thistle",       @"tomato",            @"turquoise",       \
  @"violet",        @"yellowgreen"]


*/

//@dynamic name;
//SYNTHESIZE_ASC_OBJ_LAZYDEFAULT_EXP(name,setName,[self nameOfColor])
//SYNTHESIZE_ASC_OBJ_LAZY_BLOCK(name,
//  CGF mine = self.hueComponent, other = otherColor.hueComponent;
//	NSComparisonResult result =  mine == other ? NSOrderedSame :

//  [self compareSeconds:right];

//  NSOrderedAscending = -1
//  NSOrderedSame = 0
//  NSOrderedDescending = 1

//	if (result == NSOrderedSame)
//	{
//		if (mv_tv.tv_usec < right->mv_tv.tv_usec)
//			return NSOrderedAscending;
//		else if (mv_tv.tv_usec > right->mv_tv.tv_usec)
//			return NSOrderedDescending;
//	}
//	
//	return NSOrderedSame;
//}
//
//- (NSComparisonResult)compareColorValue:(NSC*)right;  // less accurate compare
//{
//	if (mv_tv.tv_sec < right->mv_tv.tv_sec)
//		return NSOrderedAscending;
//	else if (mv_tv.tv_sec > right->mv_tv.tv_sec)
//		return NSOrderedDescending;
//	
//	return NSOrderedSame;
//}

  // comparing the same type of animal, so sort by name
  //  if ([self kindOfAnimal] == [otherAnimal kindOfAnimal]) return [[self name] caseInsensitiveCompare:[otherAnimal name]];
  // we're comparing by kind of animal now. they will be sorted by the order in which you declared the types in your enum // (Dogs first, then Cats, Birds, Fish, etc)
  //  return [[NSNumber numberWithInt:[self kindOfAnimal]] compare:[[[NSNumber]] numberWithInt:[otherAnimal kindOfAnimal]]]; }


//  return [@(self.hueComponent)compare : @(otherColor.hueComponent)];

//  HsvColor a = self.hsvColor, b = otherColor.hsvColor;
//  return [@(a.h)]
  // array_multisort($hue,SORT_ASC, $sat,SORT_ASC, $val,SORT_ASC,$s);


/*
+ colorWithHTMLString:(NSS*)str { return [self colorWithHTMLString:str defaultColor:nil]; }


+ (INST) colorWithHTMLString:(NSS*)str defaultColor:(NSC*)defaultC { if (!str || (!str.length && !defaultC)) return nil;

  NSString *colorValue = [self colorWithHexString:]
  if (!str.length || [str characterAtIndex:0] != '#') {
    //look it up; it's a colour name
    colorValue = self.colorNamesDictionary[str] ?: [self.colorNamesDictionary objectForKey:str.lowercaseString] ?: defaultColor;
#if COLOR_DEBUG
    if (!colorValue) colorValue = defaultColor
      NSLog(@"+[NSColor(AIColorAdditions) colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
#endif
  }
  //we need room for at least 9 characters (#00ff00ff) plus the NUL terminator. this array is 12 bytes long because I like multiples of four. ;)
  enum { hexStringArrayLength = 12 };
  size_t hexStringLength = 0;
  char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
  {
    NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    hexStringLength = [stringData length];
    memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1));     //subtract 1 because we don't want to overwrite that last NUL.
  }
  const char *hexString = hexStringArray;
  float   red, green, blue, alpha = 1.0;
  if (*hexString == '#') ++hexString;   //skip # if present.
  if (hexStringLength < 3) {
#if COLOR_DEBUG
    NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08) (string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
    return defaultColor;
#endif
  }
  //long specification:  #rrggbb[aa]  //short specification: #rgb[a]  //e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
  BOOL isLong = hexStringLength > 4;
  //for a long component c = 'xy':  //  c = (x * 0x10 + y) / 0xff //for a short component c = 'x':    //  c = x / 0xf
  red   = hexToInt(*(hexString++));
  if (isLong) red    = (red   * 16.0 + hexToInt(*(hexString++))) / 255.0;
  else        red   /= 15.0;
  green = hexToInt(*(hexString++));
  if (isLong) green  = (green * 16.0 + hexToInt(*(hexString++))) / 255.0;
  else        green /= 15.0;
  blue  = hexToInt(*(hexString++));
  if (isLong) blue   = (blue  * 16.0 + hexToInt(*(hexString++))) / 255.0;
  else        blue  /= 15.0;
  if (*hexString) {
    //we still have one more component to go: this is alpha. without this component, alpha defaults to 1.0 (see initialiser above).
    alpha = hexToInt(*(hexString++));
    if (isLong) alpha = (alpha * 16.0 + hexToInt(*(hexString++))) / 255.0;
    else alpha /= 15.0;
  }
  return [self r:red g:green b:blue a:alpha];
}

  NSLog(@"index %i of %ld", indc, steps );
  return (NSC*)[bitmapRep colorAtX:3 y :(int)(index/steps)];

    :AZRectFromSize(imageSize) angle:270];
   [[NSC colorWithDeviceRed:0.2 green:0.3 blue:0.7 alpha:0.9]  set];
   //[[NSC colorWithCalibratedWhite:1.0 alpha:1.0] set];
   NSRectFillUsingOperation(NSMakeRect(0, 0, imageSize.width,
   imageSize.height),
   NSCompositeCopy);
   [[NSC redColor] set]; // adding a rect to see that (and how)
   it works
   [NSBezierPath fillRect:NSMakeRect(50, 50, 200,100)];
   NSLog(@"%@", [bitmapRep colorAtX:10 y:10]);
   for a test only:
   [[bitmapRep TIFFRepresentation] writeToFile:@"/tmp/tst.tiff"
   atomically:NO];
   NSR rect = AZRectBy(100, 5);
   NSIMG *img = [NSIMG imageWithSize:rect.size drawnUsingBlock:^{
   [gradient drawInRect:rect angle:180];
   }];
   [img openInPreview];
   NSBitmapImageRep* imageRep = [NSBitmapImageRep.alloc initWithData:[img TIFFRepresentation]];
   NSA* loop = [colors arrayByAddingObject:colors.last];
   return [NSA arrayWithArrays:[[@0 to: @(steps)]nmap:^id(id obj, NSUInteger index) {

   int idx = (int)[obj floatValue]/loop.count;
   idx = idx < loop.count ? idx : idx -1;
   NSC *one = loop[idx];  NSC* two = loop[idx+1];
   return [self gradientPalletteBetween:one and:two steps:(int)loop.count/steps];
   }]];

*/
