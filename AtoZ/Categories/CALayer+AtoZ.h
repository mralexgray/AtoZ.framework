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
   <#name#>.fromValue 	= @<#from#>;		<#name#>.toValue 		= @<#to#>;

   animation.delegate = delegate = CAAnimationBlockDelegate *delegate = 	CAAnimationBlockDelegate.new;
	delegate.blockOnAnimationStarted 		= ^() { <#logic#> 	};
   delegate.blockOnAnimationSucceeded 	= ^() { <#logic#> };
	[layer addAnimation:<#name#>	forKey:nil];
}
#endif

@interface CAShapeLayer (Lassos)
- (void) redrawPath;
@end

void      prepareContext ( CGContextRef ctx );
void    applyPerspective ( CAL *l );	//	CAT3D perspective();
void   RemoveImmediately ( CAL *l );  /** Removes layer from superlayer without any fade-out animation. */
void     RemoveSublayers ( CAL *l ); /** Removes receivers sublayers */
void    ChangeSuperlayer ( CAL *l, CAL *newSuperL, int x ); /** Moves a layer from one superlayer to another, without changing its position onscreen. */

CAL*   AddPulsatingBloom ( CAL *l );
CAL* 			   AddShadow ( CAL *l );
CAL* 				 AddBloom ( CAL *l );
/** Convenience for creating, adding,a nd returning a relatively nice CAL. */
CAL*     NewLayerInLayer ( CAL *superL );
CAL*   NewLayerWithFrame ( NSR rect    );
/** Convenience for creating a CATextLayer. */
CATXTL* 			 AddLabel ( CAL *superL, NSS *text );
CATXTL*    AddLabelLayer ( CAL *superL, NSS *text, NSF *font );
CATXTL*     AddTextLayer ( CAL *superL, NSS *text, NSF *font, enum CAAutoresizingMask align );
CAL* 	  ReturnImageLayer ( CAL *superL, NSIMG *img, CGF scale );
CATXTL*    AddLabelLayer ( CAL *superL, NSS 	*text, NSF *font );

CGImageRef 	         GetCGImageNamed ( NSS *name ); /* Loads an image or pattern file into a CGImage or CGPattern. If the name begins with "/", it's interpreted as an absolute filesystem path. Otherwise, it's the name of a resource that's looked up in the app bundle. The image must exist, or an assertion-failure exception will be raised! Loaded images/patterns are cached in memory, so subsequent calls with the same name are very fast. */
CGColorRef	       GetCGPatternNamed ( NSS *name );
CGImageRef 	GetCGImageFromPasteboard ( NSPasteboard *pb ); /** Loads image data from the pasteboard into a CGImage. */
CGPatternRef      CreateImagePattern ( CGImageRef image ); /** Creates a CGPattern from a CGImage. */
CGColorRef        CreatePatternColor ( CGImageRef image ); /** Creates a CGColor that draws the given CGImage as a pattern. */
CGF                    GetPixelAlpha ( CGImageRef image, CGSize imageSize, CGP pt ); /** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */

/* As with the distort transform, the x and y values adjust intensity. I have included a CAT3DMake method as there are no built in CAT3D methods to create a transform by passing in 16 values (mimicking the CGAffineTransformMake method).
	For those that have never seen the CAT3D struct before, you must apply the transform to a CAL‘s transform, as opposed to a CGAffineTransform which is applied to the UIView‘s transform. If you want to apply it to a UIView, obtain it’s layer then set the transform (myView.layer = CAT3DMakePerspective(0.002, 0)).
	What do represent the two parameters in CAT3DMakePerspective(0.002, 0) ?
 	The first is how much you want it to skew on the X axis (horizontally), and the second for the Y axis (vertically)
	Yes, but what are the units ? (radians … ?)
	The value goes directly into the transform, if you want to make it radians, or any other type of unit you will need to put some math in there	*/

CAT3D CAT3DMake( CGF m11, CGF m12, CGF m13, CGF m14,
					  CGF m21, CGF m22, CGF m23, CGF m24,
				  	  CGF m31, CGF m32, CGF m33, CGF m34,
				     CGF m41, CGF m42, CGF m43, CGF m44);

//	CG_INLINE CAT3D CAT3DMake( CGF m11, CGF m12, CGF m13, CGF m14, CGF m21, CGF m22, CGF m23, CGF m24,
//										CGF m31, CGF m32, CGF m33, CGF m34, CGF m41, CGF m42, CGF m43, CGF m44);

// GHETTO
@interface CALayerNoHit 		: CALayer			@end
@interface CAShapeLayerNoHit 	: CAShapeLayer		@end
@interface CATextLayerNoHit 	: CATextLayer		@end
// GATED COMMUNITY
@interface CALayer (NoHit)		@property (NATOM,ASS) BOOL noHit;	@end

//@interface NSObject (AZLayerDelegate)
//- (void) layerWasClicked:  (CAL*)layer;
//@end

//@interface CALayer (WasClicked)
//- (void) wasClicked;
//@end

//- (void) addConstraintsRelSuper:(CAConstraintAttribute) nilAttributeList, ...;  // This method takes a nil-terminated list of objects.

@interface CAL (VariadicConstraints)

- (void) addConstraints:			 (NSA*)constraints;
- (void) addConstraintObjects:	 (CAConstraint*)first,... NS_REQUIRES_NIL_TERMINATION;
- (void) addConstraintsRelSuperOr:(NSN*)nilAttributeList, ... NS_REQUIRES_NIL_TERMINATION;   // This method takes a nil-terminated list of objects.
- (void) addConstraintsRelSuper:(CAConstraintAttribute)first,...; /* REQUIRES NSNotFound termination */
- (void) addConstraintsSuperSizeScaled:(CGF)scale;
- (void) addConstraintsSuperSize;
@end


typedef void(^ReverseAnimationBlock)(void);
@interface  NSObject (DidMoveToSuperLayer)
- (void) didMoveToSuperlayer;
@end

//#define BlockWeakObject(o) __typeof(o) __weak
//#define BlockWeakSelf(_x_) BlockWeakObject(self)

///// For when you need a weak reference to self, example: `BBlockWeakSelf wself = self;`
//#define AZWeakSelf(_x_)  __block __typeof__(self) _x_ = self

//maye this... https://gist.github.com/4707815
// or maybe mazeroingweak

/// For when you need a weak reference of an object, example: `BBlockWeakObject(obj) wobj = obj;`
#define BlockSafeObject(o) __typeof__(o) __weak


/// For when you need a weak reference to self, example: `BBlockWeakSelf wself = self;`
#define AZBlockSelf(_x_)  __block __typeof__(self) _x_ = self 

#define declareBlockSafe(__obj__) __weak typeof(__obj__) __obj__ = __obj__
//__tmpblk
#define blockSafe(__obj__) __obj__
//__tmpblk##
#define blk(__obj__) blockSafe(__obj__)

#define declareBlockSafeAs(__obj__, __name__) \
__weak typeof((__obj__)) __name__ = (__obj__)
	//__tmpblk##

#define SELFBLK void(^)(id _self)

typedef void(^bSelf)(id);
@interface  NSObject (bSelf)
- (void) blockSelf:(void(^)(id _self))block;
- (void) triggerKVO:(NSS*)k block:(void(^)(id _self))blk;
	//-(void)bSelfBlock:(bSelf)block;
@end


@interface CAL (AtoZ)

- (void) disableActionsForKeys:(NSA*)ks;
- (void) addActionsForKeys:(NSD*)keysAndActions;

- (CAL*) permaPresentation;
@property (RDWRT,NATOM) NSColor *backgroundNSColor;
@property (RDWRT,NATOM,ASS) BOOL selected, hovered;
@property (RONLY) NSW* window;
@property (RONLY) NSA* sublayersRecursive;

@property (NATOM, CP) void(^sublayerMouseOverBlock)(CAL*);

+ (NSA*) needsDisplayForKeys;
+ (void) setNeedsDisplayForKeys:(NSA*)ks;
- (void) needsLayoutForKey:(NSS*)key;
-   (id) scanSubsForName:	(NSS*)n;
-   (id) scanSubsForClass:	(Class)c;

@property (readonly) NSA *siblings;
@property (readonly) NSUI siblingIndex, siblingIndexMax;

@property (RDWRT, weak)  NSV* hostView;
//- (void) setHostView:(NSView *)hostView;
//- (NSV*) hostView;

- (NSA*) sublayersAscending;
- (NSA*) visibleSublayers;
-  (NSR) actuallyVisibleRect;
-  (NSR) actuallyVisibleRectInView:(NSV*)v;

- (CAL*) sublayerOfClass:(Class)k;
- (NSA*) sublayersOfClass:(Class)k;
- (void) removeImmediately;
- (void) removeSublayers;

- 	  (CAL*) addImageLayer:(NSImage*)image scale:(CGF)scale;
- (CATXTL*) addTextLayer:(NSS*)text font:(NSFont*)font align:(enum CAAutoresizingMask)align;

- (NSS*) strKey:		(NSS*)defaultName;
- (NSA*) arrKey: 		(NSS*)defaultName;
- (NSD*) dicKey: 		(NSS*)defaultName;
- (NSData*) dataKey:	(NSS*)defaultName;
-  (NSI) iKey:			(NSS*)defaultName;
-  (CGF) fKey:			(NSS*)defaultName;
- (BOOL) boolKey:		(NSS*)defaultName;
//- (NSURL*)URLKey:	(NSS*)defaultName;

- (CAL*) named:				(NSS*)name;
- (CAL*) colored:				(NSC*)color;
- (CAL*) withFrame:			(NSR)frame;
- (CAL*) withConstraints:	(NSA*)constraints;

- (id) copyLayer;

- (CAL*) hitTestSubs:(CGP)point;

- (void) addSublayer:(CAL*)layer named:(NSS*)name;

- (void) addSublayerImmediately:(CAL*)sub;
- (void) addSublayersImmediately:(NSA*)subArray;
- (void) insertSublayerImmediately:(CAL*)sub atIndex:(NSUI)idx;

- (void) setValueImmediately:(id)v forKey:(id)key;

- (void) toggleSpin: (AZState)state;

+   (id) layerWithFrame: (CGR)frame;
-   (id) initWithFrame:  (CGR)frame;

- (void)moveToFront;

@property (strong, nonatomic) CAL *root;
@property (strong, nonatomic) CATXTL *text;
@property (ASS, NATOM) AZPOS orient;
//
- (void)setValue:(id)value	  forKeyPath:(NSS*)keyPath		duration:(CFTimeInterval)duration		   delay:(CFTimeInterval)delay;


-(void) animateXThenYToFrame:(NSR)toRect duration:(NSUI)time;


- (void)blinkLayerWithColor:(NSColor *)color;

- (void) addPerspectiveForVerticalOffset:(CGF)pixels;
- (CAL*)hitTestEvent:(NSEvent*)e inView:(NSView*)v;

- (void) toggleLasso:(BOOL)state;

- (id) lassoLayerForLayer:(CAL*)layer;


- (CAL*) selectionLayerForLayer:(CAL*)layer;
- (CAT3D)makeTransformForAngle:(CGF)angle;

-   (id) objectForKeyedSubscript:(NSS*)key;
- (void) setObject:(id)object forKeyedSubscript:(NSS*)key;

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

- (ReverseAnimationBlock)pulse;


- (void)fadeOut;
- (void)fadeIn;
- (void)animateToColor:(NSC*)color;
- (void(^)(void)) animateToColor:(NSColor*)color duration:(NSTI)interval withCallBack:(BOOL)itRezhuzhesTheColor;
- (void)addAnimations:(NSA*)anims forKeys:(NSA*)keys;

+ (instancetype) layerNamed:(NSS*)name;

+ (CAL *) withName:(NSS*)name   inFrame:(NSRect)rect
			   colored:(NSC*)color withBorder:(CGF)width colored:(NSC*) borderColor;

-  (void) rotateAroundYAxis:		(CGF)radians;

- (CAT3D) makeTransformForAngle: (CGF)angle from:(CAT3D)start;
-  (BOOL) containsOpaquePoint:	(CGP)p;
-  (CAL*) labelLayer;
-  (CAL*) setLabelString:			(NSS*)label;
-    (id) sublayerWithName:		(NSS*)name;
+  (CAL*) veilForView:				(CAL*)view;

- (CAT3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

+ (CAL*)closeBoxLayer;
+ (CAL*)closeBoxLayerForLayer:(CAL*)parentLayer;

	//Metallic grey gradient background
+ (CAGL*)gradientWithColor:(NSC*)c;
+ (CAGradientLayer*) greyGradient;
-(NSS*)debugDescription;

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSS*)indentStr;
- (NSS*)debugLayerTree;
- (void) addSublayers:(NSA*)subLayers;

+ (CAL*)newGlowingSphereLayer;
@end

@interface CAGradientLayer (NSColors)
@property NSA* nsColors;
@end

@interface CALayerNonAnimating : CALayer
@end

@interface NSObject (AZStates)
@end

@interface CAL (LTKAdditions)
@property (RDWRT,NATOM,ASS) CGP frameOrigin;
@property (RDWRT,NATOM,ASS) CGSize frameSize;
@property (RDWRT,NATOM,ASS) CGF frameX;
@property (RDWRT,NATOM,ASS) CGF frameY;
@property (RDWRT,NATOM,ASS) CGF frameWidth;
@property (RDWRT,NATOM,ASS) CGF frameHeight;
@property (RDWRT,NATOM,ASS) CGF frameMinX;
@property (RDWRT,NATOM,ASS) CGF frameMidX;
@property (RDWRT,NATOM,ASS) CGF frameMaxX;
@property (RDWRT,NATOM,ASS) CGF frameMinY;
@property (RDWRT,NATOM,ASS) CGF frameMidY;
@property (RDWRT,NATOM,ASS) CGF frameMaxY;
@property (RDWRT,NATOM,ASS) CGP frameTopLeftPoint;
@property (RDWRT,NATOM,ASS) CGP frameTopMiddlePoint;
@property (RDWRT,NATOM,ASS) CGP frameTopRightPoint;
@property (RDWRT,NATOM,ASS) CGP frameMiddleRightPoint;
@property (RDWRT,NATOM,ASS) CGP frameBottomRightPoint;
@property (RDWRT,NATOM,ASS) CGP frameBottomMiddlePoint;
@property (RDWRT,NATOM,ASS) CGP frameBottomLeftPoint;
@property (RDWRT,NATOM,ASS) CGP frameMiddleLeftPoint;
@property (RDWRT,NATOM,ASS) CGP boundsOrigin;
@property (RDWRT,NATOM,ASS) CGSize boundsSize;
@property (RDWRT,NATOM,ASS) CGF boundsX;
@property (RDWRT,NATOM,ASS) CGF boundsY;
@property (RDWRT,NATOM,ASS) CGF boundsWidth;
@property (RDWRT,NATOM,ASS) CGF boundsHeight;
@property (RDWRT,NATOM,ASS) CGF boundsMinX;
@property (RDWRT,NATOM,ASS) CGF boundsMidX;
@property (RDWRT,NATOM,ASS) CGF boundsMaxX;
@property (RDWRT,NATOM,ASS) CGF boundsMinY;
@property (RDWRT,NATOM,ASS) CGF boundsMidY;
@property (RDWRT,NATOM,ASS) CGF boundsMaxY;
@property (RDWRT,NATOM,ASS) CGP boundsTopLeftPoint;
@property (RDWRT,NATOM,ASS) CGP boundsTopMiddlePoint;
@property (RDWRT,NATOM,ASS) CGP boundsTopRightPoint;
@property (RDWRT,NATOM,ASS) CGP boundsMiddleRightPoint;
@property (RDWRT,NATOM,ASS) CGP boundsBottomRightPoint;
@property (RDWRT,NATOM,ASS) CGP boundsBottomMiddlePoint;
@property (RDWRT,NATOM,ASS) CGP boundsBottomLeftPoint;
@property (RDWRT,NATOM,ASS) CGP boundsMiddleLeftPoint;
@property (RDWRT,NATOM,ASS) CGF positionX;
@property (RDWRT,NATOM,ASS) CGF positionY;

- (void) setAnchorPointAndPreserveCurrentFrame:(CGP)anchorPoint;

+ (CGF) smallestWidthInLayers:  (NSA*)layers;
+ (CGF) smallestHeightInLayers: (NSA*)layers;
+ (CGF) largestWidthInLayers:   (NSA*)layers;
+ (CGF) largestHeightInLayers:  (NSA*)layers;

- (CAL*) presentationCALayer;
- (CAL*) modelCALayer;

- (void) addDefaultFadeTransition;
- (void) addDefaultMoveInTransitionWithSubtype:	(NSS*)subtype;
- (void) addDefaultPushTransitionWithSubtype:	(NSS*)subtype;
- (void) addDefaultRevealTransitionWithSubtype:	(NSS*)subtype;
- (void) addFadeTransitionWithDuration:										  (NSTI)duration;
- (void) addMoveInTransitionWithSubtype:			(NSS*)subtype duration:(NSTI)duration;
- (void) addPushTransitionWithSubtype:				(NSS*)subtype duration:(NSTI)duration;
- (void) addRevealTransitionWithSubtype:			(NSS*)subtype duration:(NSTI)duration;

- (void) addAnimation:(CAA*)animation;
- (void) addAnimation:(CAA*)animation forKey:(NSS*)key withStopBlock: (void (^)(BOOL finished))stopBlock;
- (void) addAnimation:(CAA*)animation forKey:(NSS*)key withStartBlock:(VoidBlock)strtBlk stopBlock:(void (^)(BOOL finished))stpBlk;
- (void) replaceAnimationForKey:				   (NSS*)key withAnimation:(CAA*)animation;
- (NSA*) keyedAnimations;

- (NSImage *)renderToImage;
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize;
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize contextTransform:(CGAffineTransform)contextTransform;

- (void)enableDebugBordersRecursively:(BOOL)recursively;
@end

@interface  CATextLayer (AtoZ)
- (CTFontRef) newFontWithAttributes: (NSD*)attributes;
- (CTFontRef) newCustomFontWithName: (NSS*)fontName ofType:(NSS*)type attributes:(NSD*)attributes;
-    (CGSize) suggestSizeAndFitRange:(CFRange*)range	forAttributedString:(NSMAS*)attrString usingSize:(CGSZ)referenceSize;
-      (void) setupAttributedTextLayerWithFont:(CTFontRef)font;
@end

@interface CALNonAnimating : CAL
- (id<CAAction>)actionForKey:(NSS*)key;
@end

@interface CAScrollLayer (CAScrollLayer_Extensions)
- (void) scrollBy:				(CGP)inDelta;
- (void) scrollCenterToPoint:	(CGP)inPoint;
@end

typedef void(^MPRenderASCIIBlock)(NSString* art);

@interface CAL (MPPixelHitTesting)
- (BOOL) pixelsHitTest:(CGP)p;
- (BOOL) pixelsIntersectWithRect:(CGRect)rect;
- (void) setRenderASCIIBlock:(MPRenderASCIIBlock)block;
- (MPRenderASCIIBlock) renderASCIIBlock;
@end

