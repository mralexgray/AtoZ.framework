//
//  LayerHostingView.m
//  CoreAnimation3DProjection
//
//  Created by Milen Dzhumerov on 30/05/2010.
//  Copyright 2010 The Cosmic Machine. All rights reserved.
//

#import "AZHostView.h"
#import <AtoZ/AtoZ.h>

/*** A "layer backed NSView" 
		1. can have subviews.  it is a normal view after all
		2. it uses a layer as "pixel backing storage", instead of the kind of storage views otherwise use.
		3. the backing layer of a NSView cannot have sublayers (there is no support for "layer hierarchies"). 

			 NSView *layerBacked = [NSView new];
			 [layerBacked setWantsLayer:YES];

	A "layer hosting" view
		1. cannot have subviews
		2. its sole purpose is to "host a layer"
		3. the layer it hosts can have sublayers and a very complex layer-tree-hierarchy.

			 NSView *layerHosting = [NSView new];
			 CALayer *layer = [CALayer new];
			 [layerHosting setLayer:layer];
			 [layerHosting setWantsLayer:YES];
*/

@implementation AZHostView
-(void)awakeFromNib
{
	_host 		  		= [self setupHostView];// [CALayer layer];
//	_host.bgC 			= cgORANGE;
//	self.layer			= _host;
//	self.wantsLayer	 	= YES;
}

@end
