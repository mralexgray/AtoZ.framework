//
//  NSURL+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 8/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#define NOT_REACHED() do {	AZLOG(@"<INTERNAL INCONSISTENCY>"); } while (0)

#import "NSURL+AtoZ.h"
/* data passing categories on NSURLRequest and NSMutableURLRequest.  see the
 header file for more info.  */
//@implementation NSURLRequest (SpecialProtocol)
//- (NSD*)specialVars {
//	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
//	return [NSURLProtocol propertyForKey:[SpecialProtocol specialProtocolVarsKey] inRequest:self];
//}
//@end

//@implementation NSMutableURLRequest (SpecialProtocol)
//- (void) setSpecialVars:(NSD*)specialVars {
//	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
//	NSDictionary *specialVarsCopy = [specialVars copy];
//	[NSURLProtocol setProperty:specialVarsCopy
//						forKey:[SpecialProtocol specialProtocolVarsKey] inRequest:self];
//}
//@end

@implementation NSURL (AtoZ)

//	isImageFile:filePath
//	Uses LaunchServices and UTIs to detect if a given file path is an image file.
- (BOOL)isImageFile
{
	BOOL isImageFile = NO;
	NSString *utiValue;
	[self getResourceValue:&utiValue forKey:NSURLTypeIdentifierKey error:nil];
	return utiValue ? UTTypeConformsTo((__bridge CFStringRef)utiValue, kUTTypeImage): isImageFile;
}

@end


@implementation NSURL (Extensions)

- (NSDictionary*) parseQueryParameters:(BOOL)unescape {
	NSMutableDictionary* parameters = nil;
	NSString* query = [self query];
	if (query) {
		parameters = @{}.mutableCopy;
		NSScanner* scanner = [NSScanner.alloc initWithString:query];
		[scanner setCharactersToBeSkipped:nil];
		while (1) {
			NSString* key = nil;
			if (![scanner scanUpToString:@"=" intoString:&key] || [scanner isAtEnd]) {
				break;
			}
			[scanner setScanLocation:([scanner scanLocation] + 1)];

			NSString* value = nil;
			if (![scanner scanUpToString:@"&" intoString:&value]) {
				break;
			}

			if (unescape) {
				[parameters setObject:[value unescapeURLString] forKey:[key unescapeURLString]];
			} else {
				[parameters setObject:value forKey:key];
			}

			if ([scanner isAtEnd]) {
				break;
			}
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	return parameters;
}

@end

@implementation NSURLRequest (UserAgentSwizzling)
@dynamic useRandomUA;

- _IsIt_ useRandomUA { return [self associatedValueForKey:@"useRandomUA" orSetTo:@NO]; }
- (void) setUseRandomUA: (BOOL) u { [self setAssociatedValue:@(u) forKey:@"useRandomUA"]; }

+ (NSS*) randomUA {

 static NSA* uAs = nil;  if (!uAs) uAs = @[ 	@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.43.7 (KHTML, like Gecko) Version/7.0 Safari/537.43.7",
				@"Mozilla/5.0 (iPad; CPU OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25",
				@"Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.15",
				@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
				@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.29.13 (KHTML, like Gecko) Version/6.0.4 Safari/536.29.13",
			@"Mozilla/5.0 (Windows NT 6.1; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 5.1; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1",
			@"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.2; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
			@"Mozilla/5.0 (iPad; CPU OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25",
			@"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
			@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25",
			@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
			@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Ubuntu Chromium/25.0.1364.160 Chrome/25.0.1364.160 Safari/537.22",
			@"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:20.0) Gecko/20100101 Firefox/20.0",
			@"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.59.8 (KHTML, like Gecko) Version/5.1.9 Safari/534.59.8",
			@"Mozilla/5.0 (X11; Linux x86_64; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.29.13 (KHTML, like Gecko) Version/6.0.4 Safari/536.29.13",
			@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
			@"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31",
			@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)",

			@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31",
			@"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.22 (KHTML, like Gecko) Ubuntu Chromium/25.0.1364.160 Chrome/25.0.1364.160 Safari/537.22",
			@"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31",
			@"Mozilla/5.0 (Windows NT 5.1; rv:20.0) Gecko/20100101 Firefox/20.0",
			@"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (iPad; CPU OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36",

			@"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0",
			@"Mozilla/5.0 (Windows NT 6.1; rv:20.0) Gecko/20100101 Firefox/20.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)",
			@"Mozilla/5.0 (Windows NT 6.0; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
			@"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36",
			@"Mozilla/5.0 (X11; Linux i686; rv:21.0) Gecko/20100101 Firefox/21.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36",
			@"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31",
			@"Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:20.0) Gecko/20100101 Firefox/20.0",
			@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0",
			@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0"];
			return uAs.randomElement;
}

//ADD_DYNAMIC_PROPERTY(BOOL, useRandomUA, setUseRandomUA);

+ (void) load	{
//    [$ swizzleMethod:@selector(initWithURL:cachePolicy:timeoutInterval:) with:@selector(initWithURL2:cachePolicy:timeoutInterval:) in:self.class];
}

-(id)initWithURL2:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    if (!(self = [self initWithURL2:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval])) return nil;
    if([self ISKINDA:NSURLRequest.class]) self = self.mutableCopy;
    
    if([self ISKINDA:NSMutableURLRequest.class])
    {
        NSMutableURLRequest * req = self.mutableCopy;
		  NSS* randomUA = self.class.randomUA;
        [req setValue:randomUA forHTTPHeaderField:@"User-Agent"];
		  NSLog(@"requested %@ with randomUA!", req.URL);
    }
    return self;
}
@end


@implementation NSMutableURLRequest (Extensions)

// http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.2 - TODO: Use "multipart/mixed" in case of multiple file attachments
+ (NSData*) HTTPBodyWithMultipartBoundary:(NSString*)boundary formArguments:(NSDictionary*)arguments {
	NSMutableData* body = [NSMutableData data];
	for (NSString* key in arguments) {
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		id value = [arguments objectForKey:key];
		if ([value ISADICT]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
									 key, [value objectForKey:kMultipartFileKey_FileName]];  // TODO: Properly encode filename
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			NSString* type = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [value objectForKey:kMultipartFileKey_MimeType]];
			[body appendData:[type dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value objectForKey:kMultipartFileKey_FileData]];
		} else if ([value isKindOfClass:NSString.class]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];  // Content-Type defaults to "text/plain"
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[(NSString*)value dataUsingEncoding:NSUTF8StringEncoding]];
		} else if ([value isKindOfClass:[NSData class]]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];  // Content-Type defaults to "text/plain"
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:value];
		} else {
			NOT_REACHED();
		}
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	return body;
}

- (void) setHTTPBodyWithMultipartFormArguments:(NSDictionary*)arguments; {
	NSString* boundary = @"0xKhTmLbOuNdArY";
	[self setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	[self setHTTPBody:[[self class] HTTPBodyWithMultipartBoundary:boundary formArguments:arguments]];
}

@end


