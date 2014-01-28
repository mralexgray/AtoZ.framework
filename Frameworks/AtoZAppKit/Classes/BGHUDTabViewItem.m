//
//  BGHUDTabViewItem.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/10/09.
//  Copyright 2009 none. All rights reserved.
//


#import "BGHUDTabViewItem.h"


@implementation BGHUDTabViewItem

@synthesize themeKey;

-(id)_labelColor {

	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor];
}


@end
