

_EnumKind (AZLexicon, AZLexiconUrbanD = 0x10000001,
                            AZLexiconWiki = 0x10000002,
                          AZLexiconGoogle = 0x10000003,
                      AZLexiconDuckDuckGo = 0x10000004,
                  AZLexiconAppleThesaurus = 0x11000005,
                 AZLexiconAppleDictionary = 0x11000006,
                      AZLexiconFromTheWeb = 0x10000000,
                           AZLexiconLocal = 0x11000000,
              zDCSWikipediaDictionaryName = 0x11110000);

#define AZDEF                   AZDefinition
#define $AZDEFINELEX(W,D,LEX)  [AZDEF.alloc initWithProperties:@{@"word":W,@"definition":D,@"lexicon":@(LEX)}]
#define $AZDEFINE(W,D)         $AZDEFINELEX(W,D,0)

@interface AZDefinition : BaseModel

+ (INST) synonymsOf:(NSS*)word;
+ (INST)     define:(NSS*)term;
+ (INST)  wikipedia:(NSS*)topic;

typedef void (^DefinedBlock)(AZDefinition *def);

+ (INST)     define:(NSS*)term ofType:(AZLexicon)lexicon                  completion:(DefinedBlock)block;
+ (INST)     define:(NSS*)term ofType:(AZLexicon)lexicon timeout:(NSTI)ti completion:(DefinedBlock)block;

_NA    AZLexicon   lexicon;
@prop_NC DefinedBlock   completion;
_NA         NSTI   timeout;
_RO          id   rawResult;
_RO        BOOL   fromTheWeb;
@prop_CP        NSERR * error;
_RO         NSU * query;
_RO         NSA * results;
_NA          NSS * word;
_RO         NSS * definition,
                      * formatted;
@end

extern NSS * TagsDefaultsKey;
AZIFACEDECL(Tweet,NSO)
_NA    DATE * createdAtDate;
_NA    NSS  *screenNameString, *createdAtString, *tweetTextString;

+ (INST) tweetFromJSON:(NSD*)dict;
@end

AZIFACEDECL(AZTwitter,NSO)

typedef void (^FetchBlock)(NSArray *items, NSError *error);

+ (void) searchForTweets:(NSS*)query block:(FetchBlock)block;

@end

@interface SizeObj : NSObject
@property (readwrite) CGFloat width, height;
+ forSize:(NSSize)sz;
- (id)initWithSize:(NSSize)sz;
- (NSSize)sizeValue;
@end
