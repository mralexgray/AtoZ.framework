//
//  BGHudScroller.h
//  HUDScroller
//
//  Created by BinaryGod on 5/22/08.
//



// Special thanks to Matt Gemmell (http://mattgemmell.com/) for helping me solve the
// transparent drawing issues.  Your awesome man!!!

#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"
#import "AtoZAppKit.h"

@interface BGHUDScroller : NSScroller {
	
	NSString *arrowPosition;
	NSString *themeKey;
}

@property (copy,nonatomic) NSString *themeKey;

- (void)drawDecrementArrow:(BOOL)highlighted;
- (void)drawIncrementArrow:(BOOL)highlighted;

-(NSString *)themeKey;

-(BOOL)isHoriz;

@end
