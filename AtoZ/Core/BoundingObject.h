
#import "AZBlockView.h"         //#import "AtoZTypes.h"
#import "AtoZTypes.h"


//#define    FORBIDDEN_CLASSES( ([NSA arrayWithObjects:__VA_ARGS__]contains           [NSException raise:@"We should never get here!" format:@"%@ should have implemented this:%@", self.className, AZSELSTR]
#define  ASSERTSAME(A,B)      NSAssert(A == B, @"These values should be same, but they are %@ and %@", @(A), @(B))
#define    CONFORMS(PROTO)    [self conformsToProtocol:@protocol(PROTO)]
#define IF_CONFORMS(PROTO,X)  if(CONFORMS(PROTO)){ ({ X; }) }

#define    GETALIAS(X)        return [self floatForKey:NSStringify(X)]  // [self vFK:NSStringify(X)];    [value getValue: ptr];    (const char * typeCode, void * value); [self  X]
#define    SETALIAS(X,V)      [self sV:V fK:NSStringify(X)]

#ifndef AZO
#define AZO AZOrient
#endif
//- (BOOL) isVertical;

@interface NSO (AZAZA) @property BOOL expanded, selected, hovered; @property NSUI orientation; @end

@protocol Indexed <NSO> @concrete @property (RONLY) id<NSFastEnumeration> backingStore; @property (RONLY) NSUI index, indexMax; @end

@protocol ArrayLike <NSO,NSFastEnumeration> @concrete
@property NSA<Indexed>*storage;

@property (RONLY) NSUI count;

- (void)     addObject:(id)x;
- (void)  removeObject:(id)x;
- (void)    addObjects:(NSA*)x;
- (void) removeObjects:(NSA*)x;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)s objects:(id __unsafe_unretained [])b count:(NSUInteger)len;

@end

@protocol             RectLike   <NSO> @required

@property                  NSR   frame;
@optional

@property                  NSP   anchorPoint, position;
@property                 NSSZ   supersize;
@concrete
@property   NSAlignmentOptions    alignment;
@property                 NSUI    arMASK;
@property                  NSR    bounds,
                                  r;                        // alias [frame]
@property                 NSSZ    size;
@property                  CGF    w,        h,              // alias [size/width]
                                  width,    height,         // bounds
                                  x,        y,              // position
                                  minX,     minY,           // frame ...
                                  midX,     maxX,
                                  midY,     maxY,
                                  posX,     posY,
                                  anchX,    anchY;
@property                  CGP    minXmaxY, midXmaxY, maxXmaxY,                 
                                  minXmidY, midXmidY, maxXmidY,
                                  minXminY, midXminY, maxXminY,
                                  center, apex, origin;                 
                                  
@property (RONLY)           CGF   perimeter, area;              // 2 * (width + height)

/*! Protocol factory methods for all conformant classes! */

+ (INST) rectLike:(NSN*)dimOne, ... NS_REQUIRES_NIL_TERMINATION; // 0 - 4 NSNumber * dims + optional NSValue rect for superframe.

+ (INST) withRect:(NSR)r inRect:(NSR)sf aligned:(AZA)a;

+ (INST) withRect:(NSR)r;                     /*! NSV *r = [NSV withRect:AZRectBy(100,200)];  */

+ (INST) x:(CGF)x y:(CGF)y w:(CGF)w h:(CGF)h; /*! CAL *l = [CAL x:23 y:33 w:100 h:9]; -> l: CALayer #-1 of -1!  AZNotFound f:{{23 x 33},{100 x 9 }} b:{{ 0 x  0},{100 x 9 }} */


@end

//@interface NSIMG (SizeLike) <SizeLike> @end
@interface   NSV (RectLike) <RectLike> @end
@interface   NSW (RectLike) <RectLike> @end
@interface   CAL (RectLike) <RectLike> @end

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
//@property (RONLY) CGP   mid;
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


@protocol Drawable   <RectLike> //SizeLike>
@property (CP) ObjRectBlock drawObjectBlock;
@concrete
@property (RONLY)   CGF   span, expansionDelta;
@property           CGF   spanExpanded, spanCollapsed;
- (void) setSpanCollapsed:(CGF)c expanded:(CGF)x;
@end

typedef void(^GridIterator)(NSI r1, NSI r2);  
typedef void(^GridIteratorStep)(NSI r1Loc);

void IterateGridWithBlockStep(RNG *r1, RNG *yRange, GridIterator block, GridIteratorStep step);
void     IterateGridWithBlock(RNG * r1, RNG *r2, GridIterator block);

@protocol     GridLike <NSO> @concrete
@property         NSUI  rows, cols;  
- (void) iterateGrid:(GridIterator)b;    
@end



#define SizeableObject SizeLike 
#define BoundingObject RectLike

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

                
*/
                
