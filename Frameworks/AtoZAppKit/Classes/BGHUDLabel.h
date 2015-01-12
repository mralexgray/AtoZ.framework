//
//  BGHUDLabel.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 8/23/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"

@interface BGHUDLabel : NSTextField {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
