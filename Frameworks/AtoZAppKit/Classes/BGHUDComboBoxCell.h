//
//  NGHUDComboBoxCell.h
//  BGHUDAppKit
//
//  Created by Alan Rogers on 10/11/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"

@interface BGHUDComboBoxCell : NSComboBoxCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

- (void)drawArrowsInRect:(NSRect) frame;
-(void)drawButtonInRect:(NSRect) cellFrame;

@end
