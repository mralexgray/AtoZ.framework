//
//  AtoZAppDelegate.m
//  AZBoxTest
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZAppDelegate.h"

@implementation AtoZAppDelegate

@synthesize window = _window, boxGrid;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[boxGrid setCellSize:NSMakeSize(64.0, 64.0)];
	[boxGrid setAllowsMultipleSelection:YES];
}

- (NSUInteger)numberOfCellsInCollectionView:(AZBoxGrid *)view {
    return [NSColor fengshui].count;
}

- (AZBox *)collectionView:(AZBoxGrid *)view cellForIndex:(NSUInteger)index
{
    AZBox *cell = [view dequeueReusableCellWithIdentifier:$(@"cell.%ld", index)];
	if(!cell)
        cell = [[AZBox alloc] initWithReuseIdentifier:$(@"cell.%ld", index)];
		cell.color = [[NSColor fengshui] objectAtIndex:index];
//		[cell setImage:[[[AtoZ dockSorted]objectAtIndex:index] valueForKey:@"image"]];
    return cell;
}

- (void)collectionView:(AZBoxGrid *)_collectionView didSelectCellAtIndex:(NSUInteger)index {
    NSLog(@"Selected cell at index: %u", (unsigned int)index);
    NSLog(@"Position: %@", NSStringFromPoint([_collectionView positionOfCellAtIndex:index]));
}

- (IBAction)reload:(id)sender {
	[boxGrid reloadData];
}
@end
