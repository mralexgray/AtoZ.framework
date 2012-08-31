
//  AZBlockView.h
//  AtoZ


/*  USAGE

[[someView addSubview:
	[AZBlockView viewWithFrame:someView.bounds opaque:NO drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
		view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
		[RED set];
		[[NSBezierPath bezierPathWithRoundedRect:view.bounds xRadius:5 yRadius:5] fill];
	}]
]positioned:NSWindowBelow relativeTo:anotherView];
*/

#import "AtoZ.h"

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

