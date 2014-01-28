
//  AZQuadLayer.h
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>

@interface AZQuadLayerView : NSView

{
	NSPoint mouseDownPoint, mouseDownStartingPoint;
}
@property (nonatomic, retain) CALayer *contentLayer;
@property (nonatomic, retain) CALayer *clickedLayer;
@property (nonatomic, retain) CAShapeLayer *lassoLayer;

- (void) redrawPath;

@end
