
//  AZAppDelegate.m
//  AtoZ Entitlement

//  Created by Alex Gray on 8/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "AZEntitlementDelegate.h"
#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>
#import <AtoZ/AtoZ.h>
#import "AZQuadObject.h"


@implementation AZEntitlementDelegate
//@synthesize log = _log;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	self.log = @"hello, bitch.";  //works : log
//	self.log = $(@"%@", [AtoZ appCategories]); //works  : array
//	self.dbx = [AtoZ sharedInstance];
//	self.log = $(@"%@", [valueForKeyPath:@"name"]);  // works : directoryContentsAtPath
//	self.log = $(@"%@", [[AtoZ dock]valueForKeyPath:@"name"]);  //  FAIL
//	NSRect r = [[_window1 contentView] bounds];
//	self.quad = 	[AZQuadObject new];
//	[_window1.contentView performSelector:@selector(startAnimation:sender:) withObject:_window1.contentView];
	// each:^(id obj, NSUInteger index, BOOL *stop) {
//		[_quad insertItem:obj];

//	}];
//	_iconStyle = 1;
//	NSLog(@"QuadProps, %@", _quad.propertiesPlease);
//	self.g	 = [[AZFileGridView alloc] initWithFrame:r andFiles:[AtoZ appFolderSamplerWith:RAND_INT_VAL(23, 55)]];
//	[_g setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

//	[_window1 setContentView:_g];
//	[[_window contentView] debugDescription];
//	AZSizer *r = dbx.ap
	// Insert code here to initialize your application

	self.cc = [AZCalculatorController new];
	[_cc.window setFrame:[[NSScreen mainScreen]frame] display:YES animate:YES];
	[_cc.window setDelegate:self];
	[_cc.window makeKeyAndOrderFront:_cc.window];
}


- (void) awakeFromNib {

//	self.quad = [[AZQuadCarousel alloc]init];
//	self.quad.content = [AtoZ appFolderSamplerWith:23].mutableCopy;
//	NSLog(@"Sampler:  %@", self.quad.content);

//	[@[_north, _south, _east, _west] each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj slideIn];
//}]

//	CALayer *vag = [CALayer layer];
//	self.imageView.layer = vag;
//	[self.imageView setWantsLayer:YES];
//	vag.frame = _imageView.bounds;
//	vag.backgroundColor = cgRED;

//	[self runAnimation:nil];

//	[_quad.menus each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj reloadData];
//	}];
}

/*

- (void)runAnimation:(id)unused
{
		// Create a shaking animation that rotates a bit counter clockwisely and then rotates another
		// bit clockwisely and repeats. Basically, add a new rotation animation in the opposite
		// direction at the completion of each rotation animation.
	const CGFloat duration = 0.1f;
	const CGFloat angle = 0.03f;
	NSNumber *angleR = [NSNumber numberWithFloat:angle];
	NSNumber *angleL = [NSNumber numberWithFloat:-angle];

	CABasicAnimation *animationL = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	CABasicAnimation *animationR = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

	void (^completionR)(BOOL) = ^(BOOL finished) {
		[self.imageView.layer setValue:angleL forKey:@"transform.rotation.z"];
		[self.imageView.layer addAnimation:animationL forKey:@"L"]; // Add rotation animation in the opposite direction.
	};

	void (^completionL)(BOOL) = ^(BOOL finished) {
		[self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
		[self.imageView.layer addAnimation:animationR forKey:@"R"];
	};

	animationL.fromValue = angleR;
	animationL.toValue = angleL;
	animationL.duration = duration;
	animationL.completion = completionL; // Set completion to perform rotation in opposite direction upon completion.

	animationR.fromValue = angleL;
	animationR.toValue = angleR;
	animationR.duration = duration;
	animationR.completion = completionR;

		// First animation performs half rotation and then proceeds to enter the loop by playing animationL in its completion block
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.f];
	animation.toValue = angleR;
	animation.duration = duration/2;
	animation.completion = completionR;

	[self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
	[self.imageView.layer addAnimation:animation forKey:@"0"];
}

*/


@end
