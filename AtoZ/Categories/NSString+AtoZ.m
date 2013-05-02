
//  NSString+AtoZ.m
//  AtoZ
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <CommonCrypto/CommonDigest.h>
#define kMaxFontSize 10000
#import "HTMLNode.h"
#import "NSObject+AtoZ.h"
#import "NSColor+AtoZ.h"
#import "NSArray+AtoZ.h"
#import "AtoZFunctions.h"
#import "RuntimeReporter.h"
#import "NSString+AtoZ.h"



NSString *stringForBrightness(CGFloat brightness)
{
	if (brightness < (19.0 / 255)) {
		return @"&";
	}
	else if (brightness < (50.0 / 255)) {
		return @"8";
	}
	else if (brightness < (75.0 / 255)) {
		return @"0";
	}
	else if (brightness < (100.0 / 255)) {
		return @"$";
	}
	else if (brightness < (130.0 / 255)) {
		return @"2";
	}
	else if (brightness < (165.0 / 255)) {
		return @"1";
	}
	else if (brightness < (180.0 / 255)) {
		return @"|";
	}
	else if (brightness < (200.0 / 255)) {
		return @";";
	}
	else if (brightness < (218.0 / 255)) {
		return @":";
	}
	else if (brightness < (229.0 / 255)) {
		return @"'";
	}
	return @" ";
}

@implementation NSImage(ASCII)

- (NSString *)asciiArtWithWidth:(NSInteger)width height:(NSInteger)height
{
	if (!width)
		return nil;
	if (!height)
		return nil;
	
	NSMutableString *string = [NSMutableString string];
	
	NSImage *tempImage = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
	[tempImage lockFocus];
	[self drawInRect:NSMakeRect(0, 0, [tempImage size].width, [tempImage size].height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];	
	[tempImage unlockFocus];

	NSBitmapImageRep *bitmapImage = [[NSBitmapImageRep alloc] initWithData:[tempImage TIFFRepresentation]];
	
	for (int i = 0; i < [tempImage size].height; i++) {
		for (int j = 0; j < [tempImage size].width; j++) {
			NSColor *color = [bitmapImage colorAtX:j y:i];
			NSColor *wColor = [color colorUsingColorSpaceName:NSDeviceWhiteColorSpace];
			[string appendString:stringForBrightness([wColor whiteComponent])];
		}
		[string appendString:@"\n"];
	}
	[bitmapImage release];
	[tempImage release];
	return string;
}

@end



@implementation Definition
@end


@implementation NSString (MD5)
- (NSS*)MD5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);       // This is the md5 call
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
//	for(i = 0; i < 16; i++)     sprintf(&md5str[i * 2], "%02x", digest[i]);
//	md5str[32] = '\0';
//	ret = [NSString stringWithUTF8String:md5str];
//	free(md5str);
//	return ret;
//}
@end

//  Copyright 2011 Leigh McCulloch. Released under the MIT license.
@interface NSString_stripHtml_XMLParsee : NSObject<NSXMLParserDelegate> {
    @private
    NSMutableArray *strings;
}
- (NSS*)getCharsFound;
@end
@implementation NSString_stripHtml_XMLParsee
- (id)init {
    if (!(self = [super init])) return nil;
    strings = NSMA.new;
    return self;
}

- (void)dealloc {
    [strings release];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSS*)string {
    [strings addObject:string];
}

- (NSS*)getCharsFound {
    return [strings componentsJoinedByString:@""];
}

@end

@implementation NSString (AtoZ)

- (BOOL) isInteger { return self.isIntegerNumber; }

- (NSComparisonResult)compareNumberStrings:(NSS*)str {
    NSNumber *me = [NSNumber numberWithInt:[self intValue]];
    NSNumber *you = [NSNumber numberWithInt:[str intValue]];
    return [you compare:me];
}

- (NSS *)justifyRight:(NSUI)col;
{
    NSS *str = self;
    int add = col - str.length;
    if (add > 0) {
        NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
        str = [pad stringByAppendingString:str];
    }
    return str;
}

- (NSS *)unescapeUnicodeString {
    // unescape quotes and backwards slash
    NSString *unescapedString = [self stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    unescapedString = [unescapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];

    // tokenize based on unicode escape char
    NSMutableString *tokenizedString = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:unescapedString];
    while ([scanner isAtEnd] == NO) {
        // read up to the first unicode marker if a string has been scanned, it's a token and should be appended to the tokenized string
        NSString *token = @"";
        [scanner scanUpToString:@"\\u" intoString:&token];
        if (token != nil && token.length > 0) {
            [tokenizedString appendString:token];
            continue;
        }
        // skip two characters to get past the marker check if the range of unicode characters is beyond the end of the string (could be malformed) and if it is, move the scanner to the end and skip this token
        NSUInteger location = [scanner scanLocation];
        NSInteger extra = scanner.string.length - location - 4 - 2;
        if (extra < 0) {
            NSRange range = { location, -extra };
            [tokenizedString appendString:[scanner.string substringWithRange:range]];
            [scanner setScanLocation:location - extra];
            continue;
        }
        // move the location pas the unicode marker then read in the next 4 characters
        location += 2;
        NSRange range = { location, 4 };
        token = [scanner.string substringWithRange:range];
        unichar codeValue = (unichar)strtol([token UTF8String], NULL, 16);
        [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
        // move the scanner past the 4 characters then keep scanning
        location += 4;
        [scanner setScanLocation:location];
    }
    return tokenizedString;
}

- (NSS*)escapeUnicodeString {
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString *escapedString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData *data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char *bytes = data.bytes;
    NSMutableString *encodedString = [NSMutableString string];

    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length) {
        uint16_t code = *((uint16_t *)&bytes[bytesRead]);
        if (code > 0x007E) {
            [encodedString appendFormat:@"\\u%04X", code];
        } else {
            [encodedString appendFormat:@"%C", code];
        }
        bytesRead += sizeof(uint16_t);
    }

    // done
    return encodedString;
}

- (NSS *)w_NP_String:(NSS *)string;
{
    return [self withString:$(@"\n\n%@", string)];
}

- (NSS *)w_String:(NSS *)string;
{
    return [self withString:$(@" %@", string)];
}
- (NSS *)withString:(NSS *)string;
{
    return [self stringByAppendingString:string];
}
- (NSS*)JSONRepresentation {
    __block NSMutableString *jsonString = @"\"".mutableCopy;

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
                if (nextChar < 32)                 // all ctrl chars must be escaped
                    [jsonString appendString:[NSString stringWithFormat:@"\\u%04x", nextChar]];
                else [jsonString appendString:[NSString stringWithCharacters:&nextChar length:1]];
                break;
        }
    }];
    [jsonString appendString:@"\""];
    return jsonString;
}

+ (NSS *)stringFromArray:(NSA *)a; {

	return [self stringFromArray:a withDelimeter:@"" last:@""];
}
+ (NSS*) stringFromArray:(NSA*)a withSpaces:(BOOL)spaces onePerline:(BOOL)newl {
	return [self stringFromArray:a withDelimeter:spaces ? @" " : newl ? @"\n" : @"" last:spaces ? @" " : newl ? @"\n" : @""];
}

+ (NSS*) stringFromArray:(NSA*)a withDelimeter:(NSS*)del last:(NSS*)last {
	if (!a.count) return nil;
	NSS* outString = [a reduce:@"" withBlock:^id (id sum, id obj) {
   	return [[sum withString:obj] withString:del];
	}];
	return [[outString stringByDeletingSuffix:del]withString:last];
}

+ (NSS *)dicksonParagraphWith:(NSUI)sentences {
    return [self stringFromArray:[self.dicksonPhrases.shuffeled withMaxItems:sentences]];
}

+ (NSA *)dicksonPhrases {
    return [self.dicksonBible extractAllSentences];
}

+ (NSA *)dicksonisms {
    static NSA *dicks = nil;                return dicks = dicks ? dicks : @[
            @"When I was 10 years old - I wore this dress; I just keep getting it altered.",  @"See? I still fit into my 10-year-old clothing.", @"Look at that! Oh, is that me on the wall? I drew it myself - with chalk!",
            @"I can't move, but boy, can I ever pose!", @"I wish there was a close up on my face.. there it is! <<sighing>> Wow, looking better and better all the time.",
            @"That's a - beret - it's from Europe.", @"I really shouldn't be doing this; but I'm going to have an ad for IKEA right now.",
            @"This is a complete IKEA closet.  The bed is underneath my pants.", @"If you have a look - you can see that everything fits - into this particle board.   You just paint it white.. pull it out... oh gold and silver! (those are my two signature colors.)"];
}

+ (NSS *)dicksonBible {
    return @"When do I look at the camera?  When do I look? <gasp> Hi, what a surprise that you're here.  Welcome... to my bathroom.  My fingers are.. fused together. My thumb was broken... in.. an... acting.. accident..  I can't wait to show you more of my face. Look at my face.    There's my face, there's my face!  That's not my body... but this is my.. FACE. Here are four looks. I have four different emotions - they may seem the same.. oh there's my high school grad picture.. and my picture from Woolworth's!I like to stare blankly into space.  <<chuckle>> that's something I do. When I was 10 years old - I wore this dress; I just keep getting it altered.  See? I still fit into my 10-year-old clothing. Look at that! Oh, is that me on the wall? I drew it myself - with chalk!  I can't move, but boy, can I ever pose!  I wish there was a close up on my face.. there it is! <<sighing>> Wow, looking better and better all the time. That's a - beret - it's from Europe.  I really shouldn't be doing this; but I'm going to have an ad for IKEA right now.  This is a complete IKEA closet.  The bed is underneath my pants. If you have a look - you can see that everything fits - into this particle board.   You just paint it white.. pull it out... oh gold and silver! (those are my two signature colors.)	What are legs good for? They're not good for pants.. they're good for sitting!   It's after Labor Day and I am wearing white. This is a very comfortable pose. This is how all the models do it. This is called boobies.		And this is another picture of my FACE. I liked putting Vaseline on the lens; it erases all lines that one may have on their face.  It's a fashion face; a face full of fashion.	I eat so much fowl - I shit feathers!It's winter - so I wear pantyhose with my open-toed sandals.I hope I never get arrested for not leaving a premises which is no longer mine!	I still I look like a teenager, don't I?  Well, thankfully my herpes is in remission, right now.  Look, no blisters, not one!  Just a cold sore!  Oh, that's herpes.  Oh, It's back.	I like to fill my breasts with photos of myself; one's bigger than the other...  because my hair is - greater on one side.  This is live video footage of me.I don't blink; that's a huge part of fashion. Breathe in my eye - just some air, nothing.  I do not blink.  Not at all.  Good for me!		Here's what happens when I go down on my knees. I'm bending down right now, and I'm on my knees. There, I'm on my knees right now. I can really stay on my knees a very long time - huge part of fashion.		The look this season is clothes that don't fit correctly. These pants are way too tight, not my size. This top is completely not my size.  Isn't it fashion?!		This top doesn't fit at all <<awkward chuckle>>		These boots don't fit.  I wonder if belts fit?  No, the belt does not fit either.  <<sigh>>		Oh, these boots fit, but the purse is the wrong size (I got this from Pic-N-Save)  I'll tell you.. their Halloween collection.. not a lot to be desired... <<creepy sigh>>		This is an oversized top. These are my breasts. I have two of them.  I even 'out' my breasts on my own; it's still the same Wol-Co. photo from earlier.  I just cropped it to make it larger.. oh I cropped it again... I'm really, really good with scissors. I'll tell you that much.		Here's what I wear too bed. It's, it's like a trap - a spider trap. I get them into my bu'drow... and then I, I eat their head off.  They're absolutely delicious!		I always wanted to be on dynasty... but here's two things: and nipple and a tertiary nipple.  I have two nipples. Uh, My tummy does not have any support right now - that's just me.  And white shoes.. It's before - and after Labor Day.		I wanted to show you this necklace.  I'm wearing a gold necklace - umm, with diamonds - I wear it every single shot - every single one.  Watch this...  Prest-o Change-o!  Let's go up a little bit.. Let me get on my knees - I'm going down.  Look what's there! It's a heart diamond necklace! If you see on my left- umm right-hand side..  That's My kitty cat - I named it Chester.. and I.. he was absolutely delicious.		And and I'm also part of aChipapeantribe...  I thought I looked very.. native.. North American in this. Uh, I like to bring out my culture, my taste... oh, uh, when you open your legs, ladies - watch the Seaguls...  Sometimes they come a-flock and - they're your friends, too!  I.. could... make a hat out of most of them.		Let's open the microwave and see what I've made. Enjoy some popcorn - absolutely yumms. Yes, I do eat solid foods. But I have four microwaves stacked on top of each other for when company comes over. My door is always welcome to you.   For Halloween I'm going to dress up as.. a Hooker!  Won't that be fun!? Look at all the choices that I have!  Oh, the kids just love it.ABCDEF..GHIJKL.. M..N..OPQRS.. oh what's next, I can't remember what's next, UVWX.Y.Z! I wish I was Jacqueline Smith.. but I'm not... so here's my face double..   Okay - I like to put makeup over my makeup.. and then tattoo my makeup on. I got it from Pic-N-Save. I'm already tattooed, but you can never have enough, you know, can you?  awkakwaka.		My schedule is free so I'm available for donkey shows.. for grand openings.. for sales...  I'm good at telemarketing - and flourishes - watch the hand. So - you know, for Halloween this is how we're going to look. Some people use it as a daily look.  It's Halloween everday in my house - every single day!Welcome, Sorry I'm late... I gave myself a camel toe - and not the Dorothy Hamill kind.";
}

+ (NSS *)randomWord {
    NSURLRequest *request = [NSURLRequest requestWithURL:$URL(@"http://randomword.setgetgo.com/get.php") cachePolicy:0 timeoutInterval:5];
    NSURLResponse *response = nil;    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSS *theWord = data ? [NSString stringWithData:data encoding:NSUTF8StringEncoding] : @"Timeout!";
    return [theWord stringByTrimmingWhiteSpace];
}

//return ((NSS*)[NSS stringWithContentsOfURL: encoding:NSUTF8StringEncoding error:nil]).trim; }

+ (NSS *)randomWiki {
    __block NSS *wiki; __block NSS *word;  NSUI tries = 10; [[NSA from:0 to:tries] az_eachConcurrentlyWithBlock:^(NSI index, id obj, BOOL *stop) {
        NSS *rando = NSS.randomWord.trim;
        NSS *randoWiki = rando.wikiDescription;
        if (randoWiki) {  wiki = randoWiki;  word = rando;  *stop = YES; }
        return;
    }];
    return $(@"%@:  %@", word, wiki);
}

- (NSS *)wikiDescription { static NSS* wikiURL = nil;  wikiURL = wikiURL ?: @"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=XXXX&MaxHits=1";
	NSS *searchstring = [wikiURL stringByReplacing:@"XXXX" with:self.urlEncoded];
	NSError *err;
	NSData *responseData = [NSURLC sendSynchronousRequest: [NSURLREQ requestWithURL:$URL(searchstring) cachePolicy:AZNOCACHE timeoutInterval:10.0]  returningResponse:nil error:&err];
	if (!responseData || err) {			NSLog(@"Connection Error: %@", err.localizedDescription); return; 	}
	else	return [[NSS stringWithData:responseData encoding:NSUTF8StringEncoding]parseXMLTag:@"Description"].stringByDecodingXMLEntities ?: @"error parsing XML";

	//[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];

//
//	 NSError *requestError = nil;
//    NSS *wikiPage =  [NSS stringWithContentsOfURL:$URL($(, self)) encoding:NSUTF8StringEncoding error:&requestError];
//    //http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=%@&MaxHits=1",self)) encoding:NSUTF8StringEncoding  error:&requestError]; //NSASCIIStringEncoding
//
//	 	if (requestError != nil) LOGCOLORS(@"Error parsing wiki", requestError, ORANGE, RED, nil);
//		else  return [wikiPage parseXMLTag:@"Description"].stringByDecodingXMLEntities ?: @"Error parsing XML";
		//requestError ? $(@"Error parsing wiki: %@", requestError) : ;      // $(@"%@: %@", self,
}

+ (NSS *)spaces:(NSUI)ct {
    return [[@(0)to : @(ct)] reduce:^id (id memo, id l) { return [memo withString:@" "]; } withInitialMemo:@""];
}

+ (NSS *)randomBadWord {
    return [self badWords].randomElement;
}

+ (NSA *)badWords {
    static NSA *swearwords = nil;
    swearwords = swearwords ? : [NSA arrayFromPlist:[AZFWRESOURCES withPath:@"BadWords.plist"]];
    return swearwords;
}

- (void)setLogForeground:(id)color {
//	printf("setting fg: %s", ((NSC*)color).nameOfColor.UTF8String);
    [self setAssociatedValue:[AZLOGSHARED rgbColorValues:color] forKey:@"logFG" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)setLogBackground:(id)color {
    [self setAssociatedValue:[AZLOGSHARED rgbColorValues:color] forKey:@"logBG" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

//- (const char*) ttyClr {
//
//	BOOL inTTY =  [@(isatty(STDERR_FILENO))boolValue];
//	if (inTTY) return s;
//	NSArray* cs = @[@31,@32,@33,@34,@35,@36,@37];
//	NSArray* bg = @[@40];//,@41,@42,@43,@44,@45,@46,@47];
//
//	NSNumber* num = cs[arc4random() % 7 ];
//	NSNumber* nub = bg[arc4random() % 1 ];
//	NSString *let = [num stringValue];
//	NSString *blet = [nub stringValue];
//
//	return [NSString stringWithFormat:@"\033[%@;%@m%@\033[0m - %@", let,blet, s, num];
//}


// BLINKING
// "\033[38;5mWhatever\033[0m"


- (const char*) cchar {  return self.clr.UTF8String; }

- (NSS *)colorLogString {

static BOOL isaColorTTY, isaColor256TTY, isaXcodeColorTTY;  static BOOL envSet = NO;
		
			
	if (envSet == NO) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
				static Class tty = nil;  tty = tty ?: NSClassFromString(@"DDTTYLogger");  [tty sharedInstance];
							char *term = getenv("TERM");
							term ? ^{
								if (strcasestr(term, "color") != NULL)	{
									isaColorTTY = YES;
									isaColor256TTY = (strcasestr(term, "256") != NULL);
									if ([tty sharedInstance]) 	
    

									objc_msgSend([tty class],
										NSSelectorFromString( isaColor256TTY ? @"initialize_colors_256" : @"initialize_colors_16"));
								}
							}() : ^{
								// Xcode does NOT natively support colors in the Xcode debugging console.
								// You'll need to install the XcodeColors plugin to see colors in the Xcode console
								char *xcode_colors = getenv("XcodeColors");
								isaXcodeColorTTY = xcode_colors && (strcmp(xcode_colors, "YES") == 0);
							}();
		fprintf(stderr, "%sisaColorTTY\t=\t%s%s\t%sisaColor256TTY\t=\t%s%s\t%s", 
		isaColorTTY ? "\033[38;5m" : "",  isaColorTTY ? "YES" : "NO", isaColorTTY ? "\033[0m" : "", 
		isaColorTTY ? "\033[38;5m" : "",  isaColor256TTY ? "YES" : "NO", isaColorTTY ? "\033[0m" : "", 
		$(@"%@isaXcodeColorTTY\t=\t%@%@",isaXcodeColorTTY ? XCODE_COLORS_ESCAPE @"fg244,100,80;" : @"", StringFromBOOL(isaXcodeColorTTY), isaXcodeColorTTY ? XCODE_COLORS_RESET : @"").UTF8String);
	});
	}
	envSet = YES;
	if (!isaColorTTY  && !isaColor256TTY && !isaXcodeColorTTY) return self;
	NSA *fgs = [self hasAssociatedValueForKey:@"logFG"] ? [self associatedValueForKey:@"logFG"] : nil;
   NSA *bgs = [self hasAssociatedValueForKey:@"logBG"] ? [self associatedValueForKey:@"logBG"] : nil;

	if (!fgs && !bgs) return self;
   NSS *colored = [NSS stringWithString:self.copy];
	if ((( fgs && fgs.count == 3) || (bgs && bgs.count ==3) ) && isaXcodeColorTTY) {
		if (fgs && fgs.count ==3) {
			  colored = $(XCODE_COLORS_ESCAPE @"fg%i,%i,%i;%@" XCODE_COLORS_RESET,
							  [fgs[0] intValue], [fgs[1] intValue], [fgs[2] intValue], colored);
		 }
		 if (bgs && bgs.count ==3) {
			  colored = colored ? : self;
			  colored = $(XCODE_COLORS_ESCAPE @"bg%i,%i,%i;%@" XCODE_COLORS_RESET,
							  [bgs[0] intValue], [bgs[1] intValue], [bgs[2] intValue], colored);
		 }
		 return colored;
	}
	if (isaColor256TTY || isaColorTTY){
		NSArray* cs = @[@31,@32,@33,@34,@35,@36,@37];
		NSArray* bg = @[@40,@41,@42];//,@43,@44,@45,@46,@47];

		NSNumber* num = cs[arc4random() % 7 ];
		NSNumber* nub = bg[arc4random() % 3 ];
		NSString *let = [num stringValue];
		NSString *blet = [nub stringValue];
		return [NSString stringWithFormat:@"\033[%@;%@m%@\033[0m", let,blet, self];
	}
}

//	NSUInteger fgCodeIndex;	NSString *fgCodeRaw;	char fgCode[24];	size_t fgCodeLen;	char resetCode[8];	size_t resetCodeLen;
//
//	if (fgs && isaColorTTY) {
//		NSC*fgColor = [NSC r:[fgs[0] floatValue] g:[fgs[1]floatValue] b:[fgs[2] floatValue] a:1];
//		// Map foreground color to closest available shell color
//		fgCodeRaw   = DDTTYLogger.codes_fg[fgCodeIndex];
//		NSString *escapeSeq = @"\033[";
//		NSUInteger len1 = [escapeSeq lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//		NSUInteger len2 = [fgCodeRaw lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//		[escapeSeq getCString:(fgCode)      maxLength:(len1+1) encoding:NSUTF8StringEncoding];
//		[fgCodeRaw getCString:(fgCode+len1) maxLength:(len2+1) encoding:NSUTF8StringEncoding];
//			
//			fgCodeLen = len1+len2;
//	}
//	NSS* save = [AZTEMPD withPath:@"whatever.txt"];
//	[@{@"color": colored } writeToFile:save atomically:YES];
//	printf("%s", save.UTF8String);
//    return colored ? : self;//@"Something went wrong";

//	else if (fgColor && isaXcodeColorTTY)
//	{
		// Convert foreground color to color code sequence
//		const char *escapeSeq = XCODE_COLORS_ESCAPE_SEQ;
//		int result = snprintf(fgCode, 24, "%sfg%u,%u,%u;", escapeSeq, fg_r, fg_g, fg_b);
//		fgCodeLen = MIN(result, (24-1));
//	}
//	else
//	{
//		// No foreground color or no color support
//		
//		fgCode[0] = '\0';
//		fgCodeLen = 0;
//	}

- (NSUI) longestWordLength {  return  [self words].lengthOfLongestMemberString; }

- (NSS *)paddedTo:(NSUI)count {
    return [self stringByPaddingToLength:count withString:@" " startingAtIndex:0];
}

+ (NSA *)properNames {
    NSS *names = @"/usr/share/dict/propernames";
    return [[[self stringWithContentsOfFile:names usedEncoding:NULL error:NULL] componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet]
            sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

+ (void)randomUrabanDBlock:(void (^)(Definition *definition))block {
    __block Definition *urbanD;
    ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
    [requester setCompletionBlock:^(ASIHTTPRequest *request) {
        NSS *responsePage               = request.responseString.copy;
        NSError *requestError   = [request error];
        if (!requestError) {
            AZHTMLParser *p =       [AZHTMLParser.alloc initWithString:responsePage error:&requestError];
            NSS *title                      =       [[p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES]
                                                     getAttributeNamed:@"content"];
            NSS *desc                       =       [[p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES]
                                                     getAttributeNamed:@"content"];
            urbanD = $DEFINE(title, desc);               ///rawContents.urlDecoded.decodeHTMLCharacterEntities);
            block(urbanD);
        } else urbanD = $DEFINE(@"undefined", @"no response from urban");
    }];
    [requester startAsynchronous];
}

+ (Definition *)randomUrbanD;
{
    __block Definition *urbanD;

    ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://www.urbandictionary.com/random.php"))];
    [requester setCompletionBlock:^(ASIHTTPRequest *request) {
        NSS *responsePage = request.responseString.copy;
//		NSLog(@"Response:%@", responsePage);
        NSError *requestError   = [request error];
        if (!requestError) {
            AZHTMLParser *p = [AZHTMLParser.alloc initWithString:responsePage error:&requestError];
            NSS *title      =       [[p.head findChildWithAttribute:@"property" matchingName:@"og:title" allowPartial:YES] getAttributeNamed:@"content"];
            NSS *desc       =       [[p.head findChildWithAttribute:@"property" matchingName:@"og:description" allowPartial:YES] getAttributeNamed:@"content"];
//			NSLog(@"title: %@  desc: %@", title, desc );
            urbanD = $DEFINE(title, desc);               ///rawContents.urlDecoded.decodeHTMLCharacterEntities);
        } else urbanD = $DEFINE(@"undefined", @"no response from urban");
    }];
    [requester startAsynchronous];
    return urbanD;
}



//	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",self))];
/**	ASIHTTPRequest *requester = [ASIHTTPRequest.alloc initWithURL:$URL($(@"http://en.wikipedia.org/w/api.php?action=parse&page=%@&prop=text&section=0&format=json&callback=?", self))];//http://en.wikipedia.org/w/api.php?action=parse&page=%@&format=json&prop=text&section=0",self))];
        [requester setCompletionBlock:^(ASIHTTPRequest *request) {
                wikiD               = request.responseString.copy;
                requestError    = [request error];
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


- (BOOL)loMismo:(NSS *)s {
    return [self isEqualToString:s];
}

- (NSS*)stringByStrippingHTML {
    NSRange r;
    NSString *s = [[self copy] autorelease];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSS *)parseXMLTag:(NSS *)tag; {       return [self substringBetweenPrefix:$(@"<%@>", tag) andSuffix:$(@"</%@>", tag)]; }
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
- (NSS *)unescapeQuotes; {
    return [self stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

- (NSS *)stringByCleaningJSONUnicode {
    // Remove unsafe JSON characters
    //
    // http://www.jslint.com/lint.html#unsafe
    //
    NSMutableString *jsonStr = self.mutableCopy;
    if (jsonStr.length > 0) {
        NSMutableCharacterSet *unsafeSet = [NSMutableCharacterSet new];
        void (^ addUnsafe)(NSInteger, NSInteger) = ^(NSInteger from, NSInteger to) {
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

- (NSS*)stringByDecodingXMLEntities {
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
        if ([scanner scanString:@"&amp;" intoString:NULL]) [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL]) [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL]) [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL]) [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL]) [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            } else {
                gotNumber = [scanner scanInt:(int *)&charCode];
            }
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                [scanner scanString:@";" intoString:NULL];
            } else {
                NSString *unknownEntity = @"";
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];

                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
        } else {
            NSString *amp;
            [scanner scanString:@"&" intoString:&amp];              //an isolated & symbol
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
    } while (![scanner isAtEnd]);
 finish:
    return result;
}

- (NSS *)withPath:(NSS *)path {
    return [self stringByAppendingPathComponent:path];
}

- (NSS *)withExt:(NSS *)ext; { return [self stringByAppendingPathExtension:ext];  }

- (NSS*)stripHtml {
    // take this string obj and wrap it in a root element to ensure only a single root element exists
    NSString *string = (@"<root>%@</root>", self);
    // add the string to the xml parser
    NSStringEncoding encoding = string.fastestEncoding;
    NSData *data = [string dataUsingEncoding:encoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    // parse the content keeping track of any chars found outside tags (this will be the stripped content)
    NSString_stripHtml_XMLParsee *parsee = NSString_stripHtml_XMLParsee.new;
    parser.delegate = parsee;               [parser parse];
    NSError *error = nil;       // log any errors encountered while parsing
    if ((error = [parser parserError])) {
        NSLog(@"This is a warning only. There was an error parsing the string to strip HTML. This error may be because the string did not contain valid XML, however the result will likely have been decoded correctly anyway.: %@", error);
    }
    // any chars found while parsing are the stripped content
    NSString *strippedString = [parsee getCharsFound];
    // clean up
    [parser release];       [parsee release];
    // get the raw text out of the parsee after parsing, and return it
    return strippedString;
}

+ (NSS*)clipboard {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *supportedTypes = [NSArray arrayWithObject:NSStringPboardType];
    NSString *type = [pasteboard availableTypeFromArray:supportedTypes];
    NSString *value = [pasteboard stringForType:type];
    return value;
}

- (void)copyToClipboard {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]
                       owner:nil];
    // Above, we can say owner:nil since we are going to provide data immediately
    [pasteboard setString:self
                  forType:NSStringPboardType];
}

- (unichar)lastCharacter {
    return [self characterAtIndex:([self length] - 1)];
}

- (NSS*)substringToLastCharacter {
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
- (NSS*)decodeAllAmpersandEscapes {
    return [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

- (NSN*)numberValue {
    return [[[NSNumberFormatter alloc] init] numberFromString:self];
}

- (void)copyFileAtPathTo:(NSS*)path {
    if ([[NSFileManager defaultManager] isReadableFileAtPath:self]) [[NSFileManager defaultManager] copyItemAtPath:self toPath:path error:nil];
}

- (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSS*)fontName;
{
    return [[self class] pointSizeForFrame:frame withFont:fontName forString:self];
}
+ (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSS*)fontName forString:(NSS*)string;
{
    NSFont *displayFont = nil;
    NSSize stringSize = NSZeroSize;
    NSUInteger fontLoop = 0;
    NSMutableDictionary *fontAttributes = [[NSMutableDictionary alloc] init];
    if (frame.size.width == 0.0 && frame.size.height == 0.0) return 0.0;
    for (fontLoop = 1; fontLoop <= kMaxFontSize; fontLoop++) {
        displayFont = [[NSFontManager sharedFontManager] convertWeight:YES ofFont:[NSFont fontWithName:fontName size:fontLoop]];
        fontAttributes[NSFontAttributeName] = displayFont;
        stringSize = [string sizeWithAttributes:fontAttributes];
        if ( (stringSize.width > frame.size.width) || (stringSize.height > frame.size.height) ) break;
    }
    [fontAttributes release], fontAttributes = nil;
    return (CGFloat)fontLoop - 1.0;
}

- (NSS*)stringByReplacingAllOccurancesOfString:(NSS*)search withString:(NSS*)replacement {
    return [NSString stringWithString:[[self mutableCopy]replaceAll:search withString:replacement]];
}

- (NSS*)urlEncoded {       // Encode all the reserved characters, per RFC 3986
//	CFStringRef escaped =
//	return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//											(CFStringRef)self, NULL,
//											(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
//@"~!@#$%^&*():{}\"€!*’();:@&=+$,/?%#[]",
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

- (NSS*)urlDecoded {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:(NSRange) {0, [resultString length] }];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSS*)firstLetter {
    return [self substringWithRange:NSMakeRange(0, 1)];
}

+ (NSS*)newUniqueIdentifier {
    CFUUIDRef uuid = CFUUIDCreate(NULL);    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);                                                return AH_RETAIN(CFBridgingRelease(identifier));
}

+ (NSS*)randomAppPath {
    return [[[[NSWorkspace sharedWorkspace]launchedApplications]valueForKeyPath:@"NSApplicationPath"]randomElement];
}

+ (NSS *)randomDicksonism {
    return self.dicksonisms.randomElement;
}

+ (NSS*)randomWords:(NSInteger)number;
{
    return [[LoremIpsum new] words:number];
}
+ (NSS*)randomSentences:(NSInteger)number;
{
    return [[LoremIpsum new] sentences:number];
}
//- (NSColor *)colorValue {	return [NSColor colorFromString:self]; }
- (NSData *)colorData {
    return [NSArchiver archivedDataWithRootObject:self];
}

+ (NSColor *)colorFromData:(NSData *)theData {
    return [NSUnarchiver unarchiveObjectWithData:theData];
}

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
- (void)drawCenteredInRect:(NSR)rect withFont:(NSF *)font {
//- (void)drawCenteredInFrame:(NSRect)frame withFont:(NSF*)font {
//	NSView *view = framer;
//	NSSize size = view.frame.size;// WithFont:font;
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self attributes:@{ font: NSFontAttributeName, NSFontSizeAttribute: @(font.pointSize) } ];
//	CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
//								   rect.origin.y + (rect.size.height - size.height) / 2,
//								   size.width, size.height);
    [string drawCenteredVerticallyInRect:rect];    // withFontNamed:font.fontName andColor:WHITE];//@{font:NSFontNameAttribute }];
}

- (void)drawInRect:(NSRect)r withFont:(NSFont *)font andColor:(NSColor *)color {
    [self drawInRect:r withFontNamed:font.fontName andColor:color];
}

- (NSSZ)sizeWithFont:(NSFont *)font margin:(NSSZ)size;
{
    NSSZ sz = [self sizeWithFont:font];
    sz.width += 2 * size.width;
    sz.height += 2 * size.height;
    return sz;
}
- (NSSZ)sizeWithFont:(NSFont *)font;
{
    NSD *attrs = [NSD dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    NSAttributedString *s = [[NSAttributedString alloc]initWithString:self attributes:attrs];
    return [s  size];
}

- (CGF)widthWithFont:(NSF *)font {
    return [self sizeWithFont:font margin:NSMakeSize(font.pointSize / 2, font.pointSize / 2)].width;
}

- (NSR)frameWithFont:(NSF *)font {
    return AZRectFromSize([self sizeWithFont:font margin:NSMakeSize(font.pointSize / 2, font.pointSize / 2)]);
}

- (void)drawInRect:(NSRect)r withFontNamed:(NSS *)fontName andColor:(NSColor *)color {
    NSMPS *paraAttr = [[NSMPS defaultParagraphStyle ] mutableCopy];
    [paraAttr setAlignment:NSCenterTextAlignment];
    [paraAttr setLineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat points  = [self pointSizeForFrame:r withFont:fontName];
    NSF *fnt                = [NSFont fontWithName:fontName size:points] ? : [AtoZ font:fontName size:points] ? : [NSFont fontWithName:@"Helvetica" size:points];

    NSAS *drawingString = [[NSAS alloc] initWithString:self attributes:@{  NSFontAttributeName: fnt,
                                                                           NSForegroundColorAttributeName: color,
                                                                           NSParagraphStyleAttributeName: paraAttr }];
    [drawingString drawInRect:r];
}

//		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
////		[paraStyle setParagraphStyle:	[NSParagraphStyle defaultParagraphStyle]];
////		[paraStyle setAlignment:		NSCenterTextAlignment];
//		NSDictionary *msgAttrs = @{        NSFontAttributeName : font.fontName,
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
- (NSS*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSS*)shifted {
    return [self substringFromIndex:1];
}

- (NSS*)popped {
    return [self substringWithRange:NSMakeRange(0, self.length - 1)];
}

- (NSS*)chopped {
    return [self substringWithRange:NSMakeRange(1, self.length - 2)];
}

- (NSS*)camelized {
    return [[self mutableCopy] camelize];
}

- (NSS*)hyphonized {
    return [[self mutableCopy] hyphonize];
}

- (NSS*)underscored {
    return [[self mutableCopy] underscorize];
}

- (BOOL)isEmpty {
    return (self == nil || [self isKindOfClass:[NSNull class]]
            || [self.trim isEqualToString:@""]
            || ([self respondsToSelector:@selector(length)] && ([(NSData *)self length] == 0))
            || ([self respondsToSelector:@selector(count)] && ([(NSA*)self count] == 0)));
}

/*** Actually this should be called stringByReversingThisString, but that appeared to be too much sugar-free.  Reverse ist non-destructive */
- (NSS*)reversed  {
    NSMutableString *re = NSMutableString.string;
    for (int i = self.length - 1; i >= 0; i--) {
        [re appendString:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    return re;
}

- (NSUInteger)count:(NSS*)s options:(NSStringCompareOptions)mask {
    NSUInteger re = 0;      NSRange rr, r; r = (NSRange) {0, self.length };
    while ((rr = [self rangeOfString:s options:mask range:r]).location != NSNotFound) {
        re++;
        r.location = rr.location + 1;   r.length = self.length - r.location;
    }
    return re;
}

- (NSUInteger)count:(NSS*)aString {
    return [self count:aString options:0];
}

- (NSUInteger)indentationLevel {
    NSUInteger re = 0;
    while (re < self.length && [[self substringWithRange:NSMakeRange(re, 1)] isEqualToString:@" "]) re++;
    return re;
}

- (BOOL)contains:(NSS*)aString {
    return [self rangeOfString:aString].location != NSNotFound;
}

- (BOOL)containsAnyOf:(NSA*)array {
    for (id v in array) {
        NSString *s = [v description];
        if ([v isKindOfClass:[NSString class]]) s = (NSS*)v;
        if ([self contains:s]) return YES;
    }
    return NO;
}

- (BOOL)containsAllOf:(NSA *)array {
    for (id v in array) {
        NSString *s = [v description];
        if ([v isKindOfClass:[NSString class]]) s = (NSS*)v;
        if (![self contains:s]) return NO;
    }
    return YES;
}

- (BOOL)startsWith:(NSS*)aString {
    return [self hasPrefix:aString];
}

- (BOOL)endsWith:(NSS*)aString {
    return [self hasSuffix:aString];
}

- (BOOL)hasPrefix:(NSS*)prefix andSuffix:(NSS*)suffix {
    return [self hasPrefix:prefix] && [self hasSuffix:suffix];
}

- (NSS*)substringBetweenPrefix:(NSS*)prefix andSuffix:(NSS*)suffix {
    NSRange pre = [self rangeOfString:prefix];
    NSRange suf = [self rangeOfString:suffix];
    if (pre.location == NSNotFound || suf.location == NSNotFound) return nil;
    NSUInteger loc = pre.location  + pre.length;
    NSUInteger len = self.length - loc - (self.length - suf.location);
    //NSLog(@"Substring with range %i, %i, %@", loc, len, NSStringFromRange(r));
    return [self substringWithRange:(NSRange) {loc, len }];
}

/*** Unlike the Object-C default rangeOfString this method will return -1 if the String could not be found, not NSNotFound	 */
- (NSInteger)indexOf:(NSS*)aString {
    return [self indexOf:aString afterIndex:0];
}

- (NSInteger)indexOf:(NSS*)aString afterIndex:(NSInteger)index {
    NSRange lookupRange = NSMakeRange(0, self.length);
    if (index < 0 && -index < self.length) lookupRange.location = self.length + index;
    else {
        if (index > self.length) {
            NSString *reason = $(@"LookupIndex %ld is not within range: Expected 0-%ld", index,    self.length);
            @throw [NSException exceptionWithName:@"ArrayIndexOutOfBoundsExceptions" reason:reason userInfo:nil];
        }
        lookupRange.location = index;
    }
    NSRange range = [self rangeOfString:aString options:0 range:lookupRange];
    return (range.location == NSNotFound ? -1 : range.location);
}

- (NSInteger)lastIndexOf:(NSS*)aString {
    NSString *reversed = self.reversed;
    NSInteger pos = [reversed indexOf:aString];
    return pos == -1 ? -1 : self.length - pos;
}

- (NSRange)rangeOfAny:(NSSet *)strings {
    NSRange re = NSMakeRange(NSNotFound, 0);
    for (NSString *s in strings) {
        NSRange r = [self rangeOfString:s];     if (r.location < re.location) re = r;
    }
    return re;
}

- (NSA*)lines      {
    return [self componentsSeparatedByString:@"\n"];
}

- (NSA*)words {
    NSMutableArray *re = NSMutableArray.array;
    for (NSString *s in [self componentsSeparatedByString : @" "]) {
        if (!s.isEmpty) [re addObject:s];
    }
    return re;
}

- (NSSet *)wordSet {
    return [NSMutableSet setWithArray:self.words];
}

- (NSA*)trimmedComponentsSeparatedByString:(NSS*)separator {
    NSMutableArray *re = NSMutableArray.array;
    for (__strong NSString *s in [self componentsSeparatedByString : separator]) {
        s = s.trim;     if (!s.isEmpty) [re addObject:s];
    }
    return re;
}

- (NSA*)decolonize {
    return [self componentsSeparatedByString:@":"];
}

- (NSA*)splitByComma {
    return [self componentsSeparatedByString:@","];
}

- (NSS*)substringBefore:(NSS*)delimiter {
    NSInteger index = [self indexOf:delimiter];
    return (index == -1) ? self : [self substringToIndex:index];
}

- (NSS*)substringAfter:(NSS*)delimiter {
    NSInteger index = [self indexOf:delimiter];
    if (index == -1) {
        return self;
    }
    return [self substringFromIndex:index + delimiter.length];
}

- (NSA*)splitAt:(NSS*)delimiter {
    NSRange index = [self rangeOfString:delimiter];
    return (index.location == NSNotFound) ? @[self] : @[[self substringToIndex:index.location],
                                                        [self substringFromIndex:index.location + index.length]];
}

- (BOOL)splitAt:(NSS*)delimiter head:(NSString **)head tail:(NSString **)tail {
    NSRange index = [self rangeOfString:delimiter];
    if (index.location == NSNotFound) return NO;
    NSString *copy = self.copy;
    *head = [copy substringToIndex:index.location];
    *tail = [copy substringFromIndex:index.location + index.length];
    return YES;
}

- (NSA*)decapitate {
    NSRange index = [self rangeOfString:@" "];
    return (index.location == NSNotFound) ? @[[self trim]]
           : @[[[self substringToIndex:index.location] trim],                                                                                              [[self substringFromIndex:index.location + index.length] trim]];
}

- (NSPoint)pointValue {
    NSPoint re = (NSPoint) {0.0, 0.0 };              NSArray *values = self.splitByComma;
    if (values.count == 0) return re;
    re.x = [values[0] floatValue];
    if (values.count < 2) re.y = re.x; else re.y = [values[1] floatValue]; return re;
}

- (NSUInteger)minutesValue {
    NSArray *split = [self componentsSeparatedByString:@":"];
    return (split.count > 1) ? [split[0] intValue] * 60 + [split[1] intValue] : [self intValue];
}

- (NSUInteger)secondsValue {
    NSArray *split = [self componentsSeparatedByString:@":"];
    if (split.count > 2) return [split[0] intValue] * 3600  + [split[1] intValue] * 60 + [split[2] intValue];
    else if (split.count == 2) return [split[0] intValue] * 3600       + [split[1] intValue] * 60;
    return [self intValue];
}

- (NSURL *)url {
    return [NSURL URLWithString:self];
}

- (NSURL *)fileURL {
    return [NSURL fileURLWithPath:self];
}

- (NSS*)ucfirst {
    NSString *head = [[self substringToIndex:1] uppercaseString];   NSString *tail = [self substringFromIndex:1];
    return $(@"%@%@", head, tail);
}

- (NSS*)lcfirst {
    NSString *head = [[self substringToIndex:1] lowercaseString];
    NSString *tail = [self substringFromIndex:1];
    return $(@"%@%@", head, tail);
}

+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    return [[self alloc] initWithData:data encoding:encoding];
}

+ (NSS*)stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits {
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

- (NSAttributedString *)attributedWithFont:(NSF *)font andColor:(NSC *)color {
    return [[NSAttributedString alloc] initWithString:self attributes:@{
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            }];
}

//This method creates an NSMutableAttributedString, using an NSString and an NSMutableParagraphStyle.
- (NSMutableAttributedString *)attributedParagraphWithSpacing:(CGF)spacing {
    NSMutableParagraphStyle *aMutableParagraphStyle;
    NSMutableAttributedString *attString;
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
    [aMutableParagraphStyle setAlignment:NSLeftTextAlignment];
    [aMutableParagraphStyle setLineSpacing:spacing];
//	[aMutableParagraphStyle setParagraphSpacing:25.5];
//	[aMutableParagraphStyle setHeadIndent:25.0];
//	[aMutableParagraphStyle setTailIndent:-45.0];
    // setTailIndent: if negative, offset from right margin (right margin mark does
    //	  NOT appear); if positive, offset from left margin (margin mark DOES appear)
//	[aMutableParagraphStyle setFirstLineHeadIndent:65.0];
    [aMutableParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
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
                      range:NSMakeRange(0, [self length])];
//	[aMutableParagraphStyle release]; // since it was copy'd
//	[attString autorelease]; // since it was alloc'd
    return attString;
}

//If your NSTextView already has attributed strings in its textStorage, you can get the NSParagraphStyle by:
//aMutableParagraphStyle = [[myTextView typingAttributes]
//						  objectForKey:@"NSParagraphStyle"];

- (NSS*)truncatedForRect:(NSRect)frame withFont:(NSFont *)font {
    NSLineBreakMode truncateMode = NSLineBreakByTruncatingMiddle;
    CGFloat txSize = [self widthWithFont:font];
    if (txSize <= frame.size.width) return self;                // Don't do anything if it fits.
    NSMutableString *currString = [NSMutableString string];
    NSRange rangeToCut = { 0, 0 };
//	if( truncateMode == NSLineBreakByTruncatingTail )	    {	rangeToCut.location = [s length] -1;    rangeToCut.length = 1; }
//	else if( truncateMode == NSLineBreakByTruncatingHead )  {  rangeToCut.location = 0;					rangeToCut.length = 1; }
//	else {  // NSLineBreakByTruncatingMiddle
    rangeToCut.location = [self length] / 2;
    rangeToCut.length = 1;
    //  }
    while (txSize > frame.size.width) {
        if (truncateMode != NSLineBreakByTruncatingHead && rangeToCut.location <= 1) return @"...";
        [currString setString:self];
        [currString replaceCharactersInRange:rangeToCut withString:@"..."];
        txSize = [currString widthWithFont:font];               rangeToCut.length++;
//		if( truncateMode == NSLineBreakByTruncatingHead )	;   // No need to fix location, stays at start.
//		else if( truncateMode == NSLineBreakByTruncatingTail )
//			rangeToCut.location--;  // Fix location so range that's one longer still lies inside our string at end.
//		else
        if ( (rangeToCut.length & 1) != 1)      // even? NSLineBreakByTruncatingMiddle
            rangeToCut.location--;              // Move location left every other time, so it grows to right and left and stays centered.
        if (rangeToCut.location <= 0 || (rangeToCut.location + rangeToCut.length) > [self length]) return @"...";
    }
    return currString;
}

// Method based on code obtained from:
// http://www.thinkmac.co.uk/blog/2005/05/removing-entities-from-html-in-cocoa.html
//
- (NSS*)decodeHTMLCharacterEntities {
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
        return escaped;         // Note this is autoreleased
    }
}

- (NSS*)encodeHTMLCharacterEntities {
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

+ (NSA *)testDomains {
    static NSA *testDOmains_ = nil;

    return testDOmains_ = testDOmains_ ? : @[ @"manhunt.net", @"adam4adam.com", @"grindr.com", @"facebook.com", @"google.com", @"youtube.com", @"yahoo.com", @"baidu.com", @"wikipedia.org", @"live.com", @"qq.com", @"twitter.com", @"amazon.com", @"blogspot.com", @"google.co.in", @"taobao.com", @"linkedin.com", @"yahoo.co.jp", @"msn.com", @"sina.com.cn", @"google.com.hk", @"google.de", @"bing.com", @"yandex.ru", @"babylon.com", @"wordpress.com", @"ebay.com", @"google.co.uk", @"google.co.jp", @"google.fr", @"163.com", @"soso.com", @"vk.com", @"weibo.com", @"microsoft.com", @"mail.ru", @"googleusercontent.com", @"google.com.br", @"tumblr.com", @"ask.com", @"craigslist.org", @"pinterest.com", @"paypal.com", @"xhamster.com", @"google.es", @"sohu.com", @"apple.com", @"google.it", @"bbc.co.uk", @"avg.com", @"xvideos.com", @"google.ru", @"blogger.com", @"fc2.com", @"livejasmin.com", @"imdb.com", @"tudou.com", @"adobe.com", @"t.co", @"google.com.mx", @"go.com", @"flickr.com", @"conduit.com", @"youku.com", @"google.ca", @"odnoklassniki.ru", @"ifeng.com", @"tmall.com", @"hao123.com", @"aol.com", @"mywebsearch.com", @"pornhub.com", @"zedo.com", @"ebay.de", @"blogspot.in", @"google.co.id", @"cnn.com", @"thepiratebay.se", @"sogou.com", @"rakuten.co.jp", @"about.com", @"amazon.de", @"alibaba.com", @"google.com.au", @"google.com.tr", @"espn.go.com", @"redtube.com", @"huffingtonpost.com", @"ebay.co.uk", @"360buy.com", @"mediafire.com", @"chinaz.com", @"google.pl", @"adf.ly", @"uol.com.br", @"stackoverflow.com", @"netflix.com", @"ameblo.jp", @"youporn.com", @"dailymotion.com", @"amazon.co.jp", @"imgur.com", @"instagram.com", @"godaddy.com", @"wordpress.org", @"doubleclick.com", @"4shared.com", @"alipay.com", @"360.cn", @"globo.com", @"livedoor.com", @"amazon.co.uk", @"bp.blogspot.com", @"xnxx.com", @"cnet.com", @"searchnu.com", @"weather.com", @"torrentz.eu", @"search-results.com", @"google.com.sa", @"wigetmedia.com", @"google.nl", @"livejournal.com", @"nytimes.com", @"adcash.com", @"incredibar.com", @"tube8.com", @"dailymail.co.uk", @"neobux.com", @"ehow.com", @"badoo.com", @"google.com.ar", @"douban.com", @"cnzz.com", @"renren.com", @"tianya.cn", @"vimeo.com", @"bankofamerica.com", @"reddit.com", @"warriorforum.com", @"spiegel.de", @"deviantart.com", @"aweber.com", @"dropbox.com", @"indiatimes.com", @"pconline.com.cn", @"kat.ph", @"blogfa.com", @"google.com.pk", @"mozilla.org", @"secureserver.net", @"chase.com", @"google.co.th", @"google.com.eg", @"goo.ne.jp", @"booking.com", @"56.com", @"stumbleupon.com", @"google.co.za", @"google.cn", @"softonic.com", @"london2012.org", @"walmart.com", @"answers.com", @"sourceforge.net", @"comcast.net", @"addthis.com", @"foxnews.com", @"photobucket.com", @"wikimedia.org", @"zeekrewards.com", @"onet.pl", @"clicksor.com", @"amazonaws.com", @"pengyou.com", @"wellsfargo.com", @"wikia.com", @"liveinternet.ru", @"depositfiles.com", @"yesky.com", @"outbrain.com", @"google.co.ve", @"bild.de", @"etsy.com", @"xunlei.com", @"allegro.pl", @"statcounter.com", @"guardian.co.uk", @"skype.com", @"adultfriendfinder.com", @"fbcdn.net", @"leboncoin.fr", @"58.com", @"mgid.com", @"reference.com", @"squidoo.com", @"myspace.com", @"fiverr.com", @"iqiyi.com", @"letv.com", @"funmoods.com", @"google.com.co", @"google.com.my", @"optmd.com", @"youjizz.com", @"naver.com", @"rediff.com", @"filestube.com", @"domaintools.com", @"slideshare.net", @"themeforest.net", @"download.com", @"zol.com.cn", @"ucoz.ru", @"google.be", @"free.fr", @"rapidshare.com", @"salesforce.com", @"archive.org", @"nicovideo.jp", @"google.com.vn", @"google.gr", @"soundcloud.com", @"people.com.cn", @"orange.fr", @"scribd.com", @"nbcnews.com", @"yieldmanager.com", @"it168.com", @"xinhuanet.com", @"cam4.com", @"w3schools.com", @"4399.com", @"isohunt.com", @"iminent.com", @"tagged.com", @"files.wordpress.com", @"hootsuite.com", @"espncricinfo.com", @"yelp.com", @"wp.pl", @"hardsextube.com", @"ameba.jp", @"google.com.tw", @"imageshack.us", @"tripadvisor.com", @"4dsply.com", @"web.de", @"rambler.ru", @"google.at", @"google.se", @"gmx.net", @"pof.com"];
}

// URL Absolute string
+ (NSA*)domainsToSkip {
    return @[
        @"http://googleusercontent.com", @"http://go.com", @"http://bp.blogspot.com", @"http://secureserver.net", @"http://wikia.com", @"http://optmd.com", @"http://people.com.cn", @"http://yieldmanager.com", @"http://zedo.com", @"http://adf.ly", // 1px size
        @"http://adcash.com",                                                                                                                                                                                                                          // 1px size
        @"http://adultfriendfinder.com",                                                                                                                                                                                                               // 1px size
        @"http://rapidshare.com",                                                                                                                                                                                                                      // Creates the link tag with Javascritp
        @"http://thepiratebay.se",                                                                                                                                                                                                                     // Blocked in Italy
        @"http://kat.ph",                                                                                                                                                                                                                              // Blocked in Italy
        @"http://london2012.org"                                                                                                                                                                                                                       // Offline ?
    ];
}

- (NSS *)truncateInMiddleForWidth:(CGF)overall {
    return StringByTruncatingStringWithAttributesForWidth(self, nil, overall, NSLineBreakByTruncatingMiddle);
}
- (NSS*)truncateInMiddleToCharacters:(NSUI)chars { NSUI l,f,b;l=self.length;f=floor(chars/2)-2;b=l-f-1;

	 return l <= chars ? self : $(@"%@...%@",[self substringToIndex:f], [self substringFromIndex:b]);
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
NSString *   StringByTruncatingStringWithAttributesForWidth(NSString *s, NSDictionary *attrs, float wid, NSLineBreakMode truncateMode) {
    NSSize txSize = [s sizeWithAttributes:attrs];
    if (txSize.width <= wid) return s;                  // Don't do anything if it fits.
    NSMutableString *currString = [NSMutableString string];                                                          NSRange rangeToCut = { 0, 0 };
    if (truncateMode == NSLineBreakByTruncatingTail) {
        rangeToCut.location = [s length] - 1;    rangeToCut.length = 1;
    } else if (truncateMode == NSLineBreakByTruncatingHead) {
        rangeToCut.location = 0;                                     rangeToCut.length = 1;
    } else { rangeToCut.location = [s length] / 2;           rangeToCut.length = 1;  }    // NSLineBreakByTruncatingMiddle
    while (txSize.width > wid) {
        if (truncateMode != NSLineBreakByTruncatingHead && rangeToCut.location <= 1) return @"...";
        [currString setString:s];
        [currString replaceCharactersInRange:rangeToCut withString:@"..."];
        txSize = [currString sizeWithAttributes:attrs];                rangeToCut.length++;
        if (truncateMode == NSLineBreakByTruncatingHead) ;                            // No need to fix location, stays at start.
        else if (truncateMode == NSLineBreakByTruncatingTail) rangeToCut.location--;  // Fix location so range that's one longer still lies inside our string at end.
        else if ( (rangeToCut.length & 1) != 1)                                       // even? NSLineBreakByTruncatingMiddle
            rangeToCut.location--;                                                    // Move location left every other time, so it grows to right and left and stays centered.
        if (rangeToCut.location <= 0 || (rangeToCut.location + rangeToCut.length) > [s length]) return @"...";
    }
    return currString;
}

@implementation NSMutableString (AtoZ)


- (NSS*)shift {
    NSString *re = [self substringToIndex:1];
    [self setString:[self substringFromIndex:1]];                   return re;
}

- (NSS*)pop {
    NSUInteger index = self.length - 1;
    NSString *re = [self substringFromIndex:index];
    [self setString:[self substringToIndex:index]];                 return re;
}

- (BOOL)removePrefix:(NSS*)prefix {
    if (![self hasPrefix:prefix]) return NO;
    NSRange range = NSMakeRange(0, prefix.length);
    [self replaceCharactersInRange:range withString:@""];   return YES;
}

- (BOOL)removeSuffix:(NSS*)suffix {
    if (![self hasSuffix:suffix]) return NO;
    NSRange range = NSMakeRange(self.length - suffix.length, suffix.length);
    [self replaceCharactersInRange:range withString:@""];   return YES;
}

- (BOOL)removePrefix:(NSS*)prefix andSuffix:(NSS*)suffix {
    if (![self hasPrefix:prefix andSuffix:suffix]) return NO;
    NSRange range = NSMakeRange(0, prefix.length);
    [self replaceCharactersInRange:range withString:@""];
    range = NSMakeRange(self.length - suffix.length, suffix.length);
    [self replaceCharactersInRange:range withString:@""];   return YES;
}

- (NSMutableString *)camelize {
    unichar c, us, hy;              us = [@"_" characterAtIndex : 0];         hy = [@"-" characterAtIndex : 0];
    NSMutableString *r = [NSMutableString string];
    for (NSUInteger i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (c == us || c == hy) {
            [r setString:[self substringWithRange:NSMakeRange(i, 1)]];
            [self replaceCharactersInRange:NSMakeRange(i, 2) withString:[r uppercaseString]];       i++;
        }
    }
    return self;
}

- (NSMutableString *)hyphonize {
    return [self replaceAll:@"_" withString:@"-"];
}

- (NSMutableString *)underscorize {
    return [self replaceAll:@"-" withString:@"_"];
}

- (NSMutableString *)constantize {
    [self setString:[[self underscorize] uppercaseString]]; return self;
}

- (NSMutableString *)replaceAll:(NSS*)needle withString:(NSS*)replacement {
    [self replaceOccurrencesOfString:needle withString:replacement options:0 range:NSMakeRange(0, self.length)];    return self;
}

@end
@implementation NSString (RuntimeReporting)
- (BOOL)hasNoSubclasses {
    return ![self hasSubclasses];
}

- (BOOL)hasSubclasses {
    return [[RuntimeReporter subclassNamesForClassNamed:self] count] ? YES : NO;
}

- (int)numberOfSubclasses {
    return [[RuntimeReporter subclassNamesForClassNamed:self] count];
}

- (NSA*)subclassNames {
    return [RuntimeReporter subclassNamesForClassNamed:self];
}

- (NSA*)methodNames  // assumes the receiver contains a valid classname.
{
    return
        [[RuntimeReporter methodNamesForClassNamed:self]
         sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSA*)ivarNames  // assumes the receiver contains a valid classname.
{
    return
        [[RuntimeReporter iVarNamesForClassNamed:self]
         sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSA*)propertyNames  // assumes the receiver contains a valid classname.
{
    return
        [[RuntimeReporter propertyNamesForClassNamed:self]
         sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSA*)protocolNames  // assumes the receiver contains a valid classname.
{
    return
        [[RuntimeReporter protocolNamesForClassNamed:self]
         sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

// KVC compliance stuff: This was needed for NSTreeController.  Not needed for the iPhone version.
//- (void) setSubclassNames:(NSA*) names { NSLog(@"Can't set subclass names!"); }
//- (id) valueForUndefinedKey:(NSS*) key { return self; }
//- (void) setValue:(id)value forUndefinedKey:(NSS*)key { NSLog(@"unknown key:%@", key); }
@end
int gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior;
@implementation NSAttributedString (Geometrics)

- (NSSize)sizeForWidth:(float)width height:(float)height {
    NSInteger typesetterBehavior = NSTypesetterLatestBehavior;
    NSSize answer = NSZeroSize;
    if ([self length] > 0) {
        // Checking for empty string is necessary since Layout Manager will give the nominal
        // height of one line if length is 0.  Our API specifies 0.0 for an empty string.
        NSSize size = NSMakeSize(width, height);
        NSTextContainer *textContainer  = [[NSTextContainer alloc] initWithContainerSize:size];
        NSTextStorage *textStorage   = [[NSTextStorage alloc] initWithAttributedString:self];
        NSLayoutManager *layoutManager  = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        [textStorage addLayoutManager:layoutManager];
        [layoutManager setHyphenationFactor:0.0];
        if (typesetterBehavior != NSTypesetterLatestBehavior) [layoutManager setTypesetterBehavior:typesetterBehavior];
        // NSLayoutManager is lazy, so we need the following kludge to force layout:
        [layoutManager glyphRangeForTextContainer:textContainer];
        answer = [layoutManager usedRectForTextContainer:textContainer].size;
        // Adjust if there is extra height for the cursor
        NSSize extraLineSize = [layoutManager extraLineFragmentRect].size;
        if (extraLineSize.height > 0) answer.height -= extraLineSize.height;
        // In case we changed it above, set typesetterBehavior back
        // to the default value.
//		typesetterBehavior = NSTypesetterLatestBehavior;
    }
    return answer;
}

- (float)heightForWidth:(float)width {
    return [self sizeForWidth:width height:FLT_MAX].height;
}

- (float)widthForHeight:(float)height {
    return [self sizeForWidth:FLT_MAX height:height].width;
}

- (void)drawCenteredVerticallyInRect:(NSRect)rect {
    float strHeight = [self heightForWidth:rect.size.width];
    float orgY = (rect.origin.y) + (rect.size.height / 2) - (strHeight / 2);
    NSRect newRect = NSMakeRect(rect.origin.x, orgY, rect.size.width, strHeight);
    [self drawInRect:newRect];
}

#pragma mark Measure Attributed String
//- (NSSize)sizeForWidth:(float)width height:(float)height		{	NSSize answer = NSZeroSize ;
//
//	//	Checking for empty string is necessary since Layout Manager will give the nominal height of one line if length is 0.
//	if ([self length] > 0) {              //	Our API specifies 0.0 for an empty string.
//		NSTextContainer *textContainer  = [[NSTextContainer alloc] initWithContainerSize:(NSSize) { width, height }];
//		NSTextStorage *textStorage      = [[NSTextStorage   alloc] initWithAttributedString:self];
//		NSLayoutManager *layoutManager  = [[NSLayoutManager alloc] init];
//
//		[layoutManager  addTextContainer:textContainer];	 [textStorage   addLayoutManager:layoutManager];
//		[layoutManager  setHyphenationFactor:0.0];
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
- (NSSize)sizeInSize:(NSSize)size font:(NSFont *)font;
{
    return [self sizeForWidth:size.width height:size.height font:font];
}
- (NSSize)sizeForWidth:(float)width height:(float)height attributes:(NSD*)attributes {
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] sizeForWidth:width height:height];
}

- (float)heightForWidth:(float)width attributes:(NSD*)attributes {
    return [self sizeForWidth:width height:FLT_MAX attributes:attributes].height;
}

- (float)widthForHeight:(float)height attributes:(NSD*)attributes {
    return [self sizeForWidth:FLT_MAX height:height attributes:attributes].width;
}

#pragma mark Given String with Font
- (NSSize)sizeForWidth:(float)width height:(float)height font:(NSFont *)font {
    NSSize answer = NSZeroSize;
//	if (font == nil)	NSLog(@"[%@ %@]: Error: cannot compute size with nil font", [self class], _cmd) ;
//	else
    return answer = [self sizeForWidth:width height:height attributes:@{ NSFontAttributeName: font }];
}

- (float)heightForWidth:(float)width font:(NSFont *)font {
    return [self sizeForWidth:width height:FLT_MAX font:font].height;
}

- (float)widthForHeight:(float)height font:(NSFont *)font {
    return [self sizeForWidth:FLT_MAX height:height font:font].width;
}

@end
#import <objc/runtime.h>
#import <stdarg.h>
static BOOL IsColonOnlySelector(SEL selector);
static NSUInteger ColonCount(SEL selector);
static NSString * SillyStringImplementation(id self, SEL _cmd, ...);
@implementation NSString (JASillyStringImpl)
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (IsColonOnlySelector(sel)) {
        NSUInteger i, colonCount = ColonCount(sel);
        NSMS *typeStr = [NSMS stringWithCapacity:colonCount + 3];
        [typeStr appendString:@"@@:"];
        for (i = 0; i != colonCount; ++i) {
            [typeStr appendString:@"@"];
        }
        return class_addMethod([self class], sel, (IMP)SillyStringImplementation, typeStr.UTF8String);
    } else return [super resolveInstanceMethod:sel];
}

@end
static BOOL IsColonOnlySelector(SEL selector) {
    NSString *selString = NSStringFromSelector(selector);  NSUInteger i, count = selString.length;
    for (i = 0; i < count; ++i) {
        if ([selString characterAtIndex:i] != ':') return NO;
    }
    return YES;
}

static NSUInteger ColonCount(SEL selector) {
    assert(IsColonOnlySelector(selector));
    return NSStringFromSelector(selector).length;
}

static NSString * SillyStringImplementation(id self, SEL _cmd, ...) {
    NSUInteger i, count = ColonCount(_cmd);
    NSMutableString *string = [self mutableCopy];
    NSString *result = nil;
    @try    {
        va_list args;   id obj = nil;   va_start(args, _cmd);
        for (i = 0; i != count; ++i) {
            obj = va_arg(args, id);
            if (obj == nil) obj = @"";
            [string appendString:[obj description]];
        }
        va_end(args);
        result = [[string copy] autorelease];
    }
    @finally { [string release]; }
    return result;
}

@implementation NSString (AQPropertyKVC)
- (NSS*)propertyStyleString {
    NSString *result = [[self substringToIndex:1] lowercaseString];
    if ([self length] == 1) return (result);
    return ([result stringByAppendingString:[self substringFromIndex:1]]);
}

@end

@implementation NSString (SGSAdditions)
- (NSS*)truncatedToWidth:(CGFloat)width withAttributes:(NSD *)attributes {
    NSString *fixedString             = self;
    NSString *currentString   = self;
    NSSize stringSize              = [currentString sizeWithAttributes:attributes];
    if (stringSize.width > width) {
        NSInteger i = [self length];
        while ([currentString sizeWithAttributes:attributes].width > width) {
            if (i > 0) {
                currentString = [[self substringToIndex:i] stringByAppendingString:@"..."];
                i--;
            } else {
                currentString = @"";    break;
            }
        }
        fixedString = currentString;
    }
    return fixedString;
}

@end
@implementation NSString (Extensions)
- (BOOL)hasCaseInsensitivePrefix:(NSS*)prefix {
    NSRange range = [self rangeOfString:prefix options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
    return range.location != NSNotFound;
}

- (NSS*)urlEscapedString {
    return [(__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":@/?&=+"),
                                                                         kCFStringEncodingUTF8) autorelease];
}

- (NSS*)unescapeURLString {
    return [(__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),
                                                                                         kCFStringEncodingUTF8) autorelease];
}

static NSArray * _SpecialAbreviations() {
    static NSArray *array = nil;
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
static void _ScanSentence(NSScanner *scanner) {
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
        for (NSString *abreviation in _SpecialAbreviations()) {
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

- (NSS*)extractFirstSentence {
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    scanner.charactersToBeSkipped = nil;
    _ScanSentence(scanner);
    NSString *newSelf = [self substringToIndex:scanner.scanLocation];
    return newSelf;
}

- (NSA *)extractAllSentences {
    NSMutableArray *array = [NSMutableArray array];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
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

- (NSIndexSet *)extractSentenceIndices {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
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

- (NSS*)stripParenthesis {
    NSMutableString *string = [NSMutableString string];
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

- (BOOL)containsString:(NSS*)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

- (NSA *)extractAllWords {
    NSCharacterSet *characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
    if (self.length) {
        NSMutableArray *array = [NSMutableArray array];
        NSScanner *scanner = [[NSScanner alloc] initWithString:self];
        scanner.charactersToBeSkipped = nil;
        while (1) {
            [scanner scanCharactersFromSet:characterSet intoString:NULL];
            NSString *string;
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

- (NSRange)rangeOfWordAtLocation:(NSUInteger)location {
    NSCharacterSet *characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
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

- (NSRange)rangeOfNextWordFromLocation:(NSUInteger)location {
    NSCharacterSet *characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
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

- (NSS*)stringByDeletingPrefix:(NSS*)prefix {
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:prefix.length];
    }
    return self;
}

- (NSS*)stringByDeletingSuffix:(NSS*)suffix {
    if ([self hasSuffix:suffix]) {
        return [self substringToIndex:(self.length - suffix.length)];
    }
    return self;
}

- (NSS*)stringByReplacingPrefix:(NSS*)prefix withString:(NSS*)string {
    if ([self hasPrefix:prefix]) {
        return [string stringByAppendingString:[self substringFromIndex:prefix.length]];
    }
    return self;
}

- (NSS*)stringByReplacingSuffix:(NSS*)suffix withString:(NSS*)string {
    if ([self hasSuffix:suffix]) {
        return [[self substringToIndex:(self.length - suffix.length)] stringByAppendingString:string];
    }
    return self;
}

- (BOOL)isIntegerNumber {
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
- (void)trimWhitespaceAndNewlineCharacters {
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

+ (NSS*)stringWithFormat:(NSS*)format arguments:(va_list)argList {
    return [[[self alloc] initWithFormat:format arguments:argList] autorelease];
}

+ (NSS*)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    return [[[self alloc] initWithData:data encoding:encoding] autorelease];
}

- (id)initWithConcatnatingStrings:(NSS*)first, ...{
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
+ (id)stringWithConcatnatingStrings:(NSS*)first, ...{
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
- (BOOL)hasSubstring:(NSS*)aString {
    return [self rangeOfString:aString].location != NSNotFound;
}

// slow! proof of concept
- (NSS*)format:(id)first, ...{
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
- (NSS*)format0:(id)dummy, ...{
    va_list args;
    va_start(args, dummy);
    NSString *result = [NSString stringWithFormat:self arguments:args];
    va_end(args);
    return result;
}
- (NSRange)range {
    return NSRangeFromString(self);
}

- (NSS*)substringFromIndex:(NSUInteger)from length:(NSUInteger)length {
    return [self substringWithRange:NSMakeRange(from, length)];
}

- (NSS*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    return [self substringWithRange:NSMakeRange(from, to - from)];
}

@end

@implementation NSString (NSUTF8StringEncoding)
+ (NSS*)stringWithUTF8Data:(NSData *)data {
    return [[[self alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

- (NSS*)stringByAddingPercentEscapesUsingUTF8Encoding {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSS*)stringByReplacingPercentEscapesUsingUTF8Encoding {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataUsingUTF8Encoding {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (Evaluation)
- (NSInteger)integerValueBase:(NSInteger)radix {
    NSInteger result = 0;
    for (NSUInteger i = 0; i < [self length]; i++) {
        result *= radix;
        unichar digit = [self characterAtIndex:i];
        if ('0' <= digit && digit <= '9') digit -= '0';
        else if ('a' <= digit && digit < 'a' - 10 + radix) digit -= 'a' - 10;
        else if ('A' <= digit && digit < 'A' - 10 + radix) digit -= 'A' - 10;
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
- (id)initWithConcatnatingStrings:(NSS*)first, ...{
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
+ (id)stringWithConcatnatingStrings:(NSS*)first, ...{
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
- (NSS*)normalizedString {
    NSMutableString *result = [NSMutableString stringWithString:self];
    CFStringNormalize((__bridge CFMutableStringRef)result, kCFStringNormalizationFormD);
    CFStringFold((__bridge CFMutableStringRef)result, kCFCompareCaseInsensitive | kCFCompareDiacriticInsensitive | kCFCompareWidthInsensitive, NULL);
    return result;
}

- (NSS*)stringByRemovingExtraneousWhitespace {
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}

- (NSS*)stringByRemovingNonAlphanumbericCharacters {
    static NSMutableCharacterSet *unionSet = nil;
    if (!unionSet) {
        unionSet = [NSMutableCharacterSet alphanumericCharacterSet];
        [unionSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return [self stringByFilteringToCharactersInSet:unionSet];
}

- (NSS*)stringByFilteringToCharactersInSet:(NSCharacterSet *)set {
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

+ (NSS*)stringFromFileSize:(NSUInteger)theSize {
    float floatSize = theSize;
    if (theSize < 1023) return [NSString stringWithFormat:@"%lu bytes", theSize];
    floatSize = floatSize / 1024;
    if (floatSize < 1023) return [NSString stringWithFormat:@"%1.1f KB", floatSize];
    floatSize = floatSize / 1024;
    if (floatSize < 1023) return [NSString stringWithFormat:@"%1.1f MB", floatSize];
    floatSize = floatSize / 1024;
    return [NSString stringWithFormat:@"%1.1f GB", floatSize];
}

- (NSS*)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

- (NSS*)URLEncodedString {
    return [self URLEncodedStringForCharacters:@":/?#[]@!$&’()*+,;="];
}

- (NSS*)URLEncodedStringForCharacters:(NSS*)characters {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)characters, kCFStringEncodingUTF8);
}

- (NSS*)upperBoundsString {
    NSUInteger length = [self length];
    NSString *baseString = nil;
    NSString *incrementedString = nil;

    if (length < 1) {
        return self;
    } else if (length > 1) {
        baseString = [self substringToIndex:(length - 1)];
    } else {
        baseString = @"";
    }
    UniChar lastChar = [self characterAtIndex:(length - 1)];
    UniChar incrementedChar;

    // We can't do a simple lastChar + 1 operation here without taking into account
    // unicode surrogate characters (http://unicode.org/faq/utf_bom.html#34)

    if ((lastChar >= 0xD800UL) && (lastChar <= 0xDBFFUL)) {              // surrogate high character
        incrementedChar = (0xDBFFUL + 1);
    } else if ((lastChar >= 0xDC00UL) && (lastChar <= 0xDFFFUL)) {      // surrogate low character
        incrementedChar = (0xDFFFUL + 1);
    } else if (lastChar == 0xFFFFUL) {
        if (length > 1) baseString = self;
        incrementedChar =  0x1;
    } else {
        incrementedChar = lastChar + 1;
    }

    incrementedString = [[NSString alloc] initWithFormat:@"%@%C", baseString, incrementedChar];

    return incrementedString;
}

+ (NSS*)timeStringForTimeInterval:(NSTimeInterval)interval {
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

+ (NSS*)humanReadableStringForTimeInterval:(NSTimeInterval)interval {
    if (interval < 1) {
        return @"";
    }
    if (interval < 60) {
        int rounded = floor(interval);
        if (rounded == 1) {
            return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"second", nil)];
        }
        return [NSString stringWithFormat:@"%d %@", rounded, NSLocalizedString(@"seconds", nil)];
    }
    interval = interval / 60;
    //if (interval < 60) {
    int rounded = floor(interval);
    if (rounded == 1) {
        return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"minute", nil)];
    }
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

- (NSA*)spaceSeparatedComponents {
    return [[self stringByRemovingExtraneousWhitespace] componentsSeparatedByString:@" "];
}

+ (NSS*)randomUUID {
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *string = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, cfuuid);
    CFRelease(cfuuid);
    return string;
}

+ (NSData *)HMACSHA256EncodedDataWithKey:(NSS*)key data:(NSS*)data {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:CC_SHA256_DIGEST_LENGTH];
}

@end

@implementation NSAttributedString (SNRAdditions)

- (NSAttributedString *)attributedStringWithColor:(NSColor *)color {
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

- (NSColor *)color {
    int len = [self length];
    NSRange range = NSMakeRange(0, MIN(len, 1));     // take color from first char
    NSDictionary *attrs = [self fontAttributesInRange:range];
    NSColor *textColor = [NSColor controlTextColor];
    if (attrs) {
        textColor = [attrs objectForKey:NSForegroundColorAttributeName];
    }
    return textColor;
}

@end

@implementation NSString (IngredientsUtilities)



- (BOOL)startsWith:(NSS*)s {
    if ([self length] >= [s length] && [[self substringToIndex:[s length]] isEqualToString:s]) return YES;
    return NO;
}


+ (NSS*)stringByGeneratingXcodeHexadecimalUUID {
    //24 Uppercase Hexadecimal Characters     For example: 758912EA10C2ABB500F9A5CF
    NSMS *uuidString = [NSMS.alloc initWithCapacity:24];
    //We create 6 groups of 4 characters
    int i;
    for (i = 0; i < 6; i++) {
        NSUI r = random();
        r %= 65536;         // 16^4
        [uuidString appendString:$(@"%04lu", r).uppercaseString];
    }
    return uuidString;
}

- (BOOL)containsString:(NSS*)s {
    //BOOL isLike = [self isLike:[NSString stringWithFormat:@"*%@*", s]];
    NSRange r = [self rangeOfString:s];
    //NSLog(@"r = %@", NSStringFromRange(r));
    //NSLog(@"NSNotFound = %lu", NSNotFound);
    //NSLog(@"r.location != NSNotFound = %@", r.location != NSNotFound);
    BOOL contains = r.location != NSNotFound;

    /*if (contains != isLike)
       {
            NSLog(@"=== DIFFERENCE ===");
            NSLog(@"\t self = '%@'", self);
            NSLog(@"\t s = '%@'", s);
            NSLog(@"\t contains = %d", contains);
            NSLog(@"\t isLike = %d", isLike);
       }*/

    return contains;
}

- (BOOL)caseInsensitiveContainsString:(NSS*)s {
    NSRange r = [self rangeOfString:s options:NSCaseInsensitiveSearch];
    BOOL contains = r.location != NSNotFound;
    return contains;
}

- (BOOL)caseInsensitiveHasPrefix:(NSS*)s {
    return [[self lowercaseString] hasPrefix:[s lowercaseString]];
}

- (BOOL)caseInsensitiveHasSuffix:(NSS*)s {
    return [[self lowercaseString] hasSuffix:[s lowercaseString]];
}

- (BOOL)isCaseInsensitiveEqual:(NSS*)s {
    return [self compare:s options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

@end




@implementation NSString (additions)

- (NSInteger)numberOfLines
{
	NSInteger i, n;	NSUInteger eol, end;
	for (i = n = 0; i < [self length]; i = end, n++) {
		[self getLineStart:NULL end:&end contentsEnd:&eol forRange:NSMakeRange(i, 0)];
		if (end == eol)
		break;
	}

	return n;
}

- (NSUInteger)occurrencesOfCharacter:(unichar)ch
{
	NSUInteger n, i;
	for (i = n = 0; i < [self length]; i++)
		if ([self characterAtIndex:i] == ch)
			n++;
	return n;
}

+ (NSS*)stringWithKeyCode:(NSInteger)keyCode
{
	unichar key = keyCode & 0x0000FFFF;
	unsigned int modifiers = keyCode & 0xFFFF0000;

	NSString *special = nil;
	switch (key) {
	case NSDeleteFunctionKey:
		special = @"del"; break;
	case NSLeftArrowFunctionKey:
		special = @"left"; break;
	case NSRightArrowFunctionKey:
		special = @"right"; break;
	case NSUpArrowFunctionKey:
		special = @"up"; break;
	case NSDownArrowFunctionKey:
		special = @"down"; break;
	case NSPageUpFunctionKey:
		special = @"pageup"; break;
	case NSPageDownFunctionKey:
		special = @"pagedown"; break;
	case NSHomeFunctionKey:
		special = @"home"; break;
	case NSEndFunctionKey:
		special = @"end"; break;
	case NSInsertFunctionKey:
		special = @"ins"; break;
	case NSHelpFunctionKey:
		special = @"help"; break;
	case 0x7F:
		special = @"bs"; break;
	case 0x09:
		special = @"tab"; break;
	case 0x1B:
		special = @"esc"; break;
	case 0x0D:
		special = @"cr"; break;
	case 0x00:
		special = @"nul"; break;
	}

	if (key >= NSF1FunctionKey && key <= NSF35FunctionKey)
		special = [NSString stringWithFormat:@"f%i", key - NSF1FunctionKey + 1];

	if (key < 0x20 && key > 0 && key != 0x1B && key != 0x0D && key != 0x09)
		special = [[NSString stringWithFormat:@"ctrl-%C", (unichar)(key + 'A' - 1)] lowercaseString];

	NSString *encodedKey;
	if (modifiers) {
		encodedKey = [NSString stringWithFormat:@"<%s%s%s%s%@>",
		    (modifiers & NSShiftKeyMask) ? "shift-" : "",
		    (modifiers & NSControlKeyMask) ? "ctrl-" : "",
		    (modifiers & NSAlternateKeyMask) ? "alt-" : "",
		    (modifiers & NSCommandKeyMask) ? "cmd-" : "",
		    special ?: [NSString stringWithFormat:@"%C", key]];
	} else if (special)
		encodedKey = [NSString stringWithFormat:@"<%@>", special];
	else
		encodedKey = [NSString stringWithFormat:@"%C", key];

	NSLog(@"encodedKey = %@", encodedKey);
	return encodedKey;
}

+ (NSS*)visualStringWithKeyCode:(NSInteger)keyCode
{
	unichar key = keyCode & 0x0000FFFF;
	unsigned int modifiers = keyCode & 0xFFFF0000;

	switch (key) {
	case NSDeleteFunctionKey:
		key = 0x2326; break;
	case NSLeftArrowFunctionKey:
		key = 0x2190; break;
	case NSRightArrowFunctionKey:
		key = 0x2192; break;
	case NSUpArrowFunctionKey:
		key = 0x2191; break;
	case NSDownArrowFunctionKey:
		key = 0x2193; break;
/*	case NSPageUpFunctionKey:
		key = ; break;
	case NSPageDownFunctionKey:
		key = @"pagedown"; break;*/
	case NSHomeFunctionKey:
		key = 0x2199; break;
	case NSEndFunctionKey:
		key = 0x2197; break;
/*	case NSInsertFunctionKey:
		key = @"ins"; break;
	case NSHelpFunctionKey:
		key = ; break;*/
	case 0x7F:
		key = 0x232B; break;
	case 0x09:
		key = 0x21E5; break;
	case 0x1B:
		key = 0x238B; break;
	case 0x0D:
		key = 0x21A9; break;
/*	case 0x00:
		key = @"nul"; break;*/
	}

	NSString *special = nil;
	if (key >= NSF1FunctionKey && key <= NSF35FunctionKey)
		special = [NSString stringWithFormat:@"F%i", key - NSF1FunctionKey + 1];

	if (key < 0x20 && key > 0 && key != 0x1B && key != 0x0D && key != 0x09) {
		key = key + 'A' - 1;
		modifiers |= NSControlKeyMask;
	} else if (modifiers && [[NSString stringWithFormat:@"%C", key] isUppercase])
		modifiers |= NSShiftKeyMask;

	NSString *encodedKey;
	if (modifiers) {
		encodedKey = [NSString stringWithFormat:@"%@%@%@%@%@",
		    (modifiers & NSCommandKeyMask) ? [NSString stringWithFormat:@"%C", (unichar)0x2318] : @"",
		    (modifiers & NSAlternateKeyMask) ? [NSString stringWithFormat:@"%C", (unichar)0x2325] : @"",
		    (modifiers & NSControlKeyMask) ? [NSString stringWithFormat:@"%C", (unichar)0x2303] : @"",
		    (modifiers & NSShiftKeyMask) ? [NSString stringWithFormat:@"%C", (unichar)0x21E7] : @"",
		    special ?: [[NSString stringWithFormat:@"%C", key] uppercaseString]];
	} else if (special)
		encodedKey = special;
	else
		encodedKey = [NSString stringWithFormat:@"%C", key];

	NSLog(@"encodedKey = %@", encodedKey);
	return encodedKey;
}

+ (NSS*)stringWithKeySequence:(NSA*)keySequence
{
	NSMutableString *s = [NSMutableString string];
	for (NSNumber *n in keySequence)
		[s appendString:[self stringWithKeyCode:[n integerValue]]];
	return s;
}

+ (NSS*)stringWithCharacters:(NSA*)keySequence
{
	NSMutableString *s = [NSMutableString string];
	for (NSNumber *n in keySequence)
		if ([n unsignedIntegerValue] <= 0xFFFF)
			[s appendFormat:@"%C", (unichar)[n unsignedIntegerValue]];
	return s;
}


- (BOOL)isUppercase
{
	return [self isEqualToString:[self uppercaseString]] &&
	      ![self isEqualToString:[self lowercaseString]];
}

- (BOOL)isLowercase
{
	return [self isEqualToString:[self lowercaseString]] &&
	      ![self isEqualToString:[self uppercaseString]];
}

/* Expands <special> to a nice visual representation.
 *
 * Format of the <special> keys are:
 *   <^@r> => control-command-r (apple style)
 *   <^@R> => shift-control-command-r (apple style)
 *   <c-r> => control-r (vim style)
 *   <C-R> => control-r (vim style)
 *   <Esc> => escape (vim style)
 *   <space> => space (vim style)
 *   ...
 */
+ (NSS*)visualStringWithKeySequence:(NSA*)keySequence
{
	NSMutableString *s = [NSMutableString string];
	BOOL hadModifiers = NO;
	for (NSNumber *n in keySequence) {
		if (hadModifiers)
			[s appendString:@" "];
		NSString *vs = [self visualStringWithKeyCode:[n integerValue]];
		[s appendString:vs];
		hadModifiers = ([vs length] > 1);
	}
	return s;
}

+ (NSS*)visualStringWithKeyString:(NSS*)keyString
{
	return [self visualStringWithKeySequence:[keyString keyCodes]];
}

- (NSS*)visualKeyString
{
	return [NSString visualStringWithKeySequence:[self keyCodes]];
}


- (NSA*)keyCodes
{
	NSMutableArray *keyArray = [NSMutableArray array];
	NSScanner *scan = [NSScanner scannerWithString:self];

	NSInteger keycode;
	while ([scan scanKeyCode:&keycode])		[keyArray addObject:@(keycode)];

	if (![scan isAtEnd])		return nil;

	return keyArray;
}


@end

//  NSString+HFExtension.m
//  Handy Foundation
//  Created by venj on 13-2-19.

//#import "NSString+HFExtension.h"
//#import "NSArray+HFExtension.h"

@implementation NSString (HFExtension)
// Syntactic Sugar
- (NSS*)toUpper {
	return [self uppercaseString];
}

- (NSS*)toLower {
	return [self lowercaseString];
}

- (NSS*)upCase {
	return [self uppercaseString];
}

- (NSS*)downCase {
	return [self lowercaseString];
}

- (NSS*)capitalize {
	return [self capitalizedString];
}

- (NSUInteger)size {
	return [self length];
}

- (NSUInteger)count {
	return [self length];
}

- (NSA*)split:(NSS*)separator {
	return [self split:separator rule:HFSplitRuleAny];
}

- (NSS*)baseName {
	return [self baseNameWithExtension:NO];
}

// Enhancement.
- (NSA*)split:(NSS*)separator rule:(HFSplitRule)rule {
	switch (rule) {
		case HFSplitRuleWhole:
			return [self componentsSeparatedByString:separator];
		case HFSplitRuleAny:
		default: {
			NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:separator];
			return [self componentsSeparatedByCharactersInSet:separators];
		}
	}
}

- (BOOL)isBlank {
	if ([self length] == 0) {
		return YES;
	}
	else {
		return [[self strip] length] == 0;
	}
}

- (NSS*)baseNameWithExtension:(BOOL)ext {
	NSString *baseName = [self lastPathComponent];
	if (ext) return baseName;

	if ([[self pathExtension] isEqualToString:@""])
		return baseName;
	else {
		NSString *ext = [self pathExtension];
		return [baseName substringToIndex:([baseName length] - [ext length] - 1)];
	}
}

- (NSS*)dirName {
	NSMutableArray *components = [[self pathComponents] mutableCopy];
	[components removeLastObject];
	NSString *dirName = [NSString pathWithComponents:components];
	return dirName;
}

- (NSS*)charStringAtIndex:(NSUInteger)index {
	if (index >= [self length]) return nil;
	return [self substringWithRange:NSMakeRange(index, 1)];
}

- (NSS*)strip {
	NSCharacterSet *whiteSpaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	return [self stringByTrimmingCharactersInSet:whiteSpaces];
}

- (NSS*)lstrip {
	NSString *strippedString = [self strip];
	return [NSString stringWithFormat:@"%@%@", strippedString, [[self componentsSeparatedByString:strippedString] lastObject]];
}

- (NSS*)rstrip {
	NSString *strippedString = [self strip];
	return [NSString stringWithFormat:@"%@%@", [[self componentsSeparatedByString:strippedString] firstObject] , strippedString];
}

@end

//#include "logging.h"

@implementation NSScanner (additions)

- (unichar)peek
{
	if ([self isAtEnd])
		return 0;
	return [[self string] characterAtIndex:[self scanLocation]];
}

- (void)inc
{
	if (![self isAtEnd])
		[self setScanLocation:[self scanLocation] + 1];
}

- (BOOL)expectCharacter:(unichar)ch
{
	if ([self peek] == ch) {
		[self inc];
		return YES;
	}
	return NO;
}

- (BOOL)scanCharacter:(unichar *)ch
{
	if ([self isAtEnd])
		return NO;
	if (ch)
		*ch = [[self string] characterAtIndex:[self scanLocation]];
	[self inc];
	return YES;
}

- (BOOL)scanUpToUnescapedCharacterFromSet:(NSCharacterSet *)toCharSet
			   appendToString:(NSMutableString *)s
			     stripEscapes:(BOOL)stripEscapes
{
	unichar ch;
	BOOL gotChar = NO;

	while ([self scanCharacter:&ch]) {
		if (ch == '\\') {
			if ([self scanCharacter:&ch]) {
				if (!stripEscapes)
					[s appendString:@"\\"];
				[s appendFormat:@"%C", ch];
			} else
				[s appendString:@"\\"];
		} else if ([toCharSet characterIsMember:ch]) {
			/* Don't swallow the end character. */
			gotChar = YES;
			[self setScanLocation:[self scanLocation] - 1];
			break;
		} else
			[s appendFormat:@"%C", ch];
	}

	NSLog(@"scanned escaped string [%@]", s);

	return gotChar ? YES : NO;
}

- (BOOL)scanUpToUnescapedCharacterFromSet:(NSCharacterSet *)toCharSet
			       intoString:(NSString **)string
			     stripEscapes:(BOOL)stripEscapes
{
	NSMutableString *s = [NSMutableString string];
	BOOL ret = [self scanUpToUnescapedCharacterFromSet:toCharSet appendToString:s stripEscapes:stripEscapes];
	if (string)
		*string = s;
	return ret;
}

- (BOOL)scanUpToUnescapedCharacter:(unichar)toChar
                        intoString:(NSString **)string
                      stripEscapes:(BOOL)stripEscapes
{
	return [self scanUpToUnescapedCharacterFromSet:[NSCharacterSet characterSetWithRange:NSMakeRange(toChar, 1)]
					    intoString:string
					  stripEscapes:stripEscapes];
}

- (BOOL)scanUpToUnescapedCharacter:(unichar)toChar
                        intoString:(NSString **)string
{
	/* TextMate bundle commands want backslash escapes intact. sh unescapes. */
	return [self scanUpToUnescapedCharacter:toChar intoString:string stripEscapes:NO];
}

- (BOOL)scanShellVariableIntoString:(NSString **)intoString
{
	NSUInteger startLocation = [self scanLocation];

	BOOL initial = YES;

	NSMutableCharacterSet *shellVariableSet = nil;
	if (shellVariableSet == nil) {
		shellVariableSet = [[NSMutableCharacterSet alloc] init];
		[shellVariableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange('a', 'z' - 'a')]];
		[shellVariableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange('A', 'Z' - 'A')]];
		[shellVariableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
	}

	while (![self isAtEnd]) {
		if (![self scanCharactersFromSet:shellVariableSet intoString:nil])
			break;

		if (initial) {
			[shellVariableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange('0', '9' - '0')]];
			initial = NO;
		}
	}

	[shellVariableSet release];

	if ([self scanLocation] == startLocation)
		return NO;

	if (intoString)
		*intoString = [[self string] substringWithRange:NSMakeRange(startLocation, [self scanLocation] - startLocation)];
	return YES;
}

- (BOOL)scanString:(NSS*)aString
{
	return [self scanString:aString intoString:nil];
}

- (BOOL)scanKeyCode:(NSInteger *)intoKeyCode
{
	[self setCharactersToBeSkipped:nil];

	unichar ch;
	if (![self scanCharacter:&ch])
		return NO;

	if (ch == '\\') {
		/* Escaped character. */
		if ([self scanCharacter:&ch]) {
			if (intoKeyCode)
				*intoKeyCode = ch;
			return YES;
		} else {
			/* trailing backslash? treat as literal */
			if (intoKeyCode)
				*intoKeyCode = '\\';
			return YES;
		}
	} else if (ch == '<') {
		NSUInteger oldLocation = [self scanLocation];
		[self setCaseSensitive:NO];

		unsigned int modifiers = 0;
		BOOL gotModifier;
		do {
			gotModifier = YES;
			if ([self scanString:@"c-"] ||
			    [self scanString:@"ctrl-"] ||
			    [self scanString:@"control-"])
				modifiers |= NSControlKeyMask;
			else if ([self scanString:@"a-"] ||
				 [self scanString:@"m-"] ||
				 [self scanString:@"alt-"] ||
				 [self scanString:@"option-"] ||
				 [self scanString:@"meta-"])
				modifiers |= NSAlternateKeyMask;
			else if ([self scanString:@"s-"] ||
				 [self scanString:@"shift-"])
				modifiers |= NSShiftKeyMask;
			else if ([self scanString:@"d-"] ||
				 [self scanString:@"cmd-"] ||
				 [self scanString:@"command-"])
				modifiers |= NSCommandKeyMask;
			else
				gotModifier = NO;
		} while (gotModifier);

		unichar key;
		if ([self scanString:@"delete"] ||
		    [self scanString:@"del"])
			key = NSDeleteFunctionKey;
		else if ([self scanString:@"left"])
			key = NSLeftArrowFunctionKey;
		else if ([self scanString:@"right"])
			key = NSRightArrowFunctionKey;
		else if ([self scanString:@"up"])
			key = NSUpArrowFunctionKey;
		else if ([self scanString:@"down"])
			key = NSDownArrowFunctionKey;
		else if ([self scanString:@"pagedown"] ||
			 [self scanString:@"pgdn"])
			key = NSPageDownFunctionKey;
		else if ([self scanString:@"pageup"] ||
			 [self scanString:@"pgup"])
			key = NSPageUpFunctionKey;
		else if ([self scanString:@"home"])
			key = NSHomeFunctionKey;
		else if ([self scanString:@"end"])
			key = NSEndFunctionKey;
		else if ([self scanString:@"insert"] ||
			 [self scanString:@"ins"])
			key = NSInsertFunctionKey;
		else if ([self scanString:@"help"])
			key = NSHelpFunctionKey;
		else if ([self scanString:@"bs"] ||
			 [self scanString:@"backspace"])
			key = 0x7F;
		else if ([self scanString:@"tab"])
			key = 0x09;
		else if ([self scanString:@"escape"] ||
			 [self scanString:@"esc"])
			key = 0x1B;
		else if ([self scanString:@"cr"] ||
			 [self scanString:@"enter"] ||
			 [self scanString:@"return"])
			key = 0x0D;
		else if ([self scanString:@"space"])
			key = ' ';
		else if ([self scanString:@"bar"])
			key = '|';
		else if ([self scanString:@"lt"])
			key = '<';
		else if ([self scanString:@"bslash"] ||
			 [self scanString:@"backslash"])
			key = '\\';
		else if ([self scanString:@"nl"])	/* ctrl-J */
			key = 0x0A;
		else if ([self scanString:@"ff"])	/* ctrl-L */
			key = 0x0C;
		else if ([self scanString:@"nul"])
			key = 0x0;
		else if ([self scanCharacter:&key]) {
			int f;
			if ((key == 'f' || key == 'F') && [self scanInt:&f]) {
				key = NSF1FunctionKey + f - 1;
			} else if (modifiers == NSControlKeyMask &&
			    ((key >= 'a' && key <= 'z') ||
			     key == '@' ||
			     (key >= '[' && key <= '_'))) {
				/* ASCII control character 0x00 - 0x1F. */
				key = tolower(toupper(key) - '@');
				modifiers = 0;
			}
		} else
			goto failed;

		if (![self scanString:@">"])
			goto failed;
		if (intoKeyCode)
			*intoKeyCode = modifiers | key;
		return YES;

failed:
		[self setScanLocation:oldLocation];
		if (intoKeyCode)
			*intoKeyCode = '<';
	} else if (intoKeyCode)
		*intoKeyCode = ch;
	return YES;
}

- (void)skipWhitespace
{
	[self scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
}

@end



@implementation NSString (Similiarity)

float ScoreForSearchAsync(SKIndexRef inIndex, CFStringRef inQuery)
{
	// Create search
	SKSearchRef search = SKSearchCreate(inIndex, inQuery, kSKSearchOptionFindSimilar);
	if (search == NULL)
		return 0.0;	// XXX

	SKDocumentID documentIDs[1] = {};
	float foundScores[1] = {0.0};
	CFIndex foundCount = 0;
	while (1)
	{
		Boolean result = SKSearchFindMatches(search, 1, documentIDs, foundScores, 0.5, &foundCount);
		if (result == false)
			break;

		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}

	CFRelease(search);

	return foundScores[0];
}


- (float)isSimilarToString:(NSS*)aString
{
	// Exact-match fast case
	if ([self caseInsensitiveCompare:aString] == NSOrderedSame)
		return 1.0;

	// Fuzzy match
	float outScore = 0.0;
	SKIndexRef index = NULL;
	SKDocumentRef document = NULL;
	SKSearchRef search = NULL;
	Boolean result;

	// Create in-memory Search Kit index
	index = SKIndexCreateWithMutableData((__bridge CFMutableDataRef)[NSMutableData data], NULL, kSKIndexVector, NULL);
	if (index == NULL)
		goto catch_error;

	// Create documents with content of given strings
	document = SKDocumentCreate(CFSTR(""), NULL, CFSTR("s1"));
	if (document == NULL)
		goto catch_error;

	result = SKIndexAddDocumentWithText(index, document, (__bridge CFStringRef)self, true);
	if (result == false)
		goto catch_error;

	// Flush index
	result = SKIndexFlush(index);
	if (result == false)
		goto catch_error;

	float selfScore = ScoreForSearchAsync(index, (__bridge CFStringRef)self);
	float paramScore = ScoreForSearchAsync(index, (__bridge CFStringRef)aString);

	outScore = paramScore / selfScore;

catch_error:
	if (index)
		CFRelease(index);
	if (document)
		CFRelease(document);
	if (search)
		CFRelease(search);

	return outScore;
}

@end
