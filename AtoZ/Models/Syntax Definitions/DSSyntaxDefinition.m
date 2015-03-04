//
//  DSSyntaxDefinition.m
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 26/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//
//#import <BlocksKit/BlocksKit.h>
#import <AtoZ/AtoZ.h>
#import "DSSyntaxDefinition.h"



NSString *const DSSyntaxTypeAttribute   = @"DSSyntaxTypeAttribute";

NSString *const kDSCommentSyntaxType    = @"comment";
NSString *const kDSStringSyntaxType     = @"string";
NSString *const kDSKeywordSyntaxType    = @"keyword";

NSString *const kDSTypeSyntaxType       = @"type";
NSString *const kDSClassSyntaxType      = @"class";
NSString *const kDSConstantSyntaxType   = @"constant";
NSString *const kDSVariableSyntaxType   = @"variable";
NSString *const kDSAttributeSyntaxType  = @"attribute";
NSString *const kDSFunctionSyntaxType   = @"function";
NSString *const kDSCharacterSyntaxType  = @"character";
NSString *const kDSNumberSyntaxType     = @"number";
NSString *const kDSMacroSyntaxType      = @"macro";

NSString *const kDSDSLKeywordSyntaxType = @"DSLKeyword";

/* 
 TODO:
 - move to NSScanner for parsing.
 - strings need to support escaping.
 - strings need to support interpolation.
 - fix comments in strings.
 - use delimiters to compute indentation level (add it as an attribute) ?
*/

@implementation DSSyntaxDefinition {
  NSAttributedString* _parsed;
  NSMutableAttributedString *_attributed;
}

///-----------------------------------------------------------------------------
#pragma mark - Parsing
///-----------------------------------------------------------------------------

- (NSAttributedString*)parseString:(NSString*)string {
  _attributed = [NSMutableAttributedString.alloc initWithString:string];

  self.stringDelimiters = @[@"\".*?\"", @"'.*?'"];
  self.stringInterpolationPatterns = @[@"#{.*?}"];
  NSRange range = NSMakeRange(0, _attributed.length);

  // First match the strings, then comments, and finally the rest.
  [self matchPatterns:self.stringDelimiters range:range type:kDSStringSyntaxType];
  [self matchPatterns:self.commentPattern   range:range type:kDSCommentSyntaxType];
  [self matchWords:self.keywords            range:range type:kDSKeywordSyntaxType];
  [self matchWords:self.constantPatterns    range:range type:kDSConstantSyntaxType];
  [self matchWords:self.variablePatterns    range:range type:kDSVariableSyntaxType];
  [self matchWords:self.DSLKeywords         range:range type:kDSDSLKeywordSyntaxType];

  _parsed = _attributed;
  return _parsed;
}

- (void)matchPatterns:(NSArray*)patterns range:(NSRange)range type:(NSString*)type {
  if (!patterns || patterns.count == 0) {
    return;
  }
  NSString *expression = [patterns componentsJoinedByString:@"|"];
  [self matchExpression:expression type:type range:range];
}

- (void)matchWords:(NSArray*)words range:(NSRange)range type:(NSString*)type {
  if (!words || words.count == 0) {
    return;
  }
  NSMutableString *expression = [NSMutableString new];
  [expression appendString:@"(?<!\\w)("];
  [expression appendString:[words componentsJoinedByString:@"|"]];
  [expression appendString:@")(?!\\w)"];
  [self matchExpression:expression type:type range:NSMakeRange(0, _attributed.length)];
}

- (void)matchExpression:(NSString*)expression type:(NSString*)type range:(NSRange)range {
  if (!type) {
    NSString *sub = [_attributed.string substringWithRange:range];
    if ([[sub matchForPattern:@"{"] isValid]) {
      NSLog(@"%@", sub);
    }
  }

  NSRegularExpressionOptions opts = NSRegularExpressionDotMatchesLineSeparators
  | NSRegularExpressionAnchorsMatchLines;

  NSRegularExpression *regex = [NSRegularExpression
                                regularExpressionWithPattern:expression
                                options:opts
                                error:nil];

  NSArray* matches = [regex matchesInString:_attributed.string
                                    options:0 range:range];

  for(NSTextCheckingResult* match in matches) {

    // Don't override **inside** strigns
    NSString *currentType = [_attributed attribute:DSSyntaxTypeAttribute
                                           atIndex:match.range.location
                                    effectiveRange:NULL];

    if (currentType != kDSStringSyntaxType && currentType != kDSCommentSyntaxType) {
      if (type) {
        [_attributed addAttribute:DSSyntaxTypeAttribute value:type range:match.range];
        // Look for interpolations
        if (type == kDSStringSyntaxType) {
          [self matchPatterns:self.stringInterpolationPatterns range:match.range type:nil];
        }
      } else {
        [_attributed removeAttribute:DSSyntaxTypeAttribute range:match.range];
        [self matchPatterns:self.stringDelimiters range:match.range type:kDSStringSyntaxType];
      }
    }
  }
}

///-----------------------------------------------------------------------------
#pragma mark - Completions
///-----------------------------------------------------------------------------

// TODO: fix borked indentation
- (NSString*)completionForNewLineAfterLine:(NSString*)line
                               indentation:(NSString*)indentation {

  NSString *match = [line matchForPattern:@"def[[\\t\\p{Zs}]]*\\W+"];
  if ([match isValid]) {
    return [NSString stringWithFormat:@"%@  \n%@end", indentation, indentation];
  }
  return @"";
}

- (NSArray *)completionsForPartialWord:(NSString*)partialWord
                           partialLine:(NSString*)partiaLine
                   indexOfSelectedItem:(NSInteger *)index {
  
  NSArray* allCompletions;
  allCompletions = [@[] arrayByAddingObjectsFromArray:self.DSLKeywords];
  allCompletions = [allCompletions arrayByAddingObjectsFromArray:self.keywords];
  NSArray* completions = [allCompletions select:^BOOL(NSString* keyword) {
    return [keyword hasPrefix:partialWord];
  }];
  return completions;
}

// TODO: implement support
- (BOOL)shouldAutoPresentSuggentsionsForPartialLine:(NSString*)partialLine {
  return YES;
}

///-----------------------------------------------------------------------------
#pragma mark - Abstract methods
///-----------------------------------------------------------------------------

+ (NSString *)name {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:
                                         @"DSSyntaxDefinition abstract method: %@",
                                         NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

+ (NSArray *)extensions {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:
                                         @"DSSyntaxDefinition abstract method: %@",
                                         NSStringFromSelector(_cmd)]
                               userInfo:nil];
}


@end

















