//
//  BGHUDTableViewHeaderCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDTableViewHeaderCell : NSTableHeaderCell {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
