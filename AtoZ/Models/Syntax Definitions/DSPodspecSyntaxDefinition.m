//
//  CPPodspecSyntaxDefinition.m
//  CocoaPodsApp
//
//  Created by Fabio Pelosin on 01/10/12.
//  Copyright (c) 2012 CocoaPods. All rights reserved.
//

#import "DSPodspecSyntaxDefinition.h"

@implementation DSPodspecSyntaxDefinition

+ (NSString *)name {
  return @"Podspec";
}

+ (NSArray *)extensions {
  return @[ @"podspec" ];
}


@end
