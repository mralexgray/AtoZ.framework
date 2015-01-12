//
//  BGHUDProgressIndicator.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/6/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import <Foundation/Foundation.h>

@interface BGHUDProgressIndicator : NSProgressIndicator
//
//    double progressOffset;
//    NSTimer* animator;
//}

@property (nonatomic,copy) NSColor* color, *backgroundColor;
@property (nonatomic,copy) 				NSString *themeKey;


@end
