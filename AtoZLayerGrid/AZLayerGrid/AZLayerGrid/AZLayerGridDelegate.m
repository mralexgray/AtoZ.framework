//
//  AppDelegate.m
//  AZLayerGrid
//
//  Created by Alex Gray on 7/20/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AppDelegate.h"
#import <AtoZ/AtoZ.h>

@implementation AppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
	CAGradientLayer *back = [self greyGradient];
	[back setValue:[NSNumber numberWithBool:YES] forKey:@"locked"];
//	back.frame = [self frame];
//	back.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//	[root addSublayer:back];
}


//Metallic grey gradient background
- (CAGradientLayer*) greyGradient {
	NSArray *colors =  $array(
							  (id)[[NSColor colorWithDeviceWhite:0.15f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.19f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.25f alpha:1.0f] CGColor]);
	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	return headerLayer;
	
}



@end
