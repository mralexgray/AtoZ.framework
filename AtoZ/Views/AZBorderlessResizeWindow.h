
#define  SELFTYPE(_x_) typeof(self) _x_

#import "AtoZUmbrella.h"

@interface     FadeVisibilityWindow : NSW @end

@interface        AZHandlebarWindow : FadeVisibilityWindow
@property                       NSC * color;
@property                     AZPOS   anchorPoint;
@end

@interface AZBorderlessResizeWindow : FadeVisibilityWindow

+ (INST) windowWithContentRect:(NSR)r;

@property (NATOM)   CGF cornerRadius,   // Round corners by this amount.  Defaults to 5.
                        handleInset;    // How big are the "hot" edges?   Defaults to 30.
@property (RONLY) AZPOS screenEdge,
                        mouseEdge;
@property (RONLY)   NSP mouseLocation;  // Updates whenever mouse moves in window.
@property (RONLY)   NSR mouseEdgeRect,
                        snappedRect;
@property (RONLY)  BOOL isOnEdge,
                        isDragging,
                        isResizing,
                        isClicked,
                        isHovered;

@property AZHandlebarWindow *handle;
@end


@interface AZMagneticEdgeWindow : AZBorderlessResizeWindow
//@property (NATOM)   NSSZ   fullSize;
//@property (RONLY) AZRect * inFrame,
//                         * outFrame;
//@property (RONLY) CRNR outsideCorners;
@end



typedef void (^WindowFrameChange)(id owner,AZBorderlessResizeWindow * w);

@interface AZEdgeAwareWindow : AZBorderlessResizeWindow

@property (NATOM,CP) WindowFrameChange frameChanged;
- (void) setFrameChanged:(WindowFrameChange)frameChanged;

@property (WK) id owner;

@end
