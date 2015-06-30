
#import <AtoZ/AtoZ.h>
#import <CoreServices/CoreServices.h>

_EnumPlan(AZLexicon);

#define WikiTempl  @"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1"
#define DuckTempl  @"http://api.duckduckgo.com/?q=%@&format=json"

NSString * const DCSAppleDictionaryName = @"Apple Dictionary";

NSString * const DCSDutchDictionaryName = @"Prisma woordenboek Nederlands";
NSString * const DCSFrenchDictionaryName = @"Multidictionnaire de la langue française";
NSString * const DCSGermanDictionaryName = @"Duden-Wissensnetz deutsche Sprache";
NSString * const DCSItalianDictionaryName = @"Dizionario italiano da un affiliato di Oxford University Press";
NSString * const DCSJapaneseSupaDaijirinDictionaryName = @"スーパー大辞林";
NSString * const DCSJapanese_EnglishDictionaryName = @"ウィズダム英和辞典 / ウィズダム和英辞典";
NSString * const DCSKoreanDictionaryName = @"New Ace Korean Language Dictionary";
NSString * const DCSKorean_EnglishDictionaryName = @"New Ace English-Korean Dictionary and New Ace Korean-English Dictionary";
NSString * const DCSNewOxfordAmericanDictionaryName = @"New Oxford American Dictionary";

NSString * const DCSSimplifiedChineseDictionaryName = @"现代汉语规范词典";
NSString * const DCSSimplifiedChinese_EnglishDictionaryName = @"Oxford Chinese Dictionary";
NSString * const DCSSpanishDictionaryName = @"Diccionario General de la Lengua Española Vox";
NSString * const DCSWikipediaDictionaryName = @"Wikipedia";

NSString * const DCSOxfordDictionaryOfEnglish = @"Oxford Dictionary of English";
NSString * const DCSOxfordThesaurusOfEnglish = @"Oxford Thesaurus of English";
NSString * const DCSOxfordAmericanWritersThesaurus = @"Oxford American Writer's Thesaurus";

@interface TTTDictionary : NSObject

+ (instancetype)  dictionaryNamed:(NSString*)n;
- (NSArray*) entriesForSearchTerm:(NSString*)t;
+ (NSSet*)  availableDictionaries;              @property (readonly,copy) NSString *name, *shortName;       @end
@interface TTTDictionaryEntry : NSObject        @property (readonly,copy) NSString *HTML,*text, *headword;  @end


EXTEND(AZDefinition) @prop_ ASIHTTPRequest *requester; @end

@implementation AZDefinition { BOOL _ranCompletion; } @dynamic definition;

- (BOOL) fromTheWeb     { return _lexicon & AZLexiconFromTheWeb; }
- (NSS*) formatted      { return $(@"According to %@, %@ is %@ %@",

  [AZLexicon2Text(_lexicon) substringAfter:@"AZLexicon"],
  _word           ?: @"warning: word not set!",
  self.definition     ?: @"undefined!",
  self.fromTheWeb ? @"(Results from the internet)" : @"" );
}
- (NSS*) description    { return self.formatted;        }

SetKPfVA(Definition, @"results");

- (NSU*) query                                  { if (!_word || self.lexicon == (AZLexicon)NSNotFound) return  nil;

	return $URL($(self.lexicon == AZLexiconDuckDuckGo ? DuckTempl :
                self.lexicon == AZLexiconWiki       ? WikiTempl : @"UNKNOWNLEXI!:%@", _word)) ;
}
+ (INST)                     define:(NSS*)word  { return [self define:word ofType:AZLexiconAppleDictionary completion:NULL];	}
+ (INST)                 synonymsOf:(NSS*)word  { return [self define:word ofType:AZLexiconAppleThesaurus completion:NULL];	}
+ (INST) definitionFromDuckDuckGoOf:(NSS*)query { return [self define:query ofType:AZLexiconDuckDuckGo completion:NULL];	}

+ (INST) define:(NSS*)term ofType:(AZLexicon)lex                  completion:(DefinedBlock)blk {

  return [self define:term ofType:lex timeout:0 completion:blk];
}

+ (INST) define:(NSS*)term ofType:(AZLexicon)lex timeout:(NSTI)ti completion:(DefinedBlock)blk {

  AZDefinition *n = self.new;
                n.lexicon = lex; !blk ?: [n setCompletion:[blk copy]];
                n.timeout = ti;
                n.word    = term; // [n definition];
                return n;
}

- (void)         setCompletion:(DefinedBlock)c  {

  if (!(_completion = !IS_NULL(c) ? [c copy] : NULL)) return;
  if (self.definition && !_ranCompletion) _completion(self);
}

+ (INST)  wikipedia:(NSS*)topic { return [self define:topic ofType:DCSWikipediaDictionaryName timeout:0 completion:NULL]; }

//- (void) setLexicon:(AZLexicon)lex { if (_lexicon == lex) return;

//  if ((_lexicon = lex) != AZLexiconAppleDictionary && lex != AZLexiconAppleThesaurus) return;

//  [AZUSERDEFS setPersistentDomain:[[AZUSERDEFS persistentDomainForName:DefaultsID]
//              dictionaryWithValue:@[lex == AZLexiconAppleDictionary ? OxfordD : Thesaurus] forKey:ActiveDKey]
//                          forName:DefaultsID];


//  activeDict = lex;
//}
- (NSS*) definition { if (!_word && !_results.count) return nil; if (_results) return _results.firstObject;


  if (_lexicon == AZLexiconAppleDictionary || _lexicon == AZLexiconAppleThesaurus || _lexicon == zDCSWikipediaDictionaryName) {


          NSS* looker = _lexicon == AZLexiconAppleDictionary ? DCSOxfordDictionaryOfEnglish :
          _lexicon == zDCSWikipediaDictionaryName ? [AZLexicon2Text(zDCSWikipediaDictionaryName) substringFromIndex:1] :
          DCSOxfordThesaurusOfEnglish;

          XX(looker); XX(THIS_FILE);
          TTTDictionary *dictionary = [TTTDictionary dictionaryNamed:looker];
          //DCSSimplifiedChinese_EnglishDictionaryName];
//                                                                                              : DCSOxfordAmericanWritersThesaurus];

//        for (TTTDictionaryEntry *entry in
        (!(_results = [[dictionary entriesForSearchTerm:_word] valueForKey:@"text"]).count || !_completion) ?:_completion(self);
        return [_results firstObject];;
//            NSLog(@"%@", entry.text);

//    _results = @[(__bridge NSString*)DCSCopyTextDefinition(NULL,(__bridge CFStringRef)_word,
//                                   DCSGetTermRangeInString(NULL,(__bridge CFStringRef)_word, 0))];

  }
	else if (_lexicon == AZLexiconDuckDuckGo || _lexicon == AZLexiconWiki)  {

		if (_lexicon == AZLexiconDuckDuckGo) {
			NSURLREQ *req 	= [NSURLREQ requestWithURL:self.query];	NSURLRES *res 	= nil;	NSError 	*err  = nil;
			NSData *data 	= [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
			_rawResult 		= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL][@"RelatedTopics"];
			_results   = [_rawResult count] ? [_rawResult vFKP:@"Text"] : nil;
      if (_results.count && _completion) _completion(self);
		}
		if (_lexicon == AZLexiconWiki) {	__block NSError *requestError = nil;  __block NSS* wikiD = nil;
		
			_requester                  = [ASIHTTPRequest.alloc initWithURL:self.query];
			_requester.completionBlock 	= ^(ASIHTTPRequest *request) {	wikiD = request.responseString.copy; requestError = [request error];	};
			[_requester startSynchronous];

//			AZHTMLParser *p	__unused 	= [AZHTMLParser.alloc initWithString:wikiD error:nil];
			_rawResult = wikiD;
//			NSString * __unused stripped 	= [_rawResult stripHtml];																		// parseXMLTag:@"text"]);

			_results = requestError	?  @[$(@"Error: %@  headers: %@", requestError, _requester.responseHeaders)] :
               !wikiD.isEmpty	?  @[[wikiD parseXMLTag:@"Description"]] : nil;
      if (_results.count && _completion) _completion(self);
		}
	}
	if (_lexicon == AZLexiconUrbanD) {
		JATLog(@"setting up AZLexiconUrbanD for {self.word}", self.word);
		ASIHTTPRequest *requester 	= [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
		requester.completionBlock 	= ^(ASIHTTPRequest *request) {
			NSS *responsePage      	= request.responseString.copy;
			NSError *requestError  	= [request error];
			if (requestError) { self.error = requestError; return; } //self.definition =  @"no response from urban"; return; }
			AZHTMLParser *p 	= [AZHTMLParser.alloc initWithString:responsePage error:&requestError];
			HTMLNode *title 	= [p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES];
			NSS *__unused content	 	= [title getAttributeNamed:@"content"];
			HTMLNode *descN   = [p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES];
			_results  = @[[descN getAttributeNamed:@"content"]];
    if (_results.count && _completion) _completion(self);
        ///rawContents.urlDecoded.decodeHTMLCharacterEntities);
		};
		[requester startAsynchronous];
	}
  return _results.firstObject;
}
@end

@implementation Tweet //@synthesize screenNameString, createdAtDate, createdAtString, tweetTextString;

+ (INST) tweetFromJSON:(NSD*)dict { return [self.class.alloc initWithJSON:dict]; }

- (id)initWithJSON:(NSD*)json { SUPERINIT;

	AZSTATIC_OBJ(NSDateFormatter,dateFormatter, ({ [NSDateFormatter.alloc initWithProperties: @{

                   @"dateFormat" : @"EEE, d LLL yyyy HH:mm:ss Z",
                    @"timeStyle" : @(NSDateFormatterShortStyle),
                    @"dateStyle" : @(NSDateFormatterShortStyle),
   @"doesRelativeDateFormatting" : @(YES) }]; }));

	_screenNameString = json[@"from_user"];
	_tweetTextString  = json[@"text"];
  _createdAtDate    = [dateFormatter dateFromString:json[@"created_at"]];
  _createdAtString  = [dateFormatter stringFromDate: _createdAtDate];
	return self;
}

@end

#define DEFAULT_TIMEOUT        120.0f
#define SEARCH_RESULTS_PER_TAG 20

//        [NSURLREQ requestWithURL:
//          $(@"http://search.twitter.com/search.json?q=%@&rpp=%i&include_entities=true&result_type=mixed",
//            query.urlEncoded, SEARCH_RESULTS_PER_TAG).urlified
//                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                              timeoutInterval:DEFAULT_TIMEOUT];

@implementation AZTwitter

+ (void) searchForTweets:(NSS*)query block:(FetchBlock)block {

//- (void) setchTweetsForSearch:(NSString *)searchString block:(FetchBlock)block;

  NSBLO *operation = [NSBLO blockOperationWithBlock:^{

    NSError *err = nil; NSHTTPURLResponse *response = nil;
    NSURLREQ *request  =  NSURLREQFMT(
                                        NSURLRequestReloadIgnoringLocalCacheData,
                                        DEFAULT_TIMEOUT,  @"http://search.twitter.com/search.json?q=%@&rpp=%i&include_entities=true&result_type=mixed",
                                        query.urlEncoded,
                                        SEARCH_RESULTS_PER_TAG);

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSD *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    // Serialize JSON response into lightweight Tweet objects for convenience.
    NSA *tweets = [JSON[@"results"] map:^id (id tweetD) { return [Tweet tweetFromJSON:tweetD]; }];
    NSLog(@"Search for '%@' returned %lu results.", query, tweets.count);
    // Return to the main queue once the request has been processed.
    [NSOQMQ addOperationWithBlock:^{ block(nil,err); }];
  }];
  // Optionally, set the operation priority. This is useful when flooding the operation queue with different requests.
  [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
  [AZSOQ addOperation:operation];
}

//- (id)init;
//{
//    if (!(self = [super init]) ) return nil;
//    // The maxConcurrentOperationCount should reflect the number of open
//    // connections the server can handle. Right now, limit it to two for the sake of this example.
//    _operationQueue = NSOperationQueue.new;
//    _operationQueue.maxConcurrentOperationCount = 2;
//    return self;
//}
@end

	//
	//@dynamic  appCategories;// = _appCategories,
	//@dynamic  sortOrder;// = _sortOrder,
	//@dynamic  appFolderStrings;// = _appFolderStrings,
	//@dynamic  _dock;// = _dock,
	//@dynamic  dockSorted;// = _dockSorted,
	//@dynamic  appFolder;// = _appFolder,
	//@dynamic  appFolderSorted;// = _appFolderSorted;

@implementation SizeObj @synthesize width, height;

+   (id)      forSize:(NSSZ)sz {

	return [[self alloc]initWithSize:sz];
}
-   (id) initWithSize:(NSSZ)sz {
	if (self = [super init]) {
		width  = sz.width;
		height = sz.height;
	}
	return self;
}
- (NSSZ)    sizeValue          {
	return NSMakeSize(width, height);
}
@end
//+ (instancetype) definitionOf:(NSS*)wordOrNilForRand lexicon:(AZLexicon)lex completion:(DefinitionBlock)orNullForSync {
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];	*/
//	return $(@"POOP: %@",  p.body.rawContents.urlDecoded.decodeHTMLCharacterEntities		);
//#import "AtoZModels.h"
//#import "AtoZFunctions.h"


/* appleds

//SetKPfVA(RawResult, @"word", @"lexicon", @"completion")


    NSURL *url = [NSURL fileURLWithPath:Ox];
    CFTypeRef dict = DCSDictionaryCreate((CFURLRef) url);
    printf("%s\n", [[[dict_name componentsSeparatedByString: @" "] lastObject] UTF8String]);
    CFRange range = DCSGetTermRangeInString((DCSDictionaryRef)dict, (CFStringRef)searchStr, 0);
    NSString* result = (NSString*)DCSCopyTextDefinition((DCSDictionaryRef)dict, (CFStringRef)searchStr, range);
  	// Shorthands for dictionaries shipped with OS 10.6 Snow Leopard
	NSMD *dictionaryPrefs = [[NSUserDefaults persistentDomainForName:DefaultsIdentifier] mutableCopy];
	// Cache the original active dictionaries
	NSArray *activeDictionaries = dictionaryPrefs[ActiveDictionariesKey];
		// Set the specified dictionary as the only active dictionary
		NSString *dictionaryArgument = [NSString stringWithUTF8String: argv[1]];
		NSString *shortHand = [shorthands objectForKey:dictionaryArgument];
		NSString *dictionaryPath 		SetActiveDictionaries([NSArray arrayWithObject:dictionaryPath]);
		// Get the definition
		puts([(NSString *)DCSCopyTextDefinition(NULL, (CFStringRef)word, CFRangeMake(0, [word length])) UTF8String]);
		// Restore the cached active dictionaries
		SetActiveDictionaries(activeDictionaries);
*/
//}

//- (NSS*) description { return  }

//+ (instancetype) definitionOf:(NSS*)wordOrNilForRand lexicon:(AZLexicon)lex completion:(DefinitionBlock)orNullForSync {
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];	*/
//	return $(@"POOP: %@",  p.body.rawContents.urlDecoded.decodeHTMLCharacterEntities		);
//	if (err)	[sender showErrorOutput:@"Error searching" errorRange:NSMakeRange(0, [input length])];
//				else {
//					NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
//					NSArray *relatedTopics = [results valueForKey:@"RelatedTopics"];
//					if ([relatedTopics count]) {
//						NSDictionary *firstResult = relatedTopics[0];
//						[sender appendOutputWithNewlines:firstResult[@"Text"]];
//					} else [sender appendOutputWithNewlines:@"No results"];
//				}
//				// Call this when the task is done
//				[sender endDelayedOutputMode];
//			}];
//	
	//sendAsynchronousRequest:req queue:AZSOQ completionHandler:^(NSURLRES *response, NSData *data, NSError *error) {
//				if (error)	[sender showErrorOutput:@"Error searching" errorRange:NSMakeRange(0, [input length])];
//				else {
//					NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
//					NSArray *relatedTopics = [results valueForKey:@"RelatedTopics"];
//					if ([relatedTopics count]) {
//						NSDictionary *firstResult = relatedTopics[0];
//						[sender appendOutputWithNewlines:firstResult[@"Text"]];
//					} else [sender appendOutputWithNewlines:@"No results"];
//				}
//				// Call this when the task is done
//				[sender endDelayedOutputMode];
//			}];
//+ (instancetype) definitionFromWikipediaOf:(NSS*)query { 	__block NSS* wikiD = nil;  __block  NSError *requestError;  Definition *w; 
//	return w;
//}

//			NSLog(@"found wiki for: %@, %@", self, wikiD); return [wikiD parseXMLTag:@"Description"]; }
//	else return $(@"code: %i no resonse.. %@", requester.responseStatusCode, [requester responseHeaders]);
//		NSS* result = nil;
//	NSS* try = ^(NSS*){ return [NSS stringWithContentsOfURL: };
	//	@"https://www.google.com/search?client=safari&rls=en&q=%@&ie=UTF-8&oe=UTF-8", );
//	while (!result) [@5 times:^id{



//+ (void) setActiveDictionaries:(NSA*)ds { dPrefs[ActiveDKey] = ds; [AZUSERDEFS setPersistentDomain:dPrefs forName:DefaultsID]; }


//#define DREF DCSDictionaryRef
//
//NSA * DCSGetActiveDictionaries();     NSS * DCSDictionaryGetShortName(DREF dictID);
//NSA * DCSCopyAvailableDictionaries(); NSS *      DCSDictionaryGetName(DREF dictID);
//                                      DREF        DCSDictionaryCreate(CFURLRef url);  // SNEAKY






extern CFArrayRef DCSCopyAvailableDictionaries();
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFStringRef DCSDictionaryGetShortName(DCSDictionaryRef dictionary);
extern DCSDictionaryRef DCSDictionaryCreate(CFURLRef url);
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFArrayRef DCSCopyRecordsForSearchString(DCSDictionaryRef dictionary, CFStringRef string, void *, void *);

extern CFDictionaryRef DCSCopyDefinitionMarkup(DCSDictionaryRef dictionary, CFStringRef record);
extern CFStringRef DCSRecordCopyData(CFTypeRef record);
extern CFStringRef DCSRecordCopyDataURL(CFTypeRef record);
extern CFStringRef DCSRecordGetAnchor(CFTypeRef record);
extern CFStringRef DCSRecordGetAssociatedObj(CFTypeRef record);
extern CFStringRef DCSRecordGetHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetRawHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetString(CFTypeRef record);
extern DCSDictionaryRef DCSRecordGetSubDictionary(CFTypeRef record);
extern CFStringRef DCSRecordGetTitle(CFTypeRef record);


@interface TTTDictionaryEntry () @property (readwrite, nonatomic, copy) NSString *headword, *text, *HTML; @end

@implementation TTTDictionaryEntry

- (instancetype)initWithRecordRef:(CFTypeRef)record
                    dictionaryRef:(DCSDictionaryRef)dictionary
{
    self = [self init];
    if (!self && record) {
        return nil;
    }

    self.headword = (__bridge NSString *)DCSRecordGetHeadword(record);
    if (self.headword) {
        self.text = (__bridge_transfer NSString*)DCSCopyTextDefinition(dictionary, (__bridge CFStringRef)self.headword, CFRangeMake(0, CFStringGetLength((__bridge CFStringRef)self.headword)));
    }

    self.HTML = (__bridge_transfer NSString *)DCSRecordCopyData(record);

    return self;
}

@end

@interface TTTDictionary ()
@property (readwrite, nonatomic) DCSDictionaryRef dictionary;
@property (readwrite, nonatomic, copy) NSString *name;
@property (readwrite, nonatomic, copy) NSString *shortName;
@end

@implementation TTTDictionary

+ (NSSet *)availableDictionaries {
    static NSSet *_availableDictionaries = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableSet *mutableDictionaries = [NSMutableSet set];
        for (id dictionary in (__bridge_transfer NSArray *)DCSCopyAvailableDictionaries()) {
            [mutableDictionaries addObject:[[TTTDictionary alloc] initWithDictionaryRef:(__bridge DCSDictionaryRef)dictionary]];
        }

        _availableDictionaries = [NSSet setWithSet:mutableDictionaries];
    });

    return _availableDictionaries;
}

+ (instancetype)dictionaryNamed:(NSString *)name {
    static NSDictionary *_availableDictionariesKeyedByName = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *mutableAvailableDictionariesKeyedByName = NSMutableDictionary.new;
        for (TTTDictionary *dictionary in [self availableDictionaries]) mutableAvailableDictionariesKeyedByName[dictionary.name] = dictionary;

        _availableDictionariesKeyedByName = [NSDictionary dictionaryWithDictionary:mutableAvailableDictionariesKeyedByName];
    });

    return _availableDictionariesKeyedByName[name];
}

- initWithDictionaryRef:(DCSDictionaryRef)dictionary {

    if (!dictionary || !(self = self.init)) return nil;

    _dictionary = dictionary;
    _name = (__bridge NSString *)DCSDictionaryGetName(self.dictionary);
    _shortName = (__bridge NSString *)DCSDictionaryGetShortName(self.dictionary);

    return self;
}

- (NSArray *)entriesForSearchTerm:(NSString *)term {

    CFRange termRange = DCSGetTermRangeInString(self.dictionary, (__bridge CFStringRef)term, 0);

    if (termRange.location == kCFNotFound) return nil;

    term = [term substringWithRange:NSMakeRange(termRange.location, termRange.length)];

    NSArray *records = (__bridge_transfer NSArray *)DCSCopyRecordsForSearchString(self.dictionary, (__bridge CFStringRef)term, NULL, NULL);
    if (!records) return @[];


    NSMutableArray *mutableEntries = @[].mutableCopy;

    for (id record in records) { TTTDictionaryEntry *entry;
            if ((entry  = [TTTDictionaryEntry.alloc initWithRecordRef:(__bridge CFTypeRef)record dictionaryRef:self.dictionary]))[mutableEntries addObject:entry];
    }

    return [mutableEntries copy];
}

- (NSUInteger) hash { return self.name.hash; }
- (BOOL)  isEqual:x { return self == x ?: ![x isKindOfClass:TTTDictionary.class] ? NO :
                            [self.name isEqualToString:((TTTDictionary*)x).name];
}
@end



//NSMD *       dPrefs;
//#define DefaultsID @"com.apple.DictionaryServices"
//#define ActiveDKey @"DCSActiveDictionaries"  // DefaultsIdentifier",
//#define AppleWords @"/Library/Dictionaries/Apple Dictionary.dictionary"
//#define Thesaurus  @"/Library/Dictionaries/New Oxford American Dictionary.dictionary"
//#define OxfordD    @"/Library/Dictionaries/Oxford American Writer's Thesaurus.dictionary"
//#define WikiTempl  @"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1"
//#define DuckTempl  @"http://api.duckduckgo.com/?q=%@&format=json"
//
//static AZLexicon activeDict;
