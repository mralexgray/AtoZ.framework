//
//  BGHUDSegmentedCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/1/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"
#import "AtoZAppKit.h"

@interface BGHUDSegmentedCell : NSSegmentedCell {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

-(void)drawInteriorForSegment:(NSInteger)segment withFrame:(NSRect)rect;
-(BOOL)hasText;

@end
