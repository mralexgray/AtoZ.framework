//
//  BGHUDTableViewHeaderCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//


@import AppKit;
#import "BGThemeManager.h"

@interface BGHUDTableViewHeaderCell : NSTableHeaderCell {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
