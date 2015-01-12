//
//  BGHUDSliderCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/30/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import "AtoZAppKit.h"

@interface BGHUDSliderCell : NSSliderCell {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

-(void)drawHorizontalBarInFrame:(NSRect)frame;
-(void)drawVerticalBarInFrame:(NSRect)frame;
-(void)drawHorizontalKnobInFrame:(NSRect)frame;
-(void)drawVerticalKnobInFrame:(NSRect)frame;

@end
