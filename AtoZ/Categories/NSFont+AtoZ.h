//
//  NSFont+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 4/6/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSFont (AtoZ)

- (NSFont *)fontWithSize:(CGFloat)fontSize;
@end
@interface NSFont (AMFixes)

- (float)fixed_xHeight;
- (float)fixed_capHeight;
@end
