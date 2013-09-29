//
//  DSSyntaxDefinition.h
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 26/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>

/** DSSyntaxDefinition is an abstract class reposible of defining an interface 
 for DSSyntaxHighlighter. Concrete subclasses are expected to implement its
 properties. */
@interface DSSyntaxDefinition : NSObject

///-----------------------------------------------------------------------------
/// @name Abstract class provided methods
///-----------------------------------------------------------------------------

- (NSAttributedString*)parseString:(NSString*)string;

- (NSString*)completionForNewLineAfterLine:(NSString*)line
                               indentation:(NSString*)indentation;

- (NSArray *)completionsForPartialWord:(NSString*)partialWord
                           partialLine:(NSString*)partiaLine
                   indexOfSelectedItem:(NSInteger *)index;

- (BOOL)shouldAutoPresentSuggentsionsForPartialLine:(NSString*)partialLine;

///-----------------------------------------------------------------------------
/// @name Methods implemented by concrete subclasses
///-----------------------------------------------------------------------------

/** The name of the language described by syntax definition. */
+ (NSString *)name;

/** Common extensions used by the files of the language described by syntax
 definition. */
+ (NSArray *)extensions;

/** The list of the keywords of the language. */
@property (nonatomic, copy) NSArray *keywords;

/** A list of touples that contains the delimiters of the language. 
    @[ @[ @"do", @"end" ],
       @[ @"{", @"}"    ] ]; */
@property (nonatomic, copy) NSArray *delimiters;

@property (nonatomic, copy) NSArray *constantPatterns;

@property (nonatomic, copy) NSArray *variablePatterns;

@property (nonatomic, copy) NSArray *commentPattern;

/** The list of a specific DSL keywords. */
@property (nonatomic, copy) NSArray *DSLKeywords;

/** The list of the patterns for string interpolation. */
@property (nonatomic, copy) NSArray *stringInterpolationPatterns;

/** The list of the delimiters that define strings. */
@property (nonatomic, copy) NSArray *stringDelimiters;

/** The list of the escape characters for the strings. */
@property (nonatomic, copy) NSArray *stringEscapeCharacters;

@end

FOUNDATION_EXPORT NSString *const DSSyntaxTypeAttribute;

FOUNDATION_EXPORT NSString *const kDSPlainTextSyntaxType;
FOUNDATION_EXPORT NSString *const kDSCommentSyntaxType;
FOUNDATION_EXPORT NSString *const kDSStringSyntaxType;
FOUNDATION_EXPORT NSString *const kDSKeywordSyntaxType;

FOUNDATION_EXPORT NSString *const kDSTypeSyntaxType;
FOUNDATION_EXPORT NSString *const kDSClassSyntaxType;
FOUNDATION_EXPORT NSString *const kDSConstantSyntaxType;
FOUNDATION_EXPORT NSString *const kDSVariableSyntaxType;
FOUNDATION_EXPORT NSString *const kDSAttributeSyntaxType;
FOUNDATION_EXPORT NSString *const kDSFunctionSyntaxType;
FOUNDATION_EXPORT NSString *const kDSCharacterSyntaxType;
FOUNDATION_EXPORT NSString *const kDSNumberSyntaxType;
FOUNDATION_EXPORT NSString *const kDSMacroSyntaxType;

FOUNDATION_EXPORT NSString *const kDSDSLKeywordSyntaxType;
