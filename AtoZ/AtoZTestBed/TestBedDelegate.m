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
- (CAL*)getLayer;
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

-(CATransition*)transition {
    // Construct a new CATransition that describes the transition effect we want.
    CATransition *transition = [CATransition animation];
	// We want to build a CIFilter-based CATransition.  When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored, so we don't need to bother setting them.

	id tranny = [self.transitions randomElement];
	NSLog(@"New tranny: %@", tranny);
	if ([_transition isKindOfClass:[CIFilter class]])
		[transition setFilter:tranny];
	else{
		[transition setType:tranny];

		[transition setSubtype:@[kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom].randomElement];
		[transition setDuration:1.0];
	}
	return transition;

}
-(NSA*)transitions {
//	__block
	NSRect rect = [_targetView bounds];
	CIImage *inputMaskImage, *inputShadingImage;
	inputMaskImage = inputShadingImage = [[NSImage az_imageNamed:@"linen"] toCIImage];
//	CIImage  = [inputMaskImagetoCIImage];

	return _transitions = _transitions ?: @[

	kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal,
	^{ 		CIFilter *transitionFilter = CIFilterDefaultNamed(@"CICopyMachineTransition");
		transitionFilter.name = @"CICopyMachineTransition";
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
													   Y:rect.origin.y
													   Z:rect.size.width
													   W:rect.size.height] forKey:@"inputExtent"];
		return transitionFilter;
	}(), ^{	// Scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
		CIFilter *transitionFilter = CIFilterDefaultNamed(@"CIDisintegrateWithMaskTransition");
		CIFilter *maskScalingFilter = CIFilterDefaultNamed(@"CILanczosScaleTransform");
		transitionFilter.name = @"CIDisintegrateWithMaskTransition";
		CGRect maskExtent = [[[_targetView snapshot]toCIImage] extent];// rect;//[inputMaskImage extent];
		float xScale = rect.size.width  / maskExtent.size.width;
		float yScale = rect.size.height / maskExtent.size.height;
		[maskScalingFilter setValue:@(yScale) forKey:@"inputScale"];
		[maskScalingFilter setValue:@(xScale / yScale) forKey:@"inputAspectRatio"];
		[maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
		[transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"];
		return transitionFilter;
	}(), ^{
		return CIFilterDefaultNamed(@"CIDissolveTransition");
	}(),^{
		CIFilter* transitionFilter = CIFilterDefaultNamed(@"CIFlashTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		transitionFilter.name = @"CIFlashTransition";
		return transitionFilter;
	}(),^{
		CIFilter* transitionFilter = CIFilterDefaultNamed(@"CIModTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		transitionFilter.name = @"CIModTransition";
		return transitionFilter;
	}(),^{

		CIFilter*transitionFilter = CIFilterDefaultNamed(@"CIPageCurlTransition");
		[transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputBacksideImage"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		return transitionFilter;
	}(),^{	return CIFilterDefaultNamed(@"CISwipeTransition");
	}(),^{
		CIFilter*transitionFilter = CIFilterDefaultNamed(@"CIRippleTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
		return transitionFilter;
	}()];

}
-(void) awakeFromNib
{
	[self.segments 	 setAction:@selector(setView:) withTarget:self];
	[self.targetView setupHostView];
	[_targetView swapSubs:self.debugLayers];
	[self addObserverForKeyPath:@"self.targetView.subviews" task:^(id obj, NSDictionary *change) {
		AZLOG(@"subviews changed");
	}];
}

- (AZMedallionView*)medallion {
	return 	_medallion = _medallion ?: ^{
		AZMedallionView *n = [[AZMedallionView alloc]initWithFrame:_targetView.frame];
		n.image = [NSImage systemIcons].randomElement;
		return n;  }();
}
- (void) setView:(id)sender	{
//	self.seque =
	[self.targetView setAnimations:@{@"subviews":self.transition}];
	[self respondsToString:[sender segmentLabel]] ?

	[[_targetView animator] replaceSubview:[[_targetView subviews]objectAtIndex:0] with:[self valueForKey:[sender segmentLabel]]]
			 //newImageView];
//			   ? [NASpinSeque animateTo:self[[sender segmentLabel]] inSuperView:_targetView]
			   :  nil;

}
//								[self.targetView  swapSubs:self[[sender segmentLabel]]] : nil;	}

//- (void)setDebugLayers:(BNRBlockView*)debugLayers {
- (BLKVIEW*)blockView
{	return 	_blockView = _blockView ?:
	[BLKVIEW viewWithFrame:_targetView.frame opaque:YES drawnUsingBlock: ^(BLKVIEW *view, NSR dirtyRect) {
		view.arMASK = NSSIZEABLE;
		NSBP *arrow	= [[NSBezierPath bezierPathWithArrow]scaleToSize:AZScaleRect(view.frame, .5).size];
		NSC  *color = RANDOMCOLOR;
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
		dL.backgroundColor = cgRED;
		NSView *v = [[NSView alloc]initWithFrame:_targetView.frame];
		v.arMASK = NSSIZEABLE;
		v.layer = dL;
		v.wantsLayer = YES;
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
