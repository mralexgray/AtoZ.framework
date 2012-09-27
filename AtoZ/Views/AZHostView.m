//
//  LayerHostingView.m
//  CoreAnimation3DProjection
//
//  Created by Milen Dzhumerov on 30/05/2010.
//  Copyright 2010 The Cosmic Machine. All rights reserved.
//

#import "AZHostView.h"
#import "AtoZ.h"

@implementation AZHostView

-(void)awakeFromNib
{
	self.host 		  	= [CALayer layer];
	_host.bgC 			= cgORANGE;
	self.layer			= _host;
	self.wantsLayer	 	= YES;
}

@end
