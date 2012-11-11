//
//  AZDebugLayer.h
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"


@interface AZDebugLayer : CAShapeLayer
@property (nonatomic, retain	) CAShapeLayer *anchorPointLayer, *positionLayer;
@end

@interface AZDebugLayerView : NSView
@property (nonatomic, strong) AZDebugLayer *dLayer;
@property (nonatomic, strong) CAL *root;
@end

