//
//  BGHUDSearchFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/21/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"


NSImage *searchButtonImage(void);
NSImage *cancelButtonImageUp(void);

@interface BGHUDSearchFieldCell : NSSearchFieldCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
