/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NBBWindow.h"
#import "NBBThemeEngine.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

// Part of the window theming hack
@class NSNextStepFrame;
@interface NBBWindow()
- (void)drawRect:(NSRect)rect;
- (NSWindow*)window;
@end

struct _frFlags {
    unsigned int defeatTitleWrap:1;
    unsigned int resizeByIncrement:1;
    unsigned int RESERVED:30;
};


@interface NSNextStepFrame : NSView
{
    NSTextFieldCell*    titleCell;
    NSButton*           closeButton;
    NSButton*           minimizeButton;
    unsigned int        styleMask;
    struct _frFlags     fvFlags;
//    struct _NSSize      sizingParams;
}
@end

@interface NSNextStepFrame (appearance)
- (float)contentAlpha;
@end

@implementation NBBWindow

+ (void)load
{
	Class frameClass = [NSNextStepFrame class];
	Method m0 = class_getInstanceMethod(self, @selector(drawFrame:));
	class_addMethod(frameClass, @selector(drawFrame:), method_getImplementation(m0), method_getTypeEncoding(m0));

	Method m1 = class_getInstanceMethod(frameClass, @selector(drawRect:));
	Method m2 = class_getInstanceMethod(frameClass, @selector(drawFrame:));

	method_exchangeImplementations(m1, m2);
}

- (void)drawFrame:(NSRect)rect
{
	[self drawFrame:rect];

	if ([self.window conformsToProtocol:@protocol(NBBThemable)]) {
		NBBTheme* theme = [[NBBThemeEngine sharedThemeEngine] theme];
		NSRect frameRect = [self frame];

		NSBezierPath* border = [NSBezierPath bezierPathWithRect:frameRect];
		[border setLineWidth:[theme borderWidthForObject:self.window] * self.window.screen.backingScaleFactor];
		[[theme borderColorForObject:self.window] set];
		[border stroke];
	}
}

- (void)finalizeInit
{
	[super finalizeInit];
	[[NBBThemeEngine sharedThemeEngine] themeObject:self];
}

- (BOOL)applyTheme:(NBBTheme*) theme
{
	self.backgroundColor = theme.windowBackgroundColor;

	return YES;
}

- (void)orderBack:(id)sender
{
	[self orderOut:sender];
}

- (void)orderOut:(id)sender
{
	// actual order out takes place on animation completion.
	[[self animator] setValue:nil forKey:NSAnimationTriggerOrderOut];
}

- (void)orderWindow:(NSWindowOrderingMode)orderingMode relativeTo:(NSInteger)otherWindowNumber
{
	// we set the animations here to keep them updated if they change
	// also default animations are based on the applications window size
	CAAnimation* inAnim = [[self theme] windowInAnimation];
	inAnim.delegate = self;
	CAAnimation* outAnim = [[self theme] windowOutAnimation];
	outAnim.delegate = self;

	[self setAnimations:@{ NSAnimationTriggerOrderIn  : inAnim,
						   NSAnimationTriggerOrderOut : outAnim,
						}];

	[super orderWindow:orderingMode relativeTo:otherWindowNumber];
	if (orderingMode == NSWindowAbove) {
		[[self animator] setValue:nil forKey:NSAnimationTriggerOrderIn];
	}
}

#pragma mark Animation Delegation
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (flag
		&& [[theAnimation valueForKey:@"animationType"] isEqualToString:NSAnimationTriggerOrderOut]) {
		[super orderOut:nil];
	}
}

@end
