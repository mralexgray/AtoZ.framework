//
//  BGHUDSecureTextFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/12/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDSecureTextFieldCell : NSSecureTextFieldCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
