/*! Useful protocol for any object that implements both setter and getters for both FRAME and BOUNDS.  
    and that can be genuinely represented in those terms.
 */
@protocol RectLike <NSO>

@required _P    _Rect   frame,          ///     -frame  & -setFrame:    MUST be implemented (in a category is OK)
                        bounds;         /// AND -bounds & -setBounds:   AND shoould accurately reflect those values.

@optional _P    _Cord   anchorPoint,    /// If unimplemented
                         position;
          _P    _Rect   superframe;     /// WILL store these, for you, if unimplemented.. and make anchorPoint & position calculations meaningful.

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



#if MAC_ONLY
DECLARECONFORMANCE( NSV,     RectLike )
DECLARECONFORMANCE( NSW,     RectLike )
DECLARECONFORMANCE( CAL,     RectLike )
DECLARECONFORMANCE( NSScreen,RectLike )
DECLARECONFORMANCE( NSIMG,   RectLike )
#endif

@interface AZRect : NSO <RectLike>

- (INST) shiftedX:(CGF)x y:(CGF)y w:(CGF)w h:(CGF)h;

@end

#define AZR             AZRect

#define $AZR(_r_)       [AZR withRect:_r_]
#define AZRBy(_x_,_y_)  $AZR(AZRectBy(_x_,_y_))
#define AZRDim(_d_)     $AZR(AZRectFromDim(_d_))
#define AZRUNDERMENU     AZR.screenFrameUnderMenu

// {  CGF width, height;	}
//@prop_RO NSR r;
#ifdef UNIMPLENETED 
+ (INST) screnFrameUnderMenu;
@prop_RO CGF 	area;
- (BOOL)     contains:(id)obj;
//- (BOOL)    contaiNSP:(NSP)p;
- (BOOL) containsRect:(NSR)r;
#endif
