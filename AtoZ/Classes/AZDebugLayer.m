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


- (void) awakeFromNib
{
	self.root	= [self setupHostView];
	_root.backgroundColor = cgRANDOMCOLOR;
	self.dLayer = [AZDebugLayer layer];
	_root.layoutManager = AZLAYOUTMGR;
	[_dLayer addConstraintsSuperSize];
	[_root addSublayer:_dLayer];
	[NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
		CAL *hit = [_root hitTest:e.locationInWindow];
		areSameThenDo(hit, _dLayer.anchorPointLayer, ^{
			NSP newA = [self normalizedPoint:AZRandomPointInRect(_root.bounds) inRect:_root.bounds];
			NSLog(@"hit anchorP layer, new Anchor : %@", AZString(newA));
			_dLayer.anchorPoint = newA;
		});
		return e;
	}];

	__block AZDebugLayerView* blockself = self;
	[_dLayer addObserverForKeyPaths:@[@"anchorPoint", @"position"] task:^(id obj, NSDictionary *change) {
		NSLog(@"observed object: %@  change:%@", obj, change);
		NSP newPos = [blockself unNormalizedPoint:blockself.dLayer.anchorPoint inRect:blockself.dLayer.bounds];
		NSLog(@"newpos = %@", AZString(newPos));
		blockself.dLayer.anchorPointLayer.position = newPos;
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
//
//	NSLog(@"did change value for key: %@", key);
//}

- (id)initWithLayer:(id)layer
{
	if (!(self = [super init])) return nil;

//	NSLog(@"event: %@", event);
	self.fillColor = cgCLEARCOLOR;
	CGPathRef ref = [[NSBezierPath bezierPathWithRect:[layer bounds]]quartzPath];
	[self setPath:ref];
	CGColorRef col = cgRANDOMCOLOR;
	[self setStrokeColor:col];
	[self setLineDashPattern:@[ @(10), @(5)]];
	[self setLineWidth:3];
	[self addConstraintsSuperSize];
	self.name = @"debugShape";
	self.zPosition = 1000000;
	NSS* aName = [(CAL*)layer name];
	if (aName) {

		NSFont *font 		= [AtoZ font:@"mono" size:12];
		CATextLayer *t 		= AddTextLayer(self, aName, [AtoZ font:@"Ubuntu" size:12], 0);
		t.backgroundColor 	= self.strokeColor;
		t.foregroundColor   = [[[NSColor colorWithCGColor:self.strokeColor]contrastingForegroundColor]CGColor];
		t.anchorPoint	 	= AZAnchorBottomLeft;
		[t addConstraintsRelSuper:kCAConstraintMinY, kCAConstraintMinX, NSNotFound];
		t.bounds = AZMakeRect(NSZeroPoint, [aName sizeWithFont:font margin:NSMakeSize(4, 3)]);
	}
	return self;
//	[super actionForKey:event];
}

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
