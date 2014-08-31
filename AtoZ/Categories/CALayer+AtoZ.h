

//@import CoreText;
#import <CoreText/CoreText.h>
#import "AtoZUmbrella.h"


#define NOHITLAYER(RAW) [CANoHitLayer noHitLayerOfClass:[RAW class]]
#define NOHITLAYERFRAME(RAWTYPE,FRAME) [NOHITLAYER(RAWTYPE) objectBySettingValue:AZVrect(FRAME) forKey:@"frame"]

@interface CAL (AtoZLayerFactory) <GridLike>

+ (CAL*) gridLayerWithFrame:(NSR)r rows:(NSUI)rowCt cols:(NSUI)colCt;
+ (CAL*) gridLayerWithFrame:(NSR)r rows:(NSUI)rowCt cols:(NSUI)colCt palette:(NSA*)pal;
@property NSA *gridPalette;

+ (instancetype) noHitLayer;
+ (instancetype) noHitLayerWithFrame:(NSR)r;
+ (instancetype) noHitLayerWithFrame:(NSR)r mask:(NSUI)m;
+ (INST) layerWithFrame:(CGRect)f mask:(enum CAAutoresizingMask)m;
+ (INST) layerWithFrame: (CGR)frame;
+ (INST) layerWithValue:(id)v forKey:(NSS*)k;
+ (INST) layerWithValuesForKeys:(id)firstVal, ...;
//+ (CAShapeLayer*)lassoLayerForLayer:(CAL*)layer;
+ (INST) layerNamed:(NSS*)name;
+ (INST) withName:(NSS*)name inFrame:(NSR)r colored:(NSC*)c
                          withBorder:(CGF)w colored:(NSC*)bc;
+  (CAL*) closeBoxLayer;
+  (CAL*) closeBoxLayerForLayer:(CAL*)parentLayer;
+  (CAL*) newGlowingSphereLayer;
+ (CAGL*) gradientWithColor:(NSC*)c;
+ (CAGL*) greyGradient; //Metallic grey gradient background
+  (CAL*) veilForView:				(CAL*)view;
@end


@interface CAL (AtoZ)

//- (void) on:(NSEventMask)mask do:(SenderEvent)b; // FIX

@prop_NA id eventMonitor;
@prop_NA NSEventMask eventMask;
@prop_RO IndexedKeyMap* eventBlocks; // SenderEvent's aka ^(id sender,NSE*ev)

/*! @see swizzleHitTest for swizled implementation enablig this! */
@prop_CP  IDBlk onHit, onHover; // SenderEvent

//- (CAL*) hoverTest:(NSP)pt; // FIX

- (void) setOnHit:(IDBlk)wasHit;
- (void) setOnHover:(IDBlk)wasHit;

//- (void) setWasHit:(LayerBlock)b; - (void) setMouseOverBlock:(LayerBlock)b;
//@property (CP) void(^sublayerMouseOverBlock)(CAL*);
- (void) setSublayerMouseOverBlock:(void(^)(CAL*layer))block;

// Coerce-to-property setters.
- (void) addSublayers:(NSA*)subLayers;


@property (RONLY)  CAL * permaPresentation;
@property         BOOL   noHit,
                         animatesResize;
@property          NSC * backgroundNSColor;

@property (RONLY)  NSA * siblings;            // SUPER -> @[A,B,C]  B.siblings            = @[A,C]
@property (RONLY) AZ01   siblingIndexParity;
@property (RONLY)  NSI   siblingIndex,        // SUPER -> @[A,B,C]  B.siblingIndex        = 1
                         siblingIndexMax;     // SUPER -> @[A,B,C]  B.siblingIndexMax     = 2 (C)
@property (RONLY) BOOL   siblingIndexIsEven;  // SUPER -> @[A,B,C]  B.siblingIndexIsEven  = NO
@property (RONLY)  CAL * siblingNext,
                       * siblingPrev,
                       * hostLayer; // View's layer. Handles all events.
@property (WK)     NSV * hostView;

@property (RONLY)  NSA * sublayersRecursive,
                       * sublayersAscending,
                       * visibleSublayers;
@property (RONLY)  CAL * lastSublayer;
@property (RONLY)  NSR   actuallyVisibleRect;

/*! @see setNeedsLayoutForKey: */
@property          NSA * needsLayoutForKeys,
                       * needsDisplayForKeys;
@property         BOOL   needsLayout,needsDisplay;

- (void) setAnimations:(NSA*)a;   // zhuzhed setter

- (void) disableActionsForKeys:(NSA*)ks;
- (void)     addActionsForKeys:(NSD*)ksAndAs;   // Adds to existing without overwriting.
- (void)     setActionsForKeys:(NSD*)ksAndAs;   // Replaces existing.
- (void)  removeActionsForKeys:(NSA*)ks;
- (void)  setNeedsLayoutForKey:(NSS*)k;        // triggers layout on KVO change;
- (void) setNeedsDisplayForKey:(NSS*)k;        // triggers layout on KVO change;

- (void) setFilterName:(NSS*)n;
- (void) disableResizeActions;

-   (id)  scanSubsForName:(NSS*)n;
-   (id) scanSubsForClass:(Class)c;
-   (id)  sublayerOfClass:(Class)k;
- (NSA*) sublayersOfClass:(Class)k;

-  (NSR) actuallyVisibleRectInView:(NSV*)v;

- 	 (CAL*) addImageLayer:(NSIMG*)image scale:(CGF)scale;
- (CATXTL*)  addTextLayer:(NSS*)s font:(NSFont*)font align:(enum CAAutoresizingMask)align;

- (INST)           named:(NSS*)name;
- (INST)         colored:(NSC*)color;
- (INST)       withFrame:(NSR)frame;
- (INST) withConstraints:(NSA*)constraints;

- (void) removeConstraintWithAttribute:(CACONSTATTR)att1 rel:(NSS*)relORnil attr:(CACONSTATTR)att2;

- (INST) copyLayer;

-   (id) hitTestSubs:(CGP)point;
- (void) addSublayer:(CAL*)layer named:(NSS*)name;
- (void) addSublayerImmediately:(CAL*)sub;
- (void) addSublayersImmediately:(NSA*)subArray;
- (void) insertSublayerImmediately:(CAL*)sub atIndex:(NSUI)idx;

- (void) setValueImmediately:(id)v forKey:(id)key;
- (void) setFrameImmediately:(NSR)r;

- (AZStatus) toggleSpin;
@property AZStatus spinning;

- (void) moveToFront;
- (void) setValue:(id)v forKeyPath:(NSS*)kp duration:(CFTimeInterval)t delay:(CFTI)d;

- (void) animateXThenYToFrame:(NSR)toR duration:(NSUI)t;
- (void) blinkLayerWithColor:(NSC*)c;  /* AOK! */

- (void) addPerspectiveForVerticalOffset:(CGF)pixels;
- (CAL*) hitTestEvent:(NSE*)e inView:(NSV*)v;

- (void) toggleLasso:(BOOL)state;                 //- (id) lassoLayerForLayer:(CAL*)layer;

-  (CAL*) selectionLayerForLayer:(CAL*)layer;
- (CAT3D) makeTransformForAngle:(CGF)angle;

- (void) orientWithPoint:(CGP)pt;
- (void)     orientWithX:(CGF)x
                    andY:(CGF)y;      //- (void) rientOnEvent: (NSEvent*)event;


//@property NSP superpoint;
- (void) setAnchorPointRelative:(CGP)pt;
- (void)         setAnchorPoint:(CGP)pt inRect:(NSR)r;
- (void)         setAnchorPoint:(CGP)pt inView:(NSV*)v; //- (void) flipHorizontally;- (void) flipVertically;

- (void) flipBackAtEdge:(AZA)pos;
- (void) flipForwardAtEdge: (AZWindowPosition)position;

- (void) flipForward:(BOOL)forward  atPosition:(AZWindowPosition)pos duration:(NSTI)time;
- (CAT3D) flipForward:(BOOL)forward  atPosition:(AZPOS)pos;

+ (CAT3D) flipAnimationPositioned:(AZPOS)pos;

- (void) flipOver;
- (void) flipBack;
- (void) flipDown;

- (void) setScale:(CGF)scale;

- (ReverseAnimationBlock)pulse;
- (void) fadeOut;
- (void) fadeIn;
- (void) animateToColor:(NSC*)color;
- (VBlk) animateToColor:(NSC*)color duration:(NSTI)interval withCallBack:(BOOL)itRezhuzhesTheColor;
- (void) addAnimations:(NSA*)anims forKeys:(NSA*)keys;


-  (void) rotateAroundYAxis:		(CGF)radians;
- (CAT3D) makeTransformForAngle: (CGF)angle from:(CAT3D)start;

-  (BOOL) containsOpaquePoint:	(CGP)p;

//-  (CAL*) labelLayer; -  (CAL*) setLabelString:			(NSS*)label;
-    (id) sublayerWithName:		(NSS*)name;
- (CAL*)sublayerWithNameContaining:(NSS*)n;

- (CAT3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a;

@end

@interface CAConstraint (Mask)
+ (NSA*) attributesForMask:(AZConstraintMask)mask;
@end

@interface CAL (VariadicConstraints)
@property BOOL isLayoutManager;
- (void) setDefaultLayoutManager;
- (void) makeSuperlayer;

- (void) addConstraintsWithMaskRelSuper:(AZConstraintMask)mask;
- (void) addConstraints:                (NSA*)constraints;
- (void) addConstraintObjects:          (CACONST*)first,... NS_REQUIRES_NIL_TERMINATION;
- (void) addConstraintsRelSuper:        (CACONSTATTR)first,...; /* NS_REQUIRES_NOTFOUND_TERMINATION; REQUIRES NSNotFound termination */
- (void) addConstraintsSuperSizeScaled: (CGF)scale;
- (void) addConstraintsSuperSize;
- (void) addConstraintsSuperSizeHorizontal;


- (void) superConstrain;
- (void) superConstrainEdges:(CGF)offset;
- (void) superConstrainEdgesH:(CGF)offset;
- (void) superConstrainEdgesV:(CGF)offset;

- (void) superConstrainTopEdge;
- (void) superConstrainTopEdge:(CGF)offset;

- (void) superConstrainBottomEdge:(CGF)offset;

- (void) superConstrain: (CACONSTATTR) edge;

- (void) superConstrain: (CACONSTATTR)edge offset:(CGF)offset;
- (void) superConstrain: (CACONSTATTR)subviewEdge to:(CACONSTATTR)superlayerEdge;
- (void) superConstrain: (CACONSTATTR)subviewEdge to:(CACONSTATTR)superlayerEdge offset:(CGF)offset;
@end


@interface CAL (SHouldBeInProtocol)
@property          BOOL  isListItem;
@property (RONLY)  NSS * sisterName;
@end

@interface CAL (SwizzledCanImplement)
- (void) didMoveToSuperlayer;
@end


@interface CAL (AtoZDebug)
+ (NSW*) debugTest;
@property         BOOL  debug;
@property (RONLY)  NSS * infoString,
                       * debugDescription,
                       * debugLayerTree;
                       
- (void) debugAppendToLayerTree:(NSMS*)treeStr indention:(NSS*)indentStr;

@end



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

@interface CAL (UsedToBeFunctions)
- (void) applyPerspective;
- (void) setSuperlayer:(CAL*)sl;  // Also, acts as accessor access to removeFromSuperlayer by setting to nil!
- (void) setSuperlayer:(CAL*)sl index:(int)idx;
- (void) removeImmediately;
- (void) removeSublayers;
- (void) addBloom;
- (void) addShadow;
- (void) addPulsatingBloom;
@end

@interface NSGraphicsContext (CTX)
+ (void) prepareContext:(CGCREF)ctx;
@end

@interface CALayerNonAnimating : CALayer  @end

@interface NSObject (AZStates) @end

@interface CAL (LTKAdditions)
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

- (NSIMG*) renderToImage;
- (NSIMG*) renderToImageWithContextSize:(CGSize)contextSize;
- (NSIMG*) renderToImageWithContextSize:(CGSize)contextSize contextTransform:(CGAffineTransform)contextTransform;
-   (void) enableDebugBordersRecursively:(BOOL)rec;
@end

@interface CALNonAnimating : CAL
- (id<CAAction>)actionForKey:(NSS*)key;
@end

@interface CAScrollLayer (CAScrollLayer_Extensions) <RectLike>
- (void)            scrollTo:(CGF)off;
- (void)            scrollBy:(CGF)dist;
- (void) scrollCenterToPoint:(CGP)inPoint;
@end

typedef void(^MPRenderASCIIBlock)(NSString* art);

@interface CAL (MPPixelHitTesting)
- (BOOL) pixelsHitTest:(CGP)p;
- (BOOL) pixelsIntersectWithRect:(CGRect)rect;
- (void) setRenderASCIIBlock:(MPRenderASCIIBlock)block;
- (MPRenderASCIIBlock) renderASCIIBlock;
@end

//void      prepareContext ( CGContextRef ctx );
//void    applyPerspective ( CAL *l );	//	CAT3D perspective();
//void   RemoveImmediately ( CAL *l );  /** Removes layer from superlayer without any fade-out animation. */
//void     RemoveSublayers ( CAL *l ); /** Removes receivers sublayers */
//void    ChangeSuperlayer ( CAL *l, CAL *newSuperL, int x ); /** Moves a layer from one superlayer to another, without changing its position onscreen. */

//CAL*   AddPulsatingBloom ( CAL *l );
//CAL* 			   AddShadow ( CAL *l );
//CAL* 				 AddBloom ( CAL *l );
/** Convenience for creating, adding,a nd returning a relatively nice CAL. */
CAL*     NewLayerInLayer ( CAL *superL );
/** Convenience for creating a CATextLayer. */
CATXTL* 			 AddLabel ( CAL *superL, NSS *text );
CATXTL*    AddLabelLayer ( CAL *superL, NSS *text, NSF *font );
CATXTL*     AddTextLayer ( CAL *superL, NSS *text, NSF *font, enum CAAutoresizingMask align );
CAL* 	  ReturnImageLayer ( CAL *superL, NSIMG *img, CGF scale );
CATXTL*    AddLabelLayer ( CAL *superL, NSS 	*text, NSF *font );

CGIREF 	         GetCGImageNamed (NSS *name ); /* Loads an image or pattern file into a CGImage or CGPattern. If the name begins with "/", it's interpreted as an absolute filesystem path. Otherwise, it's the name of a resource that's looked up in the app bundle. The image must exist, or an assertion-failure exception will be raised! Loaded images/patterns are cached in memory, so subsequent calls with the same name are very fast. */
CGCLRREF	       GetCGPatternNamed (NSS *name );
CGIREF 	GetCGImageFromPasteboard (NSPasteboard *pb ); /** Loads image data from the pasteboard into a CGImage. */
CGPatternRef    CreateImagePattern (CGImageRef image ); /** Creates a CGPattern from a CGImage. */
CGCLRREF        CreatePatternColor (CGImageRef image ); /** Creates a CGColor that draws the given CGImage as a pattern. */
CGF                  GetPixelAlpha (CGImageRef image, CGSize imageSize, CGP pt ); /** Returns the alpha value of a single pixel in a CGImage, scaled to a particular size. */

/* As with the distort transform, the x and y values adjust intensity. I have included a CAT3DMake method as there are no built in CAT3D methods to create a transform by passing in 16 values (mimicking the CGAffineTransformMake method).
	For those that have never seen the CAT3D struct before, you must apply the transform to a CAL‘s transform, as opposed to a CGAffineTransform which is applied to the UIView‘s transform. If you want to apply it to a UIView, obtain it’s layer then set the transform (myView.layer = CAT3DMakePerspective(0.002, 0)).
	What do represent the two parameters in CAT3DMakePerspective(0.002, 0) ?
 	The first is how much you want it to skew on the X axis (horizontally), and the second for the Y axis (vertically)
	Yes, but what are the units ? (radians … ?)
	The value goes directly into the transform, if you want to make it radians, or any other type of unit you will need to put some math in there	*/

CAT3D CAT3DMake( CGF m11, CGF m12, CGF m13, CGF m14, CGF m21, CGF m22, CGF m23, CGF m24, CGF m31, CGF m32, CGF m33, CGF m34, CGF m41, CGF m42, CGF m43, CGF m44);

//	CG_INLINE CAT3D CAT3DMake( CGF m11, CGF m12, CGF m13, CGF m14, CGF m21, CGF m22, CGF m23, CGF m24,
//										CGF m31, CGF m32, CGF m33, CGF m34, CGF m41, CGF m42, CGF m43, CGF m44);



//CAT3D concatenatedTransformation = CAT3DConcat(xRotation, transformation);
CAT3D CA3Dm34               (CGF divisor);
CAT3D CA3DxRotation         (CGF x);
CAT3D CA3DyRotation         (CGF y);
CAT3D CA3DzRotation         (CGF z);
CAT3D CA3DTransform3DConcat (CAT3D xRotation,  CAT3D yRotation);
CAT3D CA3DxyZRotation       (CAT3D xYRotation, CAT3D zRotation);
CAT3D CA3DConcatenatedTransformation(CAT3D xyZRotation, CAT3D transformation );
//@interface CANoHitLayer : CAL @end
// GHETTO
//@interface CALayerNoHit       : CALayer         @end
//@interface CAShapeLayerNoHit 	: CAShapeLayer		@end
//@interface CATextLayerNoHit 	: CATextLayer     @end
// GATED COMMUNITY
//@interface NSObject (AZLayerDelegate)
//- (void) layerWasClicked:  (CAL*)layer;
//@end

//@interface CALayer (WasClicked)
//- (void) wasClicked;
//@end

//- (void) addConstraintsRelSuper:(CAConstraintAttribute) nilAttributeList, ...;  // This method takes a nil-terminated list of objects.
//- (void) addConstraintsRelSuperOr:(NSN*)nilAttributeList, ... NS_REQUIRES_NIL_TERMINATION;   // This method takes a nil-terminated list of objects.
