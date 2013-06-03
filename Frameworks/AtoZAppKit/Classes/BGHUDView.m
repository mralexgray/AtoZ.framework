
//  BGHUDView.m  BGHUDAppKit  Created by BinaryGod on 2/15/09.  Copyright 2009 none. All rights reserved.

#import "BGHUDView.h"

NSString *const RedrawContext = @"RedrawContext";

@implementation BGHUDView

//@synthesize flipGradient, drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder, borderColor, drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow, shadowColor, customGradient, themeKey, useTheme, color1, color2;

- (id)init {	return [self initWithFrame:NSMakeRect(0,0,100,100)]; }
//!= [super init] ? nil : ^{
//		_themeKey 		= @"gradientTheme";		_useTheme 		= 	_flipGradient 	= YES;
//		_borderColor 	= NSColor.blackColor;		_shadowColor 	= NSColor.blackColor;
//		_color1 			= NSColor.blackColor;		_color2 			= [NSColor colorWithCalibratedRed:0.804 green:0.426 blue:1.000 alpha:1.000];
//		return self;//	}();

- (id)initWithFrame:(NSRect)frame {
	if (self != [super initWithFrame:frame] ) return nil;
	_themeKey 		= @"AZFlatTheme";//@"gradientTheme";
//	_useTheme 		=  _flipGradient 	= YES;
	_borderColor 	= NSColor.blackColor;
	_shadowColor 	= NSColor.blackColor;
	_color1 			= NSColor.blackColor;
	_color2 		 	= [NSColor colorWithCalibratedRed:0.253 green:0.478 blue:0.761 alpha:1.000];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {  // This occurs, for realsies when using bghud.

	if (self != [super initWithCoder:aDecoder] ) return nil;
//	[@[@"themeKey", @"borderColor", @"shadowColor", @"color1"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[aCoder encodeObject:[self valueForKey:obj] forKey:obj]; }];
//	@"useTheme",
	[@[ @"flipGradient", @"drawTopBorder", @"drawBottomBorder", @"drawLeftBorder", @"drawRightBorder", 
		@"drawTopShadow", @"drawBottomShadow", @"drawLeftShadow", @"drawRightShadow"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self setValue:@([aDecoder decodeBoolForKey:obj]) forKey:obj]; }];

//		_useTheme         = YES;
//		_themeKey 			= [aDecoder containsValueForKey:			@"themeKey"]
//								? [aDecoder decodeObjectForKey:			@"themeKey"] :		@"atoz";	@"gradientTheme";
//		[aDecoder containsValueForKey:@"useTheme"]  ? [aDecoder decodeBoolForKey: @"useTheme"]
		_borderColor 		= [aDecoder decodeObjectForKey:     @"borderColor"] ? : NSColor.blackColor;
		_shadowColor 		= [aDecoder containsValueForKey:    @"shadowColor"] ?
								  [aDecoder decodeObjectForKey:     @"shadowColor"] : NSColor.blackColor;
		_color1 				= [aDecoder containsValueForKey:			  @"color1"] ?
								  [aDecoder decodeObjectForKey:			  @"color1"] : NSColor.blackColor;
		_color2				= [aDecoder containsValueForKey:			  @"color2"] ?
								  [aDecoder decodeObjectForKey:			  @"color2"] :
								  [NSColor colorWithCalibratedRed:0.851 green:0.723 blue:0.268 alpha:1.000];
								  
	[NCENTER addObserverForName:AZThemeDidUpdateNotification object:nil queue:NSOQMQ usingBlock:^(NSNotification *n) {	self.needsDisplay = YES; }];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {	 [super encodeWithCoder:aCoder];
	[@[@"themeKey", @"borderColor", @"shadowColor", @"color1"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[aCoder encodeObject:[self valueForKey:obj] forKey:obj]; }];
	[@[@"useTheme", @"flipGradient", @"drawTopBorder", @"drawBottomBorder", @"drawLeftBorder", @"drawRightBorder", 
		@"drawTopShadow", @"drawBottomShadow", @"drawLeftShadow", @"drawRightShadow"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[aCoder encodeBool:[[self valueForKey:obj]boolValue] forKey:obj]; }];
}
- (BGTheme *)theme {	return BGTHEME(self); }

- (void)drawRect:(NSRect)rect {
		[self.theme.normalGradient drawInRect:self.bounds angle:self.theme.gradientAngle];
		[self.theme.strokeColor set]; 														// self.theme.strokeColor set];
		NSFrameRect(self.bounds);
}
	
//- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	//    if ([object isEqualTo:_theme])
//	[keyPath isEqualToString : @"theme"] 
////		&& context == &RedrawContext 
//		? NSLog(@"context:%@ triggered needsDisplay", context), [self setNeedsDisplay:YES] : NSLog(@"did not redraw themese change due to something.. ctx: %@", context);
//}

	
//	  = BGThemeManager.keyedManager.activeTheme ?:
//		[BGThemeManager.keyedManager themeForKey:_themeKey] ?:
//		[BGThemeManager.keyedManager themeForKey:@"AZFlatTheme"];
//}
//	if (_theme) return NSLog(@"reusing theme...%@", _theme), _theme;
//	else if (_themeKey) _theme = [BGThemeManager.keyedManager themeForKey:_themeKey], NSLog(@"using theme:%@ for _themeKey: %@", _theme, _themeKey);
//	else if ((_theme = [BGThemeManager.keyedManager themeForKey:@"AZFlatTheme"])) 		NSLog(@"using AtoZ theme!");
//	return _theme;	//	[_theme addObserver:self forKeyPath:@"baseColor" options:0 context:&RedrawContext];
//}


//	NSLog(@"drawrect: %@ %@", NSStringFromRect(rect), NSStringFromClass(self.class));
//	if (_useTheme) { _theme = self.theme;	NSLog(@"indeed using theme");	//	[self.theme.normalGradient drawInRect:rect angle:_theme.gradientAngle];
/*	else {
		NSGradient *gradient= _customGradient ?: [[NSGradient alloc] initWithStartingColor:self.color1 endingColor:self.color2];
		NSShadow *dropShadow 			= NSShadow.new; 
		dropShadow.shadowColor			= self.shadowColor;
		dropShadow.shadowBlurRadius	= 5;
		self.flipGradient == 0 	? 	[gradient drawInRect:rect angle:360 - [[[BGThemeManager keyedManager] themeForKey:self.themeKey] gradientAngle]]
										:	[gradient drawInRect:rect angle:[[[BGThemeManager keyedManager] themeForKey:self.themeKey] gradientAngle]];
		[NSGraphicsContext.currentContext setShouldAntialias:NO];
		[self.borderColor set];
		rect = NSInsetRect(rect, .5f, .5f);
		//Draw Borders
		if (self.drawTopBorder) 		{	[NSGraphicsContext saveGraphicsState];
			if (self.drawTopShadow) 	{	[dropShadow setShadowOffset:NSMakeSize( 0, -1)];	[dropShadow set];	}
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMaxY(rect)) toPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
			[NSGraphicsContext restoreGraphicsState];
		}
		if (self.drawBottomBorder) 	{	[NSGraphicsContext saveGraphicsState];
			if (self.drawBottomShadow) {	[dropShadow setShadowOffset:NSMakeSize( 0, 1)];		[dropShadow set];
			}
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect))];
			[NSGraphicsContext restoreGraphicsState];
		}
		if (self.drawLeftBorder) 		{	[NSGraphicsContext saveGraphicsState];	
			if (self.drawLeftShadow) 	{	[dropShadow setShadowOffset:NSMakeSize( 1, 0)];		[dropShadow set];	}
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint:NSMakePoint(NSMinX(rect), NSMaxY(rect))];
			[NSGraphicsContext restoreGraphicsState];
		}
		if (self.drawRightBorder) 		{	[NSGraphicsContext saveGraphicsState];
			if (self.drawRightShadow) 	{	[dropShadow setShadowOffset:NSMakeSize( -1, 0)];	[dropShadow set];	}
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect)) toPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
			[NSGraphicsContext restoreGraphicsState];
		}
	}*/


@end
