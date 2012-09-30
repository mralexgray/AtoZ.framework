//
//  NSValue+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSValue+AtoZ.h"


@implementation NSValue (AZWindowPosition)
+ (id)valueWithPosition:(AZWindowPosition)pos;
{
    return [NSValue value:&pos withObjCType:@encode(AZWindowPosition)];
}
- (AZWindowPosition)positionValue;
{
    AZWindowPosition pos; [self getValue:&pos]; return pos;
}
@end
