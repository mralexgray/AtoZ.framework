//
//  NSObject+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSObject+AtoZ.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation NSObject (AtoZ)

- (NSMutableDictionary*) getDictionary
{
  if (objc_getAssociatedObject(self, @"dictionary")==nil) 
  {
    objc_setAssociatedObject(self,@"dictionary",[[NSMutableDictionary alloc] init],OBJC_ASSOCIATION_RETAIN);
  }
  return (NSMutableDictionary *)objc_getAssociatedObject(self, @"dictionary");
}


@end
