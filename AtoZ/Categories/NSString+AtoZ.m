
//  NSString+AtoZ.m
//  AtoZ
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSString+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSArray+AtoZ.h"
#import "AtoZFunctions.h"
#import "RuntimeReporter.h"
#import "AtoZ.h"
#import <CommonCrypto/CommonDigest.h>
#define kMaxFontSize	10000
#import "HTMLNode.h"


@implementation Definition
@end


@implementation NSString (MD5)
- (NSString *)MD5String
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}
//	struct MD5Context ctx;
//	const unsigned char *utf8str = (unsigned char *)[self UTF8String];
//	unsigned char digest[16];
//	int i;
//	unsigned char *md5str;
//	NSString *ret = nil;
//	// Make MD5 hash in hex-string form.
//	MD5Init(&ctx);
//	MD5Update(&ctx, utf8str, strlen(utf8str));
//	MD5Final(digest, &ctx);
//
//	md5str = malloc(33); // 2 * 16 + 1 for null
//
//	for(i = 0; i < 16; i++) 	sprintf(&md5str[i * 2], "%02x", digest[i]);
//	md5str[32] = '\0';
//	ret = [NSString stringWithUTF8String:md5str];
//	free(md5str);
//	return ret;
//}
@end

//  Copyright 2011 Leigh McCulloch. Released under the MIT license.
@interface NSString_stripHtml_XMLParsee : NSObject<NSXMLParserDelegate> {
@private
	NSMutableArray* strings;
}
- (NSString*)getCharsFound;
@end
@implementation NSString_stripHtml_XMLParsee
- (id)init
{
	if (!(self = [super init])) return nil;
	strings = NSMA.new;
	return self;
}
- (void)dealloc	{	[strings release];	}
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {		[strings addObject:string];	}
- (NSString*)getCharsFound {	return [strings componentsJoinedByString:@""];	}
@end

@implementation NSString (AtoZ)


- (NSComparisonResult)compareNumberStrings:(NSString *)str {
	NSNumber * me = [NSNumber numberWithInt:[self intValue]];
	NSNumber * you = [NSNumber numberWithInt:[str intValue]];	
	return [you compare:me];
}

- (NSS*) justifyRight:(NSUI)col;
{
	NSS* str = self;
	int add = col - str.length;
	if (add > 0) {
		NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
		str = [pad stringByAppendingString:str];
	}
	return str;
}

- (NSS*) unescapeUnicodeString
{
	// unescape quotes and backwards slash
	NSString* unescapedString = [self stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
	unescapedString = [unescapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
	
	// tokenize based on unicode escape char
	NSMutableString* tokenizedString = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:unescapedString];
	while ([scanner isAtEnd] == NO)
	{
		// read up to the first unicode marker if a string has been scanned, it's a token and should be appended to the tokenized string
		NSString* token = @"";
		[scanner scanUpToString:@"\\u" intoString:&token];
		if (token != nil && token.length > 0)
		{
			[tokenizedString appendString:token];
			continue;
		}
		// skip two characters to get past the marker check if the range of unicode characters is beyond the end of the string (could be malformed) and if it is, move the scanner to the end and skip this token 
		NSUInteger location = [scanner scanLocation];
		NSInteger extra = scanner.string.length - location - 4 - 2;
		if (extra < 0)
		{
			NSRange range = {location, -extra};
			[tokenizedString appendString:[scanner.string substringWithRange:range]];
			[scanner setScanLocation:location - extra];
			continue;
		}
		// move the location pas the unicode marker then read in the next 4 characters
		location += 2;
		NSRange range = {location, 4};
		token = [scanner.string substringWithRange:range];
		unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
		[tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
		// move the scanner past the 4 characters then keep scanning
		location += 4;
		[scanner setScanLocation:location];
	}
	return tokenizedString;
}

- (NSString*) escapeUnicodeString 
{
	// lastly escaped quotes and back slash
	// note that the backslash has to be escaped before the quote
	// otherwise it will end up with an extra backslash
	NSString* escapedString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
	escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	
	// convert to encoded unicode
	// do this by getting the data for the string
	// in UTF16 little endian (for network byte order)
	NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
	size_t bytesRead = 0;
	const char* bytes = data.bytes;
	NSMutableString* encodedString = [NSMutableString string];
	
	// loop through the byte array
	// read two bytes at a time, if the bytes
	// are above a certain value they are unicode
	// otherwise the bytes are ASCII characters
	// the %C format will write the character value of bytes
	while (bytesRead < data.length)
	{
		uint16_t code = *((uint16_t*) &bytes[bytesRead]);
		if (code > 0x007E)
		{
			[encodedString appendFormat:@"\\u%04X", code];
		}
		else
		{
			[encodedString appendFormat:@"%C", code];
		}
		bytesRead += sizeof(uint16_t);
	}
	
	// done
	return encodedString;
}


- (NSS*) w_NP_String:(NSS*)string;
{
	return [self withString:$(@"\n\n%@", string)];
}

- (NSS*) w_String:(NSS*)string;
{
	return [self withString:$(@" %@", string)];
}
- (NSS*) withString:(NSS*)string;
{
	return [self stringByAppendingString:string];

}
- (NSString *)JSONRepresentation
{
	__block NSMutableString *jsonString =@"\"".mutableCopy;
	
	// Build the result one character at a time, inserting escaped characters as necessary
	[[NSArray from:0 to:self.length] eachWithIndex:^(id obj, NSInteger i) {
		unichar nextChar = [self characterAtIndex:i];
		switch (nextChar) {
			case '\"':
				[jsonString appendString:@"\\\""];
				break;
			case '\\':
				[jsonString appendString:@"\\n"];
				break;
			case '/':
				[jsonString appendString:@"\\/"];
				break;
			case '\b':
				[jsonString appendString:@"\\b"];
				break;
			case '\f':
				[jsonString appendString:@"\\f"];
				break;
			case '\n':
				[jsonString appendString:@"\\n"];
				break;
			case '\r':
				[jsonString appendString:@"\\r"];
				break;
			case '\t':
				[jsonString appendString:@"\\t"];
				break;
			// note: maybe encode unicode characters? Spec allows raw unicode.
			default:
				if (nextChar < 32) // all ctrl chars must be escaped
					[jsonString appendString:[NSString stringWithFormat:@"\\u%04x", nextChar]];
				else
					[jsonString appendString:[NSString stringWithCharacters:&nextChar length:1]];
				break;
		}
	}];
	[jsonString appendString:@"\""];
	return jsonString;
}
+ (NSS*) stringFromArray:(NSA*)a; { return a.count == 0 ? nil : [a reduce:@"" withBlock:^id(id sum, id obj) {
		return [sum stringByAppendingString:$(@" %@",obj)];
	}];
}

+ (NSS*) dicksonParagraphWith:(NSUI)sentences { return [self stringFromArray:[self.dicksonPhrases.shuffeled withMaxItems:sentences]]; }
+ (NSA*) dicksonPhrases { return [self.dicksonBible extractAllSentences]; };
+ (NSA*) dicksonisms {		static NSA* dicks = nil;		return dicks = dicks ? dicks : @[
		 @"When I was 10 years old - I wore this dress; I just keep getting it altered.",  @"See? I still fit into my 10-year-old clothing.", @"Look at that! Oh, is that me on the wall? I drew it myself - with chalk!",
		  @"I can't move, but boy, can I ever pose!", @"I wish there was a close up on my face.. there it is! <<sighing>> Wow, looking better and better all the time.",
		  @"That's a - beret - it's from Europe.", @"I really shouldn't be doing this; but I'm going to have an ad for IKEA right now.",
		  @"This is a complete IKEA closet.  The bed is underneath my pants.", @"If you have a look - you can see that everything fits - into this particle board.   You just paint it white.. pull it out... oh gold and silver! (those are my two signature colors.)"];
}
+ (NSS*) dicksonBible { return  @"When do I look at the camera?  When do I look? <gasp> Hi, what a surprise that you're here.  Welcome... to my bathroom.  My fingers are.. fused together. My thumb was broken... in.. an... acting.. accident..  I can't wait to show you more of my face. Look at my face. 	There's my face, there's my face!  That's not my body... but this is my.. FACE. Here are four looks. I have four different emotions - they may seem the same.. oh there's my high school grad picture.. and my picture from Woolworth's!I like to stare blankly into space.  <<chuckle>> that's something I do. When I was 10 years old - I wore this dress; I just keep getting it altered.  See? I still fit into my 10-year-old clothing. Look at that! Oh, is that me on the wall? I drew it myself - with chalk!  I can't move, but boy, can I ever pose!  I wish there was a close up on my face.. there it is! <<sighing>> Wow, looking better and better all the time. That's a - beret - it's from Europe.  I really shouldn't be doing this; but I'm going to have an ad for IKEA right now.  This is a complete IKEA closet.  The bed is underneath my pants. If you have a look - you can see that everything fits - into this particle board.   You just paint it white.. pull it out... oh gold and silver! (those are my two signature colors.)	What are legs good for? They're not good for pants.. they're good for sitting!   It's after Labor Day and I am wearing white. This is a very comfortable pose. This is how all the models do it. This is called boobies.		And this is another picture of my FACE. I liked putting Vaseline on the lens; it erases all lines that one may have on their face.  It's a fashion face; a face full of fashion.	I eat so much fowl - I shit feathers!It's winter - so I wear pantyhose with my open-toed sandals.I hope I never get arrested for not leaving a premises which is no longer mine!	I still I look like a teenager, don't I?  Well, thankfully my herpes is in remission, right now.  Look, no blisters, not one!  Just a cold sore!  Oh, that's herpes.  Oh, It's back.	I like to fill my breasts with photos of myself; one's bigger than the other...  because my hair is - greater on one side.  This is live video footage of me.I don't blink; that's a huge part of fashion. Breathe in my eye - just some air, nothing.  I do not blink.  Not at all.  Good for me!		Here's what happens when I go down on my knees. I'm bending down right now, and I'm on my knees. There, I'm on my knees right now. I can really stay on my knees a very long time - huge part of fashion.		The look this season is clothes that don't fit correctly. These pants are way too tight, not my size. This top is completely not my size.  Isn't it fashion?!		This top doesn't fit at all <<awkward chuckle>>		These boots don't fit.  I wonder if belts fit?  No, the belt does not fit either.  <<sigh>>		Oh, these boots fit, but the purse is the wrong size (I got this from Pic-N-Save)  I'll tell you.. their Halloween collection.. not a lot to be desired... <<creepy sigh>>		This is an oversized top. These are my breasts. I have two of them.  I even 'out' my breasts on my own; it's still the same Wol-Co. photo from earlier.  I just cropped it to make it larger.. oh I cropped it again... I'm really, really good with scissors. I'll tell you that much.		Here's what I wear too bed. It's, it's like a trap - a spider trap. I get them into my bu'drow... and then I, I eat their head off.  They're absolutely delicious!		I always wanted to be on dynasty... but here's two things: and nipple and a tertiary nipple.  I have two nipples. Uh, My tummy does not have any support right now - that's just me.  And white shoes.. It's before - and after Labor Day.		I wanted to show you this necklace.  I'm wearing a gold necklace - umm, with diamonds - I wear it every single shot - every single one.  Watch this...  Prest-o Change-o!  Let's go up a little bit.. Let me get on my knees - I'm going down.  Look what's there! It's a heart diamond necklace! If you see on my left- umm right-hand side..  That's My kitty cat - I named it Chester.. and I.. he was absolutely delicious.		And and I'm also part of aChipapeantribe...  I thought I looked very.. native.. North American in this. Uh, I like to bring out my culture, my taste... oh, uh, when you open your legs, ladies - watch the Seaguls...  Sometimes they come a-flock and - they're your friends, too!  I.. could... make a hat out of most of them.		Let's open the microwave and see what I've made. Enjoy some popcorn - absolutely yumms. Yes, I do eat solid foods. But I have four microwaves stacked on top of each other for when company comes over. My door is always welcome to you.   For Halloween I'm going to dress up as.. a Hooker!  Won't that be fun!? Look at all the choices that I have!  Oh, the kids just love it.ABCDEF..GHIJKL.. M..N..OPQRS.. oh what's next, I can't remember what's next, UVWX.Y.Z! I wish I was Jacqueline Smith.. but I'm not... so here's my face double..   Okay - I like to put makeup over my makeup.. and then tattoo my makeup on. I got it from Pic-N-Save. I'm already tattooed, but you can never have enough, you know, can you?  awkakwaka.		My schedule is free so I'm available for donkey shows.. for grand openings.. for sales...  I'm good at telemarketing - and flourishes - watch the hand. So - you know, for Halloween this is how we're going to look. Some people use it as a daily look.  It's Halloween everday in my house - every single day!Welcome, Sorry I'm late... I gave myself a camel toe - and not the Dorothy Hamill kind."; }

+ (NSS*) randomWord
{
	NSURLRequest* request = [NSURLRequest requestWithURL:$URL(@"http://randomword.setgetgo.com/get.php") cachePolicy:0 timeoutInterval:5];
	NSURLResponse* response=nil;	NSError* error=nil;
	NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSS*theWord = data ? [NSString stringWithData:data encoding:NSUTF8StringEncoding] : @"Timeout!";
	return [theWord stringByTrimmingWhiteSpace];
}
//return ((NSS*)[NSS stringWithContentsOfURL: encoding:NSUTF8StringEncoding error:nil]).trim; }

+ (NSS*) randomWiki
{
	__block NSS* wiki; __block NSS *word;  NSUI tries = 10; [[NSA from:0 to:tries] az_eachConcurrentlyWithBlock:^(NSI index, id obj, BOOL *stop) {

		NSS *rando = NSS.randomWord.trim;
		NSS *randoWiki = rando.wikiDescription;
		if (randoWiki) {  wiki = randoWiki;  word = rando;  *stop = YES; }
		return;
	}];
	return $(@"%@:  %@", word, wiki);
}

- (NSS*)wikiDescription	{
	__block NSS* wikiD;
	__block NSError *requestError;
	NSS*wikiPage = 	[NSS stringWithContentsOfURL:$URL($(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",self)) encoding:NSUTF8StringEncoding  error:&requestError];
	//http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=%@&MaxHits=1",self)) encoding:NSUTF8StringEncoding  error:&requestError]; //NSASCIIStringEncoding
	return requestError ? $(@"Error parsing wiki: %@", requestError) : [wikiPage parseXMLTag:@"Description"].stringByDecodingXMLEntities;  // $(@"%@: %@", self,
}

+ (NSS*) randomBadWord { return [self badWords].randomElement; }

+ (NSA*) badWords {	static NSA *swearwords = nil;
								swearwords = swearwords ?: [NSA arrayFromPlist:[AZFWRESOURCES withPath:@"BadWords.plist"]];
								return swearwords;
}

- (NSS*)paddedTo:(NSUI) count { return [self stringByPaddingToLength:count withString:@" " startingAtIndex:0]; }

+ (NSA*) properNames {

	NSS* names = @"/usr/share/dict/propernames";
	return [[[self stringWithContentsOfFile:names usedEncoding:NULL error:NULL] componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet]
		sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

+ (void) randomUrabanDBlock:(void(^)(Definition* definition))block {

	__block Definition *urbanD;
	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
	[requester setCompletionBlock:^(ASIHTTPRequest *request) {

		NSS* responsePage 		= request.responseString.copy;
	 	NSError *requestError 	= [request error];
		if (!requestError) {
			AZHTMLParser *p	= 	[AZHTMLParser.alloc initWithString:responsePage error:&requestError];
			NSS *title 			=	[[p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES]
										 																			getAttributeNamed:@"content"];
			NSS *desc			= 	[[p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES]
																															getAttributeNamed:@"content"];
			urbanD = $DEFINE(  title, desc );///rawContents.urlDecoded.decodeHTMLCharacterEntities);
			block (urbanD);
		} else urbanD = $DEFINE( @"undefined", @"no response from urban" );
	}];
	[requester startAsynchronous];
}

+ (Definition*) randomUrbanD;
{
	__block Definition *urbanD;
	
	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
	[requester setCompletionBlock:^(ASIHTTPRequest *request) {

		NSS* responsePage = request.responseString.copy;
//		NSLog(@"Response:%@", responsePage);
	 	NSError *requestError 	= [request error];
		if (!requestError) {
			AZHTMLParser *p = [AZHTMLParser.alloc initWithString:responsePage error:&requestError];
			NSS *title 	= 	[[p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES] getAttributeNamed:@"content"];
			NSS *desc	= 	[[p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES] getAttributeNamed:@"content"];
//			NSLog(@"title: %@  desc: %@", title, desc );
			urbanD = $DEFINE(  title, desc );///rawContents.urlDecoded.decodeHTMLCharacterEntities);
		} else urbanD = $DEFINE( @"undefined", @"no response from urban" );
	}];
	[requester startAsynchronous];
	return urbanD;
}



//	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",self))];
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];
	[requester setCompletionBlock:^(ASIHTTPRequest *request) {
		wikiD 				= request.responseString.copy;
		requestError 	= [request error];
	}];
	[requester startSynchronous];
	AZHTMLParser *p = [AZHTMLParser.alloc initWithString:wikiD error:nil];
	return $(@"POOP: %@",p.body.rawContents.urlDecoded.decodeHTMLCharacterEntities);
*/
	///requester.responseString.stripHtml;// parseXMLTag:@"text"]);
//	if (requestError) return  $(@"Error: %@  headers: %@", requestError, [requester responseHeaders]);
//	else if (![wikiD loMismo: @"(null)"])   { NSLog(@"found wiki for: %@, %@", self, wikiD); return [wikiD parseXMLTag:@"Description"]; }
//	else return $(@"code: %i no resonse.. %@", requester.responseStatusCode, [requester responseHeaders]);
//		NSS* result = nil;
//	NSS* try = ^(NSS*){ return [NSS stringWithContentsOfURL: };
//	//	@"https://www.google.com/search?client=safari&rls=en&q=%@&ie=UTF-8&oe=UTF-8", );
//	while (!result) [@5 times:^id{ 


- (BOOL) loMismo:(NSS*)s { return  [self isEqualToString:s]; }

-(NSString *) stringByStrippingHTML {
	NSRange r;
	NSString *s = [[self copy] autorelease];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;
}
- (NSS*) parseXMLTag:(NSS*)tag;	{	return [self substringBetweenPrefix:$(@"<%@>", tag) andSuffix:$(@"</%@>",tag)]; }
//
//	NSScanner *theScanner;
//	NSString *text = nil;
//	NSS* html = self.copy;
//
//	theScanner = [NSScanner scannerWithString:html];
//	while ([theScanner isAtEnd] == NO) {
//
//		// find start of tag
//		[theScanner scanUpToString:$(@"<%@>",tag) intoString:NULL] ;
//		// find end of tag
//		[theScanner scanUpToString:@">" intoString:&text] ;
//
//		// replace the found tag with a space
//		//(you can filter multi-spaces out later if you wish)
//		html = [html stringByReplacingOccurrencesOfString:
//				[ NSString stringWithFormat:@"%@>", text]
//											   withString:@" "];
//	} // while //
//
//	// trim off whitespace
//	return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
//}
- (NSS*) unescapeQuotes; {

	return [self stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

- (NSS*) stringByCleaningJSONUnicode {

	// Remove unsafe JSON characters
	//
	// http://www.jslint.com/lint.html#unsafe
	//
	NSMutableString * jsonStr = self.mutableCopy;
	if (jsonStr.length > 0) {
		NSMutableCharacterSet *unsafeSet = [NSMutableCharacterSet new];
		void (^addUnsafe)(NSInteger, NSInteger) = ^(NSInteger from, NSInteger to) {
			if (to > from) {
				[unsafeSet addCharactersInRange:NSMakeRange(from, (to - from) + 1)];
			} else {
				[unsafeSet addCharactersInRange:NSMakeRange(from, 1)];
			}
		};

		addUnsafe(0x0000, 0x001f);
		addUnsafe(0x007f, 0x009f);
		addUnsafe(0x00ad, 0);
		addUnsafe(0x0600, 0x0604);
		addUnsafe(0x070f, 0);
		addUnsafe(0x17b4, 0);
		addUnsafe(0x17b5, 0);
		addUnsafe(0x200c, 0x200f);
		addUnsafe(0x2028, 0x202f);
		addUnsafe(0x2060, 0x206f);
		addUnsafe(0xfeff, 0);
		addUnsafe(0xfff0, 0xffff);

		return [[jsonStr componentsSeparatedByCharactersInSet:unsafeSet] componentsJoinedByString:@""];
	}
	return self;
}

- (NSString *)stringByDecodingXMLEntities {
	NSUInteger myLength = [self length];
	NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
	// Short-circuit if there are no ampersands.
	if (ampIndex == NSNotFound) {
		return self;
	}
	// Make result string with some extra capacity.
	NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
	// First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
	do {
		// Scan up to the next entity or the end of the string.
		NSString *nonEntityString;
		if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
			[result appendString:nonEntityString];
		}
		if ([scanner isAtEnd]) {
			goto finish;
		}
		// Scan either a HTML or numeric character entity reference.
		if ([scanner scanString:@"&amp;" intoString:NULL])
			[result appendString:@"&"];
		else if ([scanner scanString:@"&apos;" intoString:NULL])
			[result appendString:@"'"];
		else if ([scanner scanString:@"&quot;" intoString:NULL])
			[result appendString:@"\""];
		else if ([scanner scanString:@"&lt;" intoString:NULL])
			[result appendString:@"<"];
		else if ([scanner scanString:@"&gt;" intoString:NULL])
			[result appendString:@">"];
		else if ([scanner scanString:@"&#" intoString:NULL]) {
			BOOL gotNumber;
			unsigned charCode;
			NSString *xForHex = @"";
			// Is it hex or decimal?
			if ([scanner scanString:@"x" intoString:&xForHex]) {
				gotNumber = [scanner scanHexInt:&charCode];
			}
			else {
				gotNumber = [scanner scanInt:(int*)&charCode];
			}
			if (gotNumber) {
				[result appendFormat:@"%C", (unichar)charCode];
				[scanner scanString:@";" intoString:NULL];
			}
			else {
				NSString *unknownEntity = @"";
				[scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];

				[result appendFormat:@"&#%@%@", xForHex, unknownEntity];
				//[scanner scanUpToString:@";" intoString:&unknownEntity];
				//[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
				NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
			}
		}
		else {
			NSString *amp;
			[scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
			[result appendString:amp];
			/*
			 NSString *unknownEntity = @"";
			 [scanner scanUpToString:@";" intoString:&unknownEntity];
			 NSString *semicolon = @"";
			 [scanner scanString:@";" intoString:&semicolon];
			 [result appendFormat:@"%@%@", unknownEntity, semicolon];
			 NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
			 */
		}
	}
	while (![scanner isAtEnd]);
finish:
	return result;
}
- (NSS*)withPath:(NSS*)path { return [self stringByAppendingPathComponent:path]; }
- (NSS*)withExt: (NSS*)ext; { return [self stringByAppendingPathExtension:ext];  }

- (NSString*)stripHtml {
	// take this string obj and wrap it in a root element to ensure only a single root element exists
	NSString* string = (@"<root>%@</root>", self);
	// add the string to the xml parser
	NSStringEncoding encoding = string.fastestEncoding;
	NSData* data = [string dataUsingEncoding:encoding];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	// parse the content keeping track of any chars found outside tags (this will be the stripped content)
	NSString_stripHtml_XMLParsee* parsee = NSString_stripHtml_XMLParsee.new;
	parser.delegate = parsee;		[parser parse];
	NSError * error = nil;	// log any errors encountered while parsing
	if((error = [parser parserError])) { NSLog(@"This is a warning only. There was an error parsing the string to strip HTML. This error may be because the string did not contain valid XML, however the result will likely have been decoded correctly anyway.: %@", error);	}
	// any chars found while parsing are the stripped content
	NSString* strippedString = [parsee getCharsFound];
	// clean up
	[parser release];	[parsee release];
	// get the raw text out of the parsee after parsing, and return it
	return strippedString;
}
+ (NSString*)clipboard
{
	NSPasteboard* pasteboard = [NSPasteboard generalPasteboard] ;
	NSArray* supportedTypes = [NSArray arrayWithObject:NSStringPboardType] ;
	NSString* type = [pasteboard availableTypeFromArray:supportedTypes] ;
	NSString* value = [pasteboard stringForType:type];
	return value ;
}
- (void)copyToClipboard {
	NSPasteboard* pasteboard = [NSPasteboard generalPasteboard] ;
	[pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]
					   owner:nil] ;
	// Above, we can say owner:nil since we are going to provide data immediately
	[pasteboard setString:self
				  forType:NSStringPboardType] ;
}

- (unichar)lastCharacter {
	return [self characterAtIndex:([self length] - 1)];
}
- (NSString*)substringToLastCharacter {
	return [self substringToIndex:([self length] - 1)];
}
/*
 - (id)decodeAllPercentEscapes {
 NSString *cocoaWay =
 NSString* cfWay = CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, [self UTF8String], CFSTR(""));
 NSString* cocoaWay = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 if(![cfWay isEqualToString:cocoaWay]) {
 NSLog(@"[%@ %s]: CF and Cocoa different for %@", [self class], sel_getName(_cmd), self);
 }
 return cfWay;
 }*/
- (NSString*)decodeAllAmpersandEscapes {
	return [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}
- (NSNumber*)numberValue {
	return [[[NSNumberFormatter alloc] init] numberFromString:self];
}
- (void) copyFileAtPathTo:(NSString*)path
{
	if ( [[NSFileManager defaultManager] isReadableFileAtPath:self] )
		[[NSFileManager defaultManager] copyItemAtPath:self toPath:path error:nil];
}

- (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSString *)fontName;
{
	return [[self class] pointSizeForFrame:frame withFont:fontName forString:self];
}
+ (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSString *)fontName forString:(NSString*)string;
{
	NSFont * displayFont = nil;
	NSSize stringSize = NSZeroSize;
	NSUInteger fontLoop = 0;
	NSMutableDictionary * fontAttributes = [[NSMutableDictionary alloc] init];
	if (frame.size.width == 0.0 && frame.size.height == 0.0) return 0.0;
	for (fontLoop = 1; fontLoop <= kMaxFontSize; fontLoop++) {
		displayFont = [[NSFontManager sharedFontManager] convertWeight:YES ofFont:[NSFont fontWithName:fontName size:fontLoop]];
		fontAttributes[NSFontAttributeName] = displayFont;
		stringSize = [string sizeWithAttributes:fontAttributes];
		if ( (stringSize.width > frame.size.width) || (stringSize.height > frame.size.height) )	break;
	}
	[fontAttributes release], fontAttributes = nil;
	return (CGFloat)fontLoop - 1.0;
}

- (NSString *)stringByReplacingAllOccurancesOfString:(NSString *)search withString:(NSString *)replacement
{
	return [NSString stringWithString:[[self mutableCopy]replaceAll:search withString:replacement]];
}
- (NSString*)urlEncoded { 	// Encode all the reserved characters, per RFC 3986
//	CFStringRef escaped =
//	return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//											(CFStringRef)self, NULL,
//											(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
//@"~!@#$%^&*():{}\"€!*’();:@&=+$,/?%#[]",
	return (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(	NULL, (CFStringRef)self, NULL,
				(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
}
-(NSString*) urlDecoded {
	NSMutableString *resultString = [NSMutableString stringWithString:self];
	[resultString replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range: (NSRange) {0, [resultString length]}];
	return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)firstLetter {	return [self substringWithRange:NSMakeRange(0, 1)]; }
+ (NSString *)newUniqueIdentifier
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);	CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);						return AH_RETAIN(CFBridgingRelease(identifier));
}
+ (NSString *)randomAppPath
{
	return [[[[NSWorkspace sharedWorkspace]launchedApplications]valueForKeyPath:@"NSApplicationPath"]randomElement];
}
+ (NSS*) randomDicksonism {  return self.dicksonisms.randomElement; }
+ (NSString*) randomWords:(NSInteger)number;
{
	return [[LoremIpsum new] words:number];
}
+ (NSString*) randomSentences:(NSInteger)number;
{
	return [[LoremIpsum new] sentences:number];
}
//- (NSColor *)colorValue {	return [NSColor colorFromString:self]; }
-(NSData*) colorData {	return [NSArchiver archivedDataWithRootObject:self]; }
+ (NSColor*) colorFromData:(NSData*)theData {	return  [NSUnarchiver unarchiveObjectWithData:theData];}
//- (void)drawCenteredInRect:(CGRect)rect withFontNamed:(NSFont *)font
//{
//	CGSize size = CGSizeMake(20.0f, 400.0f); // [self sizeWithAttributes: //sizeWithFont:font];
//	CGRect textBounds = [self rectWithFont:[]
//
//	(CGRect) { rect.origin.x + (rect.size.width - size.width) / 2,
//								   rect.origin.y + (rect.size.height - size.height) / 2,
//								   size.width, size.height };
//	[self drawCenteredInRect:textBounds withFont:font.fontName];
//}
//- (void) drawCenteredInRect: (NSR)rect withFontNamed: (NSS*) font;
- (void) drawCenteredInRect: (NSR)rect withFont: (NSF*) font
{

//- (void)drawCenteredInFrame:(NSRect)frame withFont:(NSF*)font {
//	NSView *view = framer;
//	NSSize size = view.frame.size;// WithFont:font;
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:self attributes:@{font:NSFontAttributeName,NSFontSizeAttribute: @(font.pointSize)} ];
//	CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
//								   rect.origin.y + (rect.size.height - size.height) / 2,
//								   size.width, size.height);
	[string drawCenteredVerticallyInRect:rect];// withFontNamed:font.fontName andColor:WHITE];//@{font:NSFontNameAttribute }];
}
- (void) drawInRect:(NSRect)r withFont:(NSFont*)font andColor:(NSColor*)color {
	 [self drawInRect:r withFontNamed:font.fontName andColor:color];
}

- (NSSZ) sizeWithFont:(NSFont*)font margin:(NSSZ)size;
{
	NSSZ sz = [self sizeWithFont:font];
	sz.width += 2 * size.width;
	sz.height += 2 * size.height;
	return sz;
}
- (NSSZ) sizeWithFont:(NSFont*)font;
{
	NSD *attrs = [NSD dictionaryWithObjectsAndKeys: font,NSFontAttributeName, nil];
	NSAttributedString *s =[[NSAttributedString alloc]initWithString:self attributes:attrs];
	return [s  size];
}

- (CGF) widthWithFont:(NSF*)font
{
	return [self sizeWithFont:font margin:NSMakeSize(font.pointSize/2,font.pointSize/2)].width;
}
- (NSR) frameWithFont:(NSF*)font
{
	return AZRectFromSize( [self sizeWithFont:font margin:NSMakeSize(font.pointSize/2, font.pointSize/2)] );
}

- (void) drawInRect:(NSRect)r withFontNamed:(NSS*)fontName andColor:(NSColor*)color
{
	NSMPS *paraAttr = [[NSMPS defaultParagraphStyle ] mutableCopy];
	[paraAttr setAlignment:NSCenterTextAlignment];
	[paraAttr setLineBreakMode:NSLineBreakByTruncatingTail];
	CGFloat points 	= [self pointSizeForFrame:r withFont:fontName];
	NSF* fnt 		= [NSFont fontWithName:fontName size:points] ?: [AtoZ font:fontName size:points] ?: [NSFont fontWithName:@"Helvetica" size:points];

	NSAS *drawingString = [[NSAS alloc]  initWithString:self attributes:@{	NSFontAttributeName				: fnt,
																			NSForegroundColorAttributeName	: color,
																			NSParagraphStyleAttributeName	: paraAttr}];
	[drawingString drawInRect:r];
}
//		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
////		[paraStyle setParagraphStyle:	[NSParagraphStyle defaultParagraphStyle]];
////		[paraStyle setAlignment:		NSCenterTextAlignment];
//		NSDictionary *msgAttrs = @{ 	   NSFontAttributeName : font.fontName,
//										   NSFontSizeAttribute : $(@"%f",(float)[font pointSize]),
//								 NSParagraphStyleAttributeName : paraStyle };
//	 @{ NSParagraphStyleAttributeName : style,  NSFontNameAttribute : font.fontName,  : @(font.pointSize)}];

////	NSMutableParagraphStyle* style =
//	NSParagraphStyle* style =	[[NSParagraphStyle alloc]initWithProperties: @{ NSParagraphStyleAttributeName :NSCenterTextAlignment }];
//	][style setAlignment:NSCenterTextAlignment];
//	@{ style : NSParagraphStyleAttributeName};
//	[myString drawInRect:someRect withAttributes:attr];
//	[style release];
//}
- (NSString*)trim {	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; }
- (NSString *)shifted {	return [self substringFromIndex:1]; }
- (NSString *)popped { 	return [self substringWithRange:NSMakeRange(0, self.length - 1)];	}
- (NSString *)chopped {	return [self substringWithRange:NSMakeRange(1, self.length - 2)];	}
- (NSString *)camelized {	return [[self mutableCopy] camelize];	}
- (NSString *)hyphonized {	return [[self mutableCopy] hyphonize];	}
- (NSString *)underscored {	return [[self mutableCopy] underscorize]; }
- (BOOL)isEmpty { 	 return (self == nil || [self isKindOfClass:[NSNull class]]
							 			 || [self.trim isEqualToString:@""]
							 			 || ([self respondsToSelector:@selector(length)] && ([(NSData *)self length] == 0))
							 			 || ([self respondsToSelector:@selector(count)] && ([(NSArray *)self count] == 0)));
}
/*** Actually this should be called stringByReversingThisString, but that appeared to be too much sugar-free.  Reverse ist non-destructive */
- (NSString *)reversed	{		NSMutableString *re = NSMutableString.string;
								for (int i = self.length - 1; i >= 0; i--)
									[re appendString:[self substringWithRange:NSMakeRange(i, 1)]];	return re;
}
- (NSUInteger)count:(NSString *)s options:(NSStringCompareOptions)mask
{
	NSUInteger re = 0;	NSRange rr, r; r = (NSRange) { 0, self.length };
	while ((rr = [self rangeOfString:s options:mask range:r]).location != NSNotFound) {		re++;
		r.location = rr.location + 1; 	r.length = self.length - r.location; }				return re;
}
- (NSUInteger)count:(NSString *)aString {	return [self count:aString options:0];	}
- (NSUInteger)indentationLevel
{
	NSUInteger re = 0;
	while (re < self.length && [[self substringWithRange:NSMakeRange(re, 1)] isEqualToString:@" "])		re++;
	return re;
}
- (BOOL)contains:(NSString *)aString {
	return [self rangeOfString:aString].location != NSNotFound;
}
- (BOOL)containsAnyOf:(NSArray *)array
{
	for (id v in array) {	  NSString *s = [v description];
		if ([v isKindOfClass:[NSString class]]) s = (NSString *)v;
		if ([self contains:s]) 	return YES;
	}	return NO;
}
- (BOOL)containsAllOf:(NSA*) array {
	for (id v in array) {		NSString *s = [v description];
		if ([v isKindOfClass:[NSString class]]) s = (NSString *)v;
		if (![self contains:s])	return NO;
	}
	return YES;
}
- (BOOL)startsWith:(NSString *)aString {	return [self hasPrefix:aString];	}
- (BOOL)endsWith:(NSString *)aString {	return [self hasSuffix:aString];	}
- (BOOL)hasPrefix:(NSString *)prefix andSuffix:(NSString *)suffix {	return [self hasPrefix:prefix] && [self hasSuffix:suffix];	}
- (NSString *)substringBetweenPrefix:(NSString *)prefix andSuffix:(NSString *)suffix
{
	NSRange pre = [self rangeOfString:prefix];
	NSRange suf = [self rangeOfString:suffix];
	if (pre.location == NSNotFound || suf.location == NSNotFound) return nil;
	NSUInteger loc = pre.location  + pre.length;
	NSUInteger len = self.length - loc - (self.length - suf.location);
	//NSLog(@"Substring with range %i, %i, %@", loc, len, NSStringFromRange(r));
	return [self substringWithRange: (NSRange) {loc, len}];
}
/*** Unlike the Object-C default rangeOfString this method will return -1 if the String could not be found, not NSNotFound	 */
- (NSInteger)indexOf:(NSString *)aString{ 	return [self indexOf:aString afterIndex:0];	}
- (NSInteger)indexOf:(NSString *)aString afterIndex:(NSInteger)index
{
	NSRange lookupRange = NSMakeRange(0, self.length);
	if (index < 0 && -index < self.length)	lookupRange.location = self.length + index;
	else {
		if (index > self.length) {
			NSString *reason = $( @"LookupIndex %ld is not within range: Expected 0-%ld", index, 	self.length);
			@throw [NSException exceptionWithName:@"ArrayIndexOutOfBoundsExceptions" reason:reason	 userInfo:nil];
		}
		lookupRange.location = index;
	}
	NSRange range = [self rangeOfString:aString	options:0 range:lookupRange];
	return (range.location == NSNotFound ? -1 : range.location);
}
- (NSInteger)lastIndexOf:(NSString *)aString
{
	NSString *reversed = self.reversed;
	NSInteger pos = [reversed indexOf:aString];
	return pos == -1 ? -1 : self.length - pos;
}
- (NSRange)rangeOfAny:(NSSet *)strings
{
	NSRange re = NSMakeRange(NSNotFound, 0);
	for (NSString *s in strings) {	NSRange r = [self rangeOfString:s];	if (r.location < re.location) re = r;	}	return re;
}
- (NSArray *)lines	{ return [self componentsSeparatedByString:@"\n"]; }
- (NSArray *)words
{
	NSMutableArray *re = NSMutableArray.array;
	for (NSString *s in [self componentsSeparatedByString:@" "]) {  if (!s.isEmpty)	[re addObject:s];	}	return re;
}
- (NSSet *)wordSet { return [NSMutableSet setWithArray:self.words];	}
- (NSArray *)trimmedComponentsSeparatedByString:(NSString *)separator
{
	NSMutableArray *re = NSMutableArray.array;
	for (__strong NSString *s in [self componentsSeparatedByString:separator]) {	s = s.trim;	if (!s.isEmpty)  [re addObject:s]; }
	return re;
}
- (NSArray *)decolonize {	return [self componentsSeparatedByString:@":"];	}
- (NSArray *)splitByComma {	return [self componentsSeparatedByString:@","];	}
- (NSString *)substringBefore:(NSString *)delimiter
{
	NSInteger index = [self indexOf:delimiter];
	return (index == -1) ? self : [self substringToIndex:index];
}
- (NSString *)substringAfter:(NSString *)delimiter {
	NSInteger index = [self indexOf:delimiter];
	if (index == -1) {
		return self;
	}
	return [self substringFromIndex:index + delimiter.length];
}
- (NSArray *)splitAt:(NSString *)delimiter
{
	NSRange index = [self rangeOfString:delimiter];
	return (index.location == NSNotFound) ?@[self] :	 @[[self substringToIndex:index.location],
													   [self substringFromIndex:index.location + index.length]];
}
- (BOOL)splitAt:(NSString *)delimiter head:(NSString **)head tail:(NSString **)tail
{
	NSRange index = [self rangeOfString:delimiter];
	if (index.location == NSNotFound) return NO;
	NSString *copy = self.copy;
	*head = [copy substringToIndex:index.location];
	*tail = [copy substringFromIndex:index.location + index.length];
	return YES;
}
- (NSArray *)decapitate
{
	NSRange index = [self rangeOfString:@" "];
	return (index.location == NSNotFound)	? @[[self trim]]
											: @[[[self substringToIndex:index.location] trim],												[[self substringFromIndex:index.location + index.length] trim]];
}
- (NSPoint)pointValue
{
	NSPoint re = (NSPoint) {0.0, 0.0};		NSArray *values = self.splitByComma;
	if (values.count == 0) 															return re;
	re.x = [values[0] floatValue];
	if (values.count < 2) 	re.y = re.x;	else re.y = [values[1] floatValue];		return re;
}
- (NSUInteger)minutesValue
{
	NSArray *split = [self componentsSeparatedByString:@":"];
	return  (split.count > 1) ? [split[0] intValue] * 60 + [split[1] intValue] : [self intValue];
}
- (NSUInteger)secondsValue
{
	NSArray *split = [self componentsSeparatedByString:@":"];
	if (split.count > 2)	return [split[0] intValue] * 3600  + [split[1] intValue] * 60 + [split[2] intValue];
	else if (split.count == 2)	return [split[0] intValue] * 3600 	+ [split[1] intValue] * 60;
	return [self intValue];
}
-(NSURL *)url {			return [NSURL URLWithString:self];		}
-(NSURL *)fileURL {		return [NSURL fileURLWithPath:self];	}
- (NSString *)ucfirst
{
	NSString *head = [[self substringToIndex:1] uppercaseString];	NSString *tail = [self substringFromIndex:1];
	return $(@"%@%@", head, tail);
}
- (NSString *)lcfirst {
	NSString *head = [[self substringToIndex:1] lowercaseString];
	NSString *tail = [self substringFromIndex:1];
	return $(@"%@%@", head, tail);
}
+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {	return [[self alloc] initWithData:data encoding:encoding]; }
+ (NSString *)stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits
{
	//012345678 <-Indices.
	//42.123400 <-Assuming numDigits = 6.
	//^-----^   <-Returns this substring. (Trailing zeroes are deleted.)
	//42.000000
	//^^		<-Returns this substring (everything before the decimal point) for a whole number.
	NSString *format = numDigits ? $(@"%%.%luf", numDigits) : @"%f";
	NSString *str = $(format, (double)f);
	NSUInteger i = [str length];
	while (i-- > 0) {
		if ([str characterAtIndex:i] != '0') {
			//If we have run out of zeroes, this is a whole number. Leave off the decimal point.
			//Not incrementing i means that the decimal point will be dropped.
			if ([str characterAtIndex:i] != '.') ++i;
			break;
		}
	}
	return [str substringToIndex:i];
}
- (NSAttributedString*) attributedWithFont:(NSF*)font andColor:(NSC*)color {
	return [[NSAttributedString alloc] initWithString:self attributes:@{
				NSFontAttributeName : font,
	NSForegroundColorAttributeName  : color}];
}
//This method creates an NSMutableAttributedString, using an NSString and an NSMutableParagraphStyle.
-(NSMutableAttributedString *) attributedParagraphWithSpacing:(CGF)spacing
{
	NSMutableParagraphStyle *aMutableParagraphStyle;
	NSMutableAttributedString   *attString;
	/*
	 The only way to instantiate an NSMutableParagraphStyle is to mutably copy an
	 NSParagraphStyle. And since we don't have an existing NSParagraphStyle available
	 to copy, we use the default one.
	 
	 The default values supplied by the default NSParagraphStyle are:
	 Alignment   NSNaturalTextAlignment
	 Tab stops   12 left-aligned tabs, spaced by 28.0 points
	 Line break mode   NSLineBreakByWordWrapping
	 All others   0.0
	 */
	aMutableParagraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
	
	// Now adjust our NSMutableParagraphStyle formatting to be whatever we want.
	// The numeric values below are in points (72 points per inch)
	[aMutableParagraphStyle	setAlignment:NSLeftTextAlignment];
	[aMutableParagraphStyle setLineSpacing:spacing];
//	[aMutableParagraphStyle setParagraphSpacing:25.5];
//	[aMutableParagraphStyle setHeadIndent:25.0];
//	[aMutableParagraphStyle setTailIndent:-45.0];
	// setTailIndent: if negative, offset from right margin (right margin mark does
	//	  NOT appear); if positive, offset from left margin (margin mark DOES appear)
//	[aMutableParagraphStyle setFirstLineHeadIndent:65.0];
	[aMutableParagraphStyle	setLineBreakMode:NSLineBreakByWordWrapping];
	/*
	 possible allignments
	 NSLeftTextAlignment
	 NSRightTextAlignment
	 NSCenterTextAlignment
	 NSJustifiedTextAlignment
	 NSNaturalTextAlignment
	 possible line wraps
	 NSLineBreakByWordWrapping
	 NSLineBreakByCharWrapping
	 NSLineBreakByClipping
	 */
	
	// Instantiate the NSMutableAttributedString with the argument string
	attString = [[NSMutableAttributedString alloc]
				 initWithString:self];
	// Apply your paragraph style attribute over the entire string
	[attString addAttribute:NSParagraphStyleAttributeName
					  value:aMutableParagraphStyle
					  range:NSMakeRange(0,[self length])];
//	[aMutableParagraphStyle release]; // since it was copy'd
//	[attString autorelease]; // since it was alloc'd
	return attString;
}
//If your NSTextView already has attributed strings in its textStorage, you can get the NSParagraphStyle by:
//aMutableParagraphStyle = [[myTextView typingAttributes]
//						  objectForKey:@"NSParagraphStyle"];

-(NSString*) truncatedForRect:(NSRect)frame withFont:(NSFont*)font
{
	NSLineBreakMode	truncateMode = NSLineBreakByTruncatingMiddle;
	CGFloat	txSize = [self widthWithFont:font];
	if( txSize <= frame.size.width ) 	return self;	// Don't do anything if it fits.
	NSMutableString*	currString = [NSMutableString string];
	NSRange	 rangeToCut = { 0, 0 };
//	if( truncateMode == NSLineBreakByTruncatingTail )	 	{	rangeToCut.location = [s length] -1; 	rangeToCut.length = 1; }
//	else if( truncateMode == NSLineBreakByTruncatingHead )  {  rangeToCut.location = 0;					rangeToCut.length = 1; }
//	else {  // NSLineBreakByTruncatingMiddle
	rangeToCut.location = [self length] / 2;
	rangeToCut.length = 1;
	//  }
	while( txSize > frame.size.width )	{
		if( truncateMode != NSLineBreakByTruncatingHead && rangeToCut.location <= 1 )	return @"...";
		[currString setString: self];
		[currString replaceCharactersInRange: rangeToCut withString: @"..."];
		txSize = [currString widthWithFont:font];		rangeToCut.length++;
//		if( truncateMode == NSLineBreakByTruncatingHead )	;   // No need to fix location, stays at start.
//		else if( truncateMode == NSLineBreakByTruncatingTail )
//			rangeToCut.location--;  // Fix location so range that's one longer still lies inside our string at end.
//		else
		if( (rangeToCut.length & 1) != 1 )	 // even? NSLineBreakByTruncatingMiddle
			rangeToCut.location--;  // Move location left every other time, so it grows to right and left and stays centered.
		if( rangeToCut.location <= 0 || (rangeToCut.location +rangeToCut.length) > [self length] )		return @"...";
	}
	return currString;
}

// Method based on code obtained from:
// http://www.thinkmac.co.uk/blog/2005/05/removing-entities-from-html-in-cocoa.html
//
- (NSString *)decodeHTMLCharacterEntities {
	if ([self rangeOfString:@"&"].location == NSNotFound) {
		return self;
	} else {
		NSMutableString *escaped = [NSMutableString stringWithString:self];
		NSArray *codes = [NSArray arrayWithObjects:
						  @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
						  @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
						  @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
						  @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
						  @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
						  @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
						  @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
						  @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
						  @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
						  @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
						  @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
						  @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
						  @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
						  @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
		NSUInteger i, count = [codes count];
		// Html
		for (i = 0; i < count; i++) {
			NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
			if (range.location != NSNotFound) {
				[escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
										 withString:$(@"%lu", 160 + i)
											options:NSLiteralSearch
											  range:NSMakeRange(0, [escaped length])];
			}
		}
		// The following five are not in the 160+ range
		// @"&amp;"
		NSRange range = [self rangeOfString:@"&amp;"];
		if (range.location != NSNotFound) {
			[escaped replaceOccurrencesOfString:@"&amp;"
									 withString:$(@"%d", 38)
										options:NSLiteralSearch
										  range:NSMakeRange(0, [escaped length])];
		}
		// @"&lt;"
		range = [self rangeOfString:@"&lt;"];
		if (range.location != NSNotFound) {
			[escaped replaceOccurrencesOfString:@"&lt;"
									 withString:$(@"%d", 60)
										options:NSLiteralSearch
										  range:NSMakeRange(0, [escaped length])];
		}
		// @"&gt;"
		range = [self rangeOfString:@"&gt;"];
		if (range.location != NSNotFound) {
			[escaped replaceOccurrencesOfString:@"&gt;"
									 withString:$(@"%d", 62)
										options:NSLiteralSearch
										  range:NSMakeRange(0, [escaped length])];
		}
		// @"&apos;"
		range = [self rangeOfString:@"&apos;"];
		if (range.location != NSNotFound) {
			[escaped replaceOccurrencesOfString:@"&apos;"
									 withString:$(@"%i", 39)
										options:NSLiteralSearch
										  range:NSMakeRange(0, [escaped length])];
		}
		// @"&quot;"
		range = [self rangeOfString:@"&quot;"];
		if (range.location != NSNotFound) {
			[escaped replaceOccurrencesOfString:@"&quot;"
									 withString:[NSString stringWithFormat:@"%d", 34]
										options:NSLiteralSearch
										  range:NSMakeRange(0, [escaped length])];
		}
		// Decimal & Hex
		NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
		i = 0;
		while (i < [escaped length]) {
			start = [escaped rangeOfString:@"&#"
								   options:NSCaseInsensitiveSearch
									 range:searchRange];
			finish = [escaped rangeOfString:@";"
									options:NSCaseInsensitiveSearch
									  range:searchRange];
			if (start.location != NSNotFound && finish.location != NSNotFound &&
				finish.location > start.location) {
				NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
				NSString *entity = [escaped substringWithRange:entityRange];
				NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
				[escaped deleteCharactersInRange:entityRange];
				if ([value hasPrefix:@"x"]) {
					unsigned tempInt = 0;
					NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
					[scanner scanHexInt:&tempInt];
					[escaped insertString:$(@"%i", tempInt) atIndex:entityRange.location];
				} else {
					[escaped insertString:$(@"%i", [value intValue]) atIndex:entityRange.location];
				} i = start.location;
			} else { i++; }
			searchRange = NSMakeRange(i, [escaped length] - i);
		}
		return escaped;	// Note this is autoreleased
	}
}
- (NSString *)encodeHTMLCharacterEntities {
	NSMutableString *encoded = [NSMutableString stringWithString:self];
	// @"&amp;"
	NSRange range = [self rangeOfString:@"&"];
	if (range.location != NSNotFound) {
		[encoded replaceOccurrencesOfString:@"&"
								 withString:@"&amp;"
									options:NSLiteralSearch
									  range:NSMakeRange(0, [encoded length])];
	}
	// @"&lt;"
	range = [self rangeOfString:@"<"];
	if (range.location != NSNotFound) {
		[encoded replaceOccurrencesOfString:@"<"
								 withString:@"&lt;"
									options:NSLiteralSearch
									  range:NSMakeRange(0, [encoded length])];
	}
	// @"&gt;"
	range = [self rangeOfString:@">"];
	if (range.location != NSNotFound) {
		[encoded replaceOccurrencesOfString:@">"
								 withString:@"&gt;"
									options:NSLiteralSearch
									  range:NSMakeRange(0, [encoded length])];
	}
	
	return encoded;
}

+ (NSA*) testDomains {  static NSA *testDOmains_ = nil;

	return testDOmains_ = testDOmains_ ?: @[ @"manhunt.net", @"adam4adam.com", @"grindr.com", @"facebook.com", @"google.com", @"youtube.com", @"yahoo.com", @"baidu.com", @"wikipedia.org", @"live.com", @"qq.com", @"twitter.com", @"amazon.com", @"blogspot.com", @"google.co.in", @"taobao.com", @"linkedin.com", @"yahoo.co.jp", @"msn.com", @"sina.com.cn", @"google.com.hk", @"google.de", @"bing.com", @"yandex.ru", @"babylon.com", @"wordpress.com", @"ebay.com", @"google.co.uk", @"google.co.jp", @"google.fr", @"163.com", @"soso.com", @"vk.com", @"weibo.com", @"microsoft.com", @"mail.ru", @"googleusercontent.com", @"google.com.br", @"tumblr.com", @"ask.com", @"craigslist.org", @"pinterest.com", @"paypal.com", @"xhamster.com", @"google.es", @"sohu.com", @"apple.com", @"google.it", @"bbc.co.uk", @"avg.com", @"xvideos.com", @"google.ru", @"blogger.com", @"fc2.com", @"livejasmin.com", @"imdb.com", @"tudou.com", @"adobe.com", @"t.co", @"google.com.mx", @"go.com", @"flickr.com", @"conduit.com", @"youku.com", @"google.ca", @"odnoklassniki.ru", @"ifeng.com", @"tmall.com", @"hao123.com", @"aol.com", @"mywebsearch.com", @"pornhub.com", @"zedo.com", @"ebay.de", @"blogspot.in", @"google.co.id", @"cnn.com", @"thepiratebay.se", @"sogou.com", @"rakuten.co.jp", @"about.com", @"amazon.de", @"alibaba.com", @"google.com.au", @"google.com.tr", @"espn.go.com", @"redtube.com", @"huffingtonpost.com", @"ebay.co.uk", @"360buy.com", @"mediafire.com", @"chinaz.com", @"google.pl", @"adf.ly", @"uol.com.br", @"stackoverflow.com", @"netflix.com", @"ameblo.jp", @"youporn.com", @"dailymotion.com", @"amazon.co.jp", @"imgur.com", @"instagram.com", @"godaddy.com", @"wordpress.org", @"doubleclick.com", @"4shared.com", @"alipay.com", @"360.cn", @"globo.com", @"livedoor.com", @"amazon.co.uk", @"bp.blogspot.com", @"xnxx.com", @"cnet.com", @"searchnu.com", @"weather.com", @"torrentz.eu", @"search-results.com", @"google.com.sa", @"wigetmedia.com", @"google.nl", @"livejournal.com", @"nytimes.com", @"adcash.com", @"incredibar.com", @"tube8.com", @"dailymail.co.uk", @"neobux.com", @"ehow.com", @"badoo.com", @"google.com.ar", @"douban.com", @"cnzz.com", @"renren.com", @"tianya.cn", @"vimeo.com", @"bankofamerica.com", @"reddit.com", @"warriorforum.com", @"spiegel.de", @"deviantart.com", @"aweber.com", @"dropbox.com", @"indiatimes.com", @"pconline.com.cn", @"kat.ph", @"blogfa.com", @"google.com.pk", @"mozilla.org", @"secureserver.net", @"chase.com", @"google.co.th", @"google.com.eg", @"goo.ne.jp", @"booking.com", @"56.com", @"stumbleupon.com", @"google.co.za", @"google.cn", @"softonic.com", @"london2012.org", @"walmart.com", @"answers.com", @"sourceforge.net", @"comcast.net", @"addthis.com", @"foxnews.com", @"photobucket.com", @"wikimedia.org", @"zeekrewards.com", @"onet.pl", @"clicksor.com", @"amazonaws.com", @"pengyou.com", @"wellsfargo.com", @"wikia.com", @"liveinternet.ru", @"depositfiles.com", @"yesky.com", @"outbrain.com", @"google.co.ve", @"bild.de", @"etsy.com", @"xunlei.com", @"allegro.pl", @"statcounter.com", @"guardian.co.uk", @"skype.com", @"adultfriendfinder.com", @"fbcdn.net", @"leboncoin.fr", @"58.com", @"mgid.com", @"reference.com", @"squidoo.com", @"myspace.com", @"fiverr.com", @"iqiyi.com", @"letv.com", @"funmoods.com", @"google.com.co", @"google.com.my", @"optmd.com", @"youjizz.com", @"naver.com", @"rediff.com", @"filestube.com", @"domaintools.com", @"slideshare.net", @"themeforest.net", @"download.com", @"zol.com.cn", @"ucoz.ru", @"google.be", @"free.fr", @"rapidshare.com", @"salesforce.com", @"archive.org", @"nicovideo.jp", @"google.com.vn", @"google.gr", @"soundcloud.com", @"people.com.cn", @"orange.fr", @"scribd.com", @"nbcnews.com", @"yieldmanager.com", @"it168.com", @"xinhuanet.com", @"cam4.com", @"w3schools.com", @"4399.com", @"isohunt.com", @"iminent.com", @"tagged.com", @"files.wordpress.com", @"hootsuite.com", @"espncricinfo.com", @"yelp.com", @"wp.pl", @"hardsextube.com", @"ameba.jp", @"google.com.tw", @"imageshack.us", @"tripadvisor.com", @"4dsply.com", @"web.de", @"rambler.ru", @"google.at", @"google.se", @"gmx.net", @"pof.com"];	
}
// URL Absolute string
+ (NSArray*)domainsToSkip {
	return @[
			 @"http://googleusercontent.com", @"http://go.com", @"http://bp.blogspot.com", @"http://secureserver.net", @"http://wikia.com", @"http://optmd.com", @"http://people.com.cn", @"http://yieldmanager.com", @"http://zedo.com", @"http://adf.ly",				   // 1px size
	@"http://adcash.com",			   // 1px size
	@"http://adultfriendfinder.com",	// 1px size
	@"http://rapidshare.com",		   // Creates the link tag with Javascritp
	@"http://thepiratebay.se",		  // Blocked in Italy
	@"http://kat.ph",				   // Blocked in Italy
	@"http://london2012.org"			// Offline ?
	];
}

@end
//	[NSGraphicsContext saveGraphicsState];
//	[NSBezierPath clipRect: box];   // Make sure we don't draw outside our cell.
//	NSDictionary *attrs = $map(
//		[NSFont systemFontOfSize: 18, NSFontAttributeName,
//		[[NSColor alternateSelectedControlTextColor] colorWithAlphaComponent: 1], NSForegroundColorAttributeName)
//	NSLineBreakMode truncateMode = NSLineBreakByTruncatingMiddle;
//	[displayTitle drawInRect: textBox withAttributes: attrs];
//	[NSGraphicsContext restoreGraphicsState];
NSString*   StringByTruncatingStringWithAttributesForWidth( NSString* s, NSDictionary* attrs, float wid, NSLineBreakMode truncateMode )
{
	NSSize				txSize = [s sizeWithAttributes: attrs];
	if( txSize.width <= wid ) 	return s;	// Don't do anything if it fits.
	NSMutableString*	currString = [NSMutableString string];								NSRange	 rangeToCut = { 0, 0 };
	if( truncateMode == NSLineBreakByTruncatingTail )	 	{	rangeToCut.location = [s length] -1; 	rangeToCut.length = 1; }
	else if( truncateMode == NSLineBreakByTruncatingHead )  {  rangeToCut.location = 0;					rangeToCut.length = 1; }
	else {	rangeToCut.location = [s length] / 2;		rangeToCut.length = 1;  } // NSLineBreakByTruncatingMiddle
	while( txSize.width > wid )	{
		if( truncateMode != NSLineBreakByTruncatingHead && rangeToCut.location <= 1 )	return @"...";
		[currString setString: s];
		[currString replaceCharactersInRange: rangeToCut withString: @"..."];
		txSize = [currString sizeWithAttributes: attrs];		rangeToCut.length++;
		if( truncateMode == NSLineBreakByTruncatingHead )	;   // No need to fix location, stays at start.
		else if( truncateMode == NSLineBreakByTruncatingTail )
			rangeToCut.location--;  // Fix location so range that's one longer still lies inside our string at end.
		else if( (rangeToCut.length & 1) != 1 )	 // even? NSLineBreakByTruncatingMiddle
			rangeToCut.location--;  // Move location left every other time, so it grows to right and left and stays centered.
		if( rangeToCut.location <= 0 || (rangeToCut.location +rangeToCut.length) > [s length] )		return @"...";
	}
	return currString;
}

@implementation NSMutableString (AtoZ)


- (NSString *)shift
{
	NSString *re = [self substringToIndex:1];
	[self setString:[self substringFromIndex:1]];			return re;
}
- (NSString *)pop
{
	NSUInteger index = self.length - 1;
	NSString *re = [self substringFromIndex:index];
	[self setString:[self substringToIndex:index]];			return re;
}
- (BOOL)removePrefix:(NSString *)prefix
{
	if (![self hasPrefix:prefix]) 							return NO;
	NSRange range = NSMakeRange(0, prefix.length);
	[self replaceCharactersInRange:range withString:@""];	return YES;
}
- (BOOL)removeSuffix:(NSString *)suffix
{
	if (![self hasSuffix:suffix]) 							return NO;
	NSRange range = NSMakeRange(self.length - suffix.length, suffix.length);
	[self replaceCharactersInRange:range withString:@""];	return YES;
}
- (BOOL)removePrefix:(NSString *)prefix andSuffix:(NSString *)suffix
{
	if (![self hasPrefix:prefix andSuffix:suffix]) 			return NO;
	NSRange range = NSMakeRange(0, prefix.length);
	[self replaceCharactersInRange:range withString:@""];
	range = NSMakeRange(self.length - suffix.length, suffix.length);
	[self replaceCharactersInRange:range withString:@""];	return YES;
}
- (NSMutableString *)camelize
{
	unichar c, us, hy; 		us = [@"_" characterAtIndex:0];		hy = [@"-" characterAtIndex:0];
	NSMutableString *r = [NSMutableString string];
	for (NSUInteger i = 0; i < self.length; i++) {	c = [self characterAtIndex:i];
		if (c == us || c == hy) {
			[r setString:[self substringWithRange:NSMakeRange(i, 1)]];
			[self replaceCharactersInRange:NSMakeRange(i, 2) withString:[r uppercaseString]];	i++;
		}
	}	return self;
}
- (NSMutableString *)hyphonize {	return [self replaceAll:@"_" withString:@"-"];	}
- (NSMutableString *)underscorize {	return [self replaceAll:@"-" withString:@"_"];	}
- (NSMutableString *)constantize {	[self setString:[[self underscorize] uppercaseString]];	return self;		}
- (NSMutableString *)replaceAll:(NSString *)needle withString:(NSString *)replacement
{
	[self replaceOccurrencesOfString:needle withString:replacement options:0 range:NSMakeRange(0, self.length)]; 	return self;
}
@end
@implementation NSString (RuntimeReporting)
- (BOOL) hasNoSubclasses { return ![self hasSubclasses]; }
- (BOOL) hasSubclasses { return [[RuntimeReporter subclassNamesForClassNamed:self] count] ? YES : NO; }
- (int) numberOfSubclasses { return [[RuntimeReporter subclassNamesForClassNamed:self] count]; }
- (NSArray *) subclassNames { return [RuntimeReporter subclassNamesForClassNamed: self]; }
- (NSArray *) methodNames // assumes the receiver contains a valid classname.
{ 
	return 
	[[RuntimeReporter methodNamesForClassNamed:self]  
	 sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
- (NSArray *) ivarNames // assumes the receiver contains a valid classname.
{ 
	return 
	[[RuntimeReporter iVarNamesForClassNamed:self] 
	 sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
- (NSArray *) propertyNames // assumes the receiver contains a valid classname.
{ 
	return 
	[[RuntimeReporter propertyNamesForClassNamed:self]
	 sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
- (NSArray *) protocolNames // assumes the receiver contains a valid classname.
{ 
	return 
	[[RuntimeReporter protocolNamesForClassNamed:self] 
	 sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
// KVC compliance stuff: This was needed for NSTreeController.  Not needed for the iPhone version.
//- (void) setSubclassNames:(NSArray *) names { NSLog(@"Can't set subclass names!"); }
//- (id) valueForUndefinedKey:(NSString *) key { return self; }
//- (void) setValue:(id)value forUndefinedKey:(NSString *)key { NSLog(@"unknown key:%@", key); }
@end
int gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior ;
@implementation NSAttributedString (Geometrics)

- (NSSize)sizeForWidth:(float)width height:(float)height
{
	NSInteger typesetterBehavior = NSTypesetterLatestBehavior;
	NSSize answer = NSZeroSize;
	if ([self length] > 0) {
		// Checking for empty string is necessary since Layout Manager will give the nominal
		// height of one line if length is 0.  Our API specifies 0.0 for an empty string.
		NSSize size = NSMakeSize(width, height);
		NSTextContainer *textContainer 	= [[NSTextContainer alloc] initWithContainerSize:size];
		NSTextStorage	 *textStorage	= [[NSTextStorage alloc] initWithAttributedString:self];
		NSLayoutManager *layoutManager 	= [[NSLayoutManager alloc] init];
		[layoutManager addTextContainer:textContainer];
		[textStorage   addLayoutManager:layoutManager];
		[layoutManager	   setHyphenationFactor:0.0];
		if (typesetterBehavior != NSTypesetterLatestBehavior) [layoutManager setTypesetterBehavior:typesetterBehavior];
		// NSLayoutManager is lazy, so we need the following kludge to force layout:
		[layoutManager glyphRangeForTextContainer:textContainer];
		answer = [layoutManager usedRectForTextContainer:textContainer].size;
		// Adjust if there is extra height for the cursor
		NSSize extraLineSize = [layoutManager extraLineFragmentRect].size;
		if (extraLineSize.height > 0)  answer.height -= extraLineSize.height;
		// In case we changed it above, set typesetterBehavior back
		// to the default value.
//		typesetterBehavior = NSTypesetterLatestBehavior;
	}
	return answer;
}
- (float)heightForWidth:(float)width
{
	return [self sizeForWidth:width height:FLT_MAX].height;
}
- (float)widthForHeight:(float)height
{
	return [self sizeForWidth:FLT_MAX height:height].width;
}
- (void)drawCenteredVerticallyInRect:(NSRect)rect
{
	float strHeight = [self heightForWidth:rect.size.width];
	float orgY = (rect.origin.y) + (rect.size.height / 2) - (strHeight / 2);
	NSRect newRect = NSMakeRect(rect.origin.x, orgY, rect.size.width, strHeight);
	[self drawInRect:newRect];
}

#pragma mark Measure Attributed String
//- (NSSize)sizeForWidth:(float)width height:(float)height		{	NSSize answer = NSZeroSize ;
//
//	//	Checking for empty string is necessary since Layout Manager will give the nominal height of one line if length is 0.
//	if ([self length] > 0) { 			  //	Our API specifies 0.0 for an empty string.
//		NSTextContainer *textContainer 	= [[NSTextContainer alloc] initWithContainerSize:(NSSize) { width, height }];
//		NSTextStorage *textStorage 		= [[NSTextStorage 	alloc] initWithAttributedString:self];
//		NSLayoutManager *layoutManager 	= [[NSLayoutManager alloc] init];
//
//		[layoutManager 	addTextContainer:textContainer];	 [textStorage 	addLayoutManager:layoutManager];
//		[layoutManager 	setHyphenationFactor:0.0];
//		if (gNSStringGeometricsTypesetterBehavior != NSTypesetterLatestBehavior)
//			[layoutManager setTypesetterBehavior:gNSStringGeometricsTypesetterBehavior];
//		[layoutManager glyphRangeForTextContainer:textContainer];  // NSLayoutManager is lazy,we need the following kludge to force layout:
//		answer = [layoutManager usedRectForTextContainer:textContainer].size ;
//		gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior ;		// In case changed , set typesetterBehavior to default.
//	}	return answer ;
//}
//
//- (float)heightForWidth:(float)width {		return [self sizeForWidth:width	height:FLT_MAX].height ;  }
//
//- (float)widthForHeight:(float)height {		return [self sizeForWidth:FLT_MAX	height:height].width ;	}
//
@end
@implementation NSString (Geometrics)

#pragma mark Given String with Attributes
- (NSSize)sizeInSize:(NSSize)size 	  font:(NSFont*)font;
{
	return [self sizeForWidth:size.width height:size.height font:font];
}
- (NSSize)sizeForWidth:(float)width	height:(float)height attributes:(NSDictionary*)attributes
{
	return [[[NSAttributedString alloc] initWithString:self attributes:attributes]  sizeForWidth:width height:height] ;
}
- (float)heightForWidth:(float)width attributes:(NSDictionary*)attributes
{
	return [self sizeForWidth:width height:FLT_MAX attributes:attributes].height ;
}
- (float)widthForHeight:(float)height attributes:(NSDictionary*)attributes
{
	return [self sizeForWidth:FLT_MAX height:height attributes:attributes].width ;
}
#pragma mark Given String with Font
- (NSSize)sizeForWidth:(float)width height:(float)height font:(NSFont*)font
{
	NSSize answer = NSZeroSize ;
//	if (font == nil)	NSLog(@"[%@ %@]: Error: cannot compute size with nil font", [self class], _cmd) ;
//	else
		return 		answer = [self sizeForWidth:width height:height attributes:@{NSFontAttributeName: font}] ;
}
- (float)heightForWidth:(float)width font:(NSFont*)font { return [self sizeForWidth:width height:FLT_MAX font:font].height ; }
- (float)widthForHeight:(float)height font:(NSFont*)font { return [self sizeForWidth:FLT_MAX height:height font:font].width ; }
@end
#import <objc/runtime.h>
#import <stdarg.h>
static BOOL IsColonOnlySelector(SEL selector);
static NSUInteger ColonCount(SEL selector);
static NSString *SillyStringImplementation(id self, SEL _cmd, ...);
@implementation NSString (JASillyStringImpl)
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	if (IsColonOnlySelector(sel)) {
		NSUInteger i, colonCount = ColonCount(sel);
		NSMS *typeStr = [NSMS stringWithCapacity:colonCount + 3];
		[typeStr appendString:@"@@:"];
		for (i = 0; i != colonCount; ++i)			[typeStr appendString:@"@"];
		return class_addMethod([self class], sel, (IMP)SillyStringImplementation, typeStr.UTF8String);
	}
	else return [super resolveInstanceMethod:sel];
}
@end
static BOOL IsColonOnlySelector(SEL selector)
{
	NSString *selString = NSStringFromSelector(selector);  NSUInteger i, count = selString.length;
	for (i = 0; i < count; ++i)		if ([selString characterAtIndex:i] != ':')  return NO;
	return YES;
}
static NSUInteger ColonCount(SEL selector)
{
	assert(IsColonOnlySelector(selector));
	return NSStringFromSelector(selector).length;
}
static NSString *SillyStringImplementation(id self, SEL _cmd, ...)
{
	NSUInteger i, count = ColonCount(_cmd);
	NSMutableString *string = [self mutableCopy];
	NSString *result = nil;
	@try	{
		va_list args;	id obj = nil;	va_start(args, _cmd);
		for (i = 0; i != count; ++i) {
			obj = va_arg(args, id);
			if (obj == nil)  obj = @"";
			[string appendString:[obj description]];
		}
		va_end(args);
		result = [[string copy] autorelease];
	}
	@finally {[string release];}
	return result;
}

@implementation NSString (AQPropertyKVC)
- (NSString *) propertyStyleString
{
	NSString * result = [[self substringToIndex: 1] lowercaseString];
	if ( [self length] == 1 )
		return ( result );
	return ( [result stringByAppendingString: [self substringFromIndex: 1]] );
}
@end

@implementation NSString (SGSAdditions)
- (NSString*) truncatedToWidth: (CGFloat) width withAttributes: (NSD*) attributes
{
	NSString*	fixedString		= self;
	NSString*	currentString	= self;
	NSSize		stringSize		= [currentString sizeWithAttributes: attributes];
	if (stringSize.width > width)
	{
		NSInteger i = [self length];
		while ([currentString sizeWithAttributes: attributes].width > width)
		{
			if (i > 0) {
			currentString = [[self substringToIndex: i] stringByAppendingString: @"..."];
			i--;
			}
			else
			{
				currentString = @"";	break;
			}
		}
		fixedString = currentString;
	}
	return fixedString;
}
@end
@implementation NSString (Extensions)
- (BOOL) hasCaseInsensitivePrefix:(NSString*)prefix {
	NSRange range = [self rangeOfString:prefix options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
	return range.location != NSNotFound;
}
- (NSString*) urlEscapedString {
	return [(__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":@/?&=+"),
														kCFStringEncodingUTF8) autorelease];
}
- (NSString*) unescapeURLString {
	return [(__bridge NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),
																		kCFStringEncodingUTF8) autorelease];
}
static NSArray* _SpecialAbreviations() {
	static NSArray* array = nil;
	if (array == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (array == nil) {
			array = [[NSArray alloc] initWithObjects:@"vs", @"st", nil];
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return array;
}
// http://www.attivio.com/blog/57-unified-information-access/263-doing-things-with-words-part-two-sentence-boundary-detection.html
static void _ScanSentence(NSScanner* scanner) {
	NSUInteger initialLocation = scanner.scanLocation;
	while (1) {
		// Find next sentence boundary (return if at end)
		[scanner scanUpToCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_SentenceBoundariesAndNewlineCharacter) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
		NSUInteger boundaryLocation = scanner.scanLocation;
		// Skip sentence boundary (return if boundary is a newline or if at end)
		if (![scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_SentenceBoundaries) intoString:NULL]) {
			break;
		}
		if ([scanner isAtEnd]) {
			break;
		}
		// Make sure sentence boundary is followed by whitespace or newline
		NSRange range = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline)
														options:NSAnchoredSearch
														  range:NSMakeRange(scanner.scanLocation, 1)];
		if (range.location == NSNotFound) {
			continue;
		}
		// Extract previous token
		range = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline)
												options:NSBackwardsSearch
												  range:NSMakeRange(initialLocation, boundaryLocation - initialLocation)];
		if (range.location == NSNotFound) {
			continue;
		}
		range = NSMakeRange(range.location + 1, boundaryLocation - range.location - 1);
		// Make sure previous token is a not special abreviation
		BOOL match = NO;
		for (NSString* abreviation in _SpecialAbreviations()) {
			if (abreviation.length == range.length) {
				NSRange temp = [scanner.string rangeOfString:abreviation options:(NSAnchoredSearch | NSCaseInsensitiveSearch) range:range];
				if (temp.location != NSNotFound) {
					match = YES;
					break;
				}
			}
		}
		if (match) {
			continue;
		}
		// Make sure previous token does not contain a period or is more than 4 characters long or is followed by an uppercase letter
		NSRange subrange = [scanner.string rangeOfString:@"." options:0 range:range];
		if ((subrange.location != NSNotFound) && (range.length < 4)) {
			subrange = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
													   options:0
														 range:NSMakeRange(scanner.scanLocation,
																		   scanner.string.length - scanner.scanLocation)];
			subrange = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_UppercaseLetters)
													   options:NSAnchoredSearch
														 range:NSMakeRange(subrange.location != NSNotFound ?
																		   subrange.location : scanner.scanLocation, 1)];
			if (subrange.location == NSNotFound) {
				continue;
			}
		}
		// We have found a sentence
		break;
	}
}
- (NSString*) extractFirstSentence {
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	_ScanSentence(scanner);
	NSString* newSelf = [self substringToIndex:scanner.scanLocation];
	return newSelf;
}
- (NSA*) extractAllSentences {
	NSMutableArray* array = [NSMutableArray array];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	while (1) {
		[scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
		NSUInteger location = scanner.scanLocation;
		_ScanSentence(scanner);
		if (scanner.scanLocation > location) {
			[array addObject:[self substringWithRange:NSMakeRange(location, scanner.scanLocation - location)]];
		}
	}
	[scanner release];
	return array;
}
- (NSIndexSet*) extractSentenceIndices {
	NSMutableIndexSet* set = [NSMutableIndexSet indexSet];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	while (1) {
		NSUInteger location = scanner.scanLocation;
		_ScanSentence(scanner);
		if (scanner.scanLocation > location) {
			[set addIndex:location];
		}
		[scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
	}
	[scanner release];
	return set;
}
- (NSString*) stripParenthesis {
	NSMutableString* string = [NSMutableString string];
	NSRange range = NSMakeRange(0, self.length);
	while (range.length) {
		// Find location of start of parenthesis or end of string otherwise
		NSRange subrange = [self rangeOfString:@"(" options:0 range:range];
		if (subrange.location == NSNotFound) {
			subrange.location = range.location + range.length;
		} else {
			// Adjust the location to contain whitespace preceding the parenthesis
			NSRange subrange2 = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
													  options:NSBackwardsSearch
														range:NSMakeRange(range.location, subrange.location - range.location)];
			if (subrange2.location + 1 < subrange.location) {
				subrange.length += subrange.location - subrange2.location - 1;
				subrange.location = subrange2.location + 1;
			}
		}
		// Copy characters until location
		[string appendString:[self substringWithRange:NSMakeRange(range.location, subrange.location - range.location)]];
		range.length -= subrange.location - range.location;
		range.location = subrange.location;
		// Skip characters from location to end of parenthesis or end of string otherwise
		if (range.length) {
			subrange = [self rangeOfString:@")" options:0 range:range];
			if (subrange.location == NSNotFound) {
				subrange.location = range.location + range.length;
			} else {
				subrange.location += 1;
			}
			range.length -= subrange.location - range.location;
			range.location = subrange.location;
		}
	}
	return string;
}
- (BOOL) containsString:(NSString*)string {
	NSRange range = [self rangeOfString:string];
	return range.location != NSNotFound;
}
- (NSA*) extractAllWords {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if (self.length) {
		NSMutableArray* array = [NSMutableArray array];
		NSScanner* scanner = [[NSScanner alloc] initWithString:self];
		scanner.charactersToBeSkipped = nil;
		while (1) {
			[scanner scanCharactersFromSet:characterSet intoString:NULL];
			NSString* string;
			if (![scanner scanUpToCharactersFromSet:characterSet intoString:&string]) {
				break;
			}
			[array addObject:string];
		}
		[scanner release];
		return array;
	}
	return nil;
}
- (NSRange) rangeOfWordAtLocation:(NSUInteger)location {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if (![characterSet characterIsMember:[self characterAtIndex:location]]) {
		NSRange start = [self rangeOfCharacterFromSet:characterSet options:NSBackwardsSearch range:NSMakeRange(0, location)];
		if (start.location == NSNotFound) {
			start.location = 0;
		} else {
			start.location = start.location + 1;
		}
		NSRange end = [self rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(location + 1, self.length - location - 1)];
		if (end.location == NSNotFound) {
			end.location = self.length;
		}
		return NSMakeRange(start.location, end.location - start.location);
	}
	return NSMakeRange(NSNotFound, 0);
}
- (NSRange) rangeOfNextWordFromLocation:(NSUInteger)location {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if ([characterSet characterIsMember:[self characterAtIndex:location]]) {
		NSRange start = [self rangeOfCharacterFromSet:[characterSet invertedSet] options:0 range:NSMakeRange(location,
																											 self.length - location)];
		if (start.location != NSNotFound) {
			NSRange end = [self rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(start.location,
																								 self.length - start.location)];
			if (end.location == NSNotFound) {
				end.location = self.length;
			}
			return NSMakeRange(start.location, end.location - start.location);
		}
	}
	return NSMakeRange(NSNotFound, 0);
}
- (NSString*) stringByDeletingPrefix:(NSString*)prefix {
	if ([self hasPrefix:prefix]) {
		return [self substringFromIndex:prefix.length];
	}
	return self;
}
- (NSString*) stringByDeletingSuffix:(NSString*)suffix {
	if ([self hasSuffix:suffix]) {
		return [self substringToIndex:(self.length - suffix.length)];
	}
	return self;
}
- (NSString*) stringByReplacingPrefix:(NSString*)prefix withString:(NSString*)string {
	if ([self hasPrefix:prefix]) {
		return [string stringByAppendingString:[self substringFromIndex:prefix.length]];
	}
	return self;
}
- (NSString*) stringByReplacingSuffix:(NSString*)suffix withString:(NSString*)string {
	if ([self hasSuffix:suffix]) {
		return [[self substringToIndex:(self.length - suffix.length)] stringByAppendingString:string];
	}
	return self;
}
- (BOOL) isIntegerNumber {
	NSRange range = NSMakeRange(0, self.length);
	if (range.length) {
		unichar character = [self characterAtIndex:0];
		if ((character == '+') || (character == '-')) {
			range.location = 1;
			range.length -= 1;
		}
		range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_DecimalDigits_Inverted) options:0 range:range];
		return range.location == NSNotFound;
	}
	return NO;
}
//- (NSString*) stripped {
//	NSMutableString *s = self.mutableCopy;
//	[s trimWhitespaceAndNewlineCharacters];
//	return s.copy;
//}

@end
@implementation NSMutableString (Extensions)
- (void) trimWhitespaceAndNewlineCharacters {
	NSRange range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)];
	if ((range.location != NSNotFound) && (range.location > 0)) {
		[self deleteCharactersInRange:NSMakeRange(0, range.location)];
	}
	range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
								  options:NSBackwardsSearch];
	if ((range.location != NSNotFound) && (range.location < self.length - 1)) {
		[self deleteCharactersInRange:NSMakeRange(range.location, self.length - range.location)];
	}
}
@end
@implementation NSString (Creations)
- (id)initWithInteger:(NSInteger)value {
	#ifdef __LP64__
		#define __NSINTEGER_FORMAT @"%ld"
	#else
		#define __NSINTEGER_FORMAT @"%d"
	#endif
	return [self initWithFormat:__NSINTEGER_FORMAT, value];
	#undef __NSINTEGER_FORMAT
}
+ (id)stringWithInteger:(NSInteger)value {
	return [[[self alloc] initWithInteger:value] autorelease];
}
+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList {
	return [[[self alloc] initWithFormat:format arguments:argList] autorelease];
}
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
	return [[[self alloc] initWithData:data encoding:encoding] autorelease];
}
- (id)initWithConcatnatingStrings:(NSString *)first, ... {
	NSMutableArray *array = [NSMutableArray array];
	va_list args;
	va_start(args, first);
	for (NSString *component = first; component != nil; component = va_arg(args, NSString *)) {
		[array addObject:component];
	}
	va_end(args);
	// OMG... what's the best?
	return [self initWithString:[array componentsJoinedByString:@""]];
}
+ (id)stringWithConcatnatingStrings:(NSString *)first, ... {
	NSMutableArray *array = [NSMutableArray array];
	va_list args;
	va_start(args, first);
	for (NSString *component = first; component != nil; component = va_arg(args, NSString *)) {
		[array addObject:component];
	}
	va_end(args);
	return [array componentsJoinedByString:@""];
}
@end

@implementation NSString (Shortcuts)
- (BOOL)hasSubstring:(NSString *)aString {
	return [self rangeOfString:aString].location != NSNotFound;
}
// slow! proof of concept
- (NSString *)format:(id)first, ... {
	NSUInteger len = self.length;
	NSUInteger index = 0;
	BOOL passed = NO;
	do {
		unichar chr = [self characterAtIndex:index];
		if (chr == '%') {
			if (passed) {
				if ([self characterAtIndex:index - 1] == '%') {
					passed = NO;
				} else {
					break;
				}
			} else {
				passed = YES;
			}
		}
		index += 1;
	} while (index < len);
	if (index == len) {
		return [NSString stringWithFormat:self, first];
	} else {
		va_list args;
		va_start(args, first);
		NSString *result = [[NSString stringWithFormat:[self substringToIndex:index], first] stringByAppendingString:[NSString stringWithFormat:[self substringFromIndex:index] arguments:args]];
		va_end(args);
		return result;
	}
}
- (NSString *)format0:(id)dummy, ... {
	va_list args;
	va_start(args, dummy);
	NSString *result = [NSString stringWithFormat:self arguments:args];
	va_end(args);
	return result;
}
- (NSRange)range {
	return NSRangeFromString(self);
}
- (NSString *)substringFromIndex:(NSUInteger)from length:(NSUInteger)length {
	return [self substringWithRange:NSMakeRange(from, length)];
}
- (NSString *)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
	return [self substringWithRange:NSMakeRange(from, to - from)];
}
@end

@implementation NSString (NSUTF8StringEncoding)
+ (NSString *)stringWithUTF8Data:(NSData *)data {
	return [[[self alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
- (NSString *) stringByAddingPercentEscapesUsingUTF8Encoding {
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *) stringByReplacingPercentEscapesUsingUTF8Encoding {
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSData *) dataUsingUTF8Encoding {
	return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end

@implementation NSString (Evaluation)
- (NSInteger)integerValueBase:(NSInteger)radix {
	NSInteger result = 0;
	for ( NSUInteger i=0; i < [self length]; i++ ) {
		result *= radix;
		unichar digit = [self characterAtIndex:i];
		if ( '0' <= digit && digit <= '9' )
			digit -= '0';
		else if ( 'a' <= digit && digit < 'a'-10+radix )
			digit -= 'a'-10;
		else if ( 'A' <= digit && digit < 'A'-10+radix )
			digit -= 'A'-10;
		else {
			break;
		}
		result += digit;
	}
	return result;
}
- (NSInteger)hexadecimalValue {
	return [self integerValueBase:16];
}
@end

@implementation NSMutableString (Shortcuts)
- (id)initWithConcatnatingStrings:(NSString *)first, ... {
	self = [self initWithString:first];
	if (self != nil) {
		va_list args;
		va_start(args, first);
		for (NSString *component = va_arg(args, NSString *); component != nil; component = va_arg(args, NSString *)) {
			[self appendString:component];
		}
		va_end(args);
	}
	return self;
}
+ (id)stringWithConcatnatingStrings:(NSString *)first, ... {
	NSMutableString *aString = [self stringWithString:first];
	va_list args;
	va_start(args, first);
	for (NSString *component = va_arg(args, NSString *); component != nil; component = va_arg(args, NSString *)) {
		[aString appendString:component];
	}
	va_end(args);
	return aString;
}
@end


#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (SNRAdditions)
- (NSString*)normalizedString
{
	NSMutableString *result = [NSMutableString stringWithString:self];
	CFStringNormalize((__bridge CFMutableStringRef)result, kCFStringNormalizationFormD);
	CFStringFold((__bridge CFMutableStringRef)result, kCFCompareCaseInsensitive | kCFCompareDiacriticInsensitive | kCFCompareWidthInsensitive, NULL);
	return result;
}

- (NSString*)stringByRemovingExtraneousWhitespace
{
	NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
	NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
	NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
	NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
	return [filteredArray componentsJoinedByString:@" "];
}

- (NSString*)stringByRemovingNonAlphanumbericCharacters
{
	static NSMutableCharacterSet *unionSet = nil;
	if (!unionSet) {
		unionSet = [NSMutableCharacterSet alphanumericCharacterSet];;
		[unionSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	}
	return [self stringByFilteringToCharactersInSet:unionSet];
}

- (NSString*)stringByFilteringToCharactersInSet:(NSCharacterSet*)set
{
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	NSScanner *scanner = [NSScanner scannerWithString:self];
	while ([scanner isAtEnd] == NO) {
		NSString *buffer = nil;
		if ([scanner scanCharactersFromSet:set intoString:&buffer]) {
			[result appendString:buffer];	 
		} else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	return result;
}

+ (NSString *)stringFromFileSize:(NSUInteger)theSize
{
	float floatSize = theSize;
	if (theSize < 1023)
		return [NSString stringWithFormat:@"%lu bytes",theSize];
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return [NSString stringWithFormat:@"%1.1f KB",floatSize];
	floatSize = floatSize / 1024;
	if (floatSize < 1023)
		return [NSString stringWithFormat:@"%1.1f MB",floatSize];
	floatSize = floatSize / 1024;
	return [NSString stringWithFormat:@"%1.1f GB",floatSize];
}

- (NSString*)MD5 
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString stringWithFormat:
				@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
				result[0], result[1], result[2], result[3], 
				result[4], result[5], result[6], result[7],
				result[8], result[9], result[10], result[11],
				result[12], result[13], result[14], result[15]
				] lowercaseString];  
}

- (NSString*)URLEncodedString
{
	return [self URLEncodedStringForCharacters:@":/?#[]@!$&’()*+,;="];
}

- (NSString*)URLEncodedStringForCharacters:(NSString*)characters
{
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)characters, kCFStringEncodingUTF8);
}

- (NSString*)upperBoundsString
{
	NSUInteger length = [self length];
	NSString *baseString = nil;
	NSString *incrementedString = nil;
	
	if (length < 1) {
		return self;
	} else if (length > 1) {
		baseString = [self substringToIndex:(length-1)];
	} else {
		baseString = @"";
	}
	UniChar lastChar = [self characterAtIndex:(length-1)];
	UniChar incrementedChar;
	
	// We can't do a simple lastChar + 1 operation here without taking into account
	// unicode surrogate characters (http://unicode.org/faq/utf_bom.html#34)
	
	if ((lastChar >= 0xD800UL) && (lastChar <= 0xDBFFUL)) {		 // surrogate high character
		incrementedChar = (0xDBFFUL + 1);
	} else if ((lastChar >= 0xDC00UL) && (lastChar <= 0xDFFFUL)) {  // surrogate low character
		incrementedChar = (0xDFFFUL + 1);
	} else if (lastChar == 0xFFFFUL) {
		if (length > 1 ) baseString = self;
		incrementedChar =  0x1;
	} else {
		incrementedChar = lastChar + 1;
	}
	
	incrementedString = [[NSString alloc] initWithFormat:@"%@%C", baseString, incrementedChar];
	
	return incrementedString;
}

+ (NSString*)timeStringForTimeInterval:(NSTimeInterval)interval
{
	NSInteger minutes = floor(interval / 60);
	NSInteger seconds = (NSUInteger)(interval - (minutes * 60));
	NSString *secondsString = nil;
	if (seconds == 0) {
		secondsString = @"00";
	} else if (seconds < 10) {
		secondsString = [NSString stringWithFormat:@"0%ld", seconds];
	} else {
		secondsString = [NSString stringWithFormat:@"%ld", seconds];
	}
	return [NSString stringWithFormat:@"%ld:%@", minutes, secondsString];
}

+ (NSString*)humanReadableStringForTimeInterval:(NSTimeInterval)interval
{
	if (interval < 1) { return @""; }
	if (interval < 60) {
		int rounded = floor(interval);
		if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"second", nil)]; }
		return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"seconds", nil)];
	}
	interval = interval / 60;
	//if (interval < 60) {
	int rounded = floor(interval);
	if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"minute", nil)]; }
	return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"minutes", nil)];
   // }
	/*interval = interval / 60;
	if (interval < 24) {
	 int rounded = floor(interval);
	 if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"hour", nil)]; }
	 return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"hours", nil)];
	}
	interval = interval / 24;
	if (interval < 7) {
	 int rounded = floor(interval);
	 if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"day", nil)]; }
	 return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"days", nil)];
	}
	interval = interval / 7;
	if (interval < 4) {
	 int rounded = floor(interval);
	 if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"week", nil)]; }
	 return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"weeks", nil)];
	}
	interval = interval / 4;
	if (interval < 12) {
	 int rounded = floor(interval);
	 if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"month", nil)]; }
	 return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"months", nil)];
	}
	interval = interval / 12;
	int rounded = floor(interval);
	if (rounded == 1) { return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"year", nil)]; }
	return [NSString stringWithFormat:@"%1.f %@", interval, NSLocalizedString(@"years", nil)];*/
	
}

- (NSArray*)spaceSeparatedComponents
{
	return [[self stringByRemovingExtraneousWhitespace] componentsSeparatedByString:@" "];
}

+ (NSString*)randomUUID
{
	CFUUIDRef cfuuid = CFUUIDCreate (kCFAllocatorDefault);
	NSString *string = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, cfuuid);
	CFRelease(cfuuid);
	return string;
}

+ (NSData*)HMACSHA256EncodedDataWithKey:(NSString*)key data:(NSString*)data
{
	const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
	const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
	unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	return [[NSData alloc] initWithBytes:cHMAC length:CC_SHA256_DIGEST_LENGTH];
}
@end

@implementation NSAttributedString (SNRAdditions)

- (NSAttributedString*)attributedStringWithColor:(NSColor*)color
{
	NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] 
														 initWithAttributedString:self];
	int len = [attrTitle length];
	NSRange range = NSMakeRange(0, len);
	[attrTitle addAttribute:NSForegroundColorAttributeName 
							value:color
							range:range];
	[attrTitle fixAttributesInRange:range];
	return attrTitle;
}

- (NSColor*)color
{
	int len = [self length];
	NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
	NSDictionary *attrs = [self fontAttributesInRange:range];
	NSColor *textColor = [NSColor controlTextColor];
	if (attrs) {
		textColor = [attrs objectForKey:NSForegroundColorAttributeName];
	}
	return textColor;
}
@end
