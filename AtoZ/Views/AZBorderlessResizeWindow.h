

@interface          ClearWin : NSW + withFrame:(NSR)r; // Designated!
_NA BOOL debug, needsDisplay;
@end

@interface        AZHandlebarWindow : ClearWin
@prop_                          NSC * color;
@prop_                        AZPOS   anchorPoint;
@end

@interface AZBorderlessResizeWindow : ClearWin


_NA    CGF cornerRadius,   // Rounded corners by this amount.  Defaults to 5.
                handleInset;    // How big are the "hot" edges?   Defaults to 30.

_RO AZPOS screenEdge,
                mouseEdge;

_RO   NSP mouseLocation; /* AOK ... Updates coordinates, in win's bounds whenever mouse moves inside.  */

_RO   NSR mouseEdgeRect,
                snappedRect;

_RO  BOOL isOnEdge,
                isDragging,
                isResizing,
                isClicked,
                isHovered; /* AOK ... 1 onHover, 0 outside bounds */

@prop_ AZHandlebarWindow *handle; @end


#pragma mark - SUBCLASSES

@interface AZMagneticEdgeWindow : AZBorderlessResizeWindow
_NA   NSSZ   fullSize;
_RO AZRect * inFrame,
                * outFrame;
_RO  CRNR   outsideCorners;
@end

typedef void (^WindowFrameChange)(id owner, AZBorderlessResizeWindow * w);

@interface AZEdgeAwareWindow : AZBorderlessResizeWindow

@property (NA,CP) WindowFrameChange frameChanged;
- (void) setFrameChanged:(WindowFrameChange)frameChanged;

@property (WK) id owner;

@end


