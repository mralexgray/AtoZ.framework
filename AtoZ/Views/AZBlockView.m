
//  AZBlockView.m
//  AtoZ

//  Created by Alex Gray on 6/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZBlockView.h"
#import "AtoZ.h"

//@implementation AZBlockView
//@synthesize drawBlock, opaque;
//+ (AZBlockView *)viewWithFrame:(NSRect)frame 
//						 opaque:(BOOL)opaque
//				drawnUsingBlock:(AZBlockViewDrawer)theDrawBlock
//{
////	__block __typeof__(self)
//	AZBlockView *view = [[AZBlockView alloc] initWithFrame:frame];
//	[view setDrawBlock:theDrawBlock];
//	[view setOpaque:opaque];
//	return view;// autorelease];
//}
//- (void)dealloc {
//	[self setDrawBlock:nil];
//	[super dealloc];
//}
//- (void)drawRect:(NSRect)dirtyRect {
//	if (drawBlock)
//		drawBlock(self, dirtyRect);
//}
//- (BOOL)isOpaque {
//	return opaque;
//}


@implementation BNRBlockView
@synthesize drawBlock, opaque, layerBlock;

+ (BLKVIEW*) viewWithFrame: (NSR)frame  opaque: (BOOL)opaque 
			  drawnUsingBlock: (BNRBlockViewDrawer)theDrawBlock
{	//	__typeof__(self)
	BLKVIEW *view 	= [BLKVIEW.alloc initWithFrame:frame];
	[view setDrawBlock:theDrawBlock];
	[view setOpaque:opaque];
	return view;
}
+ (BLKVIEW*) inView:(NSV*)v withBlock:(BNRBlockViewLayerDelegate)ctxBlock
{
	BLKVIEW *view 	= [BLKVIEW.alloc initWithFrame:v.bounds];
	[v addSubview:view];
	view.arMASK 	= NSSIZEABLE;
	CAL* l 			= view.setupHostView;
	view.layer 		= l;
	l.delegate 		= view;
	l.arMASK 			= CASIZEABLE;
	l.bgC 				= [LINEN CGColor];
	[l setNeedsDisplay];
	[view setLayerBlock:ctxBlock];
	return view;
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx 
{
	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
		if (layerBlock) layerBlock(self, layer);
		if (drawBlock) drawBlock(self, layer.bounds);
	}];
}

- (void)drawRect:(NSRect)dirtyRect { if (drawBlock) drawBlock(self, dirtyRect); }

- (BOOL)isOpaque { 	return opaque;	}

@end

@implementation AZBlockWindow
@synthesize drawBlock;

+ (AZBlockWindow*) windowWithFrame: (NSRect)frame drawnUsingBlock:(BNRBlockViewDrawer)theDrawBlock
{	//	__typeof__(self)
	AZBlockWindow *view = [AZBlockWindow.alloc initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	view.drawBlock = theDrawBlock;
//	[view setMovable: YES];
	[(NSView*)[view contentView]addSubview:view.drawBlock];
	return view;
}

- (BOOL) acceptsFirstResponder { return YES; }
- (BOOL) acceptsMouseMovedEvents { return YES; }
@end

/*
@implementation AZBlockView
@synthesize drawBlock, opaque;
+ (AZBlockView*)  viewWithFrame:(NSRect)frame  opaque:(BOOL)opaque
				drawnUsingBlock:(AZBlockViewDrawer)theDrawBlock
{
//	__typeof__(self) view = [[AZBlockView alloc] initWithFrame:frame];
//	[view setDrawBlock:theDrawBlock];
//	[view setOpaque:opaque];
//	return view;// autorelease];
}


- (void)drawRect:(NSRect)dirtyRect {	if (drawBlock)		drawBlock(self, dirtyRect); }

- (BOOL)isOpaque {	return opaque; }

@end
*/