

JREnumDeclare (AZLexicon, AZLexiconUrbanD = 0x10000001,
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

@prop_NA    AZLexicon   lexicon;
@prop_NC DefinedBlock   completion;
@prop_NA         NSTI   timeout;
@prop_RO           id   rawResult;
@prop_RO         BOOL   fromTheWeb;
@prop_CP        NSERR * error;
@prop_RO          NSU * query;
@prop_RO          NSA * results;
@prop_NA          NSS * word;
@prop_RO          NSS * definition,
                      * formatted;
@end

extern NSS * TagsDefaultsKey;
AZIFACEDECL(Tweet,NSO)
@prop_NA    DATE * createdAtDate;
@prop_NA    NSS  *screenNameString, *createdAtString, *tweetTextString;

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
