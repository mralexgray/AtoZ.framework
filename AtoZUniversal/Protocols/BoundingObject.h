
//_Type _Void( ^RowColBlk    )(_SInt r, _SInt c);
//_Type _Void( ^RowColBlkIdx )(_SInt r, _SInt c, NSUI idx);

//_Type _Void( ^GridIteratorStep )(_SInt r1Loc);
//_Type _Void(       ^SizeChange )(_Size oldSz,_Size newSz);

//_Void IterateGridWithBlockStep(RNG * rows, RNG *cols, RowColBlk b, GridIteratorStep step);
//_Void     IterateGridWithBlock(RNG * rows, RNG *cols, RowColBlk b);


//@Vows GridLike <NSObject> @concrete
//
//
//￭

//  _NA _Size  dimensions;
//  _NA  _UInt  rows,
//              cols;
//  _NA  RNG  *colSpan, *rowSpan;


@Xtra (NObj, AZAZA)
   _P _ObjC owner _
   _P _IsIt expanded,
            selected,
            hovered _
   _P _UInt orientation _
￭


@Vows Drawable <RectLike>

  _CP ObjRectBlock /*ObjRectBlock*/ drawObjectBlock;

@concrete

  _RO _Flot  span,
             expansionDelta _
   _P _Flot  spanExpanded,
             spanCollapsed _

- _Void_ setSpanCollapsed:_Flot_ c expanded:_Flot_ x _
￭



//_Type struct  { _UInt rows;
//                _UInt cols; } AZTable;
//_RO AZTable  table;
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
                

