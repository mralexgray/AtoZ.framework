//
//  AZColorViewController.m
//  AtoZ
//
//  Created by Alex Gray on 11/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "ColorVC.h"

@interface ColorVC ()

@end

@implementation ColorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
 	if (self != [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) return nil;
	self.palette = [NSC.randomPalette map:^id(id obj) { return [NSIMG swatchWithColor:obj size:AZSizeFromDimension(self.autoGrid.width)]; }];

	[self.autoGrid bind:@"items"toObject:self withKeyPath:@"palette" options:nil];
	return self;
}

@end
