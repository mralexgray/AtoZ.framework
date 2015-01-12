//
//  BGHUDBox.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/16/09.
//  Copyright 2009 none. All rights reserved.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"

@interface BGHUDBox : NSBox {
	
	NSColor *borderColor, *shadowColor, *color1, *color2;
     BOOL   flipGradient, drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder,
            drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow,
            useTheme;

	NSGradient *customGradient;
	NSString *themeKey;
}

@property BOOL flipGradient, drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder,
            drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow,
            useTheme;

// Inherited @property (strong) NSColor *borderColor;
@property NSColor *shadowColor,  *color1, *color2;
@property NSGradient *customGradient;
@property NSString *themeKey;

@end
