	//
	//  AZDock.m
	//  AtoZ
//	//
	//  Created by Alex Gray on 9/12/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AtoZModels.h"
#import "AtoZFunctions.h"

JREnumDefine(AZLexicon);

@implementation Definition

//+ (instancetype) definitionOf:(NSS*)wordOrNilForRand lexicon:(AZLexicon)lex completion:(DefinitionBlock)orNullForSync {


+ (instancetype) definitionFromWikipediaOf:(NSS*)query { 
 
 	__block NSS* wikiD = nil;  __block  NSError *requestError;
	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",query))];
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];
*/
	[requester setCompletionBlock:^(ASIHTTPRequest *request) {
              	wikiD               = request.responseString.copy;
					requestError    = [request error];
	}];
	[requester startSynchronous];
   AZHTMLParser *p = [AZHTMLParser.alloc initWithString:wikiD error:nil];
		
	
//	return $(@"POOP: %@",  p.body.rawContents.urlDecoded.decodeHTMLCharacterEntities
//	);
	requester.responseString.stripHtml;// parseXMLTag:@"text"]);
	Definition *w = self.instance;
	w.word = query;
	w.lexicon = AZLexiconWiki;
	if (requestError) {
	
	 	 w.definition = $(@"Error: %@  headers: %@", requestError, [requester responseHeaders]);
	}
	else if (![wikiD loMismo: @"(null)"])   { 
			w.definition = [wikiD parseXMLTag:@"Description"];
	}
	return w;
//			NSLog(@"found wiki for: %@, %@", self, wikiD); return [wikiD parseXMLTag:@"Description"]; }
//	else return $(@"code: %i no resonse.. %@", requester.responseStatusCode, [requester responseHeaders]);
//		NSS* result = nil;
//	NSS* try = ^(NSS*){ return [NSS stringWithContentsOfURL: };
	//	@"https://www.google.com/search?client=safari&rls=en&q=%@&ie=UTF-8&oe=UTF-8", );
//	while (!result) [@5 times:^id{

}

//+ (instancetype) 
+ (instancetype) definitionFromDuckDuckGoOf:(NSS*)query {

	NSS *url 		= [NSS stringWithFormat:@"http://api.duckduckgo.com/?q=%@&format=json", query];
	NSURLREQ *req 	= [NSURLREQ requestWithURL:$URL(url)];
	NSURLRES *res 	= nil;
	NSError 	*err  = nil;
	Definition *w = self.instance;
	w.word = query;
	w.lexicon = AZLexiconWiki;

	NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
	
	w.definition = err ? @"Error."  : ^{
	
		NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
	NSArray *rel = [results vFK:@"RelatedTopics"];
	return rel.count ? rel[0][@"Text"] : @"No results";
	}();
	return w;
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
