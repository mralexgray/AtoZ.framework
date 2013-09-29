
//  AZBlockView.m
//  AtoZ

//  Created by Alex Gray on 6/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZBlockView.h"
#import "AtoZ.h"

@implementation BLKCELL

//+ (instancetype) inView:(NSV*)v withBlock:(void(^)(BLKCELL*cell, NSR cF, NSV*cV))blk {

//	BLKCELL *cell 	= [BLKCELL.alloc initWithCoder:<#(NSCoder *)#> .alloc initWithFrame:frame];
//	[view setDBlock:theDrawBlock];
//	[view setOpaque:opaque];
//	return view;
//}

@end

@implementation BNRBlockView
//@synthesize drawBlock, opaque, layerBlock;
+ (BLKVIEW*) viewWithFrame: (NSR)frame  opaque: (BOOL)opaque 
			  drawnUsingBlock: (BNRBlockViewDrawer)theDrawBlock
{	//	__typeof__(self)
	BLKVIEW *view 	= [BLKVIEW.alloc initWithFrame:frame];
	[view setDBlock:theDrawBlock];
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
	[view setLBlock:ctxBlock];
	return view;
}

+ (BLKVIEW*) inView:(NSV*)v withFrame:(NSR)f inContext:(BNRBlockViewLayerDelegate)ctxBlock{
	
	BLKVIEW *blkV 	= [self.alloc initWithFrame:v.bounds];
	blkV.arMASK = NSSIZEABLE;
	BOOL hasLayer = (v.layer != nil);	
	[blkV setupHostView];	
//	if (!hasLayer)  [v setupHostView];
	blkV.layer.needsDisplayOnBoundsChange = YES;
	CAL*l = CAL.layer;
	l.arMASK = kCALayerNotSizable;
	l.frame = f;
	[blkV.layer addSublayer:l]; 
	l.arMASK 			= CASIZEABLE;
	CABlockDelegate *d = [CABlockDelegate delegateFor:l ofType:CABlockTypeDrawBlock withBlock: ^(CAL* layer,CGContextRef ref){
		[NSGraphicsContext drawInContext:ref flipped:NO actions:^{
			NSLog(@"drawing in blockview block delegate context: %@", AZString(layer.frame));
			ctxBlock(blkV, layer);
		}];
	}];
	[v addSubview:blkV];
	return blkV;
}


- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx 
{
	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
		if (_lBlock) self.lBlock(self, layer);
		if (_dBlock) self.dBlock(self, layer.bounds);
	}];
}

- (void)drawRect:(NSRect)dirtyRect { if (_dBlock) self.dBlock(self, dirtyRect); }
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
