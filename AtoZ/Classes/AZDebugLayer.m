//
//  AZDebugLayer.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZDebugLayer.h"

@interface AZDebugLayer ()
@property (nonatomic, retain	) CAShapeLayer *anchorPointLayer, *positionLayer;
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
		_anchorPointLayer.position 		= [self normalizedPoint:self.anchorPoint];
        _anchorPointLayer.delegate = self;
		[self addSublayer:_anchorPointLayer];
		[_anchorPointLayer setNeedsDisplay];
		[NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^NSEvent *(NSEvent *e) {
			CAL *hit = [self hitTest:e.locationInWindow];
			areSameThenDo(hit, _anchorPointLayer, ^{
					self.anchorPoint = AZRandomPointInRect(self.bounds); NSLog(@"hit anchorP layer");
				});
			return e;
		}];
		[self addObserverForKeyPaths:@[@"anchorPoint", @"position"] task:^(id obj, NSDictionary *change) {
			
			_anchorPointLayer.position = [self normalizedPoint:self.anchorPoint];
		}];
    }
    return self;
}

- (NSP) normalizedPoint: (NSP)p
{
	return  (NSPoint) {	self.bounds.size.width 	* p.x, self.bounds.size.height * p.y	};

}
- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	if ( areSame(layer, _anchorPointLayer) ) {
		[@"a" drawInRect:layer.frame withFontNamed:[[AtoZ fonts]first] andColor:WHITE];
	}

}

@end
