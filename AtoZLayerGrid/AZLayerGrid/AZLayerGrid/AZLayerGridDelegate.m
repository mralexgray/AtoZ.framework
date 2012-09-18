//
//  AppDelegate.m
//  AZLayerGrid
//
//  Created by Alex Gray on 7/20/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AZLayerGridDelegate.h"
#import <AtoZ/AtoZ.h>

@implementation AZLayerGridDelegate


- (void)awakeFromNib
{
	
//	CALayer *root 			= [CALayer greyGradient];
//	[root setValue:@(YES) forKey:@"locked"];
//	root.frame 				= [_window.contentView bounds];
//	root.autoresizingMask 	= kCALayerWidthSizable | kCALayerHeightSizable;
//	self.gridView 			= AddLayer(root);
//	_gridView.superview.wantsLayer = YES;
	//	[root addSublayer:back];
}


//Metallic grey gradient background
//- (CAGradientLayer*) greyGradient {
//	NSArray *colors =  $array(
//							  (id)[[NSColor colorWithDeviceWhite:0.15f alpha:1.0f]CGColor],
//							  [[NSColor colorWithDeviceWhite:0.19f alpha:1.0f]CGColor],
//							  [[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]CGColor],
//							  [[NSColor colorWithDeviceWhite:0.25f alpha:1.0f] CGColor]);
//	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
//	CAGradientLayer *headerLayer = [CAGradientLayer layer];
//	headerLayer.colors = colors;
//	headerLayer.locations = locations;
//	return headerLayer;
//	
//}



@end
