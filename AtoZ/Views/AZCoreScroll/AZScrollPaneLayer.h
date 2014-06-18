#import <Quartz/Quartz.h>

#import "AZScrollerProtocols.h"
// - assumes the layout manager is a SFTimeLineLayout
// - assumes all sublayers are SFSnapShotLayers

@interface AZScrollPaneLayer : CAScrollLayer < AZScrollerContent > {

BOOL selectionAnim;

__unsafe_unretained id <AZScrollerContentController> _contentController;
CGFloat contentWidth, visibleWidth, stepSize;
}

@property(assign) id <AZScrollerContentController> contentController;

- (void)selectSnapShot:(NSInteger)index;
- (void)moveSelection:(NSInteger)dx;
- (void)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;
@end
