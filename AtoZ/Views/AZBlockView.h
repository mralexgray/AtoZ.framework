//
//  AZBlockView.h
//  AtoZ
//

@class AZBlockView;
// Declare the AZBlockViewDrawer block type:
typedef void(^AZBlockViewDrawer)(AZBlockView *view, NSRect dirtyRect);
@interface AZBlockView : NSView {
	AZBlockViewDrawer drawBlock;
	BOOL opaque;
}
+ (AZBlockView *)viewWithFrame:(NSRect)frame
                         opaque:(BOOL)opaque
                drawnUsingBlock:(AZBlockViewDrawer)drawBlock;
@property (nonatomic, copy) AZBlockViewDrawer drawBlock;
@property (nonatomic, assign) BOOL opaque;
@end

