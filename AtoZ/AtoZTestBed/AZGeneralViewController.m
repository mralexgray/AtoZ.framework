//
//  AZGeneralViewController.m

#import "AZGeneralViewController.h"
#import "TestBedDelegate.h"

@implementation AZGeneralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self != [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) return nil;		return self;
}

-(void) awakeFromNib
{
	[self.segments setFont:[AtoZ controlFont]];		//	[_segments fitTextNice];
	[self.segments 	 setAction:@selector(changeViewFromDropdown:) withTarget:self];
	_targetView.wantsLayer 	    = YES;
//	self.targetView.layer.style = @{ @"sublayers": CATransition.randomTransition };

//	[self.targetView swapSubs:self.debugLayers];
//	[self.view.layer setStyle:@{@"sublayers":[CATransition randomTransition]}];
//	[self.targetView
//	[ setAnimations:@{@"subviews":[CATransition randomTransition]}];
//	[self addObserverForKeyPath:@"targetView" task:^(id obj, NSDictionary *change) {
//		AZLOG(@"subviews changed");
//	}];
}

- (void) changeViewFromDropdown:(id)sender
{
	NSS* label	= [sender segmentLabel];  NSLog(@"looking for label cinderlla view: %@", label);
	id newView	=	areSame(label, @"prism" ) 	  ? [AZPrismView.alloc initWithFrame:_targetView.frame]
				:	areSame(label, @"azGrid") 	  ? [AZGrid.alloc initWithCapacity:23]
				: 	[self respondsToString:label] ?	self[[sender segmentLabel]]
				:	nil;
	!newView ?: ^{
		if (_targetView.subviews.count !=0)	[_targetView removeAllSubviews];
		[_targetView addSubview:newView];
		[newView setFrame:_targetView.bounds]; 			//replaceSubview:_targetView.firstSubview with:newView];
														//		[[_targetView animator] replaceSubview:_targetView.firstSubview with:newView];
		[[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:@"unlock"]];
		[[SoundManager sharedInstance] playSound:[Sound soundNamed:@"unlock"]];
	}();

//	TestBedDelegate *d = (TestBedDelegate*)[[NSApplication sharedApplication]delegate];
//	self.pBar.primaryColor = RANDOMCOLOR;

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

- (LetterView*) letterView { return _letterView = [[LetterView alloc]initWithFrame:_targetView.frame]; }

- (BOOL) holdEm
{
	TestBedDelegate* aD = (TestBedDelegate*)[[NSApplication sharedApplication] delegate];
	return [[aD holdOntoViews] state] == NSOnState;// ? YES : NO;
}

- (AtoZGridViewAuto*) autoGrid
{
	return _autoGrid = _autoGrid ?: [AtoZGridViewAuto.alloc initWithFrame:_targetView.bounds andArray:NSIMG.systemIcons];// inView:_targetView];
}

- (AtoZGridViewAuto*) picol
{
	return _picol = _picol ?: [AtoZGridViewAuto.alloc initWithFrame:_targetView.bounds andArray:NSC.randomPalette];
}

-(NSSV*)contactSheet {


//	if (_picol) {	NSR old = [[_picol associatedValueForKey:_picol.identifier]rectValue]; logRect(old); logRect(_targetView.frame);
//		if (NSEqualRects(_targetView.frame, old)) return  _picol;
//	}	else _picol = ^{

	return _contactSheet = ^{


		NSSV *sv 	= [[NSSV alloc]initWithFrame:_targetView.bounds];
 		sv.autoresizingMask = NSSIZEABLE;

		NSIMG* i	= [NSImage contactSheetWith:[NSIMG monoIcons] inFrame:_targetView.bounds columns:12];
		NSIV *iv  	= [[NSIV alloc]initWithFrame:AZRectFromSize(i.size)];
		iv.image 	= i;
		sv.hasVerticalScroller = YES;
		sv.documentView = iv;
		return sv;
	}();
//
//		AZSizer *s	= [AZSizer forQuantity:[NSIMG monoIcons].count inRect:_targetView.frame];
//		NSA* rects 	= s.rects.copy;
//		[iv.image lockFocus];
//		[[NSIMG monoIcons] eachWithIndex:^(id obj, NSInteger idx) {
//			[obj drawInRect:[[rects normal: idx]rectValue] fraction:1];
//			// badgeForRect:AZMakeRectFromSize(s.size) withColor:RANDOMCOLOR  stroked:nil withString:$(@"%ld", idx)]drawInRect:[obj rectValue]];
//		}];
//		[iv.image unlockFocus];
//		iv.identifier = [NSS newUniqueIdentifier];
		//			[iv associateValue:AZVrect(_targetView.frame) withKey:[iv.identifier UTF8String]];
//		return iv;
}




- (BLKVIEW*)blockView
{
	return 	_blockView = _blockView ?:
	[BLKVIEW viewWithFrame:_targetView.frame opaque:NO drawnUsingBlock: ^(BLKVIEW *view, NSR dirtyRect) {

		view.arMASK = NSSIZEABLE;
		NSRect topBox = AZUpperEdge(view.frame, 100);
		NSRect botBox = AZRectTrimmedOnTop(view.frame, 100);
		NSA* palette = [NSC randomPalette];

		[view setAssociatedValue:[NSC linenTintedWithColor:[palette nextObject]] forKey:@"blockC" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
		NSRectFillWithColor( botBox, [view associatedValueForKey:@"blockC"] );
		NSRectFillWithColor( topBox, [[view associatedValueForKey:@"blockC"] complement]);
		NSBP *arrow	= [[NSBezierPath bezierPathWithArrow]
					   scaleToSize: (NSSZ) { quadrantsVerticalGutter(botBox), NSHeight(botBox) }];
		[arrow setLineWidth:5];
		//		[arrow setLineDash:dash count:20 phase:40];
		[arrow drawWithFill:[palette nextObject] andStroke:[palette nextObject]];
		[arrow drawPointsAndHandles];

		[[NSArray from:0 to:3] eachWithIndex:^(id obj, NSInteger idx) {
			NSBP *tri = [NSBezierPath bezierPathWithTriangleInRect:
						 quadrant( botBox, (QUAD)idx ) orientation:(AMTriangleOrientation)idx];
			[tri drawWithFill:[palette nextObject] andStroke:[palette nextObject]];
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
