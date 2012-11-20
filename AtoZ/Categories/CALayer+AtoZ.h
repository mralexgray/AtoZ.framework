	//
	//  CALayer+AtoZ.h
	//  AtoZ
	//
	//  Created by Alex Gray on 7/13/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "AtoZ.h"


@interface CAShapeLayer (Lassos)
- (void) redrawPath;
@end

void prepareContext(CGContextRef ctx);

extern void applyPerspective (CALayer* layer);
//	extern CATransform3D perspective();

/** Moves a layer from one superlayer to another, without changing its position onscreen. */
extern void ChangeSuperlayer( CALayer *layer, CALayer *newSuperlayer, int index );
/** Removes a layer from its superlayer without any fade-out animation. */
extern void RemoveImmediately( CALayer *layer );

extern CALayer* AddPulsatingBloom( CALayer *layer);
extern CALayer* AddShadow ( CALayer *layer);
extern CALayer* AddBloom  ( CALayer *layer);

/** Convenience for creating, adding,a nd returning a relatively nice CALayer. */
extern CALayer* NewLayerInLayer( CALayer *superlayer );
extern CALayer* NewLayerWithFrame( NSRect rect );

/** Convenience for creating a CATextLayer. */
extern CATextLayer* AddTextLayer  ( CALayer *superlayer, NSString *text, NSFont* font, enum CAAutoresizingMask align );
extern CATextLayer* AddLabelLayer ( CALayer *superlayer, NSString *text, NSFont* font );
extern CATextLayer* AddLabel ( 	    CALayer *superlayer, NSString *text );

extern CALayer* ReturnImageLayer( CALayer *superlayer, NSImage *image, CGFloat scale);
extern CATextLayer* AddLabelLayer( CALayer *superlayer, NSString *text, NSFont* font );

/** Loads an image or pattern file into a CGImage or CGPattern. If the name begins with "/", it's interpreted as an absolute filesystem path. Otherwise, it's the name of a resource that's looked up in the app bundle. The image must exist, or an assertion-failure exception will be raised! Loaded images/patterns are cached in memory, so subsequent calls with the same name are very fast. */
extern CGImageRef GetCGImageNamed ( NSString *name );
extern CGColorRef GetCGPatternNamed (      NSString *name );
/** Loads image data from the pasteboard into a CGImage. */
extern CGImageRef GetCGImageFromPasteboard ( NSPasteboard *pb );
/** Creates a CGPattern from a CGImage. */
extern CGPatternRef CreateImagePattern ( CGImageRef image );
/** Creates a CGColor that draws the given CGImage as a pattern. */
extern CGColorRef CreatePatternColor ( CGImageRef image );
/** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */
float GetPixelAlpha ( CGImageRef image, CGSize imageSize, CGPoint pt );

/**
As with the distort transform, the x and y values adjust intensity. I have included a CATransform3DMake method as there are no built in CATransform3D methods to create a transform by passing in 16 values (mimicking the CGAffineTransformMake method).

For those that have never seen the CATransform3D struct before, you must apply the transform to a CALayer‘s transform, as opposed to a CGAffineTransform which is applied to the UIView‘s transform. If you want to apply it to a UIView, obtain it’s layer then set the transform (myView.layer = CATransform3DMakePerspective(0.002, 0)).

	What do represent the two parameters in CATransform3DMakePerspective(0.002, 0) ?
 	The first is how much you want it to skew on the X axis (horizontally), and the second for the Y axis (vertically)

	Yes, but what are the units ? (radians … ?)
	The value goes directly into the transform, if you want to make it radians, or any other type of unit you will need to put some math in there
 */
extern CATransform3D CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44);
//
//
//	CG_INLINE CATransform3D CATransform3DMake( CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
//					  						   CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
//											   CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
//											   CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44);

@interface CALayer (VariadicConstraints)
- (void)addConstraintsRelSuper:(CAConstraintAttribute)first,...; /* REQUIRES NSNotFound termination */
//- (void) addConstraintsRelSuper:(CAConstraintAttribute) nilAttributeList, ...;  // This method takes a nil-terminated list of objects.
@end

@interface CALayer (AtoZ)

-(id)initWithFrame:(CGRect)rect;

- (void)moveToFront;

@property (strong, nonatomic) CAL *root;
@property (strong, nonatomic) CATXTL *text;
@property (ASS, NATOM) AZPOS orient;
//
- (void)setValue:(id)value      forKeyPath:(NSString *)keyPath        duration:(CFTimeInterval)duration           delay:(CFTimeInterval)delay;


-(void) animateXThenYToFrame:(NSR)toRect duration:(NSUI)time;


- (void)blinkLayerWithColor:(NSColor *)color;

- (void) addPerspectiveForVerticalOffset:(CGFloat)pixels;
- (CAL*)hitTestEvent:(NSEvent*)e inView:(NSView*)v;

- (void) toggleLasso:(BOOL)state;

- (id) lassoLayerForLayer:(CALayer*)layer;


- (CALayer*) selectionLayerForLayer:(CALayer*)layer;
- (CATransform3D)makeTransformForAngle:(CGFloat)angle;

//- (id)objectForKeyedSubscript:(NSString *)key;
//- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

- (void)addConstraints:(NSA*)constraints;
- (void)orientWithPoint:(CGPoint) point;
- (void)orientWithX: (CGFloat)x andY: (CGFloat)y;
//- (void)orientOnEvent: (NSEvent*)event;

- (void) setAnchorPointRelative: (CGPoint) anchorPoint;
- (void) setAnchorPoint: (CGPoint) anchorPoint inRect:(NSRect)rect;
- (void) setAnchorPoint: (CGPoint) anchorPoint inView: (NSView *) view;
//- (void) flipHorizontally;
//- (void) flipVertically;
- (void) flipBackAtEdge:	(AZWindowPosition)position;
- (void) flipForwardAtEdge: (AZWindowPosition)position;

- (CATransform3D) flipAnimationPositioned:(AZWindowPosition)pos;

- (void) flipOver;
- (void) flipBack;
- (void) flipDown;

- (void) setScale: (CGFloat) scale;

- (void)pulse;
- (void)fadeOut;
- (void)fadeIn;
- (void)animateToColor:(NSColor*)color;

- (void)addAnimations:(NSA*)anims forKeys:(NSArray *)keys;

+ (instancetype) layerNamed:(NSS*)name;

+ (CALayer *) withName:(NSString*)name   inFrame:(NSRect)rect
			   colored:(NSColor*)color withBorder:(CGFloat)width colored:(NSColor*) borderColor;

-(void)rotateAroundYAxis:(CGFloat)radians;

- (CATransform3D)makeTransformForAngle:(CGFloat)angle from:(CATransform3D)start;
- (BOOL)containsOpaquePoint:(CGPoint)p;
- (CALayer *) labelLayer;
- (CALayer *) setLabelString:(NSString *)label;
- (id) sublayerWithName:(NSString *)name;
+ (CALayer*)veilForView:(CALayer*)view;

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

- (void) addConstraintsSuperSizeScaled:(CGFloat)scale;
- (void) addConstraintsSuperSize;
+ (CALayer*)closeBoxLayer;
+ (CALayer*)closeBoxLayerForLayer:(CALayer*)parentLayer;

	//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient;
-(NSString*)debugDescription;

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr;
- (NSString*)debugLayerTree;
- (void) addSublayers:(NSA*)subLayers;

+ (CALayer*)newGlowingSphereLayer;



@end
@interface CALayer (LTKAdditions)

@property (weak, readonly) CAL* permaPresentation;


@property (readwrite, nonatomic, assign) CGPoint frameOrigin;
@property (readwrite, nonatomic, assign) CGSize frameSize;
@property (readwrite, nonatomic, assign) CGFloat frameX;
@property (readwrite, nonatomic, assign) CGFloat frameY;
@property (readwrite, nonatomic, assign) CGFloat frameWidth;
@property (readwrite, nonatomic, assign) CGFloat frameHeight;
@property (readwrite, nonatomic, assign) CGFloat frameMinX;
@property (readwrite, nonatomic, assign) CGFloat frameMidX;
@property (readwrite, nonatomic, assign) CGFloat frameMaxX;
@property (readwrite, nonatomic, assign) CGFloat frameMinY;
@property (readwrite, nonatomic, assign) CGFloat frameMidY;
@property (readwrite, nonatomic, assign) CGFloat frameMaxY;
@property (readwrite, nonatomic, assign) CGPoint frameTopLeftPoint;
@property (readwrite, nonatomic, assign) CGPoint frameTopMiddlePoint;
@property (readwrite, nonatomic, assign) CGPoint frameTopRightPoint;
@property (readwrite, nonatomic, assign) CGPoint frameMiddleRightPoint;
@property (readwrite, nonatomic, assign) CGPoint frameBottomRightPoint;
@property (readwrite, nonatomic, assign) CGPoint frameBottomMiddlePoint;
@property (readwrite, nonatomic, assign) CGPoint frameBottomLeftPoint;
@property (readwrite, nonatomic, assign) CGPoint frameMiddleLeftPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsOrigin;
@property (readwrite, nonatomic, assign) CGSize boundsSize;
@property (readwrite, nonatomic, assign) CGFloat boundsX;
@property (readwrite, nonatomic, assign) CGFloat boundsY;
@property (readwrite, nonatomic, assign) CGFloat boundsWidth;
@property (readwrite, nonatomic, assign) CGFloat boundsHeight;
@property (readwrite, nonatomic, assign) CGFloat boundsMinX;
@property (readwrite, nonatomic, assign) CGFloat boundsMidX;
@property (readwrite, nonatomic, assign) CGFloat boundsMaxX;
@property (readwrite, nonatomic, assign) CGFloat boundsMinY;
@property (readwrite, nonatomic, assign) CGFloat boundsMidY;
@property (readwrite, nonatomic, assign) CGFloat boundsMaxY;
@property (readwrite, nonatomic, assign) CGPoint boundsTopLeftPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsTopMiddlePoint;
@property (readwrite, nonatomic, assign) CGPoint boundsTopRightPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsMiddleRightPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsBottomRightPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsBottomMiddlePoint;
@property (readwrite, nonatomic, assign) CGPoint boundsBottomLeftPoint;
@property (readwrite, nonatomic, assign) CGPoint boundsMiddleLeftPoint;
@property (readwrite, nonatomic, assign) CGFloat positionX;
@property (readwrite, nonatomic, assign) CGFloat positionY;

+ (id)layerWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame;

- (void)setAnchorPointAndPreserveCurrentFrame:(CGPoint)anchorPoint;

+ (CGFloat)smallestWidthInLayers:(NSArray *)layers;
+ (CGFloat)smallestHeightInLayers:(NSArray *)layers;
+ (CGFloat)largestWidthInLayers:(NSArray *)layers;
+ (CGFloat)largestHeightInLayers:(NSArray *)layers;

- (CALayer *)presentationCALayer;
- (CALayer *)modelCALayer;

- (void)addDefaultFadeTransition;
- (void)addDefaultMoveInTransitionWithSubtype:(NSString *)subtype;
- (void)addDefaultPushTransitionWithSubtype:(NSString *)subtype;
- (void)addDefaultRevealTransitionWithSubtype:(NSString *)subtype;
- (void)addFadeTransitionWithDuration:(NSTimeInterval)duration;
- (void)addMoveInTransitionWithSubtype:(NSString *)subtype duration:(NSTimeInterval)duration;
- (void)addPushTransitionWithSubtype:(NSString *)subtype duration:(NSTimeInterval)duration;
- (void)addRevealTransitionWithSubtype:(NSString *)subtype duration:(NSTimeInterval)duration;

- (void)addAnimation:(CAAnimation *)animation;
- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key withStopBlock:(void (^)(BOOL finished))stopBlock;
- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key withStartBlock:(void (^)(void))startBlock stopBlock:(void (^)(BOOL finished))stopBlock;
- (void)replaceAnimationForKey:(NSString *)key withAnimation:(CAAnimation *)animation;
- (NSArray *)keyedAnimations;

- (NSImage *)renderToImage;
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize;
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize contextTransform:(CGAffineTransform)contextTransform;

- (void)enableDebugBordersRecursively:(BOOL)recursively;
@end
@interface  CATextLayer (AtoZ)
- (CTFontRef)newFontWithAttributes:(NSDictionary *)attributes;
- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes;
- (CGSize)suggestSizeAndFitRange:(CFRange *)range	forAttributedString:(NSMutableAttributedString *)attrString
															  usingSize:(CGSize)referenceSize;
- (void)setupAttributedTextLayerWithFont:(CTFontRef)font;

@end

@interface CALayerNonAnimating : CALayer
- (id<CAAction>)actionForKey:(NSString *)key;
@end


@interface CAScrollLayer (CAScrollLayer_Extensions)
- (void)scrollBy:(CGPoint)inDelta;
- (void)scrollCenterToPoint:(CGPoint)inPoint;
@end

typedef void(^MPRenderASCIIBlock)(NSString* art);

@interface CALayer (MPPixelHitTesting)

- (BOOL) pixelsHitTest:(CGPoint)p;
- (BOOL) pixelsIntersectWithRect:(CGRect)rect;

- (void) setRenderASCIIBlock:(MPRenderASCIIBlock)block;
- (MPRenderASCIIBlock) renderASCIIBlock;

@end

