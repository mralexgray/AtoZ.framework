//
//  BGHUDProgressIndicator.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/6/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"
#import <Foundation/Foundation.h>

@interface BGHUDProgressIndicator :NSProgressIndicator {
    double progressOffset;
    NSTimer* animator;
}

@property (strong) NSColor* color, *backgroundColor;
@property (readwrite, strong) NSTimer* animator;
@property (readwrite) double progressOffset;
@property (strong) NSString *themeKey;


@end
