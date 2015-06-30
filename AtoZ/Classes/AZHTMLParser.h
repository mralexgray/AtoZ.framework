
//  HTMLParser.h  StackOverflow
//  Created by Ben Reeves on 09/03/2010.  Copyright 2010 Ben Reeves. All rights reserved.


@class           HTMLNode ;
@interface 	 AZHTMLParser : NSObject

- initWithContentsOfURL:(NSU*)u error:(NSERR*__autoreleasing*)e;
-          initWithData:(DTA*)d error:(NSERR*__autoreleasing*)e;
-        initWithString:(NSS*)s error:(NSERR*__autoreleasing*)e;

_RO HTMLNode * doc,		// Returns the doc  tag
                  * body,	//	Returns the body tag
                  * html, 	//	Returns the html tag
                  * head;	//	Returns the head tag
@end


//{	@public	htmlDocPtr _doc;	}

