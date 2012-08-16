//
//  CALayer+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>



/** Constants for various commonly used colors. */
extern CGColorRef kBlackColor, kWhiteColor,
kTranslucentGrayColor, kTranslucentLightGrayColor,
kAlmostInvisibleWhiteColor,
kHighlightColor, kRedColor, kLightBlueColor;


/** Moves a layer from one superlayer to another, without changing its position onscreen. */
void ChangeSuperlayer( CALayer *layer, CALayer *newSuperlayer, int index );

/** Removes a layer from its superlayer without any fade-out animation. */
void RemoveImmediately( CALayer *layer );

/** Convenience for creating a CATextLayer. */
//CATextLayer* AddTextLayer( CALayer *superlayer,
//                           NSString *text, NSFont* font,
//                           enum CAAutoresizingMask align );


/** Loads an image or pattern file into a CGImage or CGPattern.
 If the name begins with "/", it's interpreted as an absolute filesystem path.
 Otherwise, it's the name of a resource that's looked up in the app bundle.
 The image must exist, or an assertion-failure exception will be raised!
 Loaded images/patterns are cached in memory, so subsequent calls with the same name
 are very fast. */
CGImageRef GetCGImageNamed( NSString *name );
CGColorRef GetCGPatternNamed( NSString *name );

/** Loads image data from the pasteboard into a CGImage. */
//CGImageRef GetCGImageFromPasteboard( NSPasteboard *pb );

/** Creates a CGPattern from a CGImage. */
CGPatternRef CreateImagePattern( CGImageRef image );

/** Creates a CGColor that draws the given CGImage as a pattern. */
CGColorRef CreatePatternColor( CGImageRef image );

/** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */
float GetPixelAlpha( CGImageRef image, CGSize imageSize, CGPoint pt );


#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))
CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

@interface CALayer (AtoZ)

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

- (void) addConstraintsRelativeToSuperlayer;

+ (CALayer*)closeBoxLayer; 
+ (CALayer*)closeBoxLayerForLayer:(CALayer*)parentLayer;

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient;


-(NSString*)debugDescription;
-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr;
//-(NSString*)debugLayerTree;

@end
