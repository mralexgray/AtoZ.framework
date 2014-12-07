
#import <Zangetsu/Zangetsu.h>
#import <AtoZ/AtoZMacroDefines.h>
#import <AtoZ/AtoZTypes.h>

/*! Useful protocol for any object that implements both setter and getters for both FRAME and BOUNDS.  
    and that can be genuinely represented in those terms.
 */
@protocol RectLike <NSO>

@required @prop_    NSR   frame,          ///     -frame  & -setFrame:    MUST be implemented (in a category is OK)
                          bounds;         /// AND -bounds & -setBounds:   AND shoould accurately reflect those values.

@optional @prop_    NSP   anchorPoint,    /// If unimplemented
                          position;
          @prop_    NSR   superframe;     /// WILL store these, for you, if unimplemented.. and make anchorPoint & position calculations meaningful.

@concrete @prop_RO  AZA   insideEdge;                     // !!!
          @prop_RO  NSS * insideEdgeHex;
          @prop_NA NSUI   arMASK;
          @prop_NA  NSR   r;                        // alias [frame]
          @prop_NA NSSZ   size;
          @prop_NA  CGF   w,        h,              // alias [size/width]
                            width,    height,         // bounds
                            x,        y,              // position
                            minX,     minY,           // frame ...
                            midX,     maxX,
                            midY,     maxY,
                            posX,     posY,
                            anchX,    anchY;
@prop_NA              CGP   minXmaxY, midXmaxY, maxXmaxY,
                            minXmidY, midXmidY, maxXmidY,
                            minXminY, midXminY, maxXminY,
                            centerPt, apex, origin, bOrigin;

@prop_RO              CGF   perimeter, area;              // 2 * (width + height)

- (BOOL)  isLargerThan:(id<RectLike>)r;
- (BOOL) isSmallerThan:(id<RectLike>)r;
- (BOOL)     isRectLke:(id<RectLike>)r;
- (BOOL)  isLargerThanRect:(NSR)r;
- (BOOL) isSmallerThanRect:(NSR)r;
- (BOOL)        isSameRect:(NSR)r;

/*! Protocol factory methods for all conformant classes! */

/*! CAL *l = [CAL x:23 y:33 w:100 h:9]; -> l: CALayer #-1 of -1!  AZNotFound f:{{23 x 33},{100 x 9 }} b:{{ 0 x  0},{100 x 9 }} */
+ (INST) x:(CGF)x
         y:(CGF)y
         w:(CGF)w
         h:(CGF)h;

// 0 - 4 * NSNumber.. dims + optional NSValue rect for superframe.
+ (INST) rectLike:(NSN*)d1, ... NS_REQUIRES_NIL_TERMINATION;
+ (INST) withRect:(NSR)r;                     /*! NSV *r = [NSV withRect:AZRectBy(100,200)];  */
@end

//@prop_ NSAlignmentOptions   alignment;

@protocol Random  <NSO>
@required + (INST) random;              // implement random and you get random:ct for free!
@concrete + (NSA*) random:(NSUI)ct;     // ie. +[NSColor random:10] -> 10 randos..
@end

@protocol Indexed <NSO> @concrete
@prop_RO id<NSFastEnumeration> backingStore;
@prop_RO  NSUI index, indexMax;
@end

@protocol FakeArray <NSO,NSFastEnumeration>
@required
@prop_RO id<NSFastEnumeration>enumerator;
- (int) indexOfObject:(id)x;
@concrete
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
- (void)eachWithIndex:(void(^)(id obj,int index))block; // Dep's on indexOffObject:
- (void)do:(void(^)(id obj))block;               // Dep's on <NSFastEnumeration>
@end

@protocol ArrayLike <NSO,NSFastEnumeration>
@concrete @prop_ NSA<Indexed>*storage;
@prop_RO NSUI count;

- (void)     addObject:(id)x;
- (void)  removeObject:(id)x;
- (void)    addObjects:(NSA*)x;
- (void) removeObjects:(NSA*)x;

@end

#define DECLARECONFORMANCE(_CLASS_,_PROTOCOL_) @interface _CLASS_ (_PROTOCOL_) <_PROTOCOL_> @end

DECLARECONFORMANCE( NSV,     RectLike )
DECLARECONFORMANCE( NSW,     RectLike )
DECLARECONFORMANCE( CAL,     RectLike )
DECLARECONFORMANCE( NSScreen,RectLike )
DECLARECONFORMANCE( NSIMG,   RectLike )



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

@protocol      TypedArray   <NSO> @concrete
@prop_ Class objectClass;
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



#define SizeableObject SizeLike 
#define BoundingObject RectLike

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
//#import "AZBlockView.h"         //#import "AtoZTypes.h"



*/
                

