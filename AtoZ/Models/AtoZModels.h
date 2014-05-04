
#import "AtoZUmbrella.h"

JREnumDeclare (AZLexicon, AZLexiconUrbanD = 0x10000001,
                            AZLexiconWiki = 0x10000002,
                          AZLexiconGoogle = 0x10000003,
                      AZLexiconDuckDuckGo = 0x10000004,
                  AZLexiconAppleThesaurus = 0x11000005,
                 AZLexiconAppleDictionary = 0x11000006,
                      AZLexiconFromTheWeb = 0x10000000,
                           AZLexiconLocal = 0x11000000);

@class AZDefinition;
typedef void (^DefinedBlock)(AZDefinition *def);

@interface AZDefinition : BaseModel


+ (INST) synonymsOf:(NSS*)word;
+ (INST)     define:(NSS*)term ofType:(AZLexicon)lexicon completion:(DefinedBlock)block;

@prop_      AZLexicon   lexicon;
@prop_NC DefinedBlock   completion;
@prop_CP        NSERR * error;
@prop_RO          NSS * formatted;
@prop_RO          NSU * query;
@prop_RO           id   rawResult;
@prop_RO         BOOL   fromTheWeb;
@prop_NA          NSA * results;
@prop_NA          NSS * word,
                      * definition;
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
