//
//  BGHUDSecureTextFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/12/08.
//


@import AppKit;
#import "BGThemeManager.h"

@interface BGHUDSecureTextFieldCell : NSSecureTextFieldCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
