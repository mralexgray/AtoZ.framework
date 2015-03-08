


@interface            Lasso : NSObject

+ (void) rope: layer; // Howdy cowboy.  Rope yur layer, pardner. AUtoEnables!
+ (void) setFree; // aka UNrope. willhappen regardless if it needs to go elsewhere.

+   (id) hit; //hit test the location, and rope!

+ (BOOL) toggle;   // switch and return status.. so ya know.
+ (void) setEnabled:(BOOL)e; // setter
+ (BOOL) enabled;  // getter
@end

@interface CAShapeLayerAuto :  CAShapeLayer @end
#define CASHLA CAShapeLayerAuto

typedef NSBP*(^PathBlock)(id shp);

@interface CAShapeLayer (Lassos)

- (void) setPathForRect:(PathBlock)pathForRect;
@property (CP) PathBlock   pathForRect;
@prop_RO   CGPR   calculatedPath;
@prop_RO    CGF   dynamicStroke;
@prop_RO    NSA * dynamicDash;

@end


@interface CAGradientLayer (NSColors)
@property NSA* NSColors;
@end


@interface  CATextLayer (AtoZ)

@prop_RO NSAS * attributedString;
@prop_RO  NSR   stringBounds;
@property BOOL  sizeToFit;

- (void) adjustBoundsToFit;

-      (void) setupAttributedTextLayerWithFont:(CTFontRef)font;

/*! @return calculate dimensions for a text layer that already exists. */
@property (readonly) CGR dimensions;

/*! @abstract Use this if you are already storing your data as attributed strings.
        @code     

    CATextLayer *p = [[CATextLayer alloc] init];
    p.string = @"Wiggly wabbit!";
    p.font = CTFontCreateWithName( (CFStringRef)@"Verdana", 0.0, NULL);
    p.fontSize = 18.0;
    CGRect TR = [self dimensionsForTextLayer: p];
    p.anchorPoint = CGPointMake(0, -TR.origin.y/TR.size.height);    // left side of baseline
    p.bounds = TR;
    p.position = CGPointMake( 150, 100 );
*/
+ (CGR) dimensionsForAttributedString: (NSAS*)as;
// Use this if you are using plain strings and you need to calculate a new size for a change you are about to make.
+ (CGR) dimensionsForString:(NSS*)s font:(NSS*)fontName size:(CGF)fontSize;

+    (CGSize) suggestSizeAndFitRange:(CFRange*)range	forAttributedString:(NSMAS*)attrStr usingSize:(CGSZ)referenceSz;
@end

//+ (CTFontRef) customFontWithName:(NSS*)fontName ofType:(NSS*)type attributes:(NSD*)attrs;
//+ (CTFontRef) fontWithAttributes:(NSD*)attributes;


@interface CAGradientLayer (InnerShadow)  // from  "SKInnerShadowLayer.h"

- (void) innerShadowWithColor:(NSC*)c off:(CGSZ)off rad:(CGF)r opacity:(CGF)o;
@end

