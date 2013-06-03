//
//  BGHUDColorWell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 8/9/08.
//


#import "BGHUDColorWell.h"


@implementation BGHUDColorWell

@synthesize themeKey;

#pragma mark Init/Dealloc Methods

-(id)init {
	
	self = [super init];
	
	if(self) {
		isBeingDecoded = NO;
		self.themeKey = @"gradientTheme";
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	isBeingDecoded = YES;
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			
			self.themeKey = @"gradientTheme";
		}
	}
	
	[self setUseTransparentWell: [aDecoder decodeBoolForKey: @"useTransparentWell"]];
	isBeingDecoded = NO;
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
	[coder encodeBool: [self useTransparentWell] forKey: @"useTransparentWell"];
}


#pragma mark Drawing Methods

- (void)drawRect:(NSRect) rect {
	
	if (isBeingDecoded)
		return;
	
	// rect in parameter is the clip region, could be part of the bounds
	// We want to draw the whole bound without clip region optimization
	rect = [self bounds];
	
	
	if([self isEnabled]) {
		if([self isActive]) {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInRect: rect angle: 270];
		} else {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: rect angle: 270];
		}
	}
	else {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledNormalGradient] drawInRect: rect angle: 270];
	}
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	NSFrameRect(rect);
	
	[self drawWellInside: rect];
}

- (void)drawWellInside:(NSRect) rect {
	
	if([self isBordered]) {
		
		rect = NSInsetRect(rect, 5, 5);
	} else {
		
		rect = NSInsetRect(rect, 2, 2);
	}
	
	
	if([self isEnabled]) {
		if([self useTransparentWell]) {
			NSColor *newColor = [NSColor colorWithDeviceRed: [[self color] redComponent]
													  green: [[self color] greenComponent]  
													   blue: [[self color] blueComponent] 
													  alpha: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue]];
			[newColor set];
		} else {
			[[self color] set];
		}
	}
	else {
		NSColor *disabledColor = [NSColor colorWithDeviceRed: [[self color] redComponent]
													   green: [[self color] greenComponent]  
														blue: [[self color] blueComponent] 
													   alpha: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledAlphaValue]];
		[disabledColor set];
	}
	
	
	NSRectFill(rect);
}

#pragma mark Helper Methods

- (BOOL)useTransparentWell {
	
	return useTransparentWell;
}

- (void)setUseTransparentWell:(BOOL) flag {
	
	useTransparentWell = flag;
	
	[self drawRect: [self frame]];
}


@end
