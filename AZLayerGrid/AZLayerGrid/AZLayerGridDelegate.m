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
	[AtoZ sharedInstance];
	_content = [NSIMG monoIcons].mutableCopy;
	[_boxes setDelegate:self];
	[_boxes setDataSource:self];
	[_boxes reloadData];
	[_boxes setCellSize:NSMakeSize(64.0, 64.0)];
	[_boxes setAllowsMultipleSelection:YES];
}

- (NSUInteger)numberOfCellsInCollectionView:(AZBoxGrid *)collectionView
{
	return [_content count];
}
- (AZBox *)collectionView:(AZBoxGrid *)collectionView cellForIndex:(NSUInteger)index
{
	AZBox *cell = [_boxes dequeueReusableCellWithIdentifier:@"cell"];
	if(!cell)
		cell = [AZBox.alloc initWithFrame:AZRectFromDim(100) representing:_content[index] atIndex:index];
		return cell;
}
- (void)collectionView:(AZBoxGrid *)collectionView didDeselectCellAtIndex:(NSUInteger)index
{
	NSLog(@"Selected cell at index: %u", (unsigned int)index);
	NSLog(@"Position: %@", NSStringFromPoint([_boxes positionOfCellAtIndex:index]));
}

//	CALayer *root 			= [CALayer greyGradient];
//	[root setValue:@(YES) forKey:@"locked"];
//	root.frame 				= [_window.contentView bounds];
//	root.autoresizingMask 	= kCALayerWidthSizable | kCALayerHeightSizable;
//	self.gridView 			= AddLayer(root);
//	_gridView.superview.wantsLayer = YES;
//	[root addSublayer:back];



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
