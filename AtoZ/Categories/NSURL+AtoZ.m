//
//  NSURL+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 8/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

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
//- (void)setSpecialVars:(NSD*)specialVars {
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
		parameters = [NSMutableDictionary dictionary];
		NSScanner* scanner = [[NSScanner alloc] initWithString:query];
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
		[scanner release];
	}
	return parameters;
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
		} else if ([value isKindOfClass:[NSString class]]) {
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


