//
//  BGHUDTokenFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/10/08.
//


#import <AppKit/AppKit.h>
#import "BGHUDTokenAttachmentCell.h"
#import "NSTokenAttachmentCell.h"
#import "BGThemeManager.h"

@interface BGHUDTokenFieldCell : NSTokenFieldCell {

	BOOL fillsBackground;
	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
