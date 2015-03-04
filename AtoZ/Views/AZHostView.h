//
//  LayerHostingView.h
//  CoreAnimation3DProjection
//
//  Created by Milen Dzhumerov on 30/05/2010.
//  Copyright 2010 The Cosmic Machine. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#import <QuartzCore/QuartzCore.h>

@interface AZHostView : NSView
{
	CAL *_host;
}

@property (nonatomic, strong) CAL *host;

@end
