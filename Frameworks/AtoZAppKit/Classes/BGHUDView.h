//
//  BGHUDView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDView : NSView

@property (nonatomic, strong) NSString 	*themeKey;
@property (readonly,		weak) BGTheme 		*theme;
@property (nonatomic, strong) NSGradient 	*customGradient;
@property (nonatomic, strong) NSColor		*shadowColor, *borderColor, 		*color1, 		*color2;
@property (nonatomic, assign) BOOL 			drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder,
														drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow,
														flipGradient, 	useTheme;
@end


//{
//			BOOL flipGradient, drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder, drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow;
//	NSGradient *customGradient;
//		NSColor *borderColor, *shadowColor, *color1, *color2;
//			BOOL useTheme;
//	NSString *themeKey;
//}