//
//  DSRubySyntaxDefinition.m
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 29/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#import "DSRubySyntaxDefinition.h"

/** 
 TODO:
 - string interpolation
 - here docs
 - %q, %w formats
 */

@implementation DSRubySyntaxDefinition

+ (NSString *)name {
  return @"Ruby";
}

+ (NSArray *)extensions {
  return @[ @"rb" ];
}

- (id)init {
  self = [super init];
  if (self) {

    self.keywords = @[
    @"BEGIN", @"END", @"alias", @"and", @"begin", @"break", @"case", @"class",
    @"def", @"defined", @"do", @"else", @"elsif", @"end", @"ensure", @"false",
    @"for", @"in", @"module", @"next", @"nil", @"not", @"or", @"redo",
    @"rescue", @"retry", @"return", @"self", @"super", @"then", @"true",
    @"undef", @"when", @"yield", @"if", @"unless", @"while", @"until",
    @"attr_reader", @"attr", @"attr_writer", @"autoload", @"include" ];

    self.delimiters = @[
    @[ @"def[[\\t\\p{Zs}]]*\\W+", @"end" ],
    @[ @"do", @"end" ],
    @[ @"{", @"}" ],
    @[ @"[", @"]" ],
    ];

    // Includes symbols
    self.constantPatterns = @[ @"[A-Z]\\w*", @":\\w+"];
    self.variablePatterns = @[@"@\\w+"];
    self.commentPattern   = @[@"#.*?\n"];
  }
  return self;
}

@end
