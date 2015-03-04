//
//  DSObjectiveCSyntaxDefinition.m
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 01/10/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#import "DSObjectiveCSyntaxDefinition.h"

@implementation DSObjectiveCSyntaxDefinition

+ (NSString *)name { return @"Objective-C"; }

+ (NSArray *)extensions { return @[ @"h", @"m" ]; }

- (id)init { SUPERINIT;

  self.keywords = @[
  @"id",
  @"nil",
  @"self",
  @"void",
  @"@implementation",
  @"@interface",
  @"@end",
  @"__block"
  ];

  self.delimiters = @[
  @[ @"{", @"}" ],
  @[ @"[", @"]" ],
  @[ @"@{", @"}" ],
  @[ @"@[", @"]" ],
  ];

  self.commentPattern = @[@"//.*?\n"];

  return self;
}

@end
