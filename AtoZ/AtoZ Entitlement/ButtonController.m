
//  ButtonController.m
//  AtoZ

//  Created by Alex Gray on 8/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "ButtonController.h"

@implementation ButtonController

- (IBAction)more:(id)sender {

	[_quads.items addObject:@"*"];
	[_quads.menus az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj reloadData];
	}];

}

- (IBAction)less:(id)sender {

	[_quads.items removeLastObject];
	[_quads.menus az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj reloadData];
	}];

}
@end
