//
//  BGHUDTextFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/2/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"

@interface BGHUDTextFieldCell : NSTextFieldCell {

	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
