

@import AtoZUniversal;


@interface NSO (AZAZA) @prop_ NSO* owner; @prop_ BOOL expanded, selected, hovered; @prop_ NSUI orientation;   @end


@protocol Drawable   <RectLike> @prop_CP ObjRectBlock /*ObjRectBlock*/ drawObjectBlock;
@concrete
@prop_RO        CGF   span, expansionDelta;
@prop_          CGF   spanExpanded, spanCollapsed;
- (void) setSpanCollapsed:(CGF)c expanded:(CGF)x;
@end

typedef void(^GridIterator)(NSI r, NSI c);
typedef void(^GridIteratorIdx)(NSI r, NSI c, NSUI idx);

typedef void(^GridIteratorStep)(NSI r1Loc);
typedef void(^SizeChange)(NSSZ oldSz,NSSZ newSz);


void IterateGridWithBlockStep(RNG *r1, RNG *yRange, GridIterator block, GridIteratorStep step);
void     IterateGridWithBlock(RNG * r1, RNG *r2, GridIterator block);


typedef struct  { NSUI  rows;
                  NSUI  cols; } AZTable;

@protocol  GridLike <NSO> @concrete

@prop_NA       NSSZ  dimensions;
@prop_RO    AZTable  table;
@prop_NA       NSUI  rows,
                     cols;
@prop_CP  SizeChange onChangeDimensions;

- (void) iterateGrid:(GridIterator)b;
- (void) iterateGridWithIndex:(GridIteratorIdx)b;

- (void) setOnChangeDimensions:(void(^)(NSSZ oldSz,NSSZ newSz))c;

@end


//@protocol     GridLike <NSO> @concrete
//@prop_CP SizeChange sizeChanged;
//- (void) setSizeChanged:(void(^)(NSSZ oldSz,NSSZ newSz))c;
//
//@prop_NA          NSSZ  dimensions;
//@prop_NA          NSUI  rows, cols;  
//
//- (void) iterateGrid:(GridIterator)b;
//@end




//  frameMiddleRightPoint,//frameTopMiddlePoint,
//frameBottomRightPoint,//  frameTopRightPoint,
//frameBottomMiddlePoint,//frameTopLeftPoint,
// frameBottomLeftPoint,
// frameMiddleLeftPoint,
//@property  CGP    frameOrigin, boundsOrigin;/

 

//                  boundsTopLeftPoint,
//                  boundsTopMiddlePoint,
//                  boundsTopRightPoint,
//                  boundsMiddleRightPoint,
//                  boundsBottomRightPoint,
//                  boundsBottomMiddlePoint,
//                  boundsBottomLeftPoint,
//                  boundsMiddleLeftPoint,
//@property  CGF    boundsX,
//                  boundsY,
//                  boundsWidth,
//                  boundsHeight,
//                  boundsMinX,
//                  boundsMidX,
//                  boundsMaxX,
//                  boundsMinY,
//                  boundsMidY,
//                  boundsMaxY,


//@required 
//                        bounds; 
//@property         NSP   position, anchorPoint;
//@property         NSAlignmentOptions alignment;
//@concrete
//@property        NSSZ   size; 
//@property         CGF   width, height, w, h;
//@prop_RO CGP   mid;
//@property         CGF   midX, midY, maxX, maxY;

//@pcategoryinterface (SizeLike,Aliases) @property CGF w, h; @end

//@protocol    RectLike   <PointLike,SizeLike> 
//@optional
   // aka layer.frame : superlayer.bounds.  supoerframe origin should always be NSZeroPoint!
//@property         AZA   alignment;    // undefined until set / superframe is Set
//@concrete
//@property         NSP   origin,       // This is inherited, but can be affected by superframe, alignment.
//                        center,       // same as mid unless origin is effected.
//                        apex;         // origin + size (same as size unless effected)
//                        
//@property        NSSZ   size;         // This is inherited, but supplies a ddefault implementation.                                    
//@property         NSR   frame, r;        // derived from / affects bounds + origin + alignment.



//@end
//@property         CGF   frameMidX,  frameMaxX, 
//                        frameMinY,  frameMidY,  frameMaxY; // frameCenter,  boundsCenter;   //                   frameoriginX,        originY;                 // frameOrigin accessors
//SizeLike>

//@interface NSO (ExtendWithProtocol) @end


/*
@property        BOOL   vertical;
//@pcategoryinterface(ArrayLike,FastEnumeration)
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
//@end
//#define AZD AZDistance
//#define AZD(h,v) (AZD){h,v}
//typedef struct _AZDistance { CGF horizontal; CGF vertical; } AZDistance;


//boundsHeight,   boundsWidth,frameHeight,    frameWidth, - (void) setBoundsSize:(NSSZ)sz; - (void)  setFrameSize:(NSSZ)sz;


//                         boundsMinX,     boundsMidX,   boundsMaxX,
//                      boundsMinY,     boundsMidY,   boundsMaxY;
//- (void)     w:(CGF)x h:(CGF)y;
//- (NSSZ)  scaleWithSize:(NSSZ)z;  - (NSSZ) resizeWithSize:(NSSZ)z;    @end

//@protocol     Moveable   <NSObject>     @end
//- (void) moveBy:(NSP)distance;

//@property (readonly) NSSZ size;

//- (void) setBoundsHeight: (CGF)h;
//- (void) setBoundsWidth:  (CGF)w;
//- (void) setFrameHeight:  (CGF)h;
//- (void) setFrameWidth:   (CGF)w;

                frameTopLeftPt,  frameTopMidPt,   frameTopRightPt,
                frameMidLeftPt,  frameMidPt,      frameMidRightPt,
                frameBotLeftPt,  frameBotMidPt,   frameBotRightPt,
                boundsTopLeftPt, boundsTopMidPt,  boundsTopRightPt,
                boundsMidLeftPt, boudsMidPt,      boundsMidRightPt,
                boundsBotLeftPt, boundsBotMidPt,  boundsBotRightPt; 

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
  StrongTypedArrayLikeProtocol(DrawableObjectArrayLike,DrawableObject)
#define StrongTypedArrayLikeProtocol(_NewProtocolName_,_ObjectsAdhereToProtocol_)\
@protocol _NewProtocolName_ <ArrayLike> @concrete\
- (void) addObject:(id<_ObjectsAdhereToProtocol_>)x; \
- (void)    addObjects:(NSA<_ObjectsAdhereToProtocol_>*)x;  @end
@interface NSO (DrawableObject) <Drawable> @end


//@interface BoundingObjectDummy  : NSObject @end


centerX, bottom, top, centerY, originY, originX, frameX, frameY, frameSize, boundsSize;
@property CGF leftEdge, rightEdge, boundsWidth,  boundsHeight, boundsX, boundsY, frameWidth,   frameHeight,

typedef void(^MutationBlock)(id _self, id x, NSUI idx);
@optional @property (CP) MutationBlock onInsert; @property (CP) void(^onRemove)(id _self, id x, NSUI idx);

+ (INST) withRect:(NSR)r inRect:(NSR)sf aligned:(AZA)a;
//#import "AZBlockView.h"         //



*/
                

