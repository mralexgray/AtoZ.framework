
//  HTMLParser.m
//  StackOverflow
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.

#import "AtoZ.h"
#include <libxml2/libxml/HTMLparser.h>      //HTMLparser.h>
#import "HTMLNode.h"
#import "AZHTMLParser.h"

@interface AZHTMLParser ()
@property htmlDocPtr docPtr;
@end

@implementation AZHTMLParser

-(EL*) doc	{ return _docPtr == NULL ? nil : [HTMLNode instanceWithXMLNode:(xmlNode*)_docPtr];	}
-(EL*) html	{ return _docPtr == NULL ? nil : [self.doc findChildTag:@"html"];	}
-(EL*) head	{ return _docPtr == NULL ? nil : [self.doc findChildTag:@"head"];	}
-(EL*) body	{ return _docPtr == NULL ? nil : [self.doc findChildTag:@"body"];	}

-         initWithString:(NSS*)str error:(__autoreleasing NSERR**)e  {

  if (!(self = super.init)) return nil;	_docPtr = NULL;

	if (str.length)	{
		CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
		CFStringRef   cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
		const char       * enc = CFStringGetCStringPtr(cfencstr, 0);
		// _doc = htmlParseDoc((xmlChar*)[string UTF8String], enc);
		int        optionsHtml = HTML_PARSE_RECOVER;
		           optionsHtml = optionsHtml | HTML_PARSE_NOERROR; //Uncomment this to see HTML errors
               optionsHtml = optionsHtml | HTML_PARSE_NOWARNING;
                   _docPtr = htmlReadDoc ((xmlChar*)str.UTF8String, NULL, enc, optionsHtml);
	}
	else *e = e ? [NSERR errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil] : *e;
	return self;
}
-           initWithData:(DTA*)dta error:(NSERR*__autoreleasing*)e  { if (!(self = [super init])) return nil;

  _docPtr = NULL;

  if (dta)	{
		CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
		CFStringRef   cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
		const char       * enc = CFStringGetCStringPtr(cfencstr, 0);                                  //_doc = htmlParseDoc((xmlChar*)[data bytes], enc);
		_docPtr = htmlReadDoc((xmlChar*)dta.bytes, "",	enc, XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
	}
	else	*e = e ? [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil] : *e;
	return self;
}
-  initWithContentsOfURL:(NSURL*)u error:(NSERR*__autoreleasing*)e  {

	NSData * _data = [NSData.alloc initWithContentsOfURL:u options:0 error:e];
	if (_data == nil || *e) return nil;
	return self = [self initWithData:_data error:e];
}

- (void) dealloc {	if (_docPtr)	xmlFreeDoc(_docPtr); }

@end
