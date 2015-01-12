//
//  BGHUDButtonCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/25/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import "AtoZAppKit.h"

@interface BGHUDButtonCell : NSButtonCell {
	NSString *themeKey;
	NSButtonType buttonType;
}

@property (strong) NSString *themeKey;

-(void) drawCheckInFrame:						(NSRect)frame isRadio:(BOOL)radio;
-(void) drawTexturedRoundedButtonInFrame:	(NSRect)frame;
-(void) drawRoundRectButtonInFrame:			(NSRect)frame;
-(void) drawSmallSquareButtonInFrame:		(NSRect)frame;
-(void) drawRoundedButtonInFrame:			(NSRect)frame;
-(void) drawRecessedButtonInFrame:			(NSRect)frame;
-(void) drawTexturedSquareButtonInFrame:	(NSRect)frame;

@end
