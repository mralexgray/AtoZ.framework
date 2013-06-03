//
//  BGHUDStepperCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 4/6/09.
//
//  Copyright 2009 Tyler Bunnell and Steve Audette
//	All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDStepperCell : NSStepperCell {

	NSString *themeKey;
	int topButtonFlag;
	int bottomButtonFlag;
	
	BOOL topPressed;
	BOOL bottomPressed;
	BOOL isTopDown;
	BOOL isBottomDown;
}

@property (strong) NSString *themeKey;

@end
