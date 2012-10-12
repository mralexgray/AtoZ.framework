//
//  AZDebugLayer.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZDebugLayer.h"

@interface AZDebugLayer ()
@property (nonatomic, retain) CALayer *anchorPointLayer;
@end

@implementation AZDebugLayer
- (id)init
{
    self = [super init];
    if (self) {
		self.anchorPointLayer = [CAL layer];
		_anchorPointLayer.backgroundColor = cgRED;
		_anchorPointLayer.cornerRadius = 10;
		_anchorPointLayer.bounds = AZRectFromDim(10);
		_anchorPointLayer.position = (NSPoint) {self.bounds.size.width * self.anchorPoint.x,
												self.bounds.size.height * self.anchorPoint.y};
        _anchorPointLayer.delegate = self;
		[self addObserverForKeyPath:@"anchorPoint" task:^(id obj, NSDictionary *change) {
			_anchorPointLayer.position = (NSPoint) {self.bounds.size.width * self.anchorPoint.x,
													self.bounds.size.height * self.anchorPoint.y};
		}];
    }
    return self;
}
@end
