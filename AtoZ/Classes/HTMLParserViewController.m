//
//  HTMLParserViewController.m
//  AtoZ
//
//  Created by Alex Gray on 12/6/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "HTMLParserViewController.h"

@interface HTMLParserViewController ()

@end

@implementation HTMLParserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(IBAction) parseURL:(id) sender;
{

//	NSString *googleString = $(@"http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryString=%@&MaxHits=1",[sender stringValue]);
////	@"https://www.google.com/search?client=safari&rls=en&q=%@&ie=UTF-8&oe=UTF-8", );
//	NSURL *googleURL = [NSURL URLWithString:googleString];
//	NSError *error;
//
////	NSA *a = [NSA arrayWithContentsOfURL:googleURL];
////	NSLog(@"array %@", a);
//
//	NSString *googlePage = [NSString stringWithContentsOfURL:googleURL
//													encoding:NSASCIIStringEncoding
//													   error:&error];
////	NSMS* outp = [NSMS new];
	_textField.stringValue = [[sender stringValue]wikiDescription];// parseXMLTag:@"Description"];

//	HTMLParser *parser = [[HTMLParser alloc] initWithString:googlePage error:&error];
////
//	if (error) {
//		NSLog(@"Error: %@", error);
//		return;
//	}
////
//	HTMLNode *bodyNode = [parser body];

//	NSArray *inputNodes = [bodyNode findChildTags:@"st"];

//	for (HTMLNode *inputNode in inputNodes) {
//		[outp appendString:[inputNode getAttributeNamed:@"value"]];
//		if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
//			NSLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question
//		}
//	}
//	[_textField setStringValue:googlePage];
//	NSArray *spanNodes = [bodyNode findChildTags:@"Description"];
//	[_textField setStringValue:((HTMLNode*)spanNodes[0]).contents];


//	[outp appendString:[[spanNodes filterOne:^BOOL(HTMLNode *spanNode ) {
//		if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"st"]){
//			NSS* s = [spanNode allContents];
//			return  s != nil;
//		} else return NO;
//	}] rawContents]];
////			NSLog(@"%@", [spanNode rawContents]); //Answer to second question
////		}
////	}
//	[outp appendString:@"\n*****************\n"];
//	[outp appendString:googlePage];
//	[_textField setStringValue:outp];

//	[parser release];
}
@end
