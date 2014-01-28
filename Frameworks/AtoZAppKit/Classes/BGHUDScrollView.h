//
//  BGHUDScrollView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/31/08.
//


#import <Cocoa/Cocoa.h>
#import "BGHUDScroller.h"
#import "BGThemeManager.h"

@interface BGHUDScrollView : NSScrollView {
	
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
