//
//  AZDock.h
//  AtoZ
//
//  Created by Alex Gray on 9/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

//#import "AtoZFunctions.h"
#import "AtoZUmbrella.h"
//#import "AZObject.h"
//#import <Cocoa/Cocoa.h>

JREnumDeclare (AZLexicon, AZLexiconUrbanD, AZLexiconWiki, AZLexiconGoogle, AZLexiconDuckDuckGo, AZLexiconAppleThesaurus, AZLexiconAppleDictionary);

@class AZDefinition;
typedef void (^AZDefinitionCallback)(AZDefinition *def);

@interface AZDefinition : BaseModel
+ (INST) define:(NSString*)term ofType:(AZLexicon)lexicon completion:(AZDefinitionCallback)block;
@property (CP) AZDefinitionCallback completion;
@property (ASS) AZLexicon lexicon; 
@property (RONLY) NSURL* query;
@property (NATOM, STRNG) NSString *word, *definition;
@property (NATOM, STRNG) NSA* results;
@property (strong, nonatomic) id rawResult;
@property (copy) NSError *error;
@end
#define $DEFINE(A, B) [AZDefinition.alloc initWithProperties : @{ @"word" : A, @"definition" : B }]


extern NSString *TagsDefaultsKey;
@interface Tweet : NSObject
@property (nonatomic, strong) NSDate	*createdAtDate;
@property (nonatomic, strong) NSString  *screenNameString, *createdAtString, *tweetTextString;
- (id)initWithJSON:(NSDictionary *)JSONObject;
@end


@interface SizeObj : NSObject
@property (readwrite) CGFloat width, height;
+ (id)forSize:(NSSize)sz;
- (id)initWithSize:(NSSize)sz;
- (NSSize)sizeValue;
@end
