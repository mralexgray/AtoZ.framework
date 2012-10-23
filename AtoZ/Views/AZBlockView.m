
//  AZBlockView.m
//  AtoZ

//  Created by Alex Gray on 6/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZBlockView.h"
#import "AtoZ.h"

//@implementation AZBlockView
//@synthesize drawBlock, opaque;
//+ (AZBlockView *)viewWithFrame:(NSRect)frame 
//                         opaque:(BOOL)opaque
//                drawnUsingBlock:(AZBlockViewDrawer)theDrawBlock
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
@synthesize drawBlock, opaque;

+ (BNRBlockView*) viewWithFrame: (NSRect)frame  opaque: (BOOL)opaque
				drawnUsingBlock:(BNRBlockViewDrawer)theDrawBlock
{
//	__typeof__(self)
	BNRBlockView *view = [[BNRBlockView alloc] initWithFrame:frame];
	[view setDrawBlock:theDrawBlock];
	[view setOpaque:opaque];
	return view;// autorelease];
}

- (void)drawRect:(NSRect)dirtyRect { if (drawBlock) drawBlock(self, dirtyRect); }

- (BOOL)isOpaque { 	return opaque;	}

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

//- (void)dealloc
//{
//	[drawBlock release];
//	[super dealloc];
//}

- (void)drawRect:(NSRect)dirtyRect {
	if (drawBlock)
		drawBlock(self, dirtyRect);
}

- (BOOL)isOpaque {
	return opaque;
}

@end
