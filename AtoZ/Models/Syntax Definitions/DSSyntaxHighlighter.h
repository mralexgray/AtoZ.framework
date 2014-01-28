//
//  DSSyntaxHighlighter.h
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 26/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSSyntaxDefinition.h"
#import "AZSyntaxTheme.h"

/** The DSSyntaxHighlighter is responsible of coordinating the layout managers of a text container with a syntax definition and a theme. In a  nutshell it reacts to the editings of the text storage and provides temporary attributes to the layout manager. */
@interface DSSyntaxHighlighter : NSObject <NSTextStorageDelegate, NSLayoutManagerDelegate>

/* The NSTextStorage that is attached to the highlighter. */
@property (nonatomic, readonly) NSTextStorage* storage;
/* The syntax definition used for the analyzing the text. */
@property (nonatomic, strong) DSSyntaxDefinition* syntaxDefinition;
/* The theme to use for highlighting the values of the syntax definition. */
@property (nonatomic, strong) AZSyntaxTheme* theme;

/* Initializes a highlighter with the given storage.  
	The highligther will set itself as the delegate of the storage and of its layout managers. */
- (id)initWithTextStorage:(NSTextStorage *)storage;
@end
