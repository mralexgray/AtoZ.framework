//
//  MetalImageCell.m
//  Paparazzi!
//
//  Created by Wevah on 2005.08.08.
//  Copyright 2005 Derailer. All rights reserved.
//

#import "MetalUI.h"


@implementation MetalImageCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSImage *img = [self image];
	
	if (img) {
		cellFrame = NSInsetRect(cellFrame, 4.0, 4.0);
		NSSize imgSize = [img size];
		NSRect imgRect;
		float width, height;
		
		if (cellFrame.size.width > imgSize.width && cellFrame.size.height > imgSize.height) {
			width = imgSize.width;
			height = imgSize.height;
		} else {
			float ratio = MIN(cellFrame.size.width / imgSize.width, cellFrame.size.height / imgSize.height);
			width = imgSize.width * ratio;
			height = imgSize.height * ratio;
		}
		
		imgRect = NSMakeRect(floorf((cellFrame.size.width - width) / 2.0) + cellFrame.origin.x, floorf((cellFrame.size.height - height) / 2.0) + cellFrame.origin.y, ceilf(width), ceilf(height));
		
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		[img drawInRect:imgRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
		[[NSColor colorWithCalibratedWhite:0.4 alpha:1.0] set];
		
		NSFrameRect(NSInsetRect(imgRect, -1.0, -1.0));
	}
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSRectEdge sides[] = {NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge, NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge};
	float grays[] = {0.95, 0.9, 0.6, 0.9, 0.4, 0.4, 0.4, 0.4};
	NSRect rect = NSDrawTiledRects(cellFrame, cellFrame, sides, grays, 8);
	[[NSColor colorWithCalibratedWhite:0.95 alpha:1.0] set];
	NSRectFill(rect);
	[self drawInteriorWithFrame:rect inView:controlView];
}

@end
