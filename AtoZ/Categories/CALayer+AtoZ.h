	//
	//  CAL+AtoZ.h
	//  AtoZ
	//
	//  Created by Alex Gray on 7/13/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "AtoZ.h"

CAT3D CA3DxRotation(float x);
CAT3D CA3DyRotation(float y);
CAT3D CA3DzRotation(float z);

CAT3D CA3DTransform3DConcat(CAT3D xRotation, CAT3D yRotation);
CAT3D CA3DxyZRotation(CAT3D xYRotation, CAT3D zRotation);
CAT3D CA3DConcatenatedTransformation(CAT3D xyZRotation, CAT3D transformation );
//CAT3D concatenatedTransformation = CAT3DConcat(xRotation, transformation);

#ifdef INVISIBLE

** EXAMPLE **

- (void) animateLayerOpacity 
{
	CABA <#name#> =	[CABA animationWithKeyPath:<#keypath#>];
   <#name#>.beginTime 	= <#interval#>;		<#name#>.endTime 		= <#interval#>;   <#name#>.repeatCount 	= <#repeats#>;
   <#name#>.fromValue 	= @<#from#>;    	<#name#>.toValue 		= @<#to#>;

   animation.delegate = delegate = CAAnimationBlockDelegate *delegate = 	CAAnimationBlockDelegate.new;
	delegate.blockOnAnimationStarted 		= ^() { <#logic#> 	};
   delegate.blockOnAnimationSucceeded 	= ^() { <#logic#> };
	[layer addAnimation:<#name#>	forKey:nil];
}
#endif

@interface CAAnimationBlockDelegate : NSObject

// Block to call when animation is started
@property (nonatomic, strong) void(^blockOnAnimationStarted)(void);
// Block to call when animation is successful
@property (nonatomic, strong) void(^blockOnAnimationSucceeded)(void);
// Block to call when animation fails
@property (nonatomic, strong) void(^blockOnAnimationFailed)(void);	
										
/* Delegate method called by CAAnimation at start of animation
 * @param theAnimation animation which issued the callback.	*/
- (void)animationDidStart:(CAAnimation *)theAnimation;

/* Delegate method called by CAAnimation at end of animation
 * @param theAnimation animation which issued the callback.
 * @param finished BOOL indicating whether animation succeeded or failed.	 */
- (void)animationDidStop:(CAAnimation *)theAnimation	finished:(BOOL)flag;
@end


@interface CAShapeLayer (Lassos)
- (void) redrawPath;
@end

void prepareContext(CGContextRef ctx);
extern void applyPerspective (CAL* layer);
//	extern CAT3D perspective();

/** Moves a layer from one superlayer to another, without changing its position onscreen. */
extern void ChangeSuperlayer( CAL *layer, CAL *newSuperlayer, int index );
/** Removes a layer from its superlayer without any fade-out animation. */
extern void RemoveImmediately( CAL *layer );
/** Removes receivers sublayers */
extern void RemoveSublayers( CAL *layer );

extern CAL* AddPulsatingBloom( CAL *layer);
extern CAL* AddShadow ( CAL *layer);
extern CAL* AddBloom  ( CAL *layer);

/** Convenience for creating, adding,a nd returning a relatively nice CAL. */
extern CAL* NewLayerInLayer( CAL *superlayer );
extern CAL* NewLayerWithFrame( NSRect rect );

/** Convenience for creating a CATextLayer. */
extern CATextLayer* AddTextLayer  ( CAL *superlayer, NSString *text, NSFont* font, enum CAAutoresizingMask align );
extern CATextLayer* AddLabelLayer ( CAL *superlayer, NSString *text, NSFont* font );
extern CATextLayer* AddLabel ( 		CAL *superlayer, NSString *text );

extern CAL* ReturnImageLayer( CAL *superlayer, NSImage *image, CGF scale);
extern CATextLayer* AddLabelLayer( CAL *superlayer, NSString *text, NSFont* font );

/** Loads an image or pattern file into a CGImage or CGPattern. If the name begins with "/", it's interpreted as an absolute filesystem path. Otherwise, it's the name of a resource that's looked up in the app bundle. The image must exist, or an assertion-failure exception will be raised! Loaded images/patterns are cached in memory, so subsequent calls with the same name are very fast. */
extern CGImageRef GetCGImageNamed ( NSString *name );
extern CGColorRef GetCGPatternNamed (	  NSString *name );
/** Loads image data from the pasteboard into a CGImage. */
extern CGImageRef GetCGImageFromPasteboard ( NSPasteboard *pb );
/** Creates a CGPattern from a CGImage. */
extern CGPatternRef CreateImagePattern ( CGImageRef image );
/** Creates a CGColor that draws the given CGImage as a pattern. */
extern CGColorRef CreatePatternColor ( CGImageRef image );
/** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */
float GetPixelAlpha ( CGImageRef image, CGSize imageSize, CGP pt );

/**
As with the distort transform, the x and y values adjust intensity. I have included a CAT3DMake method as there are no built in CAT3D methods to create a transform by passing in 16 values (mimicking the CGAffineTransformMake method).

For those that have never seen the CAT3D struct before, you must apply the transform to a CAL‘s transform, as opposed to a CGAffineTransform which is applied to the UIView‘s transform. If you want to apply it to a UIView, obtain it’s layer then set the transform (myView.layer = CAT3DMakePerspective(0.002, 0)).

	What do represent the two parameters in CAT3DMakePerspective(0.002, 0) ?
 	The first is how much you want it to skew on the X axis (horizontally), and the second for the Y axis (vertically)

	Yes, but what are the units ? (radians … ?)
	The value goes directly into the transform, if you want to make it radians, or any other type of unit you will need to put some math in there	*/
extern CAT3D CAT3DMake(CGF m11, CGF m12, CGF m13, CGF m14,
				  CGF m21, CGF m22, CGF m23, CGF m24,
				  CGF m31, CGF m32, CGF m33, CGF m34,
				  CGF m41, CGF m42, CGF m43, CGF m44);
//
//
//	CG_INLINE CAT3D CAT3DMake( CGF m11, CGF m12, CGF m13, CGF m14,
//					  						   CGF m21, CGF m22, CGF m23, CGF m24,
//											   CGF m31, CGF m32, CGF m33, CGF m34,
//											   CGF m41, CGF m42, CGF m43, CGF m44);

@interface CAL (VariadicConstraints)
- (void)addConstraintsRelSuper:(CAConstraintAttribute)first,...; /* REQUIRES NSNotFound termination */
//- (void) addConstraintsRelSuper:(CAConstraintAttribute) nilAttributeList, ...;  // This method takes a nil-terminated list of objects.
@end

@interface CAL (AtoZ)

- (NSA*) sublayersOfClass:(Class)k;
- (void) removeImmediately;
- (void) removeSublayers;

- (CAL*)addImageLayer:(NSImage*)image scale:(CGF)scale;
- (CATXTL*)addTextLayer:(NSS*)text font:(NSFont*)font align:(enum CAAutoresizingMask)align;


- (NSS*)strKey:		(NSS*)defaultName;
- (NSA*)arrKey: 	(NSS*)defaultName;
- (NSD*)dicKey: 	(NSS*)defaultName;
- (NSData*)dataKey:	(NSS*)defaultName;
- (NSI)iKey:		(NSS*)defaultName;
- (CGF)fKey:		(NSS*)defaultName;
- (BOOL)boolKey:	(NSS*)defaultName;
//- (NSURL*)URLKey:	(NSS*)defaultName;


- (CAL*) named:(NSS*)name;
- (CAL*) colored:(NSColor*)color;
- (CAL*) withFrame:(NSR)frame;
- (CAL*) withConstraints:(NSA*)constraints;

- (id) copyLayer;

- (CAL*) hitTestSubs:(CGP)point;

- (void) addSublayer:(CAL*)layer named:(NSS*)name;

- (void) addSublayerImmediately:(CAL*)sub;
- (void) addSublayersImmediately:(NSA*)subArray;
- (void) insertSublayerImmediately:(CAL*)sub atIndex:(NSUI)idx;


- (void) toggleSpin: (AZState)state;

-(id)initWithFrame:(CGRect)rect;

- (void)moveToFront;

@property (strong, nonatomic) CAL *root;
@property (strong, nonatomic) CATXTL *text;
@property (ASS, NATOM) AZPOS orient;
//
- (void)setValue:(id)value	  forKeyPath:(NSString *)keyPath		duration:(CFTimeInterval)duration		   delay:(CFTimeInterval)delay;


-(void) animateXThenYToFrame:(NSR)toRect duration:(NSUI)time;


- (void)blinkLayerWithColor:(NSColor *)color;

- (void) addPerspectiveForVerticalOffset:(CGF)pixels;
- (CAL*)hitTestEvent:(NSEvent*)e inView:(NSView*)v;

- (void) toggleLasso:(BOOL)state;

- (id) lassoLayerForLayer:(CAL*)layer;




- (CAL*) selectionLayerForLayer:(CAL*)layer;
- (CAT3D)makeTransformForAngle:(CGF)angle;

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

- (void)addConstraints:(NSA*)constraints;
- (void)orientWithPoint:(CGP) point;
- (void)orientWithX: (CGF)x andY: (CGF)y;
//- (void)orientOnEvent: (NSEvent*)event;

- (void) setAnchorPointRelative: (CGP) anchorPoint;
- (void) setAnchorPoint: (CGP) anchorPoint inRect:(NSRect)rect;
- (void) setAnchorPoint: (CGP) anchorPoint inView: (NSView *) view;
//- (void) flipHorizontally;
//- (void) flipVertically;
- (void) flipBackAtEdge:	(AZWindowPosition)position;
- (void) flipForwardAtEdge: (AZWindowPosition)position;

- (void) flipForward:(BOOL)forward  atPosition:(AZWindowPosition)pos duration:(NSTI)time;
- (CAT3D) flipForward:(BOOL)forward  atPosition:(AZPOS)pos;

+ (CAT3D) flipAnimationPositioned:(AZPOS)pos;

- (void) flipOver;
- (void) flipBack;
- (void) flipDown;

- (void) setScale: (CGF) scale;

- (void)pulse;
- (void)fadeOut;
- (void)fadeIn;
- (void)animateToColor:(NSColor*)color;

- (void)addAnimations:(NSA*)anims forKeys:(NSArray *)keys;

+ (instancetype) layerNamed:(NSS*)name;

+ (CAL *) withName:(NSString*)name   inFrame:(NSRect)rect
			   colored:(NSColor*)color withBorder:(CGF)width colored:(NSColor*) borderColor;

-(void)rotateAroundYAxis:(CGF)radians;

- (CAT3D)makeTransformForAngle:(CGF)angle from:(CAT3D)start;
- (BOOL)containsOpaquePoint:(CGP)p;
- (CAL *) labelLayer;
- (CAL *) setLabelString:(NSString *)label;
- (id) sublayerWithName:(NSString *)name;
+ (CAL*)veilForView:(CAL*)view;

- (CAT3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

- (void) addConstraintsSuperSizeScaled:(CGF)scale;
- (void) addConstraintsSuperSize;
+ (CAL*)closeBoxLayer;
+ (CAL*)closeBoxLayerForLayer:(CAL*)parentLayer;

	//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient;
-(NSString*)debugDescription;

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr;
- (NSString*)debugLayerTree;
- (void) addSublayers:(NSA*)subLayers;

+ (CAL*)newGlowingSphereLayer;



@end
@interface CAL (LTKAdditions)

- (CAL*) permaPresentation;

@property (readwrite, nonatomic, assign) BOOL hovered;
@property (readwrite, nonatomic, assign) BOOL selected;

@property (readwrite, nonatomic, assign) CGP frameOrigin;
@property (readwrite, nonatomic, assign) CGSize frameSize;
@property (readwrite, nonatomic, assign) CGF frameX;
@property (readwrite, nonatomic, assign) CGF frameY;
@property (readwrite, nonatomic, assign) CGF frameWidth;
@property (readwrite, nonatomic, assign) CGF frameHeight;
@property (readwrite, nonatomic, assign) CGF frameMinX;
@property (readwrite, nonatomic, assign) CGF frameMidX;
@property (readwrite, nonatomic, assign) CGF frameMaxX;
@property (readwrite, nonatomic, assign) CGF frameMinY;
@property (readwrite, nonatomic, assign) CGF frameMidY;
@property (readwrite, nonatomic, assign) CGF frameMaxY;
@property (readwrite, nonatomic, assign) CGP frameTopLeftPoint;
@property (readwrite, nonatomic, assign) CGP frameTopMiddlePoint;
@property (readwrite, nonatomic, assign) CGP frameTopRightPoint;
@property (readwrite, nonatomic, assign) CGP frameMiddleRightPoint;
@property (readwrite, nonatomic, assign) CGP frameBottomRightPoint;
@property (readwrite, nonatomic, assign) CGP frameBottomMiddlePoint;
@property (readwrite, nonatomic, assign) CGP frameBottomLeftPoint;
@property (readwrite, nonatomic, assign) CGP frameMiddleLeftPoint;
@property (readwrite, nonatomic, assign) CGP boundsOrigin;
@property (readwrite, nonatomic, assign) CGSize boundsSize;
@property (readwrite, nonatomic, assign) CGF boundsX;
@property (readwrite, nonatomic, assign) CGF boundsY;
@property (readwrite, nonatomic, assign) CGF boundsWidth;
@property (readwrite, nonatomic, assign) CGF boundsHeight;
@property (readwrite, nonatomic, assign) CGF boundsMinX;
@property (readwrite, nonatomic, assign) CGF boundsMidX;
@property (readwrite, nonatomic, assign) CGF boundsMaxX;
@property (readwrite, nonatomic, assign) CGF boundsMinY;
@property (readwrite, nonatomic, assign) CGF boundsMidY;
@property (readwrite, nonatomic, assign) CGF boundsMaxY;
@property (readwrite, nonatomic, assign) CGP boundsTopLeftPoint;
@property (readwrite, nonatomic, assign) CGP boundsTopMiddlePoint;
@property (readwrite, nonatomic, assign) CGP boundsTopRightPoint;
@property (readwrite, nonatomic, assign) CGP boundsMiddleRightPoint;
@property (readwrite, nonatomic, assign) CGP boundsBottomRightPoint;
@property (readwrite, nonatomic, assign) CGP boundsBottomMiddlePoint;
@property (readwrite, nonatomic, assign) CGP boundsBottomLeftPoint;
@property (readwrite, nonatomic, assign) CGP boundsMiddleLeftPoint;
@property (readwrite, nonatomic, assign) CGF positionX;
@property (readwrite, nonatomic, assign) CGF positionY;

+ (id)layerWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame;

- (void)setAnchorPointAndPreserveCurrentFrame:(CGP)anchorPoint;

+ (CGF)smallestWidthInLayers:(NSArray *)layers;
+ (CGF)smallestHeightInLayers:(NSArray *)layers;
+ (CGF)largestWidthInLayers:(NSArray *)layers;
+ (CGF)largestHeightInLayers:(NSArray *)layers;

- (CAL *)presentationCAL;
- (CAL *)modelCAL;

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

@interface CALNonAnimating : CAL
- (id<CAAction>)actionForKey:(NSString *)key;
@end


@interface CAScrollLayer (CAScrollLayer_Extensions)
- (void)scrollBy:(CGP)inDelta;
- (void)scrollCenterToPoint:(CGP)inPoint;
@end

typedef void(^MPRenderASCIIBlock)(NSString* art);

@interface CAL (MPPixelHitTesting)

- (BOOL) pixelsHitTest:(CGP)p;
- (BOOL) pixelsIntersectWithRect:(CGRect)rect;

- (void) setRenderASCIIBlock:(MPRenderASCIIBlock)block;
- (MPRenderASCIIBlock) renderASCIIBlock;

@end

