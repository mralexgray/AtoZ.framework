//
//  BGHUDTableCornerView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/29/08.
//  Copyright 2008 none. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "BGThemeManager.h"

@interface BGHUDTableCornerView : NSView {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

- (id)initWithThemeKey:(NSString *)key;

@end
