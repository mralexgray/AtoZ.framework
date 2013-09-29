//
//  DSSyntaxTextView.h
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 25/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//


#import "DSSyntaxHighlighter.h"
#import <NoodleKit/NoodleLineNumberView.h>


@interface DSSyntaxTextView : NSTextView

/** The syntax highlighter used by the text view. */
@property (nonatomic, strong) DSSyntaxHighlighter* syntaxHighlighter;
/** The color theme used by the syntax highlighter. */
@property (nonatomic) 			AZSyntaxTheme *theme;
/** The syntax definition used by the syntax highlighter. */
@property (nonatomic) DSSyntaxDefinition *syntaxDefinition;
/** The view used to display the line numbers. */
@property (nonatomic, readonly) NoodleLineNumberView *lineNumberView;

/// @name Code editing options  

/** Indicates if the line number ruler is visible. */
@property BOOL lineNumbersVisible;
/** The number of spaces for tab expansion.  A value of 0 indicates no tab expansion. */
@property (nonatomic) NSInteger tabWidth;

@end
