//
//  AZGeneralViewController.m
//  AtoZ
//
//  Created by Alex Gray on 11/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZGeneralViewController.h"
#import "TestBedDelegate.h"

@interface AZGeneralViewController ()

@end
@implementation AZGeneralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Initialization code here.
	}

	return self;
}


-(void) awakeFromNib {
	[self.segments setFont:[AtoZ controlFont]];
//	[_segments fitTextNice];
	[self.segments 	 setAction:@selector(poopOnSegment:) withTarget:self];
//	[self.targetView swapSubs:self.debugLayers];
	[self.view.layer setStyle:@{@"sublayers":[CATransition randomTransition]}];
//	[self.targetView
//	[ setAnimations:@{@"subviews":[CATransition randomTransition]}];
	[self addObserverForKeyPath:@"targetView" task:^(id obj, NSDictionary *change) {
		AZLOG(@"subviews changed");
	}];
}

- (void) poopOnSegment:(id)sender	{	NSS* label = [sender segmentLabel];  NSV *newView

	=	areSame(label, @"prism" ) 	  ? 	[[AZPrismView alloc]initWithFrame:_targetView.frame]
	:	areSame(label, @"azGrid") 	  ? 	[[AZGrid alloc]initWithCapacity:23]
	: 	[self respondsToString:label] ?		self[[sender segmentLabel]]
	:	nil;				 !newView ?: ^{

		[[_targetView animator] replaceSubview:_targetView.firstSubview with:newView];
		[[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:@"unlock"]];
		[[SoundManager sharedInstance] playSound:[Sound soundNamed:@"unlock"]];
	}();

//	TestBedDelegate *d = (TestBedDelegate*)[[NSApplication sharedApplication]delegate];
	self.pBar.primaryColor = RANDOMCOLOR;

}


-(NSImageView*) baseImageView {
	NSImageView *v = [[NSImageView alloc]initWithFrame:_targetView.frame];
	v.arMASK = NSSIZEABLE;
	v.imageScaling = NSImageScaleProportionallyUpOrDown;
	v.image = [[NSImage alloc]initWithSize:_targetView.frame.size];
	return v;
}
-(NSImageView*)badges
{
	if (_badges) return  _badges;
	NSImageView* someBadges =   [self baseImageView];
	AZSizer *s = [AZSizer forQuantity:10 inRect:_targetView.frame];
	[someBadges.image lockFocus];
	[s.rects eachWithIndex:^(id obj, NSInteger idx) {
		[[NSImage badgeForRect:AZMakeRectFromSize(s.size) withColor:RANDOMCOLOR  stroked:nil withString:$(@"%ld", idx)]drawInRect:[obj rectValue]];
	}];
	[someBadges.image unlockFocus];
	_badges = [self holdEm] ? someBadges : nil;	 return someBadges;
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

- (LetterView*) letterView {
	return _letterView = [[LetterView alloc]initWithFrame:_targetView.frame];
}

- (BOOL) holdEm
{
	TestBedDelegate* aD = (TestBedDelegate*)[[NSApplication sharedApplication] delegate];
	return [[aD holdOntoViews] state] == NSOnState;// ? YES : NO;
}

- (AtoZGridViewAuto*) picol
{
	NSA *p = [[NSC randomPalette]withMinItems:300];
	p = [p map:^id(id obj) { return [NSIMG swatchWithColor:obj size:AZSizeFromDimension(200)]; }];
//	 [NSIMG monoIcons];   LOG_EXPR(p);

	return _picol = _picol ?: [[AtoZGridViewAuto alloc]initWithArray:p];
}

-(NSImageView*)picolOld {



	if (_picol) {	NSR old = [[_picol associatedValueForKey:_picol.identifier]rectValue]; logRect(old); logRect(_targetView.frame);
		if (NSEqualRects(_targetView.frame, old)) return  _picol;
	}
	else _picol = ^{NSIV *iv  	= [self baseImageView];
		AZSizer *s	= [AZSizer forQuantity:[NSIMG monoIcons].count inRect:_targetView.frame];
		NSA* rects 	= s.rects.copy;
		[iv.image lockFocus];
		[[NSIMG monoIcons] eachWithIndex:^(id obj, NSInteger idx) {
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



- (AtoZGridViewAuto*) autoGrid
{
	return _autoGrid = _autoGrid ?: [[AtoZGridViewAuto alloc]initWithArray:[NSIMG systemIcons]];// inView:_targetView];
}

- (BLKVIEW*)blockView
{	return 	_blockView = _blockView ?:
	[BLKVIEW viewWithFrame:_targetView.frame opaque:NO drawnUsingBlock: ^(BLKVIEW *view, NSR dirtyRect) {

		view.arMASK = NSSIZEABLE;
		NSRect topBox = AZUpperEdge(view.frame, 100);
		NSRect botBox = AZRectTrimmedOnTop(view.frame, 100);
		AZPalette  *palette = [AZPalette new];

		[view associate:[NSC linenTintedWithColor:[palette nextColor]] with:@"blockC"];
		NSRectFillWithColor( botBox, [view associatedValueForKey:@"blockC"] );
		NSRectFillWithColor( topBox, [[view associatedValueForKey:@"blockC"] complement]);
		NSBP *arrow	= [[NSBezierPath bezierPathWithArrow]
					   scaleToSize: (NSSZ) { quadrantsVerticalGutter(botBox), NSHeight(botBox) }];
		[arrow setLineWidth:5];
		//		[arrow setLineDash:dash count:20 phase:40];
		[arrow drawWithFill:[palette nextColor] andStroke:[palette nextColor]];
		[arrow drawPointsAndHandles];

		[[NSArray from:0 to:3] eachWithIndex:^(id obj, NSInteger idx) {
			NSBP *tri = [NSBezierPath bezierPathWithTriangleInRect:
						 quadrant( botBox, (QUAD)idx ) orientation:(AMTriangleOrientation)idx];
			[tri drawWithFill:[palette nextColor] andStroke:[palette nextColor]];
			[tri drawPointsAndHandles];

		}];
		[@" I am Drawn in a block.\n And this text is guaranteed to fit! " drawInRect:topBox withFontNamed:[AtoZ randomFontName] andColor:WHITE];
	}];
}

- (AZMedallionView*)medallion {
	return 	_medallion = _medallion ?: ^{
		AZMedallionView *n = [[AZMedallionView alloc]initWithFrame:_targetView.frame];
		n.image = [NSImage systemIcons].randomElement;
		return n;  }();
}

-(AZHostView*)hostView {
	return 	_hostView = _hostView ?: (AZHostView*)^{
		AZHostView *h = [[AZHostView alloc]initWithFrame:_targetView.frame];
		h.host.backgroundColor = cgRANDOMCOLOR;
		return h;
	}();
}

-(AZDebugLayerView*)debugLayers {
	return 	_debugLayers = _debugLayers ?: (AZDebugLayerView*)^{


		AZDebugLayerView *dL = [[AZDebugLayerView alloc]initWithFrame:_targetView.frame];
		dL.arMASK = NSSIZEABLE;
		return dL;
	}();
	/*
	 dL.backgroundColor = cgGREEN;
	 NSView *v = [[NSView alloc]initWithFrame:_targetView.frame];
	 v.arMASK = NSSIZEABLE;
	 CAL* lay = [v setupHostView];
	 [lay addSublayer:dL];
	 [[[AZFolder samplerWithCount:4]valueForKeyPath:@"image"] eachWithIndex:^(id obj, NSInteger idx) {
	 NSR framer = quadrant(_targetView.bounds, idx+1);
	 CAL *new = [CALayer layer];
	 new.frame = framer;
	 new.backgroundColor = cgRANDOMCOLOR;//NewLayerWithFrame(framer);
	 new.contents = obj;
	 new.transform = [new makeTransformForAngle:.45];
	 [lay addSublayer:new];
	 }];
	 return v;
	 }();
	 */
}


@end
