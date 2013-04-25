//
//  SNRHUDButtonCell.m
//  SNRHUDKit
//  Created by Indragie Karunaratne on 12-01-23.
//  Copyright (c) 2012 indragie.com. All rights reserved.

#import "SNRHUDButtonCell.h"

#define SNRButtonBlackGradientBottomColor		 		[NSC white: .15 a:1  ]
#define SNRButtonBlackGradientTopColor					[NSC white: .22 a:1  ]
#define SNRButtonBlackHighlightColor					[NSC white:1	a:.05]
#define SNRButtonBlueGradientBottomColor		  		[NSC r:0 g:.31 b:.78 a:1]
#define SNRButtonBlueGradientTopColor					[NSC r:0 g:.53 b:.87 a:1]
#define SNRButtonBlueHighlightColor				  		[NSC white:1	a:.25]

#define SNRButtonTextFont									[NSFont systemFontOfSize:11.f]
#define SNRButtonTextColor						   		WHITE
#define SNRButtonBlackTextShadowOffset					(NSSZ) { 0,  1 }
#define SNRButtonBlackTextShadowBlurRadius			1
#define SNRButtonBlackTextShadowColor					BLACK
#define SNRButtonBlueTextShadowOffset					(NSSZ) { 0, -1 }
#define SNRButtonBlueTextShadowBlurRadius		 		2
#define SNRButtonBlueTextShadowColor				 	[NSC white:0 a:.6]

#define SNRButtonDisabledAlpha					   	.7
#define SNRButtonCornerRadius								3
#define SNRButtonDropShadowColor					 		[NSC white:1 a:.05]
#define SNRButtonDropShadowBlurRadius					1
#define SNRButtonDropShadowOffset						(NSSZ) {  0, -1 }
#define SNRButtonBorderColor								BLACK
#define SNRButtonHighlightOverlayColor					[NSC white:0 a:.3]

#define SNRButtonCheckboxTextOffset				  		3
#define SNRButtonCheckboxCheckmarkColor		   	[NSC white:.78 a:1]
#define SNRButtonCheckboxCheckmarkLeftOffset	  		4
#define SNRButtonCheckboxCheckmarkTopOffset	   	1
#define SNRButtonCheckboxCheckmarkShadowOffset		(NSSZ) { 0, 0}
#define SNRButtonCheckboxCheckmarkShadowBlurRadius 3
#define SNRButtonCheckboxCheckmarkShadowColor	 	[NSC white:0 a:.75]
#define SNRButtonCheckboxCheckmarkLineWidth	   	2

static NSString* const SNRButtonReturnKeyEquivalent = @"\r";


@interface SNRHUDButtonCell ()
- (BOOL) snr_shouldDrawBlueButton;
- (void) snr_drawButtonBezelWithFrame:	 (NSR)frame inView:(NSV*)controlView;
- (void) snr_drawCheckboxBezelWithFrame:(NSR)frame inView:(NSV*)controlView;
- (NSR)  snr_drawButtonTitle:  (NSAS*)title 	withFrame:	 (NSR)frame inView:(NSV*)controlView;
- (NSR)  snr_drawCheckboxTitle:(NSAS*)title withFrame:	 (NSR)frame inView:(NSV*)controlView;
- (NSBP*)snr_checkmarkPathForRect:		 (NSR)rect mixed:  (BOOL)mixed;
@end

@implementation SNRHUDButtonCell 																{	NSBP *__bezelPath;	NSButtonType __buttonType;	}

-    (id) initWithCoder:  	(NSCoder*)aDecoder												{

	if ((self = [super initWithCoder:aDecoder])) {
		__buttonType = (NSButtonType)[[self valueForKey:@"buttonType"] unsignedIntegerValue];
		  _on 			= [NSC colorFromHexRGB:	  [self valueForKey:@"on"]] ?: RED;
		  _off 			= [NSC colorFromHexRGB:  [self valueForKey:@"off"]] ?: YELLOw;
		  _mixed			= [NSC colorFromHexRGB:[self valueForKey:@"mixed"]] ?: ORANGE;
	}
	return self;
}
-  (void) encodeWithCoder:	(NSCoder*)aCoder 													{

	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:self.on.toHex 		   forKey:@"on"];
	[aCoder encodeObject:self.off.toHex 	  forKey:@"off"];
	[aCoder encodeObject:self.mixed.toHex 	forKey:@"mixed"];
}
-  (void) setButtonType:	(NSButtonType)aType												{	__buttonType = aType;	[super setButtonType:aType];	}
-  (void) drawWithFrame:		 			  (NSR)cF inView: (NSV*)cV						{

	if (!self.isEnabled) CGContextSetAlpha(NSGraphicsContext.currentContext.graphicsPort, SNRButtonDisabledAlpha);
	[super drawWithFrame:cF inView:cV];
	if (__bezelPath && self.isHighlighted) [__bezelPath fillWithColor:self.on ?: SNRButtonHighlightOverlayColor];
}
-  (void) drawBezelWithFrame:				  (NSR)f  inView: (NSV*)cV						{ [self snr_drawButtonBezelWithFrame:f inView:cV]; }
-   (NSR) drawTitle:(NSAS*)t  withFrame: (NSR)f  inView: (NSV*)cV						{

	 return __buttonType == NSSwitchButton ? 	[self snr_drawCheckboxTitle:t withFrame:f inView:cV]
														:	[self snr_drawButtonTitle:t   withFrame:f inView:cV];
}
-  (void) drawImage:(NSIMG*)i withFrame: (NSR)f  inView: (NSV*)cV						{

	__buttonType == NSSwitchButton ?	[self snr_drawCheckboxBezelWithFrame:f inView:cV] : nil;
}
//-  (BOOL) drawCheckBoxesShaded 																	{
//
//	BOOL shaded = NO;
//
//	if (_delegate != nil && [_delegate respondsToSelector:@selector(cellShouldDrawCheckBoxesShaded:)]) {
//		NSLog(@"shaded Delegate = %@", _delegate);
//		shaded = [_delegate cellShouldDrawCheckBoxesShaded:self];
//		NSLog(@"delegate says I %@ draw shaded!", shaded ? @"SHOULD" : @"SHOULD NOT");
//	}
//	return shaded;
//}
-  (void) snr_drawButtonBezelWithFrame:  (NSR)f  inView:	(NSV*)cV						{
	
	f = NSInsetRect(f, 0.5f, 0.5f);
	f.size.height -= SNRButtonDropShadowBlurRadius;
	__bezelPath = [NSBP bezierPathWithRoundedRect:f xRadius:SNRButtonCornerRadius yRadius:SNRButtonCornerRadius];
	BOOL blue = [self snr_shouldDrawBlueButton];
	BOOL shaded = YES;//[self drawCheckBoxesShaded];
	if (!shaded || blue) {
		// Draw the gradient fill
		[[NSG gradientFrom:blue ? SNRButtonBlueGradientBottomColor : SNRButtonBlackGradientBottomColor 
							 to:blue ? SNRButtonBlueGradientTopColor : SNRButtonBlackGradientTopColor]
		  drawInBezierPath:__bezelPath angle:270.f];
	} else {				//this is whats active!!
//		NSLog(@"just filled with: %@", self.on.nameOfColor);
		[[NSG gradientFrom:RED to:ORANGE ] /*self.on.brighter to:self.on.darker] */ drawInBezierPath:__bezelPath angle:270.f];
	}
//		NSIMG* oo = [NSIMG imageFromLockedFocusSize: lock:^NSImage *(NSImage *) {
//			}:__bezelPath.bounds.size lock:^NSImage *(NSImage *i) {
//			[[NSG gradientFrom:self.on.brighter to:self.on.darker]  drawInBezierPath:__bezelPath angle:270.f];
//			return LogAndReturn(i);	}];	[oo openInPreview];

	[NSGraphicsContext state:^{									// Draw the border and drop shadow
		[[NSSHDW  shadowWithColor:SNRButtonDropShadowColor offset:SNRButtonDropShadowOffset blurRadius:SNRButtonDropShadowBlurRadius]set];
		[__bezelPath strokeWithColor:SNRButtonBorderColor];
	}];
	// Draw the highlight line around the top edge of the pill
	// Outset the width of the rectangle by 0.5px so that the highlight "bleeds" around the rounded corners
	// Outset the height by 1px so that the line is drawn right below the border
	NSRect highlightRect = NSInsetRect(f, -0.5f, 1.f);
	// Make the height of the highlight rect something bigger than the bounds so that it won't show up on the bottom
	highlightRect.size.height *= 2.f;
	[NSGraphicsContext state:^{
		NSBP *highlightPath = [NSBP bezierPathWithRoundedRect:highlightRect cornerRadius:SNRButtonCornerRadius];
		[__bezelPath addClip];
		[highlightPath strokeWithColor:blue ? SNRButtonBlueHighlightColor : SNRButtonBlackHighlightColor];
	}];
}
-  (void) snr_drawCheckboxBezelWithFrame:(NSR)f  inView: (NSV*)cV						{
	// At this time the checkbox uses the same style as the black button so we can use that method to draw the background
	f.size.width 	-= 2.f;
	f.size.height 	-= 1.f;
	[self snr_drawButtonBezelWithFrame:f inView:cV];
	// Draw the checkmark itself
	if (self.state == NSOffState) 	return;

	NSBP *path 		= [[self snr_checkmarkPathForRect:f mixed:self.state == NSMixedState]stroked:SNRButtonCheckboxCheckmarkLineWidth];
	[SNRButtonCheckboxCheckmarkColor set];
	NSSHDW *shadow = [NSSHDW  shadowWithColor:SNRButtonCheckboxCheckmarkShadowColor 
												  offset:SNRButtonCheckboxCheckmarkShadowOffset
											 blurRadius:SNRButtonCheckboxCheckmarkShadowBlurRadius];
	[NSGraphicsContext state:^{	[shadow set];	[path stroke];		}];
}
- (NSBP*) snr_checkmarkPathForRect:		  (NSR)rect mixed:(BOOL)mixed					{

	NSBP *path = [NSBP bezierPath];
	if (mixed) {
		NSP left 	= NSMakePoint(rect.origin.x + SNRButtonCheckboxCheckmarkLeftOffset, round(NSMidY(rect)));
		NSP right 	= NSMakePoint(NSMaxX(rect) - SNRButtonCheckboxCheckmarkLeftOffset, left.y);
		[path moveToPoint:left];
		[path lineToPoint:right];
	} else {
		NSP top 		= NSMakePoint(NSMaxX(rect), rect.origin.y);
		NSP bottom 	= NSMakePoint(round(NSMidX(rect)), round(NSMidY(rect)) + SNRButtonCheckboxCheckmarkTopOffset);
		NSP left 	= NSMakePoint(rect.origin.x + SNRButtonCheckboxCheckmarkLeftOffset, round(bottom.y / 2.f));
		[path moveToPoint:top];
		[path lineToPoint:bottom];
		[path lineToPoint:left];
	}
	return path;
}

-   (NSR) snr_drawButtonTitle:  (NSAS*)title withFrame:  (NSR)f inView:(NSV*)cV	{

	BOOL blue 				= [self snr_shouldDrawBlueButton];
	NSSHDW *textShadow	= [NSSHDW shadowWithColor:blue ?      SNRButtonBlueTextShadowColor : SNRButtonBlackTextShadowColor 
														 offset:blue ?     SNRButtonBlueTextShadowOffset : SNRButtonBlackTextShadowOffset
													blurRadius:blue ? SNRButtonBlueTextShadowBlurRadius : SNRButtonBlackTextShadowBlurRadius];

	NSAS *attrLabel = [NSAS stringWithString:title.string attributes:@{ NSFontAttributeName : SNRButtonTextFont,
																		  	   NSForegroundColorAttributeName : SNRButtonTextColor, 
																		               NSShadowAttributeName : textShadow}];
	NSSize labelSize = attrLabel.size;
	NSRect labelRect = NSMakeRect(	NSMidX(f) - (labelSize.width / 2.f), 
												NSMidY(f) - (labelSize.height / 2.f), labelSize.width, labelSize.height);
	[attrLabel drawInRect:NSIntegralRect(labelRect)];
	return labelRect;
}
-   (NSR) snr_drawCheckboxTitle:(NSAS*)title withFrame:  (NSR)f inView:(NSV*)cV	{

	NSSHDW *textShadow 	= [NSSHDW shadowWithColor:SNRButtonBlackTextShadowColor 
								  					    offset:SNRButtonBlackTextShadowOffset 
												   blurRadius:SNRButtonBlackTextShadowBlurRadius];
 	NSAS *attrLabel 		= [NSAS stringWithString:title.string attributes:	@{	NSFontAttributeName : SNRButtonTextFont, 
																						 NSForegroundColorAttributeName : SNRButtonTextColor,
																						          NSShadowAttributeName : textShadow}];
	NSSize labelSize = attrLabel.size;
	NSRect labelRect = NSMakeRect(	f.origin.x + SNRButtonCheckboxTextOffset, 
												NSMidY(f) - (labelSize.height / 2.f), 
												labelSize.width, labelSize.height);
	[attrLabel drawInRect:NSIntegralRect(labelRect)];
	return labelRect;
}
#pragma mark - Private
-  (BOOL) snr_shouldDrawBlueButton																{
	return [[self keyEquivalent] isEqualToString:SNRButtonReturnKeyEquivalent] && (__buttonType != NSSwitchButton);
}
@end
