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

JREnumDeclare (AZLexicon, AZLexiconUrbanD, AZLexiconWiki, AZLexiconGoogle, AZLexiconDuckDuckGo);

@class Definition;
typedef void (^DefinitionCallback)(Definition *def);

@interface Definition : BaseModel
@property (CP) DefinitionCallback callback;
@property AZLexicon lexicon; 
@property (NATOM, STRNG) NSString *word, *definition;
@end
#define $DEFINE(A, B) [Definition.alloc initWithProperties : @{ @"word" : A, @"definition" : B }]


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
