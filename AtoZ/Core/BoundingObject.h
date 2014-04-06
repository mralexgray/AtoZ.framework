
#import "extobjc_OSX/EXTConcreteProtocol.h"
#import "AtoZUmbrella.h"
#import "AZBlockView.h"


//  StrongTypedArrayLikeProtocol(DrawableObjectArrayLike,DrawableObject)

//#define StrongTypedArrayLikeProtocol(_NewProtocolName_,_ObjectsAdhereToProtocol_)\
//@protocol _NewProtocolName_ <ArrayLike> @concrete\
//- (void) addObject:(id<_ObjectsAdhereToProtocol_>)x; \
//- (void)    addObjects:(NSA<_ObjectsAdhereToProtocol_>*)x;  @end


@protocol DrawableObject <NSObject>
@concrete
- (void) setSpanCollapsed:(CGF)c expanded:(CGF)x;
@property (RONLY) CGF span, expansionDelta;
@property         CGF spanExpanded, spanCollapsed;
@property (CP) DrawObjectBlock drawObjectBlock;
@end

@interface NSO (DrawableObject) <DrawableObject> @end

@protocol Indexed <NSObject> @concrete
@property (RONLY) id<NSFastEnumeration> backingStore;
@property (RONLY) NSUI index, indexMax;
@end

@protocol ArrayLike <NSFastEnumeration>
@concrete
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
@property NSA<Indexed>*storage;
@property (RONLY) NSUI count;

- (void)     addObject:(id)x;
- (void)  removeObject:(id)x;
- (void)    addObjects:(NSA*)x;
- (void) removeObjects:(NSA*)x;

@end


typedef void(^GridIterator)(NSUI r, NSUI c);  void IterateGridWithBlock(NSUI rows, NSUI cols, GridIterator block);

@protocol     GridLike <NSO>                                       
@concrete
@property         NSUI  rows, cols;  - (void) iterateGrid:(GridIterator)b;    
@end

//@pcategoryinterface(ArrayLike,FastEnumeration)
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
//@end
//#define AZD AZDistance
//#define AZD(h,v) (AZD){h,v}
//typedef struct _AZDistance { CGF horizontal; CGF vertical; } AZDistance;

//@property AZO orientation;


@interface NSO (AZAZA) 
@property AZA alignment;
@property AZO orientation;
@property (RONLY) BOOL isVertical;
@end


@protocol TwoDimensional <NSObject> 
@required @property NSP position; 
@concrete
@property CGFloat x, y;
- (BOOL) isVertical;
@end

@protocol Resizable <NSO,TwoDimensional>  @required  @property NSSize size; 
@concrete
@property NSR bounds;
@property CGFloat width, height; - (CGFloat) perimeter;
@end

@protocol Pinnable  <Resizable,TwoDimensional> 

@concrete
@property NSR frame;

@property (RONLY) NSW * window;


@property         CGF //boundsHeight,   boundsWidth,
//                      frameHeight,    frameWidth,
                      frameMinX,      frameMidX,    frameMaxX,
                      frameMinY,      frameMidY,    frameMaxY;//                   frameoriginX,        originY;                 // frameOrigin accessors

@property         CGP center, 
                      frameOrigin,    boundsOrigin,
                      frameCenter,    boundsCenter;
@end

//- (void) setBoundsSize:(NSSZ)sz;
//- (void)  setFrameSize:(NSSZ)sz;

#define SizeableObject Resizable 
#define BoundingObject Pinnable

//                         boundsMinX,     boundsMidX,   boundsMaxX,
//                      boundsMinY,     boundsMidY,   boundsMaxY;
//- (void)     w:(CGF)x h:(CGF)y;
//- (NSSZ)  scaleWithSize:(NSSZ)z;  - (NSSZ) resizeWithSize:(NSSZ)z;    @end

//@protocol     Moveable   <NSObject>     @end
//- (void) moveBy:(NSP)distance;

@interface NSIMG  (SizeableObject) <SizeableObject> @end
@interface NSV    (BoundingObject) <BoundingObject> @end
@interface NSW    (BoundingObject) <BoundingObject> @end
@interface CAL    (BoundingObject) <BoundingObject> @end


@interface NSO (ExtendWithProtocol) @end

/*
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
                boundsBotLeftPt, boundsBotMidPt,  boundsBotRightPt; */
                
//@interface BoundingObjectDummy  : NSObject @end


//centerX, bottom, top, centerY, originY, originX, frameX, frameY, frameSize, boundsSize;
//@property CGF leftEdge, rightEdge, boundsWidth,  boundsHeight, boundsX, boundsY, frameWidth,   frameHeight,

//typedef void(^MutationBlock)(id _self, id x, NSUI idx);
//@optional @property (CP) MutationBlock onInsert; @property (CP) void(^onRemove)(id _self, id x, NSUI idx);

