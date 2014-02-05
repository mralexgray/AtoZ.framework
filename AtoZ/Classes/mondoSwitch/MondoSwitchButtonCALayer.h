
//  MondoSwitchButtonCALayer.h
//  CocoaMondoKit



typedef enum {
	PPNoEvent = (1 << 1),
  PPstandardMouseDown = (1 << 2),
  PPcanDragSwitch = (1 << 3),
  PPdragOccurred = (1 << 4)
} MondoSwitchEventType;

@interface MondoSwitchButtonCALayer : CALayer

@property	CALayer* theSwitch;
@property	MondoSwitchEventType currentEventState;
@property	CGImageRef notClickedImgRef, clickedImgRef;
@property	CGPoint mouseDownPointForCurrentEvent;

@property(nonatomic) BOOL on;

-(void)mouseDown:(CGPoint)point;
-(void)mouseUp:(CGPoint)point;
-(void)mouseDragged:(CGPoint)point;
-(void)setOn:(BOOL)on animated:(BOOL)animated;
@end

@interface MondoSwitchButtonCALayer (PrivateMethods)
- (void)createtheSwitch;
- (void)switchSide;
- (void)moveSwitch:(CGPoint)point;
- (BOOL)shouldDrag:(CGFloat)dx;
- (CGImageRef)switchImageForPath:(NSBezierPath*)path topColor:(CGFloat)topColor  bottomColor:(CGFloat)bottomColor;
@end

