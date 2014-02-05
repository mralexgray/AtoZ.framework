//
//  AZButton.m
//  AtoZ
//
#import "AZButton.h"
#import "AtoZ.h"

#define AZButtonBlackGradientBottomColor		 [NSColor colorWithDeviceWhite:0.150 alpha:1.000]
#define AZButtonBlackGradientTopColor			[NSColor colorWithDeviceWhite:0.220 alpha:1.000]
#define AZButtonBlackHighlightColor			  [NSColor colorWithDeviceWhite:1.000 alpha:0.050]
#define AZButtonBlueGradientBottomColor		  [NSColor colorWithDeviceRed:0.000 green:0.310 blue:0.780 alpha:1.000]
#define AZButtonBlueGradientTopColor			 [NSColor colorWithDeviceRed:0.000 green:0.530 blue:0.870 alpha:1.000]
#define AZButtonBlueHighlightColor			   [NSColor colorWithDeviceWhite:1.000 alpha:0.250]

#define AZButtonGreenGradientBottomColor		  [NSColor colorWithDeviceRed:0.000 green:1 blue:0 alpha:1.000]
#define AZButtonGreenGradientTopColor			 [NSColor colorWithDeviceRed:0.000 green:.5 blue:0 alpha:1.000]
#define AZButtonGreenHighlightColor			   [NSColor colorWithDeviceWhite:1.000 alpha:0.250]

#define AZButtonTextFont						 [NSFont systemFontOfSize:11.f]
#define AZButtonTextColor						[NSColor whiteColor]
#define AZButtonBlackTextShadowOffset			NSMakeSize(0.f, 1.f)
#define AZButtonBlackTextShadowBlurRadius		1.f
#define AZButtonBlackTextShadowColor			 [NSColor blackColor]
#define AZButtonBlueTextShadowOffset			 NSMakeSize(0.f, -1.f)
#define AZButtonBlueTextShadowBlurRadius		 2.f
#define AZButtonBlueTextShadowColor			  [NSColor colorWithDeviceWhite:0.000 alpha:0.600]

#define AZButtonDisabledAlpha					0.7f
#define AZButtonCornerRadius					 3.f
#define AZButtonDropShadowColor				  [NSColor colorWithDeviceWhite:1.000 alpha:0.050]
#define AZButtonDropShadowBlurRadius			 1.f
#define AZButtonDropShadowOffset				 NSMakeSize(0.f, -1.f)
#define AZButtonBorderColor					  [NSColor blackColor]
#define AZButtonHighlightOverlayColor			[NSColor colorWithDeviceWhite:0.000 alpha:0.300]

#define AZButtonCheckboxTextOffset			   3.f
#define AZButtonCheckboxCheckmarkColor		   [NSColor colorWithDeviceWhite:0.780 alpha:1.000]
#define AZButtonCheckboxCheckmarkLeftOffset	  4.f
#define AZButtonCheckboxCheckmarkTopOffset	   1.f
#define AZButtonCheckboxCheckmarkShadowOffset	NSMakeSize(0.f, 0.f)
#define AZButtonCheckboxCheckmarkShadowBlurRadius 3.f
#define AZButtonCheckboxCheckmarkShadowColor	 [NSColor colorWithDeviceWhite:0.000 alpha:0.750]
#define AZButtonCheckboxCheckmarkLineWidth	   2.f

static NSString* const AZButtonReturnKeyEquivalent = @"\r";

@interface AZButtonCell ()
//- (BOOL)az_shouldDrawBlueButton;
//- (BOOL)az_shouldDrawGreenButton;
- (void)az_drawButtonBezelWithFrame:(NSRect)frame inView:(NSView*)controlView;
- (void)az_drawCheckboxBezelWithFrame:(NSRect)frame inView:(NSView*)controlView;
- (NSRect)az_drawButtonTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView;
- (NSRect)az_drawCheckboxTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView;
- (NSBezierPath *)az_checkmarkPathForRect:(NSRect)rect mixed:(BOOL)mixed;

@end

@implementation AZButtonCell 
{  
	NSBezierPath *__bezelPath;	
	NSButtonType __buttonType;
}
@synthesize color, isTopTab;

- (id)   initWithCoder:			(NSCoder*) aDecoder { if ((self = [super initWithCoder:aDecoder])) {
	__buttonType = (NSButtonType)[[self valueForKey:@"buttonType"] unsignedIntegerValue]; } return self;
}
- (void) setButtonType:			(NSButtonType) aType {	__buttonType = aType;	[super setButtonType:aType]; }
- (void) drawWithFrame:			(NSRect) cellFrame 	inView:(NSView*) controlView {
	if (![self isEnabled])
		CGContextSetAlpha([AZGRAPHICSCTX graphicsPort], AZButtonDisabledAlpha);
	[super drawWithFrame:cellFrame inView:controlView];
	if (__bezelPath && [self isHighlighted]) { [color set]; [__bezelPath fill]; }
}
- (void) drawBezelWithFrame:		(NSRect) frame 		inView:(NSView*) controlView {
	[self az_drawButtonBezelWithFrame:frame inView:controlView]; 
}
- (NSRect)drawTitle: (NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView *)controlView {
	switch (__buttonType) {
		case NSSwitchButton:
			return [self az_drawCheckboxTitle:title withFrame:frame inView:controlView]; 	break;
		default:
			return [self az_drawButtonTitle:title withFrame:frame inView:controlView];		break;
	}
}
- (void)  drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView {
	if (__buttonType == NSSwitchButton) [self az_drawCheckboxBezelWithFrame:frame inView:controlView];
}
- (void)  az_drawButtonBezelWithFrame:(NSRect)frame inView:(NSView*)controlView {
	
	if (!isTopTab)  frame = NSInsetRect(frame, 0.5f, 0.5f);
	frame.size.height -= AZButtonDropShadowBlurRadius;
	BOOL custom = TRUE;
//	self.buttonColor = (!self.buttonColor ? RANDOMCOLOR : self.buttonColor);
	__bezelPath =  (!isTopTab ? 
					[NSBezierPath bezierPathWithRoundedRect:frame xRadius:AZButtonCornerRadius yRadius:AZButtonCornerRadius ] :
					[NSBezierPath bezierPathWithRoundedRect:frame cornerRadius:AZButtonCornerRadius inCorners:OSBottomLeftCorner|OSBottomRightCorner]);
	
	NSGradient *gradientFill = [[NSGradient alloc]initWithColors:$array(color.darker.darker, color.brighter.brighter)];
	[gradientFill drawInBezierPath:__bezelPath angle:270.f];
	// Draw the border and drop shadow
	[NSGraphicsContext saveGraphicsState];
	[AZButtonBorderColor set];
	NSShadow *dropShadow = [NSShadow new];
	[dropShadow setShadowColor:AZButtonDropShadowColor];
	[dropShadow setShadowBlurRadius:AZButtonDropShadowBlurRadius];
	[dropShadow setShadowOffset:AZButtonDropShadowOffset];
	[dropShadow set];
	[__bezelPath stroke];
	[NSGraphicsContext restoreGraphicsState];
	// Draw the highlight line around the top edge of the pill
	// Outset the width of the rectangle by 0.5px so that the highlight "bleeds" around the rounded corners
	// Outset the height by 1px so that the line is drawn right below the border
	NSRect highlightRect = NSInsetRect(frame, -0.5f, 1.f);
	// Make the height of the highlight rect something bigger than the bounds so that it won't show up on the bottom
	highlightRect.size.height *= 2.f;
	[NSGraphicsContext saveGraphicsState];
	NSBezierPath *highlightPath = (!isTopTab ?
								   [NSBezierPath bezierPathWithRoundedRect:highlightRect xRadius:AZButtonCornerRadius yRadius:AZButtonCornerRadius] :
								   [NSBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:AZButtonCornerRadius inCorners:OSBottomLeftCorner|OSBottomRightCorner]);
	
	[__bezelPath addClip];
	//	[GREEN set]; //	[blue ? AZButtonBlueHighlightColor : AZButtonBlackHighlightColor set];
	[highlightPath stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	/**
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
	 self.buttonColor = RED;
	 NSGradient *backgroundGradient = [NSGradient.alloc initWithColorsAndLocations:
	 //			[[[buttonColor darker] darker]darker]
	 BLACK, 0,
	 [[buttonColor darker] darker], .12,
	 [buttonColor darker], .5,
	 buttonColor, .5,
	 [buttonColor brighter], .9,
	 WHITE, 1,nil];
	 //			[[buttonColor brighter]brighter],1, nil];
	 //			[NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f, 
	 //			[NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f, 
	 //										  [NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f, 
	 //										  [NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f, 
	 //										  [NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f, 
	 //										  [NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f, 
	 //										  nil];
	 
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
	 //		NSColor *highlight = [RANDOMCOLOR colorWithAlphaComponent:.5];
	 [[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
	 //		[highlight setFill];
	 NSRectFillUsingOperation(frame, NSCompositeSourceOver);
	 [ctx restoreGraphicsState];
	 }
	 }
	 **/
}

- (void)az_drawCheckboxBezelWithFrame:(NSRect)frame inView:(NSView*)controlView
{
	// At this time the checkbox uses the same style as the black button so we can use that method to draw the background
	frame.size.width -= 2.f;
	frame.size.height -= 1.f;
	[self az_drawButtonBezelWithFrame:frame inView:controlView];
	// Draw the checkmark itself
	if ([self state] == NSOffState) { return; }
	NSBezierPath *path = [self az_checkmarkPathForRect:frame mixed:[self state] == NSMixedState];
	[path setLineWidth:AZButtonCheckboxCheckmarkLineWidth];
	[AZButtonCheckboxCheckmarkColor set];
	NSShadow *shadow = [NSShadow new];
	[shadow setShadowColor:AZButtonCheckboxCheckmarkShadowColor];
	[shadow setShadowBlurRadius:AZButtonCheckboxCheckmarkShadowBlurRadius];
	[shadow setShadowOffset:AZButtonCheckboxCheckmarkShadowOffset];
	[NSGraphicsContext saveGraphicsState];
	[shadow set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
}

- (NSBezierPath *)az_checkmarkPathForRect:(NSRect)rect mixed:(BOOL)mixed
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	if (mixed) {
		NSPoint left = NSMakePoint(rect.origin.x + AZButtonCheckboxCheckmarkLeftOffset, round(NSMidY(rect)));
		NSPoint right = NSMakePoint(NSMaxX(rect) - AZButtonCheckboxCheckmarkLeftOffset, left.y);
		[path moveToPoint:left];
		[path lineToPoint:right];
	} else {
		NSPoint top = NSMakePoint(NSMaxX(rect), rect.origin.y);
		NSPoint bottom = NSMakePoint(round(NSMidX(rect)), round(NSMidY(rect)) + AZButtonCheckboxCheckmarkTopOffset);
		NSPoint left = NSMakePoint(rect.origin.x + AZButtonCheckboxCheckmarkLeftOffset, round(bottom.y / 2.f));
		[path moveToPoint:top];
		[path lineToPoint:bottom];
		[path lineToPoint:left];
	}
	return path;
}

- (NSRect)az_drawButtonTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView {
	NSColor *contrasting = [color contrastingForegroundColor];
	BOOL blue = [self az_shouldDrawBlueButton];
	NSString *label = [title string];
	NSShadow *textShadow = [NSShadow new];
	[textShadow setShadowOffset:blue ? AZButtonBlueTextShadowOffset : AZButtonBlackTextShadowOffset];
	//	[textShadow setShadowColor:[contrasting isDark] ? [NSColor whiteColor] : [NSColor blackColor]]; AZButtonBlueTextShadowColor : AZButtonBlackTextShadowColor];
	[textShadow setShadowBlurRadius:blue ? AZButtonBlueTextShadowBlurRadius : AZButtonBlackTextShadowBlurRadius];
	NSDictionary *attributes = @{NSFontAttributeName: AZButtonTextFont, NSForegroundColorAttributeName: contrasting, NSShadowAttributeName: textShadow};
	NSAttributedString *attrLabel = [NSAttributedString.alloc initWithString:label attributes:attributes];
	NSSize labelSize = attrLabel.size;
	NSRect labelRect = NSMakeRect(NSMidX(frame) - (labelSize.width / 2.f), NSMidY(frame) - (labelSize.height / 2.f), labelSize.width, labelSize.height);
	[attrLabel drawInRect:NSIntegralRect(labelRect)];
	return labelRect;
	
	/**
	 //	NSLog(@"Strtig keys %@",[title attributeKeys]);
	 NSColor *contrasting = WHITE;
	 // [buttonColor contrastingForegroundColor];
	 
	 //	BOOL blue = [self az_shouldDrawBlueButton];
	 NSString *label = [title string];
	 NSShadow *textShadow = [NSShadow new];
	 //	[textShadow setShadowOffset:blue ? AZButtonBlueTextShadowOffset : AZButtonBlackTextShadowOffset];
	 textShadow.shadowColor = ([contrasting isDark] ? WHITE : BLACK);
	 NSFont *buttonFont = [NSFont fontWithName:@"Ubuntu Mono Bold" size:12.0];
	 
	 NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:buttonFont, NSFontAttributeName, contrasting, NSForegroundColorAttributeName, textShadow, NSShadowAttributeName, nil];
	 NSAttributedString *attrLabel = [NSAttributedString.alloc initWithString:label attributes:attributes];
	 NSSize labelSize = title.size;
	 NSRect labelRect = NSMakeRect(NSMidX(frame) - (labelSize.width / 2.f), NSMidY(frame) - (labelSize.height / 2.f), labelSize.width, labelSize.height);
	 [attrLabel drawInRect: frame];
	 //	NSIntegralRect(labelRect)];
	 
	 return labelRect;
	 **/
}

- (NSRect)az_drawCheckboxTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView
{
	NSString *label = [title string];
	NSShadow *textShadow = [NSShadow new];
	[textShadow setShadowOffset:AZButtonBlackTextShadowOffset];
	[textShadow setShadowColor:AZButtonBlackTextShadowColor];
	[textShadow setShadowBlurRadius:AZButtonBlackTextShadowBlurRadius];
	NSDictionary *attributes = @{NSFontAttributeName: AZButtonTextFont, NSForegroundColorAttributeName: AZButtonTextColor, NSShadowAttributeName: textShadow};
	NSAttributedString *attrLabel = [NSAttributedString.alloc initWithString:label attributes:attributes];
	NSSize labelSize = attrLabel.size;
	NSRect labelRect = NSMakeRect(frame.origin.x + AZButtonCheckboxTextOffset, NSMidY(frame) - (labelSize.height / 2.f), labelSize.width, labelSize.height);
	[attrLabel drawInRect:NSIntegralRect(labelRect)];
	return labelRect;
}

#pragma mark - Private

- (BOOL)az_shouldDrawBlueButton
{
	return FALSE;// [[self keyEquivalent] isEqualToString:AZButtonReturnKeyEquivalent] && (__buttonType != NSSwitchButton);
}

-(NSColor*) color {
	return (!color ? BLUE : color);
}

//- (void)az_drawButtonBezelWithFrame:(NSRect)frame inView:(NSView*)controlView
//{
//	frame = NSInsetRect(frame, 0.5f, 0.5f);
//	frame.size.height -= AZButtonDropShadowBlurRadius;
//	BOOL blue = [self az_shouldDrawBlueButton];
////	BOOL green = [self az_shouldDrawGreenButton];
//	BOOL custom = TRUE; //( buttonColor == nil );
//	__bezelPath = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:AZButtonCornerRadius yRadius:AZButtonCornerRadius];
//	NSGradient *gradientFill = [NSGradient.alloc //	initWithStartingColor: 	blue ? AZButtonGreenGradientBottomColor : 
//						   	custom ? [[buttonColor darker]darker] : AZButtonBlackGradientBottomColor
//	endingColor:			blue ? AZButtonGreenGradientTopColor : 
//							custom ? buttonColor : AZButtonBlackGradientTopColor];
//	// Draw the gradient fill
//	[gradientFill drawInBezierPath:__bezelPath angle:270.f];
//	// Draw the border and drop shadow
//	[NSGraphicsContext saveGraphicsState];
//	[AZButtonBorderColor set];
//	NSShadow *dropShadow = [NSShadow new];
//	[dropShadow setShadowColor:AZButtonDropShadowColor];
//	[dropShadow setShadowBlurRadius:AZButtonDropShadowBlurRadius];
//	[dropShadow setShadowOffset:AZButtonDropShadowOffset];
//	[dropShadow set];
//	[__bezelPath stroke];
//	[NSGraphicsContext restoreGraphicsState];
//	// Draw the highlight line around the top edge of the pill
//	// Outset the width of the rectangle by 0.5px so that the highlight "bleeds" around the rounded corners
//	// Outset the height by 1px so that the line is drawn right below the border
//	NSRect highlightRect = NSInsetRect(frame, -0.5f, 1.f);
//	// Make the height of the highlight rect something bigger than the bounds so that it won't show up on the bottom
//	highlightRect.size.height *= 2.f;
//	[NSGraphicsContext saveGraphicsState];
//	NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:highlightRect xRadius:AZButtonCornerRadius yRadius:AZButtonCornerRadius];
//	[__bezelPath addClip];
//	[blue ? AZButtonBlueHighlightColor : AZButtonBlackHighlightColor set];
//	[highlightPath stroke];
//	[NSGraphicsContext restoreGraphicsState];
//}
//
//- (void)az_drawCheckboxBezelWithFrame:(NSRect)frame inView:(NSView*)controlView
//{
//	// At this time the checkbox uses the same style as the black button so we can use that method to draw the background
//	frame.size.width -= 2.f;
//	frame.size.height -= 1.f;
//	[self az_drawButtonBezelWithFrame:frame inView:controlView];
//	// Draw the checkmark itself
//	if ([self state] == NSOffState) { return; }
//	NSBezierPath *path = [self az_checkmarkPathForRect:frame mixed:[self state] == NSMixedState];
//	[path setLineWidth:AZButtonCheckboxCheckmarkLineWidth];
//	[AZButtonCheckboxCheckmarkColor set];
//	NSShadow *shadow = [NSShadow new];
//	[shadow setShadowColor:AZButtonCheckboxCheckmarkShadowColor];
//	[shadow setShadowBlurRadius:AZButtonCheckboxCheckmarkShadowBlurRadius];
//	[shadow setShadowOffset:AZButtonCheckboxCheckmarkShadowOffset];
//	[NSGraphicsContext saveGraphicsState];
//	[shadow set];
//	[path stroke];
//	[NSGraphicsContext restoreGraphicsState];
//}
//
//- (NSBezierPath *)az_checkmarkPathForRect:(NSRect)rect mixed:(BOOL)mixed
//{
//	NSBezierPath *path = [NSBezierPath bezierPath];
//	if (mixed) {
//		NSPoint left = NSMakePoint(rect.origin.x + AZButtonCheckboxCheckmarkLeftOffset, round(NSMidY(rect)));
//		NSPoint right = NSMakePoint(NSMaxX(rect) - AZButtonCheckboxCheckmarkLeftOffset, left.y);
//		[path moveToPoint:left];
//		[path lineToPoint:right];
//	} else {
//		NSPoint top = NSMakePoint(NSMaxX(rect), rect.origin.y);
//		NSPoint bottom = NSMakePoint(round(NSMidX(rect)), round(NSMidY(rect)) + AZButtonCheckboxCheckmarkTopOffset);
//		NSPoint left = NSMakePoint(rect.origin.x + AZButtonCheckboxCheckmarkLeftOffset, round(bottom.y / 2.f));
//		[path moveToPoint:top];
//		[path lineToPoint:bottom];
//		[path lineToPoint:left];
//	}
//	return path;
//}
//

//- (NSRect)az_drawCheckboxTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSView*)controlView
//{
//	NSString *label = [title string];
//	NSShadow *textShadow = [NSShadow new];
//	[textShadow setShadowOffset:AZButtonBlackTextShadowOffset];
//	[textShadow setShadowColor:AZButtonBlackTextShadowColor];
//	[textShadow setShadowBlurRadius:AZButtonBlackTextShadowBlurRadius];
//	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:AZButtonTextFont, NSFontAttributeName, AZButtonTextColor, NSForegroundColorAttributeName, textShadow, NSShadowAttributeName, nil];
//	NSAttributedString *attrLabel = [NSAttributedString.alloc initWithString:label attributes:attributes];
//	NSSize labelSize = attrLabel.size;
//	NSRect labelRect = NSMakeRect(frame.origin.x + AZButtonCheckboxTextOffset, NSMidY(frame) - (labelSize.height / 2.f), labelSize.width, labelSize.height);
//	[attrLabel drawInRect:NSIntegralRect(labelRect)];
//	return labelRect;
//}

@end
@implementation AZButton{
	AZButtonCallback _inCallback;
	AZButtonCallback _outCallback;
}

- (void)setInCallback:(AZButtonCallback)block{ 		_inCallback = [block copy];	}

- (void)setOutCallback:(AZButtonCallback)block{	_outCallback = [block copy];	}

- (void)setInCallback:(AZButtonCallback)inBlock	   andOutCallback:(AZButtonCallback)outBlock{
	[self setInCallback:inBlock];
	[self setOutCallback:outBlock];
}

- (id)initWithFrame:(NSRect)frame{
	if((self = [super initWithFrame:frame]))
		[self addTrackingArea:[NSTrackingArea.alloc initWithRect:self.visibleRect options:NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways owner:self userInfo:nil]];
	return self;
}

- (void)mouseEntered:(NSEvent *)theEvent{  !(self.isEnabled && _inCallback) ?: _inCallback();  }

- (void)mouseExited:(NSEvent *)theEvent{ !_outCallback ?: _outCallback();	}
+ (Class)cellClass {
	return [AZButtonCell class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (![aDecoder isKindOfClass:[NSKeyedUnarchiver class]])
		return [super initWithCoder:aDecoder];
	NSKeyedUnarchiver *unarchiver = (NSKeyedUnarchiver *)aDecoder;
	Class oldClass = [[self superclass] cellClass];
	Class newClass = [[self class] cellClass];
	[unarchiver setClass:newClass forClassName:NSStringFromClass(oldClass)];
	self = [super initWithCoder:aDecoder];
	[unarchiver setClass:oldClass forClassName:NSStringFromClass(oldClass)];
	return self;
}

@end
