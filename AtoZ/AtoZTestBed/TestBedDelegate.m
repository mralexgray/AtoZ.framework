//
//  AZAppDelegate.m
//  AtoZTestBed
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "TestBedDelegate.h"
#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>

@interface NSObject (getLayer)
- (CAL*)	getLayer;
+ (NSView*)viewInView:(NSView*)view;
@end
@implementation NSObject (getLayer)
+ (NSView*)viewInView:(NSView*)view;
{
	NSView* v = [[NSView alloc]initWithFrame:[view frame]];
	[view addSubview:v positioned:NSWindowAbove relativeTo:view.lastSubview];
	return v;
}
- (CAL*)getLayer { //__block NSView* me = (NSView*)self;
	return  [(NSView*)self layer] ?: [(NSView*)self setupHostView];//(CAL*)^{ [me setWantsLayer:YES];  me.layer.anchorPoint = (CGP){.5, .5}; [me.layer setAnchorPointRelative:me.center]; return me.layer; }();
}
@end
const CGFloat dash[2] = {100, 60};

@interface TestBedDelegate ()
@property (nonatomic, retain) CATransition *transition;
@property (nonatomic, retain) NSA *transitions;

@end

@implementation TestBedDelegate

-(CATransition*)transition
{
    // Construct a new CATransition that describes the transition effect we want.
    CATransition *transition = [CATransition animation];
	// We want to build a CIFilter-based CATransition.  When CATransition's "filter" is set, "type" and "subtype" properties are ignored.
	CATransition* tranny = [CATransition transitionsFor:_targetView].randomElement; 		NSLog(@"New tranny: %@", tranny);
	return [tranny isKindOfClass:[CIFilter class]] 	? 	   ^{
		transition.filter 	= tranny; return transition;	 }() : ^{  //itsa filter
		transition.type		= tranny;
		transition.subtype	= @[ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom].randomElement;
		transition.duration	= 1.0;	  return transition; }();
}
-(void) awakeFromNib
{
	[self loadSecondNib:nil];
	[AtoZ sharedInstance];
	[_segments 	 setAction:@selector(setView:) withTarget:self];
	[_targetView setupHostView];
	[_targetView 	swapSubs:self.debugLayers];
	[self addObserverForKeyPath:@"self.targetView.subviews" task:^(id obj, NSDictionary *change) {
		AZLOG(@"subviews changed");
	}];
}


- (IBAction)loadSecondNib:(id)sender
{
	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"TestBed"];
	[awc showWindow:self];
    [[awc window] makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] arrangeInFront:nil];
//	
//	// Load with NSBundle
//	NSLog(@"Loading NIB …");
//
//	if (![NSBundle loadNibNamed:@"TestBed" owner:self])
//		{
//		NSLog(@"Warning! Could not load myNib file.\n");
//		}
}


- (AZMedallionView*)medallion {
	return 	_medallion = _medallion ?: ^{
		AZMedallionView *n = [[AZMedallionView alloc]initWithFrame:_targetView.frame];
		n.image = [NSImage systemIcons].randomElement;
		return n;  }();
}
- (void) setView:(id)sender	{
	Sound *rando = [Sound soundNamed:@"unlock"];
	[[SoundManager sharedManager] prepareToPlayWithSound:rando];
	[[SoundManager sharedInstance] playSound:rando];
//
	NSS* str= [sender segmentLabel] ?: @"";
	if ([self respondsToSelector:NSSelectorFromString(str)]){
//		id newV = self[[sender segmentLabel]];
//		newV[@"hidden"] = @(YES);
//		if ([_targetView.subviews doesNotContainObject:newV])

//		[_targetView addSubview:newV];
//		[self.targetView setAnimations:@{@"subviews":self.transition}];
		[self.targetView replaceSubview:_targetView.subviews[0] with:[self valueForKey:[sender segmentLabel]]];
			 //newImageView];
//			   ? [NASpinSeque animateTo:self[[sender segmentLabel]] inSuperView:_targetView]
	}

}
//								[self.targetView  swapSubs:self[[sender segmentLabel]]] : nil;	}

//- (void)setDebugLayers:(BNRBlockView*)debugLayers {
- (BLKVIEW*)blockView
{	return 	_blockView = _blockView ?:
	[BLKVIEW viewWithFrame:_targetView.frame opaque:YES drawnUsingBlock: ^(BLKVIEW *view, NSR dirtyRect) {
		view.arMASK = NSSIZEABLE;
		NSBP *arrow	= [[NSBezierPath bezierPathWithArrow]scaleToSize:AZScaleRect(view.frame, .5).size];
//		NSC  *color = RANDOMCOLOR;
//		[view associatedValueForKey:@"blockC"]
//		color :? [view setAssociatedValue:[NSC linenTintedWithColor:RANDOMCOLOR] forKey:@"blockC"];
		NSRectFillWithColor( view.frame, [view associatedValueForKey:@"blockC"] );
		[[NSBezierPath bezierPathWithTriangleInRect:
			  quadrant( view.frame, 1 ) orientation:AMTriangleLeft] drawWithFill:RED andStroke:RANDOMCOLOR];
		[arrow setLineWidth:5];
		[arrow setLineDash:dash count:20 phase:40];
		[arrow drawWithFill:RED andStroke:RANDOMCOLOR];
		[arrow drawPointsAndHandles];
	}];
}

-(AZHostView*)hostView {
	return 	_hostView = _hostView ?: (AZHostView*)^{
		AZHostView *h = [[AZHostView alloc]initWithFrame:_targetView.frame];
		h.host.backgroundColor = cgRANDOMCOLOR;
		return h;
	}();
}

-(NSView*)debugLayers {
	return 	_debugLayers = _debugLayers ?: (NSView*)^{
		AZDebugLayer *dL = [AZDebugLayer layer];
		dL.backgroundColor = cgGREEN;
		NSView *v = [[NSView alloc]initWithFrame:_targetView.frame];
		v.arMASK = NSSIZEABLE;
		v.layer = dL;//[CALayer layer];
		v.wantsLayer = YES;
//		[v.layer addSublayer:dL];
		[[[AZFolder samplerWithCount:4]valueForKeyPath:@"image"] eachWithIndex:^(id obj, NSInteger idx) {
			NSR framer = quadrant(_targetView.bounds, idx+1);
			CAL *new = [CALayer layer];
			new.frame = framer;
			new.backgroundColor = cgRANDOMCOLOR;//NewLayerWithFrame(framer);
			new.contents = obj;
			new.transform = [new makeTransformForAngle:.45];
//			applyPerspective(new);
			//			NSUI ii = (NSUI)idx;
//			NSRect r = quadrant(_targetView.frame, 1);
//			[new addSublayer:ReturnImageLayer(dL, obj, 1)];
			[v.layer addSublayer:new];
//			[v.layer addSublayer:[(NSIMG*)obj imageLayerForRect:quadrant(_targetView.frame, ii+1)]];
		}];
		return v;
	}();

}
////	AZLOG(_debugLayers);
//	__block __typeof(self) blockSelf = self;
//	_debugLayers = [AZBlockView viewWithFrame:_window.frame opaque:NO drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
//			view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
////			NSLog(@"drawignRect: %@  blockself: %@", AZStringFromRect(dirtyRect), blockSelf);
//			[[NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5] drawWithFill:RED andStroke:RANDOMCOLOR];
//		}];
//	return _debugLayers;
////		[AZBlockView ne][[NSView alloc]initWithFrame:_targetView.frame];
////		[v setupHostView];
////		v.layer.backgroundColor = cgPURPLE;
////		AZDebugLayer *layer = [AZDebugLayer layer];
////		layer.backgroundColor = cgGREEN;
////		v.layer.sublayers = @[layer];
//
//}

@end
#define SPINS              3.0f
#define DURATION           2.5f
#define TRANSITION_OUT_KEY @"transition out"
#define TRANSITION_IN_KEY  @"transition in"
#define TRANSITION_IDENT   @"transition type"

@implementation NASpinSeque

+ (id)animateTo:(id)v inSuperView:(id)sV
{
    NASpinSeque *n = [NASpinSeque new];// = [super init];
//    if (self) {

		n.sV = sV ?: [[[NSApplication sharedApplication]mainWindow]contentView];
		n.v1 = [sV subviews][0] ?: [NSObject viewInView:sV];
		n.v2 = v;
//		[[NSThread mainThread]performBlock:^{
			[n perform];
//		} waitUntilDone:YES];
	return n;
}
- (void)perform{
	CABA *rotation = [CABA animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @0.0;
    rotation.toValue   = @(M_PI * SPINS);

    CABA *scaleDown = [CABA animationWithKeyPath:@"transform.scale"];
    scaleDown.fromValue = @1.0;
    scaleDown.toValue   = @0.0;

    CABA *fadeOut = [CABA animationWithKeyPath:@"opacity"];
    fadeOut.fromValue = @1.0;
    fadeOut.toValue   = @0.0;

    CAAG *transitionOut = [CAAG animation];
    transitionOut.animations          = @[rotation, scaleDown, fadeOut];
    transitionOut.duration            = DURATION;
    transitionOut.delegate            = self;
    transitionOut.removedOnCompletion = NO;
    transitionOut.fillMode            = kCAFillModeForwards;
    [transitionOut setValue:TRANSITION_OUT_KEY forKey:TRANSITION_IDENT];
	self.l1 = [_v1 getLayer];
	_l1.frame = _sV.bounds;
	_l1.anchorPoint = (CGPoint){.5,.5};
//	_l1.frame  = [_sV bounds];//anchorPoint = NSMakePoint(.5,.5);
    [_l1 addAnimation:transitionOut forKey:TRANSITION_OUT_KEY];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    NSString *type = [anim valueForKey:TRANSITION_IDENT];

    if ([type isEqualToString:TRANSITION_OUT_KEY]) {
		[_sV subviewsBlockSkippingSelf:^(id view) {
			[view setHidden:YES];
		}];
//		[self.v2 setHidden:YES];
		if ([_sV.subviews doesNotContainObject:_v2]) [_sV addSubview:_v2];
		[_v2 setFrame:_sV.bounds];
//		[_v2 setNeedsDisplay:YES];
		self.l2 =[_v2 getLayer];

		_l2.frame = [_sV bounds];
//		_l2.frame = [self.sV bounds];//NSMakePoint(.5,.5);
		_l2.anchorPoint = (CGPoint){.5,.5};
		CABA *rotation = [CABA animationWithKeyPath:@"transform.rotation"];
        rotation.fromValue = @0.0;
        rotation.toValue   = @(M_PI * SPINS);

        CABA *scaleUp = [CABA animationWithKeyPath:@"transform.scale"];
        scaleUp.fromValue = @0.0;
        scaleUp.toValue   = @1.0;

        CAAG *transitionIn = [CAAG animation];
        transitionIn.animations = [NSArray arrayWithObjects:rotation, scaleUp, nil];
        transitionIn.duration   = DURATION;
        transitionIn.delegate   = self;
        [transitionIn setValue:TRANSITION_IN_KEY forKey:TRANSITION_IDENT];

//        [self.l1 presentModalViewController:self.destinationViewController animated:NO];
//		[self.v2 fadeIn];
		[self.l2 addAnimation:transitionIn forKey:TRANSITION_IN_KEY];

		return;//destinationLayer
    }

    if ([type isEqualToString:TRANSITION_IN_KEY]) {
		[self.v1 removeFromSuperview];
        [self.l1 removeAnimationForKey:TRANSITION_OUT_KEY];
    }

}
@end
