
#import "AtoZUmbrella.h"

@interface          ClearWin : NSW + withFrame:(NSR)r; // Designated!
@prop_NA BOOL debug, needsDisplay;
@end

@interface        AZHandlebarWindow : ClearWin
@prop_                          NSC * color;
@prop_                        AZPOS   anchorPoint;
@end

@interface AZBorderlessResizeWindow : ClearWin


@prop_NA    CGF cornerRadius,   // Rounded corners by this amount.  Defaults to 5.
                handleInset;    // How big are the "hot" edges?   Defaults to 30.

@prop_RO  AZPOS screenEdge,
                mouseEdge;

@prop_RO    NSP mouseLocation; /* AOK ... Updates coordinates, in win's bounds whenever mouse moves inside.  */

@prop_RO    NSR mouseEdgeRect,
                snappedRect;

@prop_RO   BOOL isOnEdge,
                isDragging,
                isResizing,
                isClicked,
                isHovered; /* AOK ... 1 onHover, 0 outside bounds */

@prop_ AZHandlebarWindow *handle; @end


#pragma mark - SUBCLASSES

@interface AZMagneticEdgeWindow : AZBorderlessResizeWindow
@prop_NA   NSSZ   fullSize;
@prop_RO AZRect * inFrame,
                * outFrame;
@prop_RO   CRNR   outsideCorners;
@end

typedef void (^WindowFrameChange)(id owner, AZBorderlessResizeWindow * w);

@interface AZEdgeAwareWindow : AZBorderlessResizeWindow

@property (NATOM,CP) WindowFrameChange frameChanged;
- (void) setFrameChanged:(WindowFrameChange)frameChanged;

@property (WK) id owner;

@end


