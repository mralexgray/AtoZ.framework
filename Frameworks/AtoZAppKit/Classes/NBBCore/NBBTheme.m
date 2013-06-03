/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <QuartzCore/QuartzCore.h>

#import "NBBTheme.h"

@implementation NBBTheme

- (void)dealloc
{
    self.identifier = nil;
	self.prefrences = nil;
//    [super dealloc];
}

- (NSFont*)smallFont
{
	return [NSFont controlContentFontOfSize:14.0];
}

- (NSFont*)normalFont
{
	return [NSFont controlContentFontOfSize:24.0];
}

- (NSFont*)largeFont
{
	return [NSFont controlContentFontOfSize:32.0];
}

- (NSColor*)textColor
{
	return [NSColor textColor];
}

- (NSColor*)cellForegroundColor
{
	return [NSColor controlTextColor];
}

- (NSColor*)labelForegroundColor
{
	return self.textColor;
}

- (NSColor*)cellBackgroundColor
{
	return [NSColor controlBackgroundColor];
}
- (NSColor*)labelBackgroundColor
{
	return [NSColor clearColor];
}

- (NSColor*)highlightColor
{
	return [NSColor highlightColor];
}

- (NSColor*)windowBackgroundColor
{
	return [NSColor windowBackgroundColor];
}

- (CAAnimation*)windowInAnimation
{
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"frameOrigin"];
	// assumes all windows are the same size.
	NSWindow* keyWin = [NSApp keyWindow];
	NSPoint fromPoint = NSMakePoint(0.0, NSHeight(keyWin.frame));
	animation.fromValue = [NSValue valueWithPoint:fromPoint];
	animation.toValue = [NSValue valueWithPoint:NSZeroPoint];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	animation.duration = 0.5;
	animation.repeatCount = 1.0;
	[animation setValue:NSAnimationTriggerOrderIn forKey:@"animationType"];

	return animation;
}

- (CAAnimation*)windowOutAnimation
{
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"frameOrigin"];
	// assumes all windows are the same size.
	NSWindow* keyWin = [NSApp keyWindow];
	NSPoint toPoint = NSMakePoint(0.0, NSHeight(keyWin.frame));
	animation.toValue = [NSValue valueWithPoint:toPoint];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	animation.duration = 0.5;
	animation.repeatCount = 1.0;
	[animation setValue:NSAnimationTriggerOrderOut forKey:@"animationType"];

	return animation;
}

// combination for font, color and alignment
- (NSDictionary*)cellTextAttributes
{
	NSMutableParagraphStyle* ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];//autorelease];
	ps.alignment = NSCenterTextAlignment;
	return @{ NSForegroundColorAttributeName : [self cellForegroundColor],
			  NSFontAttributeName : [self normalFont],
			  NSParagraphStyleAttributeName : ps};
}

- (NSDictionary*)labelTextAttributes
{
	NSMutableParagraphStyle* ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy] ;//autorelease];
	ps.alignment = NSCenterTextAlignment;
	return @{ NSForegroundColorAttributeName : [self labelForegroundColor],
			  NSFontAttributeName : [self normalFont],
			  NSParagraphStyleAttributeName : ps};
}

- (NSColor*)foregroundColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object
{
	if ([object isKindOfClass:[NSTextField class]]) {
		return self.labelForegroundColor;
	}
	if ([object isKindOfClass:[NSControl class]]) {
		return self.cellForegroundColor;
	}
	return self.textColor;
}

- (NSColor*)backgroundColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object
{
	if ([object isKindOfClass:[NSTextField class]]) {
		return self.labelBackgroundColor;
	}
	if ([object isKindOfClass:[NSControl class]]) {
		return self.cellBackgroundColor;
	}
	return [NSColor clearColor];
}

- (NSColor*)borderColorForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object
{
	if ([object isKindOfClass:[NSWindow class]]) {
		return [NSColor windowFrameColor];
	}
	return [NSColor gridColor];
}

- (CGFloat)borderWidthForObject:(id <NSUserInterfaceItemIdentification, NSObject>) object
{
	return 2.0;
}

- (NSRect)frameForObject:(NSView*) view
{
	return view.frame;
}

// default theme preferences should supply the frames for controls
// if the theme wishes controls to have a layout diffrent from NIB
// you can also override any application default preference
- (NSDictionary*)defaultThemePrefrences
{
	return @{};
}

@end
