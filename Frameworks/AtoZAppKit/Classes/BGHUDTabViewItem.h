//
//  BGHUDTabViewItem.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/10/09.
//  Copyright 2009 none. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDTabViewItem : NSTabViewItem {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
