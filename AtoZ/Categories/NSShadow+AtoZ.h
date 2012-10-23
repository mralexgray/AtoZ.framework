//
//  NSShadow+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSShadow (AtoZ)
+ (NSShadow*)shadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius color:(NSColor *)shadowColor ;
- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur;
+ (void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)radius
					  color:(NSColor *)shadowColor;
+ (void)clearShadow;
@end
