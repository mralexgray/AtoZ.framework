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
	[_dLayer addObserverForKeyPaths:@[@"anchorPoint", @"position"] task:^(id obj, NSDictionary *change) {
		NSLog(@"observed object: %@  change:%@", obj, change);
		NSP newPos = [self unNormalizedPoint:_dLayer.anchorPoint inRect:_dLayer.bounds];
		NSLog(@"newpos = %@", AZString(newPos));
		_dLayer.anchorPointLayer.position = newPos;
		//			[_anchorPointLayer setNeedsDisplay];
	}];
	
}


- (BOOL)acceptsFirstResponder;
{
    return YES;
}

@end



@implementation AZDebugLayer
- (id)init
{
    self = [super init];
    if (self) {
		self.anchorPointLayer 	= [CASL layer];
		self.positionLayer 		= [CASL layer];

		_anchorPointLayer.bgC 			= cgRED;
		_anchorPointLayer.cornerRadius 	= 10;
		_anchorPointLayer.bounds 		= AZRectFromDim(50);
        _anchorPointLayer.delegate = self;
		[self addSublayer:_anchorPointLayer];
		[_anchorPointLayer setNeedsDisplay];
    }
    return self;
}
//- (void) setAnchorPoint:(CGPoint)anchorPoint {
//	anchorPoint = anchorPoint;
//	_anchorPointLayer.position 		= [self unNormalizedPoint:self.anchorPoint inRect:[self bounds]];
//	[_anchorPointLayer setNeedsDisplay];
//}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	if ( areSame(layer, _anchorPointLayer) ) {
		[@"a" drawInRect:layer.frame withFontNamed:[[AtoZ fonts]first] andColor:WHITE];
	}

}

@end
