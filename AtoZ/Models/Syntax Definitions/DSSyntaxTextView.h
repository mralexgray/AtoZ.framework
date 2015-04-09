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
_NA DSSyntaxHighlighter* syntaxHighlighter;
/** The color theme used by the syntax highlighter. */
_NA 			AZSyntaxTheme *theme;
/** The syntax definition used by the syntax highlighter. */
_NA DSSyntaxDefinition *syntaxDefinition;
/** The view used to display the line numbers. */
_RO NoodleLineNumberView *lineNumberView;

/// @name Code editing options  

/** Indicates if the line number ruler is visible. */
_AT BOOL lineNumbersVisible;
/** The number of spaces for tab expansion.  A value of 0 indicates no tab expansion. */
_NA NSInteger tabWidth;

@end
