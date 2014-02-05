
#import "AZDarkButtonCell.h"
#import "AtoZ.h"

/**  Custom cells...  not directly related to Basemodel, etc... but you can see some ways to access the shared instance, etc */

@implementation AZPriorityClickCell

- (id) copyWithZone:(NSZone *)zone {

	AZPriorityClickCell* x = [super copyWithZone:zone];
	x.range = _range;
	x.block = _block;
	return x;
}
- (id) target 	{ return self; 					  }

- (SEL) action	{ return @selector( tickPriority ); }

- (void) tickPriority
{
	NSUInteger val = [objc_getAssociatedObject(self,_cmd) unsignedIntegerValue];
	val = val < AZRANGEMAX(_range) ? val + 1 : _range.location;
	 
//	((TodoItem*)TodoList.sharedInstance.items[((NSTableView*)self.controlView).selectedRow]).priority = @( val < 8 ? val + 1 : 0 );
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[NSColor.darkGrayColor set];
	NSRectFill ( cellFrame );
	NSString	*string = ((NSNumber*)self.objectValue).stringValue;
	NSDictionary *attrs = @{ NSFontAttributeName : [NSFont fontWithName:@"Lucida Grande Bold" size: cellFrame.size.height - 10], NSForegroundColorAttributeName : NSColor.whiteColor };
	NSSize   stringSize = [string sizeWithAttributes:attrs];
 	[string drawInRect: (NSRect) { NSMidX(cellFrame) - stringSize.width / 2, cellFrame.origin.y + 3, stringSize.width, stringSize.height } withAttributes:attrs];
}

@end

@implementation AZColorCell

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = (AZColorCell*)[super initWithCoder:aDecoder];
	if(self && [aDecoder containsValueForKey: @"colorForObjectValue"])
		self.colorForObjectValue = [aDecoder decodeObjectForKey: @"colorForObjectValue"];
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	[super encodeWithCoder: coder];
	[coder encodeObject: self.colorForObjectValue forKey: @"colorForObjectValue"];
}

-(id)copyWithZone:(NSZone *) zone {
	AZColorCell *copy = [super copyWithZone: zone];

	[copy setColorForObjectValue: [self colorForObjectValue]];
	return copy;
}
- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	return GREEN;
}
- (NSRect)drawingRectForBounds:(NSRect)theRect { return  theRect; }
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {	[_colorForObjectValue(self.objectValue) set];	NSRectFill(cellFrame); 
	[super drawWithFrame:cellFrame inView:controlView];
}

@end

@implementation AZDarkButtonCell

- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
	NSGraphicsContext *ctx = AZGRAPHICSCTX;
	CGContextRef contextRef = [ctx graphicsPort];

	NSData *data = [image TIFFRepresentation];
	CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
	if(source) {
		CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
		CFRelease(source);

		CGContextSaveGState(contextRef);
		{
			NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
			CGFloat white = [self isHighlighted] ? 0.2f : 0.35f;
			CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
			[[NSColor colorWithDeviceWhite:white alpha:1.0f] setFill];
			NSRectFill(rect);
		}
		CGContextRestoreGState(contextRef);

		CGContextSaveGState(contextRef);
		{
			NSRect rect = frame;
			CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
			[[NSColor colorWithDeviceWhite:0.1f alpha:1.0f] setFill];
			NSRectFill(rect);
		}
		CGContextRestoreGState(contextRef);

		CFRelease(imageRef);
	}
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	NSGraphicsContext *ctx = AZGRAPHICSCTX;

	CGFloat roundedRadius = 0.0f;

	BOOL outer = YES;
	BOOL background = YES;
	BOOL stroke = YES;
	BOOL innerStroke = YES;

	if(outer) {
		[ctx saveGraphicsState];
		NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:roundedRadius yRadius:roundedRadius];
		[outerClip setClip];

		NSGradient *outerGradient = [NSGradient.alloc initWithColorsAndLocations:
									 [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f,
									 [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f,
									 nil];

		[outerGradient drawInRect:[outerClip bounds] angle:90.0f];
		//		[outerGradient release];
		[ctx restoreGraphicsState];
	}

	if(background) {
		[ctx saveGraphicsState];
		NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:roundedRadius yRadius:roundedRadius];
		[backgroundPath setClip];

		NSGradient *backgroundGradient = [NSGradient.alloc initWithColorsAndLocations:
										  [NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f,
										  [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f,
										  [NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f,
										  [NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f,
										  [NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f,
										  [NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f,
										  nil];

		[backgroundGradient drawInRect:[backgroundPath bounds] angle:270.0f];
		//		[backgroundGradient release];
		[ctx restoreGraphicsState];
	}

	if(stroke) {
		[ctx saveGraphicsState];
		[[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f) xRadius:roundedRadius yRadius:roundedRadius] stroke];
		[ctx restoreGraphicsState];
	}

	if(innerStroke) {
		[ctx saveGraphicsState];
		[[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f) xRadius:roundedRadius yRadius:roundedRadius] stroke];
		[ctx restoreGraphicsState];
	}

	if([self isHighlighted]) {
		[ctx saveGraphicsState];
		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:roundedRadius yRadius:roundedRadius] setClip];
		[[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
		NSRectFillUsingOperation(frame, NSCompositeSourceOver);
		[ctx restoreGraphicsState];
	}
}

@end
