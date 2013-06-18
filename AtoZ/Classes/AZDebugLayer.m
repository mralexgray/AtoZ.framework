//
//  AZDebugLayer.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZDebugLayer.h"

@implementation AZDebugLayerView
- (NSP) normalizedPoint: (NSP)p inRect: (NSR)r
{
	NSLog(@"normalizing: %@ inRect: %@", AZString(p), AZString(r));
	return (NSP) { (p.x / NSWidth(r)), (p.y / NSHeight(r))};
}

- (NSP) unNormalizedPoint: (NSP)p inRect:(NSR)r
{
	return  (NSPoint) {	(r.size.width * p.x), (r.size.height * p.y)	};

}
- (void) awakeFromNib	{
	self.root	= [self setupHostView];
	_root.backgroundColor = cgRANDOMCOLOR;
	self.dLayer = [AZDebugLayer layer];
	_root.layoutManager = AZLAYOUTMGR;
	[_dLayer addConstraintsSuperSize];
	[_root addSublayer:_dLayer];
	[NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
		CAL *hit = [_root hitTest:e.locationInWindow];
		areSameThenDo(hit, _dLayer, ^{ ///.anchorPointLayer, ^{
			NSP newA = [self normalizedPoint:AZRandomPointInRect(_root.bounds) inRect:_root.bounds];
			NSLog(@"hit anchorP layer, new Anchor : %@", AZString(newA));
			_dLayer.anchorPoint = newA;
		});
		return e;
	}];

	__block AZDebugLayerView* blockself = self;
	[_dLayer addObserverForKeyPaths:@[@"anchorPoint", @"position"] task:^(id obj, NSString *keyPath) {
		NSLog(@"observed object: %@  change:%@", obj, keyPath);
		NSP newPos = [blockself unNormalizedPoint:blockself.dLayer.anchorPoint inRect:blockself.dLayer.bounds];
		NSLog(@"newpos = %@", AZString(newPos));
//		blockself.dLayer.anchorPointLayer.position = newPos;
		//			[_anchorPointLayer setNeedsDisplay];
	}];
	
}


- (BOOL)acceptsFirstResponder;
{
	return YES;
}

@end



@implementation AZDebugLayer
//- (void) didChangeValueForKey:(NSString *)key {
//	NSLog(@"did change value for key: %@", key);
//}

- (id)init
{
	if (self != [super init]) return nil;
//	_tracking = [layer ISKINDA:AZDebugLayer.class] ? [layer tracking] : layer;
//	if (_tracking)
//		[self bind:@"frame" toObject:_tracking withKeyPath:@"bounds" nilValue:AZVrect(AZRectFromDim(100))];
	self.nDoBC = YES;
	[self sV:RANDOMCOLOR fK:@"color"];
	self.arMASK = CASIZEABLE;
	self.loM = AZLAYOUTMGR;
	[self addConstraintsSuperSize];
	self.masksToBounds = YES;
	self.delegate = self;
	[self setNeedsDisplay];
	self.zPosition = 1000000;
	return self;
}
- (void) drawInContext:(CGContextRef)ctx {
	[NSGC drawInContext:ctx flipped:NO actions:^{

//	self.fillColor = cgCLEARCOLOR;
//	[self setPath:[NSBP bezierPathWithRect:[layer bounds]].newQuartzPath];

	NSBP* b = [NSBP bezierPathWithRect:self.superlayer.bounds];
	[NSBP setDefaultLineWidth:AZMinDim(self.superlayer.boundsSize)*.05];
	b.dashPattern = @[ @10, @10];
	[b strokeWithColor:self[@"color"]];
	[$(@"%@ z:%.0f i:%ld s:%@ v:%@", self.superlayer.name ?:@"", self.superlayer.zPosition, self.superlayer.siblingIndex, StringFromBOOL(self.superlayer.selected), self.superlayer.hostView) drawAtPoint:self.superlayer.boundsOrigin withAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"UbuntuMono-Bold"size:12], NSFontSizeAttribute:@14}];
	}];
}
//	[self bind:@"lineWidth" toObject:layer withKeyPath:@"bounds" transform:^id(id value) {
//		return @(AZMinDim([value rectValue].size) * .05);	}];
//	[self addConstraintsSuperSize];
//	self.name = @"debugShape";
//	self.zPosition = 1000000;

//	CATextLayer *t 		= AddTextLayer(self, @"s", AtoZ.controlFont, 0);
//	[t bind:@"string" toObject:layer withKeyPath:NSValueBinding transform:^id(id value) {
//		CAL *l = value;
//		return $(@"%@ z:%.0f i:%ld s:%@ v:%@", l.name ?:@"", l.zPosition, l.siblingIndex, StringFromBOOL(l.selected), l.hostView);
//	}];
//	t.backgroundColor 	= self.strokeColor;
//	t.foregroundColor   	= [NSColor colorWithCGColor:self.strokeColor].contrastingForegroundColor.CGColor;
//	t.anchorPoint	 		= AZAnchorBottomLeft;
//	[t addConstraintsRelSuper:kCAConstraintMinY, kCAConstraintMinX, NSNotFound];
//	[t bind:@"bounds" toObject:t withKeyPath:@"string" transform:^id(id value) {
//		return AZVrect(AZMakeRect(NSZeroPoint, [value sizeWithFont:AtoZ.controlFont margin:(NSSZ){4,3}]));
//	}];
////	t.bounds = AZMakeRect(NSZeroPoint, [aName sizeWithFont:AtoZ.controlFont margin:(NSSZ){4,3}]);
//	return self;
//}
-(BOOL) containsPoint:(CGPoint)p { return NO; };
//- (id)init
//{
//	if (!(self = [super init])) return nil;
//
//	self.name = @"debugShape";
//	self.fillColor = cgCLEARCOLOR;

//		self.anchorPointLayer 	= [CASL layer];
//		self.positionLayer 		= [CASL layer];
//
//		_anchorPointLayer.bgC 			= cgRED;
//		_anchorPointLayer.cornerRadius 	= 10;
//		_anchorPointLayer.bounds 		= AZRectFromDim(50);
//		_anchorPointLayer.delegate = self;
//		[self addSublayer:_anchorPointLayer];
//		[_anchorPointLayer setNeedsDisplay];
//	return self;
//}
//- (void) setAnchorPoint:(CGPoint)anchorPoint {
//	anchorPoint = anchorPoint;
//	_anchorPointLayer.position 		= [self unNormalizedPoint:self.anchorPoint inRect:[self bounds]];
//	[_anchorPointLayer setNeedsDisplay];
//}



//- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//
//	if ( areSame(layer, _anchorPointLayer) ) {
//		[@"a" drawInRect:layer.frame withFontNamed:[[AtoZ fonts]first] andColor:WHITE];
//	}
//
//}

@end
