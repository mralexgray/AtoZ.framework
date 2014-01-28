//
//  NSColor+RGBHex.h
//  TwUI
//
//  Created by Adam Kirk on 6/1/13.
//
//

#import <Cocoa/Cocoa.h>

@interface NSColor (RGBHex)

+ (NSColor *)tui_colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
+ (NSColor *)tui_colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(CGFloat)a;
+ (NSColor *)tui_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (NSColor *)tui_colorWithHex:(NSInteger)hex;

@end
