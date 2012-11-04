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
#import "ConciseKit.h"

@interface NSObject (getLayer)
- (CAL*)	getLayer;
+ (NSView*) viewInView:(NSView*)view;
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


-(void) awakeFromNib {

	[AtoZ sharedInstance];
//	[self loadSecondNib:nil];
	[self.segments 	 setAction:@selector(setView:) withTarget:self];
	[_targetView setupHostView];
//	CATRANNY *transition = [[CATRANNY alloc]initWithProperties:@{@"type":kCATransitionPush, @"subtype":kCATransitionFromLeft}];

	CATransition *transition = [CATransition animation];
	[transition setType:	kCATransitionMoveIn];
	[transition setSubtype:	kCATransitionFromLeft];
	// Specify an explicit duration for the transition.
    [transition setDuration:1.0];
    // Associate the CATransition we've just built with the "subviews" key for this SlideshowView instance, so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
    [_targetView setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];

	[self.targetView 	swapSubs:self.debugLayers];
	[self addObserverForKeyPath:@"self.targetView.subviews" task:^(id obj, NSDictionary *change) {
		AZLOG(@"subviews changed");
	}];
}

-(NSImageView*) baseImageView {
	NSImageView *v = [[NSImageView alloc]initWithFrame:_targetView.frame];
	v.arMASK = NSSIZEABLE;
	v.imageScaling = NSImageScaleProportionallyUpOrDown;
	v.image = [[NSImage alloc]initWithSize:_targetView.frame.size];
	return v;
}
-(NSImageView*)badges {

	_badges = [self baseImageView];
	AZSizer *s = [AZSizer forQuantity:10 inRect:_targetView.frame];
	[_badges.image lockFocus];
		[s.rects eachWithIndex:^(id obj, NSInteger idx) {
			[[NSImage badgeForRect:AZMakeRectFromSize(s.size) withColor:RANDOMCOLOR  stroked:nil withString:$(@"%ld", idx)]drawInRect:[obj rectValue]];
		}];
	[_badges.image unlockFocus];
	return _badges;
}

-(NSImageView*)imageNamed {
	return _imageNamed = _imageNamed ?: ^{
		NSImageView *base = [self baseImageView];
		AZSizer *s = [AZSizer forQuantity:[NSIMG frameworkImages].count inRect:_targetView.frame];
		NSA* rects = s.rects.copy;
		[base.image lockFocus];
			[[NSIMG frameworkImages] eachWithIndex:^(id obj, NSInteger idx) {
				[obj drawInRect:[[rects normal: idx]rectValue] fraction:1];
				// badgeForRect:AZMakeRectFromSize(s.size) withColor:RANDOMCOLOR  stroked:nil withString:$(@"%ld", idx)]drawInRect:[obj rectValue]];
			}];
		[base.image unlockFocus];
//		[base addObserverForKeyPath: task:<#^(id obj, NSDictionary *change)task#>
		return base;
	}();


}
-(NSImageView*)picol {

	if (_picol) {	NSR old = [[_picol associatedValueForKey:_picol.identifier]rectValue]; logRect(old); logRect(_targetView.frame);
					if (NSEqualRects(_targetView.frame, old)) return  _picol;
	}
	else _picol = ^{NSIV *iv  	= [self baseImageView];
			AZSizer *s	= [AZSizer forQuantity:[NSIMG icons].count inRect:_targetView.frame];
			NSA* rects 	= s.rects.copy;
			[iv.image lockFocus];
				[[NSIMG icons] eachWithIndex:^(id obj, NSInteger idx) {
					[obj drawInRect:[[rects normal: idx]rectValue] fraction:1];
		// badgeForRect:AZMakeRectFromSize(s.size) withColor:RANDOMCOLOR  stroked:nil withString:$(@"%ld", idx)]drawInRect:[obj rectValue]];
				}];
			[iv.image unlockFocus];
			iv.identifier = [NSS newUniqueIdentifier];
//			[iv associateValue:AZVrect(_targetView.frame) withKey:[iv.identifier UTF8String]];
			return iv;
	}();
	return _picol;


}



- (BLKVIEW*)blockView
{	return 	_blockView = _blockView ?:
	[BLKVIEW viewWithFrame:_targetView.frame opaque:NO drawnUsingBlock: ^(BLKVIEW *view, NSR dirtyRect) {

		view.arMASK = NSSIZEABLE;
		NSRect topBox = AZUpperEdge(view.frame, 100);
		NSRect botBox = AZRectTrimmedOnTop(view.frame, 100);
		NSA  *palette = [NSColor randomPalette];

		[view associate:[NSC linenTintedWithColor:paletteArray.randomElement] with:@"blockC"];
		NSRectFillWithColor( botBox, [view associatedValueForKey:@"blockC"] );
		NSRectFillWithColor( topBox, [[view associatedValueForKey:@"blockC"] complement]);
		NSBP *arrow	= [[NSBezierPath bezierPathWithArrow]
									 scaleToSize: (NSSZ) { quadrantsVerticalGutter(botBox), NSHeight(botBox) }];
		[arrow setLineWidth:5];
//		[arrow setLineDash:dash count:20 phase:40];
		[arrow drawWithFill:paletteArray.randomElement andStroke:paletteArray.randomElement];
		[arrow drawPointsAndHandles];

		[[NSArray from:0 to:3] eachWithIndex:^(id obj, NSInteger idx) {
			NSBP *tri = [NSBezierPath bezierPathWithTriangleInRect:
			  quadrant( botBox, (QUAD)idx ) orientation:(AMTriangleOrientation)idx];
			[tri drawWithFill:paletteArray.randomElement andStroke:paletteArray.randomElement];
			[tri drawPointsAndHandles];

		}];
		[@" I am Drawn in a block.\n And this text is guaranteed to fit! " drawInRect:topBox withFontNamed:[AtoZ randomFontName] andColor:WHITE];
	}];
}


//-(CATransition*)transition
//{
//    // Construct a new CATransition that describes the transition effect we want.
//    CATransition *transition = [CATransition animation];
//	// We want to build a CIFilter-based CATransition.  When CATransition's "filter" is set, "type" and "subtype" properties are ignored.
//	CATransition* tranny = [CATransition transitionsFor:_targetView].randomElement; 		NSLog(@"New tranny: %@", tranny);
//	return [tranny isKindOfClass:[CIFilter class]] 	? 	   ^{
//		transition.filter 	= tranny; return transition;	 }() : ^{  //itsa filter
//		transition.type		= tranny;
//		transition.subtype	= @[ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom].randomElement;
//		transition.duration	= 1.0;	  return transition; }();
//}


- (IBAction)loadSecondNib:(id)sender
{
	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"TestBed"];
	[[awc window] makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] arrangeInFront:nil];

//	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"TestBed" owner:self];
//	[awc showWindow:self];
//    [[awc window] makeKeyAndOrderFront:nil];
//    [[NSApplication sharedApplication] arrangeInFront:nil];
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

- (void) setView:(id)sender
{
	NSV *newView;
	NSS* label = [sender segmentLabel];
	newView = [label isEqualToString:@"prism"] ? [[AZPrismView alloc]initWithFrame:_targetView.frame] :
				[label isEqualToString:@"azGrid"] ? [[AZGrid alloc]initWithCapacity:23] :
	[self respondsToSelector:NSSelectorFromString(label)] ? self[[sender segmentLabel]] :nil;
//		id newV = self[[sender segmentLabel]]; newV[@"hidden"] = @(YES);
//		if ([_targetView.subviews doesNotContainObject:newV])
//		[_targetView addSubview:newV];
//		[self.targetView setAnimations:@{@"subviews":self.transition}];
	if (newView) {	[[_targetView animator] replaceSubview:_targetView.firstSubview with:newView];
//			   ? [NASpinSeque animateTo:self[[sender segmentLabel]] inSuperView:_targetView]

	[[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:@"unlock"]];
	[[SoundManager sharedInstance] playSound:[Sound soundNamed:@"unlock"]];

	}

}
//								[self.targetView  swapSubs:self[[sender segmentLabel]]] : nil;	}

//- (void)setDebugLayers:(BNRBlockView*)debugLayers {


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
