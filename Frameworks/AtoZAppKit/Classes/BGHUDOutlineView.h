//
//  BGHUDOutlineView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/20/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import "BGHUDTableViewHeaderCell.h"
#import "BGHUDTableCornerView.h"

@interface BGHUDOutlineView : NSOutlineView {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
