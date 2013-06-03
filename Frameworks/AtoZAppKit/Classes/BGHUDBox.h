//
//  BGHUDBox.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/16/09.
//  Copyright 2009 none. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDBox : NSBox {
	
	BOOL flipGradient;
	BOOL drawTopBorder;
	BOOL drawBottomBorder;
	BOOL drawLeftBorder;
	BOOL drawRightBorder;
	NSColor *borderColor;
	BOOL drawTopShadow;
	BOOL drawBottomShadow;
	BOOL drawLeftShadow;
	BOOL drawRightShadow;
	NSColor *shadowColor;
	NSGradient *customGradient;
	
	NSColor *color1;
	NSColor *color2;
	
	NSString *themeKey;
	BOOL useTheme;
}

@property BOOL flipGradient;
@property BOOL drawTopBorder;
@property BOOL drawBottomBorder;
@property BOOL drawLeftBorder;
@property BOOL drawRightBorder;
@property (strong) NSColor *borderColor;
@property BOOL drawTopShadow;
@property BOOL drawBottomShadow;
@property BOOL drawLeftShadow;
@property BOOL drawRightShadow;
@property (strong) NSColor *shadowColor;
@property (strong) NSGradient *customGradient;
@property (strong) NSColor *color1;
@property (strong) NSColor *color2;

@property (strong) NSString *themeKey;
@property BOOL useTheme;

@end
