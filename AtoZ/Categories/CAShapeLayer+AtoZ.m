
#import <QuartzCore/QuartzCore.h>

#import <AtoZ/AtoZ.h>
#import "CAShapeLayer+AtoZ.h"
#define SHAREDLASSO self.class.sharedLasso
#define ROOTL SHAREDLASSO.root

@interface       Lasso   ()
@property (weak)   CAL * hit;                     // victim, weakling (public via class getter)
@property          CAL * root;                    // host
@property       CASHLA * lasso, * highlight;      // two pieces o'twine
@end
@implementation                Lasso
SYNTHESIZE_SINGLETON_FOR_CLASS(Lasso,sharedLasso); static BOOL enabled = NO;

-   (id) init             { SUPERINIT;

  (_root = CAL.noHitLayer).sublayers = @[_highlight = CASHLA.noHitLayer,    _lasso = CASHLA.noHitLayer];
   /*_root.zPosition = 120000;*/        _highlight.strokeColor = cgWHITE;  [_lasso   b:@"lineDashPattern"
                                                                         tO:_lasso wKP:@"dynamicDash" o:nil];
  [_root disableResizeActions]; return self;
}

+ (void) setEnabled:(BOOL)e { if (!(enabled = e)) [self setFree]; } // liberate if we just disabled.
+ (BOOL) enabled            { return enabled; }
+ (BOOL) toggle             { self.enabled =! self.enabled; return self.enabled; }
+ (void) setFree            { IF_VOID(!SHAREDLASSO.hit); [ROOTL removeFromSuperlayer]; SHAREDLASSO.hit = nil; }
+ (void) rope:(CAL*)lyr     {

IF_VOID(          !lyr          // require thatthe layer exist
||          ISNOTA(lyr,CAL)     // that it be and ACTUAL layer
||        !enabled              // weareglobally enabled
|| EQUAL2ANYOF(    lyr,         // and the layer AINT any o these!
                 ROOTL.         // can't lasso yourself!
            superlayer,         //
                 ROOTL,
                        nil));

  [ROOTL removeFromSuperlayer];
  [ROOTL bindFrameToBoundsOf:lyr];
  [SHAREDLASSO.hit = lyr addSublayer:ROOTL];
  [SHAREDLASSO.lasso replaceAnimationForKey:@"chunky" withAnimation:[CABA dashPhaseAnimationForPerimeter:SHAREDLASSO.lasso.perimeter]];
}
+ hit { return SHAREDLASSO.hit; }
@end

@implementation CAShapeLayerAuto   - (id) init { SUPERINIT;

  self.arMASK       = CASIZEABLE;
  self.fillColor    = cgCLEARCOLOR;
  self.strokeColor  = cgBLACK;
  self.lineJoin     = kCALineJoinRound;
  self.zPosition    = 10000;
  self.pathForRect  = ^NSBP*(CASHL *l){

    return [NSBP withR:AZInsetRect(l.bounds, l.dynamicStroke/2.)];
  };
  [self b:@"lineWidth"   to:@"dynamicStroke" using:@1 type:BindTypeIfNil];
  [self b:@"path"      toKP:@"calculatedPath"];
  return self;
}
- (void) didMoveToSuperlayer { AZLOGCMD; [self bindFrameToBoundsOf:self.superlayer]; }

- (ACT) actionForKey:(NSS*)k { return [@[ kCAOnOrderIn, kCAOnOrderOut] containsObject:k] ? ({

  CABA *a = [CABA animationWithKeyPath:@"strokeStart"];
  a.toValue = SameString(k,@"onOrderIn") ? @1 : @0;// ? @(self.perimeter) : @0;
  CABA *b = [CABA animationWithKeyPath:@"lineDashPhase"];
  b.toValue = SameString(k,@"onOrderIn") ? @(self.perimeter) : @0;
  __unused CABA *c = [CABA animationWithKeyPath:@"strokeEnd"];
  b.toValue = SameString(k,@"onOrderIn") ? @(self.perimeter) : @0;

  a.duration = b.duration = .6;
  CAAnimationGroup*g = CAAnimationGroup.new; g.animations = @[a,b]; g;  }) : nil;
}

//  return SameString(k,@"onOrderIn") ? CAA.fadeInAnimation :
//         SameString(k,@"onOrderOut") ? CAA.fadeOutAnimation:
//  self.superlayer.loM = AZLAYOUTMGR;
//  [self addConstraintsSuperSize];
//  [self.superlayer setNeedsLayout];
//[self b:@"bounds" tO:self.superlayer wKP:@"bounds" o:nil];
//[self b:@"position" tO:self.superlayer wKP:@"position" o:nil]; }


@end

@implementation CAShapeLayer (Lassos)


SetKPfVA( DynamicDash,    @"dynamicStroke", @"superlayer");
SetKPfVA( CalculatedPath, @"bounds",          @"position");
SetKPfVA( DynamicStroke,  @"bounds");

SYNTHESIZE_ASC_CAST(pathForRect, setPathForRect,PathBlock);

-  (CGPR) calculatedPath { NSBP *p;

  NSLog(@"calculating path for rect:%@%@", AZStringFromRect(self.bounds), self.name ? [@" for layer named:" withString:self.name] : @"");

  return ((p = self.pathForRect ?  self.pathForRect(self)
                                : [NSBP bezierPathWithRoundedRect:self.frame cornerRadius:self.cornerRadius]))
                                ? p.quartzPath : self.path;
}
-   (CGF) dynamicStroke     { CGF base = .05 * AZMaxDim(self.size); return  base < 2 ? 2 : base > 5 ? 5 : base; }
-  (NSA*) dynamicDash       { CGF perimeter = self.perimeter;

  NSN* chunk = @(perimeter / (perimeter > 200 ? 32. : 16.)); return @[chunk,chunk];
}
-  (void) redrawPath         { self.path = self.calculatedPath; [self setNeedsDisplay];                  }
@end

//- (void) didChangeValueForKey:(NSString *)key { XX(key);  [super didChangeValueForKey:key]; }
//  [self setNeedsDisplay];
//  self.KVOBlock     = ^(CAL*l,NSS*k,id v){ LOGCOLORS(@"KVO BLOCK!! KEY:", k, @" LAYER:",l, nil);
//    if ([containsObject:k] || ((CASHL*)l).path == NULL) [(CASHL*)l redrawPath];
//  };

//  [self addObserverForKeyPaths:@[@"bounds", @"position"] task:^(id obj, NSString *keyPath) { [obj redrawPath]; }];
//  [self.root animate:@"opacity" to:@0 time:2 completion:^{
//  [self.lasso.lasso setLineDashPattern:self.lasso.lasso.dynamicDash]; [self.root setOpacity:1]; [CATRANNY transactionWithLength:2 actions:^{ [self.root setOpacity:1.]; }];  }];

@interface AZTextLayer : CATextLayer
@end
@implementation AZTextLayer
@end
@implementation CATextLayer (AtoZ) @dynamic sizeToFit;

- (NSAS*) attributedString {

 return [NSAS.alloc initWithString:self.string attributes:self.fontAttributes];
}
+     (NSST*) keyPathsForValuesAffectingStringBounds  { return NSSET(@"string", @"font", @"fontSize"); }

- (void) setSizeToFit:(BOOL)sizeToFit {

  self.arMASK = CASIZEABLE;
  [self addObserverForKeyPath:@"bounds" task:^(CATXTL* sender) {


      CGF x = [sender.attributedString pointSizeForSize:sender.size];
      XX(x);  [sender setFontSize:x];
//       [sender.string pointSizeForFrame:sender.bounds withFont:sender.font]];

    }];
}

//    NSMAS *maString = [sender attributedString].mC;
//    NSR cellFrame   = [sender bounds];
//    NSSZ stringSize = maString.size;

//    if (stringSize.width > cellFrame.size.width) {
//      while (stringSize.width > cellFrame.size.width) {
//        NSFont *font = [maString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
//        [maString addAttribute:NSFontAttributeName value:
//                 [NSFont fontWithName:font.fontName size:[font.fontDescriptor[NSFontSizeAttribute] floatValue] - 0.5]
//                                                   range:[(NSS*)maString range]];
//          stringSize = maString.size;
//      }
//    }
//    [(CATXTL*)sender setFontSize:stringSize];
//    NSR dRect            = cellFrame;
//    dRect.size.height    = stringSize.height;
//    dRect.origin.y      += (cellFrame.size.height - stringSize.height) / 2;
//    [maString drawInRect:dRect];

-       (NSR) stringBounds                            { if (!self.string) return NSZeroRect;

	NSAttributedString *as=  [self.string isKindOfClass:NSAttributedString.class] ? self.string : ^{

		NSFont* outfont; CFTypeRef layerfont = self.font;
			
		if(layerfont && ISA((__bridge id)layerfont,NSString))
      outfont = [NSFont fontWithName:(__bridge NSString*)layerfont size:self.fontSize];
		else {
			CFTypeID ftypeid = CFGetTypeID(layerfont);
			if(ftypeid == CTFontGetTypeID()) {
				CFStringRef fname = CTFontCopyPostScriptName(layerfont);
				outfont = [NSFont fontWithName:(__bridge NSString*)fname size:self.fontSize];
				CFRelease(fname);
			} 
			else if (ftypeid == CGFontGetTypeID()) {
				CFStringRef fname = CGFontCopyPostScriptName((CGFontRef)layerfont);
				outfont = [NSFont fontWithName:(__bridge NSString*)fname size:self.fontSize];
				CFRelease(fname);
			}
			else { // It's undefined, and defaults to Helvetica
				outfont = [NSFont systemFontOfSize:self.fontSize];
			}
		}
		return [NSAS.alloc initWithString:self.string attributes:@{NSFontAttributeName: outfont}];
	}();
		
  return AZCenteredRect([as size], self.frame);
}

-      (void) adjustBoundsToFit                       { self.frame = self.stringBounds; }

-      (NSS*) name        {  return [super name] ?: [self string] ?: nil; }
-       (CGR) dimensions  {

  return [self.class dimensionsForString:self.string
                                    font:((__bridge NSFont*)self.font).fontName //(__bridge NSString*)CTFontCopyPostScriptName(self.font) //
                                    size:self.fontSize];
}
+       (CGR) dimensionsForString:  (NSS*)s font:(NSS*)fontName size:(CGF)fontSize        {

    if (!s) return NSZeroRect;

  return [self.class dimensionsForAttributedString:[NSAS.alloc initWithString:s attributes:@{
                                                                        NSFontAttributeName:fontName ?
                                                                        [NSFont fontWithName:fontName size:fontSize] :
                                                                        [NSFont systemFontOfSize:fontSize]}]];
}

-      (void) setupAttributedTextLayerWithFont:(CTFontRef)font                            {

	NSD *baseAttributes     = @{(NSS *)kCTFontAttributeName : (__bridge id)font};
	NSMAS *attrString       = [NSMAS.alloc initWithString:self.string attributes:baseAttributes];
	CFRelease(font);
	//Make the class name in the string Courier Bold and red
	NSDictionary *fontAttributes = @{
    (NSS*)kCTFontFamilyNameAttribute: @"Courier",
		(NSS*)kCTFontStyleNameAttribute: @"Bold",
		(NSS*)kCTFontSizeAttribute: @16.f
  };
	CTFontRef courierFont   = [self.class newFontWithAttributes:fontAttributes];
	NSRNG rangeOfClassName  = [attrString.string rangeOfString:@"CATXTL"];
	[attrString addAttribute:(NSS *)kCTFontAttributeName            value:(__bridge id)courierFont range:rangeOfClassName];
	[attrString addAttribute:(NSS *)kCTForegroundColorAttributeName value: (id)cgRED                range:rangeOfClassName];
	CFRelease(courierFont);
	self.string             = attrString;
	self.wrapped            = YES;
	CFRange fitRange;
	CGRect textDisplayRect  = CGRectInset(self.bounds, 10.f, 10.f);
	CGSize recommendedSize  = [self.class suggestSizeAndFitRange:&fitRange forAttributedString:attrString usingSize:textDisplayRect.size];
	self.size         = recommendedSize;
	self.position           = AZCenterOfRect(self.superlayer.bounds); //	[attrString release];
}
+       (CGR) dimensionsForAttributedString:(NSAS*)asp                                    {

  CGF ascent = 0, descent = 0, width =  0;

//  CGMutablePathRef framePath    = CGPathCreateMutable();
//  CTFramesetterRef framesetter  = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)asp);
//  CFRange fullStringRange       = CFRangeMake(0, CFAttributedStringGetLength((CFAttributedStringRef)asp));
//  CTFrameRef aFrame             = CTFramesetterCreateFrame(framesetter, fullStringRange, framePath, NULL);
//  CFRelease(framePath);
//
//  CFArrayRef lines = CTFrameGetLines(aFrame);
//  CFIndex count = CFArrayGetCount(lines);
//  CGPoint *origins = malloc(sizeof(CGPoint)*count);
//  CTFrameGetLineOrigins(aFrame, CFRangeMake(0, count), origins);
//
//  // note that we only enumerate to count-1 in here-- we draw the last line separately
//  for (CFIndex i = 0; i < count-1; i++)
//  {
//    CGF ascent = 0, descent = 0;
//    CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
//    width = MAX(width, CTLineGetTypographicBounds( line, &ascent, &descent, NULL));  // Force width to integral.
//    ascentTot   += ascent;
//    descentTot  += descent;
//    CFRelease(line);
//  }
//
  CTLineRef line = CTLineCreateWithAttributedString( (CFAttributedStringRef) asp);
  width = CTLineGetTypographicBounds( line, &ascent, &descent, NULL );
  CFRelease(line);
  width = ceilf(width);                   // Force width to integral.
  if (((int)width)%2) width += 1.0;       // Force width to even.
  return CGRectMake(0, -descent, width, ceilf(ascent+descent));
}
+ (CTFontRef) newFontWithAttributes:(NSD*)attributes                                      {
	CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
	CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0, NULL);
	CFRelease(descriptor);
	return font;
}
+ (CTFontRef) newCustomFontWithName:(NSS*)fntNm ofType:(NSS*)type attributes:(NSD*)attrs  {

	NSString *fontPath                  = [AZFWORKBUNDLE pathForResource:fntNm ofType:type];
	NSData *data                        = [NSData.alloc initWithContentsOfFile:fontPath];
	CGDataProviderRef fontProvider      = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);   //	[data release];
	CGFontRef cgFont                    = CGFontCreateWithDataProvider(fontProvider);
	CGDataProviderRelease(fontProvider);
	CTFontDescriptorRef fontDescriptor  = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
	CTFontRef font                      = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
	CFRelease(fontDescriptor);
	CGFontRelease(cgFont);
	return font;
}
+      (CGSZ) suggestSizeAndFitRange:(CFRange*)range
                forAttributedString:(NSAS*)attrString
		                      usingSize:(CGSZ)referenceSize                                   {

	CTFramesetterRef framesetter  = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGSZ suggestedSize            =	CTFramesetterSuggestFrameSizeWithConstraints( framesetter,
                                                                                CFRangeMake(0, attrString.length),
                                                                                NULL,
                                                                                referenceSize,
                                                                                range);
	//HACK: There is a bug in Core Text where suggested size is not quite right
	//I'm padding it with half line height to make up for the bug.
	//see the coretext-dev list: http://web.archiveorange.com/archive/v/nagQXwVJ6Gzix0veMh09
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
	CGF ascent, descent, leading;
	CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGF lineHeight        = ascent + descent + leading;
	suggestedSize.height += lineHeight / 2.f;
	//END HACK
	return suggestedSize;
}
@end


@implementation CAGradientLayer (NSColors) // @dynamic nsColors;

- (void) setNSColors:(NSA*)nscs {	self.colors = [nscs arrayByPerformingSelector:@selector(CGColor)]; }
- (NSA*) NSColors { return [self.colors map:^id(id o) { return [NSC colorWithCGColor:(CGColorRef)o]; }]; }
@end


@interface InnerShadow :NSO
@property  NSC * color;
@property CGSZ   offset;
@property CGF    radius, 
                 opacity;
@end
@implementation InnerShadow @end

@implementation CAGradientLayer (InnerShadow) 

- (void) innerShadowWithColor:(NSC*)c off:(CGSZ)off rad:(CGF)r opacity:(CGF)o {


  __block InnerShadow *innerShadow  = self[@"innerShadow"] 
                                    = [InnerShadow.new objectBySettingValuesWithDictionary:

  @{@"color":c?:BLACK, @"offset": AZVsize(NSEqualSizes(off, NSZeroSize)? CGSizeMake(0, 3) : off), @"radius":@(r?:5.), @"opacity":@(o?:1.)}];
  


//+ (BOOL)needsDisplayForKey:(NSString *)key {
//	if ([key isEqualToString:@"innerShadowColor"] || [key isEqualToString:@"innerShadowRadius"] || [key isEqualToString:@"innerShadowOpacity"] || [key isEqualToString:@"innerShadowOffset"]) {
//		return YES;
//	}
//	return [super needsDisplayForKey:key];
//}

//- (id)actionForKey:(NSString *) key {
//	if ([key isEqualToString:@"innerShadowColor"] || [key isEqualToString:@"innerShadowRadius"] || [key isEqualToString:@"innerShadowOpacity"] || [key isEqualToString:@"innerShadowOffset"]) {
//		CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:key];
//		theAnimation.fromValue = [self.presentationLayer valueForKey:key];
//		return theAnimation;
//	}
//		return [super actionForKey:key];
//}

//- _Void_ drawInContext:(CGContextRef)ctx {

  [self setDrawInContextBlk:^(CALayer *l, CGContextRef ctx) {
    
      

    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat radius = l.cornerRadius;
    
    CGRect rect = l.bounds;
    if (l.borderWidth != 0) {
      rect = CGRectInset(rect, l.borderWidth, l.borderWidth);
      radius -= l.borderWidth;
      radius = MAX(radius, 0);
    }
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextClip(ctx);
      
    CGMutablePathRef outer = CGPathCreateMutable();
    CGPathAddRect(outer, NULL, CGRectInset(rect, -1*rect.size.width, -1*rect.size.height));
    
    CGPathAddPath(outer, NULL, bezierPath.CGPath);
    CGPathCloseSubpath(outer);
    
    
    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(innerShadow.color.CGColor);
    
    CGFloat newComponents[4];
    NSInteger numberOfComponents = CGColorGetNumberOfComponents(innerShadow.color.CGColor);
    
    switch (numberOfComponents){ case 2:  {
        //grayscale
        newComponents[0] = oldComponents[0];
        newComponents[1] = oldComponents[0];
        newComponents[2] = oldComponents[0];
        newComponents[3] = oldComponents[1]*innerShadow.opacity;   break;  } case 4: {
        //RGBA
        newComponents[0] = oldComponents[0];
        newComponents[1] = oldComponents[1];
        newComponents[2] = oldComponents[2];
        newComponents[3] = oldComponents[3]*innerShadow.opacity;    break;  }
    }    
    CGColorRef innerShadowColorWithMultipliedAlpha = CGColorCreate(colorspace, newComponents);
    CGColorSpaceRelease(colorspace);
    CGContextSetFillColorWithColor(ctx, innerShadowColorWithMultipliedAlpha);
    CGContextSetShadowWithColor(ctx, off, r, innerShadowColorWithMultipliedAlpha);
    CGContextAddPath(ctx, outer);
    CGContextEOFillPath(ctx);
    CGPathRelease(outer);
    CGColorRelease(innerShadowColorWithMultipliedAlpha);
  }];
}

@end