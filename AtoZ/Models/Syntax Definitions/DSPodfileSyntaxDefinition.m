//
//  CPPodfileSyntaxDefinition.m
//  CocoaPodsApp
//
//  Created by Fabio Pelosin on 01/10/12.
//  Copyright (c) 2012 CocoaPods. All rights reserved.
//

#import "DSPodfileSyntaxDefinition.h"

@implementation DSPodfileSyntaxDefinition

+ (NSString *)name {
  return @"Podfile";
}

- (id)init {
  self = [super init];
  if (self) {
    self.DSLKeywords = @[ @"pod", @"platform", @"ios", @"osx",
    @"inhibit_all_warnings!", @"post_install", @"podspec" ];
  }
  return self;
}

@end
