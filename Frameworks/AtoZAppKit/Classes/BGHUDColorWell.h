//
//  BGHUDColorWell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 8/9/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDColorWell : NSColorWell {

	NSString *themeKey;
	BOOL useTransparentWell;
	BOOL isBeingDecoded;
}

@property (strong) NSString *themeKey;

- (BOOL)useTransparentWell;
- (void)setUseTransparentWell:(BOOL) flag;

@end
