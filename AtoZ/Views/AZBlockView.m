
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



@implementation NSImage (AtoZDrawBlock)
+ (NSImage*)imageWithSize:(NSSZ)size drawnUsingBlock:(NSImageDrawer)drawBlock;
{
	NSImage *newer = [NSIMG.alloc initWithSize:size];
	[newer lockFocus];
	drawBlock();
	[newer unlockFocus];
	return newer;
//	if ([newer associatedValueForKey:@"dBlock"]) {NSImageDrawer d = [newer associatedValueForKey:@"dBlock"];	d(); }
//	[newer setAssociatedValue:drawBlock forKey:@"dBlock"];
}

@end


@implementation BNRBlockView
@synthesize drawBlock, opaque;

+ (BNRBlockView*) viewWithFrame: (NSRect)frame  opaque: (BOOL)opaque drawnUsingBlock:(BNRBlockViewDrawer)theDrawBlock
{	//	__typeof__(self)
	BNRBlockView *view = [[BNRBlockView alloc] initWithFrame:frame];
	[view setDrawBlock:theDrawBlock];
	[view setOpaque:opaque];
	return view;
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
