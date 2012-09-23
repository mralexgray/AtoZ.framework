#import "AZCoreScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "AZSnapShotLayer.h"
#import "AZTimeLineLayout.h"
#import "AZScrollPaneLayer.h"
#import "AZScrollerLayer.h"

//#import	<AtoZ/AtoZ.h>


#define SFLeftArrowKey 123
#define SFRightArrowKey 124
#define SHIFT_ANIM_SPEED 2.0f


@interface AZCoreScrollView ()							//@private
@property (nonatomic, retain) NSGradient				* bgGradient;
@property (nonatomic, assign) AZTimeLineViewEventType 	currentMouseEventType;
@end

@implementation AZCoreScrollView

- (void)awakeFromNib {				/* draw a basic gradient for view background*/
	_bgGradient = [[NSGradient alloc] initWithStartingColor:GRAY1 endingColor:GRAY3];
	[self setupLayers];										   [self setupListeners];
}
- (void)setupLayers {
	//	CGRect viewFrame = NSRectToCGRect( self.frame );		//	viewFrame.origin.y = 0;
	self.mainLayer 		= [CALayer layer];
	self.layer 			= _mainLayer;
	self.wantsLayer 	= YES;
	_mainLayer.name 	= @"mainLayer";
	_mainLayer.frame 	= [self bounds];
	_mainLayer.delegate = self;					[_mainLayer setNeedsDisplay];
												// causes the layer content to be drawn in -drawRect:
	// create a "container" layer for all content layers same frame as the view's master layer, automatically resizes as necessary.
	CALayer* contentContainer 	= [CALayer layer];
	contentContainer.frame 		= self.bounds;
	contentContainer.delegate 	= self;
//	contentContainer.anchorPoint= CGPointMake(0.5,0.5);
//	contentContainer.position 	= self.center;
	contentContainer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[contentContainer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
	[self.layer addSublayer:contentContainer];

	_bodyLayer 					= [AZScrollPaneLayer layer];
	_bodyLayer.name 			= @"scrollLayer";
	_bodyLayer.scrollMode 		= kCAScrollBoth;//	kCAScrollHorizontally;
	_bodyLayer.layoutManager 	= [AZTimeLineLayout layoutManager];
	_bodyLayer.constraints		= @[	AZConstRelSuper ( kCAConstraintMinX ),
	 	 								AZConstRelSuper ( kCAConstraintMaxX ),
										AZConstRelSuperScaleOff( kCAConstraintMaxY,   .8, 0	),
										AZConstRelSuperScaleOff( kCAConstraintHeight, .8, 0	) ];

	// TODO -- SFScrollLayer -- has reference to site and listens for change methods
	_scrollerLayer 				 = [AZScrollerLayer layer];
	_scrollerLayer.name 			 = @"scroller";
	_scrollerLayer.constraints	=	@[				AZConstRelSuper(kCAConstraintMaxX),
			AZConstRelSuper(kCAConstraintMinX),		AZConstRelSuper(kCAConstraintWidth),
			AZConstAttrRelNameAttrScaleOff(kCAConstraintMaxY, 	@"superlayer", kCAConstraintMaxY,   1, 0),
			AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, 	@"superlayer", kCAConstraintMaxY,  .8, 1),
			AZConstAttrRelNameAttrScaleOff(kCAConstraintHeight, @"superlayer", kCAConstraintHeight,.2, 0) ];


//		AZConstRelSuperScaleOff( kCAConstraintMinY, 		1, 	40	),
// AZConstRelSuper ( kCAConstraintMaxX), AZConstRelSuper ( kCAConstraintMinY),
// AZConstRelSuper ( kCAConstraintMaxX), AZConstRelSuperScaleOff( kCAConstraintWidth, 	1,	 0	),	//-20
// AZConstRelSuperScaleOff( kCAConstraintMinY,		.2,	0	),
//	[bodyLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"scroller" attribute:kCAConstraintMaxY offset:10]];
//										 AZConstRelSuper(kCAConstraintMaxY),
//										 AZConstRelSuperScaleOff(kCAConstraintHeight, , 0)	];
	//		[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer"
	//				attribute:kCAConstraintMinY offset:0] ]];//		10 + SCROLLER_HEIGHT]]];

	for (AZFile* i in [[AtoZ dock]sortedWithKey:@"hue" ascending:YES]){

		AZSnapShotLayer *d = [AZSnapShotLayer rootSnapWithFile:i andDisplayMode:AZAdobeInitals];
		NSLog(@"Snapclass: %@ .	Assigned color:%@	Was null: %@.", d.propertiesPlease, 		d.contentLayer.backgroundColor, StringFromBOOL(i.color));
		[_bodyLayer addSublayer:d];
	}

	[self debugLayers:@[_bodyLayer, _mainLayer, _scrollerLayer, contentContainer]];
	//	 each:^(id obj, NSUInteger index, BOOL *stop) {
	//		[obj debug];
	//	}];
	[_scrollerLayer 		setScrollerContent:_bodyLayer];
	[_bodyLayer 			setContentController:_scrollerLayer];
	[contentContainer addSublayer:_bodyLayer];
	[contentContainer addSublayer:_scrollerLayer];
	[contentContainer layoutSublayers];
	[contentContainer layoutIfNeeded];
	[_bodyLayer selectSnapShot:0];


}

- (void)setupListeners {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appNoLongerActive:)
												 name:NSApplicationWillResignActiveNotification				 object:[NSApplication sharedApplication]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:)
												 name:NSApplicationWillBecomeActiveNotification			 object:[NSApplication sharedApplication]];
}

#pragma mark - NSView Methods

- (void) drawRect:(NSRect)rect {		// Everything else is handled by core animation

	[_bgGradient drawInRect:self.bounds angle:90.0];
}

#pragma mark - NSResponder Methods

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)e {

	// every app with eye candy needs a slow mode invoked by the shift key
	if ([e modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask))
		[CATransaction setValue:@SHIFT_ANIM_SPEED forKey:@"animationDuration"];

	switch ([e keyCode])
	{
		case SFLeftArrowKey:
			[self moveSelection:-1];
			break;

		case SFRightArrowKey:
			[self moveSelection:+1];
			break;
		default:
			NSLog (@"unhandled key event: %d\n", [e keyCode]);
			[super keyDown:e];
	}
}

- (void) mouseDown: (NSEvent *) event {
	NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);
	NSPoint mD = [NSScreen convertAndFlipEventPoint:event relativeToView:self];

	if ([event modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask))
		[CATransaction setValue:@SHIFT_ANIM_SPEED forKey:@"animationDuration"];


	else if ( CGRectContainsPoint ( _bodyLayer.frame, cgLocation )) {
		[_bodyLayer mouseDownAtPointInSuperlayer:cgLocation];
	}

	else if ( CGRectContainsPoint ( _scrollerLayer.frame, cgLocation ) ) {
		if ( [_scrollerLayer mouseDownAtPointInSuperlayer:cgLocation] ) {
			_currentMouseEventType = AZTimeLineViewNotifyScrollerEventType;
		}
	}
	PoofAtPoint(mD, 222);
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);

	if ( _currentMouseEventType == AZTimeLineViewNotifyScrollerEventType ) {
		[_scrollerLayer mouseDragged:cgLocation];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	CGPoint cgLocation = NSPointToCGPoint(location);

	if ( _currentMouseEventType == AZTimeLineViewNotifyScrollerEventType ) {
		[_scrollerLayer mouseUp:cgLocation];
	}

	_currentMouseEventType = AZTimeLineViewUndefinedEventType;
}

- (void)scrollWheel:(NSEvent *)theEvent {
	[_scrollerLayer moveSlider:-[theEvent deltaX] ];
}


#pragma mark -
#pragma mark Listener Methods

- (void) appNoLongerActive:(NSNotification*)notification {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	[_scrollerLayer setOpacity:0.7];
	[_bodyLayer setOpacity:0.7];
}

- (void) appBecameActive:(NSNotification*)notification {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	[_scrollerLayer setOpacity:1.0];
	[_bodyLayer setOpacity:1.0];
}



#pragma mark -
#pragma mark private methods

- (void)moveSelection:(NSInteger)dx {
	[_bodyLayer moveSelection:dx];
}



- (void)debugLayers:(NSArray*)layers {

	[layers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
		obj.borderWidth = 4;
		obj.borderColor =	( [obj isEqualTo:_mainLayer] ? cgRED :
							 ( [obj isEqualTo:_bodyLayer] ? cgPURPLE :
							  ( [obj isEqualTo:_scrollerLayer] ? cgGREEN : GRAY2.CGColor)));
		NSDictionary* textStyle = @{@"Ubuntu Mono Bold" : @"font", kCAAlignmentCenter : @"alignmentMode"};
		CATextLayer* labelLayer = [CATextLayer layer];
		labelLayer.fontSize = 10;
		labelLayer.frame = obj.bounds;
		labelLayer.style = textStyle;
		labelLayer.foregroundColor =	cgWHITE;
			//		labelLayer.position = CGPointMake(0,0);
			//		labelLayer.anchorPoint = CGPointMake(0,0);
		[obj addSublayer:labelLayer];	//AZCenterOfRect(contentLayer.bounds);
		labelLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	}];
}

@end
	//@interface CustomView (PrivateMethods)
	//- (void)setupLayers;
	//- (void)setupListeners;
	//- (void)moveSelection:(NSInteger)dx;
	//@end

	//- (void) debugLayers:(NSArray*)layers{
		/*	1=open, 0=closed  */				//if (0)	 [[NSLogConsole sharedConsole] open];
	//	[layers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
	//		obj.borderColor = cgRANDOMCOLOR;
	//		obj.borderWidth = RAND_FLOAT_VAL(3,8);
	//	}];
	//}
