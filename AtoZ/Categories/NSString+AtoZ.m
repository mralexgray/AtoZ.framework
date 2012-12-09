
//  NSString+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSString+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSArray+AtoZ.h"
#import "RuntimeReporter.h"
#import "AtoZ.h"
#import <CommonCrypto/CommonDigest.h>

#define kMaxFontSize	10000



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
- (void)dealloc	{    [strings release];	}
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {	    [strings addObject:string];	}
- (NSString*)getCharsFound {    return [strings componentsJoinedByString:@""];	}
@end

@implementation NSString (AtoZ)


- (NSS*)wikiDescription;
{
	NSString *searchString = $(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",self);
	//	@"https://www.google.com/search?client=safari&rls=en&q=%@&ie=UTF-8&oe=UTF-8", );

	NSString *wikiPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchString]
													encoding:NSUTF8StringEncoding //NSASCIIStringEncoding
													   error:nil];
	//	NSMS* outp = [NSMS new];
	return [wikiPage parseXMLTag:@"Description"];
}


- (NSS*)parseXMLTag:(NSS*)tag;
{
	return [self substringBetweenPrefix:$(@"<%@>",tag) andSuffix:$(@"</%@>",tag)];
}
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
//
//	} // while //
//
//	// trim off whitespace
//	return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
//
//}


- (NSS*)withPath:(NSS*)path;
{
	return [self stringByAppendingPathComponent:path];
}

- (NSString*)stripHtml {
    // take this string obj and wrap it in a root element to ensure only a single root element exists
    NSString* string = [NSString stringWithFormat:@"<root>%@</root>", self];

    // add the string to the xml parser
    NSStringEncoding encoding = string.fastestEncoding;
    NSData* data = [string dataUsingEncoding:encoding];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];

    // parse the content keeping track of any chars found outside tags (this will be the stripped content)
    NSString_stripHtml_XMLParsee* parsee = [[NSString_stripHtml_XMLParsee alloc] init];
    parser.delegate = parsee;
    [parser parse];

    // log any errors encountered while parsing
    //NSError * error = nil;
    //if((error = [parser parserError])) {
    //    NSLog(@"This is a warning only. There was an error parsing the string to strip HTML. This error may be because the string did not contain valid XML, however the result will likely have been decoded correctly anyway.: %@", error);
    //}

    // any chars found while parsing are the stripped content
    NSString* strippedString = [parsee getCharsFound];

    // clean up
    [parser release];
    [parsee release];

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
	CFRelease(uuid);						return AZ_RETAIN(CFBridgingRelease(identifier));
}
+ (NSString *)randomAppPath
{
	return [[[[NSWorkspace sharedWorkspace]launchedApplications]valueForKeyPath:@"NSApplicationPath"]randomElement];
}

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
			NSString *reason = [NSString stringWithFormat: @"LookupIndex %ld is not within range: Expected 0-%ld", index, 	self.length];
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
	return [NSString stringWithFormat:@"%@%@", head, tail];
}

- (NSString *)lcfirst {
	NSString *head = [[self substringToIndex:1] lowercaseString];
	NSString *tail = [self substringFromIndex:1];
	return [NSString stringWithFormat:@"%@%@", head, tail];
}

+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {	return [[self alloc] initWithData:data encoding:encoding]; }

+ (NSString *)stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits
{
	//012345678 <-Indices.
	//42.123400 <-Assuming numDigits = 6.
	//^-----^   <-Returns this substring. (Trailing zeroes are deleted.)
	//42.000000
	//^^		<-Returns this substring (everything before the decimal point) for a whole number.
	NSString *format = numDigits ? [NSString stringWithFormat:@"%%.%luf", numDigits] : @"%f";
	NSString *str = [NSString stringWithFormat:format, (double)f];
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
- (void) setSubclassNames:(NSArray *) names { NSLog(@"Can't set subclass names!"); }
- (id) valueForUndefinedKey:(NSString *) key { return self; }
- (void) setValue:(id)value forUndefinedKey:(NSString *)key { NSLog(@"unknown key:%@", key); }

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
		[layoutManager       setHyphenationFactor:0.0];

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
