	//
	//  AZDock.m
	//  AtoZ
//	//
	//  Created by Alex Gray on 9/12/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AtoZModels.h"
#import "AtoZFunctions.h"
#import <CoreServices/CoreServices.h>

JREnumDefine(AZLexicon);
NSMD *dictionaryPrefs;
NSString * const DefaultsIdentifier 	= @"com.apple.DictionaryServices",
			* const ActiveDictionariesKey = @"DefaultsIdentifier",
			* const AppleWords				= @"/Library/Dictionaries/Apple Dictionary.dictionary",
			* const Thesaurus					= @"/Library/Dictionaries/New Oxford American Dictionary.dictionary",
			* const OxfordDictionary		= @"/Library/Dictionaries/Oxford American Writer's Thesaurus.dictionary";

void SetActiveDictionaries(NSArray *dictionaries) {
	[dictionaryPrefs setObject:dictionaries forKey:ActiveDictionariesKey];
	[AZUSERDEFS setPersistentDomain:dictionaryPrefs forName:DefaultsIdentifier];
}
NSArray* DCSGetActiveDictionaries();
NSArray* DCSCopyAvailableDictionaries();
NSString* DCSDictionaryGetName(DCSDictionaryRef dictID);
NSString* DCSDictionaryGetShortName(DCSDictionaryRef dictID);
DCSDictionaryRef DCSDictionaryCreate(CFURLRef url);

@interface  AZDefinition ()
@property (strong) ASIHTTPRequest *requester;
@end
@implementation AZDefinition

//+ (instancetype) definitionOf:(NSS*)wordOrNilForRand lexicon:(AZLexicon)lex completion:(DefinitionBlock)orNullForSync {
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];	*/
//	return $(@"POOP: %@",  p.body.rawContents.urlDecoded.decodeHTMLCharacterEntities		);
+ (INST) synonymsOf:(NSS*)word  { return [self define:word ofType:AZLexiconAppleThesaurus completion:NULL];	}
+ (INST) define:(NSS*)word   { return [self define:word ofType:AZLexiconAppleDictionary completion:NULL];	}
+ (INST) definitionFromDuckDuckGoOf:(NSS*)query { return [self define:query ofType:AZLexiconDuckDuckGo completion:NULL];	}

+ (INST) define:(NSString*)term ofType:(AZLexicon)lexicon completion:(AZDefinitionCallback)block {
	AZDefinition *n = AZDefinition.new;	n.lexicon = lexicon; n.word = term;	if (block != NULL) n.completion = [block copy];	[n rawResult];
	return n;
}

+ (NSSet*) keyPathsForValuesAffectingRawResult {  return NSSET(@"word", @"lexicon", @"completion"); }

- (NSString*) definition { return _definition ?: _results ? _results[0] : nil; }

- (NSURL*) query {  if (!_word || _lexicon == (AZLexicon)NSNotFound) return  nil;

	return  _lexicon == AZLexiconDuckDuckGo ? $URL($(@"http://api.duckduckgo.com/?q=%@&format=json", _word)) :
			  _lexicon == AZLexiconWiki 		 ? $URL($(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",_word)) : nil;
}

- (id) rawResult {

	if (_lexicon == AZLexiconDuckDuckGo || _lexicon == AZLexiconWiki)  {

		if (_lexicon == AZLexiconDuckDuckGo) {
			NSURLREQ *req 	= [NSURLREQ requestWithURL:self.query];	NSURLRES *res 	= nil;	NSError 	*err  = nil;
			NSData *data 	= [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
			_rawResult 		= (NSArray*)((NSD*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL])[@"RelatedTopics"];
			self.results   = [_rawResult count] ? [_rawResult vFKP:@"Text"] : nil;
		}
		if (_lexicon == AZLexiconWiki) {	__block NSError *requestError = nil;  __block NSS* wikiD = nil;
		
			_requester 							= [ASIHTTPRequest.alloc initWithURL:self.query];
			_requester.completionBlock 	= ^(ASIHTTPRequest *request) {	wikiD = request.responseString.copy; requestError = [request error];	};
			[_requester startSynchronous];
			AZHTMLParser *p		= [AZHTMLParser.alloc initWithString:wikiD error:nil];
			_rawResult = wikiD;
			NSString * stripped 	= [_rawResult stripHtml];																		// parseXMLTag:@"text"]);
			self.results  			= requestError 		?  @[$(@"Error: %@  headers: %@", requestError, _requester.responseHeaders)]
										: ![wikiD isEmpty]	?  @[[wikiD parseXMLTag:@"Description"]] : nil;
		}
		if (_results.count) _completion(self);
	}
	if (_lexicon == AZLexiconUrbanD) {
		JATLog(@"setting up AZLexiconUrbanD for {self.word}", self.word);
		ASIHTTPRequest *requester 	= [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
		requester.completionBlock 	= ^(ASIHTTPRequest *request) {
			NSS *responsePage      	= request.responseString.copy;
			NSError *requestError  	= [request error];
			if (requestError) { self.definition =  @"no response from urban"; return; }
			AZHTMLParser *p 	= [AZHTMLParser.alloc initWithString:responsePage error:&requestError];
			HTMLNode *title 	= [p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES];
			NSS *content	 	= [title getAttributeNamed:@"content"];
			HTMLNode *descN   = [p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES];
			self.definition = [descN getAttributeNamed:@"content"];
        ///rawContents.urlDecoded.decodeHTMLCharacterEntities);
			_completion(self);
		};
		[requester startAsynchronous];
	}

/* appleds
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
}
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


@end


NSString *TagsDefaultsKey = @"tags";

@implementation Tweet
@synthesize screenNameString, createdAtDate, createdAtString, tweetTextString;

- (id)initWithJSON:(NSDictionary *)JSONObject;
{
	if (self != super.init ) return nil;
	self.screenNameString 			= 					  JSONObject [@"from_user"];
	NSDateFormatter *dateFormatter 	= [NSDateFormatter.alloc 	 initWithProperties:
									@{ 	@"dateFormat" : @"EEE, d LLL yyyy HH:mm:ss Z",
										@"timeStyle"  : @(NSDateFormatterShortStyle),
										@"dateStyle"  : 	@(NSDateFormatterShortStyle),
										@"doesRelativeDateFormatting": 	  @(YES) }];
	self.createdAtDate 	 = [dateFormatter dateFromString:JSONObject[@"created_at"]];
	self.createdAtString = [dateFormatter stringFromDate:		self.createdAtDate];
	self.tweetTextString = 										JSONObject[@"text"];
	return self;
}

@end
	//
	//@dynamic  appCategories;// = _appCategories,
	//@dynamic  sortOrder;// = _sortOrder,
	//@dynamic  appFolderStrings;// = _appFolderStrings,
	//@dynamic  _dock;// = _dock,
	//@dynamic  dockSorted;// = _dockSorted,
	//@dynamic  appFolder;// = _appFolder,
	//@dynamic  appFolderSorted;// = _appFolderSorted;

@implementation SizeObj
@synthesize width, height;

+(id)forSize:(NSSize)sz{

	return [[self alloc]initWithSize:sz];
}
- (id)initWithSize:(NSSize)sz {
	if (self = [super init]) {
		width  = sz.width;
		height = sz.height;
	}
	return self;
}

- (NSSize)sizeValue {
	return NSMakeSize(width, height);
}
@end
