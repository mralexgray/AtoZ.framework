//
//  BGHUDTabView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/10/09.
//  Copyright 2009 none. All rights reserved.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import "BGHUDTabViewItem.h"

@interface BGHUDTabView : NSTabView {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
