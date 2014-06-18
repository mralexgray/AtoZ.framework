
//  THnamedColors.m  Lumumba
//  Created by Benjamin Schüttler on 28.10.09.  Copyright 2011 Rogue Coding. All rights reserved.

#import "AtoZ.h"
#import "AZNamedColors.h"

@implementation NSColorList (Dictionary)

-(NSD*) dictionary { return [self.allKeys mapToDictForgivingly:^AZKeyPair *(id key) {
		return [AZKeyPair key:key value:[self colorWithKey:key]];
	}];
}
@end

@implementation AZNamedColors


//+ (void)initialize {	[super initialize]; [self namedColors];
//}
+ (INST) namedColors {	static AZNamedColors *sharedNamedColors = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{ sharedNamedColors = self.new; });
  return sharedNamedColors;
}

- (id) init { return self = [super initWithName:@"AZNamedColors"] ? [self _initColors], self :nil; }

- (void)_initColors {
	if ([self.allKeys count] > 0)
		return;

#define _COLOR(V, N) \
\
 ({ id x = [NSC colorWithHex:@#V]; id z =@#N; if(x&&z)[self setColor:x forKey:z]; })

  //	_COLOR(FFFFFF00, Transparent);
	_COLOR(F0F8FF, AliceBlue);
	_COLOR(FAEBD7, AntiqueWhite);
	_COLOR(AFB837, AppleGreen);
	_COLOR(00FFFF, Aqua);
	_COLOR(7FFFD4, Aquamarine);
	_COLOR(F0FFFF, Azure);
	_COLOR(F5F5DC, Beige);
	_COLOR(FFE4C4, Bisque);
	_COLOR(000000, Black);
	_COLOR(FFEBCD, BlanchedAlmond);
	_COLOR(0000FF, Blue);
	_COLOR(8A2BE2, BlueViolet);
	_COLOR(A52A2A, Brown);
	_COLOR(DEB887, BurlyWood);
	_COLOR(5F9EA0, CadetBlue);
	_COLOR(7FFF00, Chartreuse);
	_COLOR(D2691E, Chocolate);
	_COLOR(FF7F50, Coral);
	_COLOR(6495ED, CornflowerBlue);
	_COLOR(FFF8DC, Cornsilk);
	_COLOR(DC143C, Crimson);
	_COLOR(00FFFF, Cyan);
	_COLOR(00008B, DarkBlue);
	_COLOR(008B8B, DarkCyan);
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
	_COLOR(483D8B, DarkSlateBlue);
	_COLOR(2F4F4F, DarkSlateGray);
	_COLOR(00CED1, DarkTurquoise);
	_COLOR(9400D3, DarkViolet);
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
	_COLOR(008000, Green);
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
	_COLOR(00FF00, Lime);
	_COLOR(32CD32, LimeGreen);
	_COLOR(FAF0E6, Linen);
	_COLOR(FF00FF, Magenta);
	_COLOR(800000, Maroon);
	_COLOR(66CDAA, MediumAquaMarine);
	_COLOR(0000CD, MediumBlue);
	_COLOR(BA55D3, MediumOrchid);
	_COLOR(9370D8, MediumPurple);
	_COLOR(3CB371, MediumSeaGreen);
	_COLOR(7B68EE, MediumSlateBlue);
	_COLOR(00FA9A, MediumSpringGreen);
	_COLOR(48D1CC, MediumTurquoise);
	_COLOR(C71585, MediumVioletRed);
	_COLOR(191970, MidnightBlue);
	_COLOR(F5FFFA, MintCream);
	_COLOR(FFE4E1, MistyRose);
	_COLOR(FFE4B5, Moccasin);
	_COLOR(FFDEAD, NavajoWhite);
	_COLOR(000080, Navy);
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
	_COLOR(00FF7F, SpringGreen);
	_COLOR(4682B4, SteelBlue);
	_COLOR(D2B48C, Tan);
	_COLOR(008080, Teal);
	_COLOR(D8BFD8, Thistle);
	_COLOR(FF6347, Tomato);
	_COLOR(40E0D0, Turquoise);
	_COLOR(EE82EE, Violet);
	_COLOR(F5DEB3, Wheat);
	_COLOR(FFFFFF, White);
	_COLOR(F5F5F5, WhiteSmoke);
	_COLOR(FFFF00, Yellow);
	_COLOR(9ACD32, YellowGreen);
#undef _COLOR
}
//- (id)init {
//	if (instance != nil) {
//		[NSExcep  tion
//		 raise:NSInternalInconsistencyException
//		 format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
//		 [self className],
//		 NSStringFromSelector(_cmd),
//		 [self className],
//		 NSStringFromSelector(@selector(instance))
//		 ];
//	} else if ((self = [super init])) {
//		instance = self;
//		[self _initColors];
//	}
//	return instance;
//}
+ (NSString *)nameOfColor:(NSColor *)color {
	return [self nameOfColor:color savingDistance:nil];
}
+ (NSString *)nameOfColor:(NSColor *)color savingDistance:(NSColor **)distance {
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

+ (NSC*) normal:(NSUI)idx { return [self.namedColors.colors normal:idx]; }// valueForKey:[[self allKeys] normal: idx]]; }

- (NSA*) colors { return [NSC colorsInListNamed:self.name]; }

@end
