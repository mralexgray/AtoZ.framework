
//  HTMLParser.h
//  StackOverflow
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.


#import <Foundation/Foundation.h>

@class           HTMLNode ;
@interface 	 AZHTMLParser : NSObject

-(id)initWithContentsOfURL:(NSURL*)url 		error:(NSError**)error;
-(id)initWithData:			(NSData*)data 		error:(NSError**)error;
-(id)initWithString:			(NSString*)string error:(NSError**)error;

- (HTMLNode*)doc;		// Returns the doc  tag
- (HTMLNode*)body;	//	Returns the body tag
- (HTMLNode*)html; 	//	Returns the html tag
- (HTMLNode*)head;	//	Returns the head tag

@end




//{	@public	htmlDocPtr _doc;	}

