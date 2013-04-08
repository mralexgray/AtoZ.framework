//
//  NSFont+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 4/6/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "NSFont+AtoZ.h"

@implementation NSFont (AtoZ)

- (NSFont *)fontWithSize:(CGFloat)fontSize {

		return [NSFont fontWithName:self.fontName size:fontSize];
}
@end
