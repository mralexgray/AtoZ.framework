//
//  MetalImageCell.m
//  Paparazzi!
//
//  Created by Wevah on 2005.08.08.
//  Copyright 2005 Derailer. All rights reserved.
//

#import "MetalUI.h"
#import <AtoZ/AtoZ.h>
@implementation MetalImageCell

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
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
		
		[AZGRAPHICSCTX setImageInterpolation:NSImageInterpolationHigh];
		[img drawInRect:imgRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
		[[NSColor colorWithCalibratedWhite:0.4 alpha:1.0] set];
		
		NSFrameRect(NSInsetRect(imgRect, -1.0, -1.0));
	}
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSRectEdge sides[] = {NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge, NSMinYEdge, NSMaxXEdge, NSMaxYEdge, NSMinXEdge};
	const CGF grays[] = {0.95, 0.9, 0.6, 0.9, 0.4, 0.4, 0.4, 0.4};
	NSRect rect = NSDrawTiledRects(cellFrame, cellFrame, sides, grays, 8);
	[[NSColor colorWithCalibratedWhite:0.95 alpha:1.0] set];
	NSRectFill(rect);
	[self drawInteriorWithFrame:rect inView:controlView];
}

@end



static const float kMaxDragImageDimension = 256.0;

@implementation MetalImageView

+ (Class)cellClass {
	return [MetalImageCell class];
}

- (void)awakeFromNib {
	[self setCell:[[MetalImageCell alloc] init]];
}

- (void)copy:(id)sender {
	NSImage *img = [self image];

	if (img) {
		NSPasteboard *pb = [NSPasteboard generalPasteboard];
		[pb declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:self];
		[pb setData:[[self image] TIFFRepresentation] forType:NSTIFFPboardType];
	}
}

- (void)setImage:(NSImage *)anImage {
	[self.enclosingScrollView.documentView setFrame:(NSRect){NSZeroPoint,anImage.size}];
	[super setImage:anImage];

	NSSize size = [anImage size];

	float width, height;

	if (kMaxDragImageDimension > size.width && kMaxDragImageDimension > size.height) {
		width = size.width;
		height = size.height;
	} else {
		float ratio = size.width > size.height ? kMaxDragImageDimension / size.width : kMaxDragImageDimension / size.height;
		width = floorf(ratio * size.width);
		height = floorf(ratio * size.height);
	}

	dragImage = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
	[dragImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[anImage drawInRect:NSMakeRect(0.0, 0.0, width, height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:0.8];
	[dragImage unlockFocus];
}

// Override mouseDown: cos NSImageView does something funky that blocks my mouseDragged:
// Mayhap I'll move to a custom view at some point, since I'm doing my own drawing anyway....
- (void)mouseDown:(NSEvent *)event {
	// nothing
}

- (void)mouseDragged:(NSEvent *)event {
	NSImage *img = [self image];

	if (img) {
		NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
		NSPoint p = [event locationInWindow];

		NSSize size = [dragImage size];

		p.x -= size.width / 2.0;
		p.y -= size.height / 2.0;

		[pb declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:self];
		[pb setData:[img TIFFRepresentation] forType:NSTIFFPboardType];

		[[self window] dragImage:dragImage at:p offset:NSZeroSize event:event pasteboard:pb source:self slideBack:YES];
	}
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
		return isLocal ?NSDragOperationNone : NSDragOperationCopy;
}

- (BOOL)validateMenuItem:(NSMenuItem*)item {
	return  ( ![self image] && [item action] == @selector(copy:))  ? NO : YES;
}

@end

@implementation MetalPopUpButtonCell

- (id)initTextCell: (NSString*) title pullsDown:(BOOL)pullsDown {
	if (self = [super initTextCell:title pullsDown:YES]) {
		[self setUsesItemFromMenu:NO];
		[self setBezelStyle:NSTexturedSquareBezelStyle];
		[self setArrowPosition:NSPopUpNoArrow];
	}

	return self;
}

- (void)setImage:(NSImage *)anImage {
	if (anImage) {
		NSMenuItem *item = [[NSMenuItem alloc] init];
		[item setImage:anImage];
		[item setOnStateImage:nil];
		[item setMixedStateImage:nil];
		[self setMenuItem:item];
		//		[item release];
	}
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[[self image] setFlipped:YES];
	[[self image] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

@end

@implementation MetalTextField

+ (Class)cellClass {
	return [MetalTextFieldCell class];
}

- (void)awakeFromNib {
	NSAttributedString *str = [self attributedStringValue];
	MetalTextFieldCell *cell = [[MetalTextFieldCell alloc] initTextCell:@""];
	[self setCell:cell];
	[self setAttributedStringValue:str];
}

@end



static NSShadow *bevel;

@implementation MetalTextFieldCell

- (id)initTextCell: (NSString*) string {
	self = [super initTextCell:string];
	
	return self;
}

+ (void)initialize {
	if (!bevel) {
		bevel = [[NSShadow alloc] init];
		[bevel setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]];
		[bevel setShadowOffset:NSMakeSize(0.0, -1.0)];
	}	
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[bevel set];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
