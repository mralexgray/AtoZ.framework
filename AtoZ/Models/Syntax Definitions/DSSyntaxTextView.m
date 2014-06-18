
//  DSSyntaxTextView.m  DSSyntaxKit
//  Created by Fabio Pelosin on 25/09/12.  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.

#import "AtoZ.h"
#import "DSSyntaxTextView.h"
#import "DSObjectiveCSyntaxDefinition.h"

@implementation DSSyntaxTextView

- (id)initWithFrame:(NSRect)frame {
	
	return self = [super initWithFrame:frame] ? [self commonInitialization], self : nil;
}
- (void)awakeFromNib {  [self commonInitialization]; }

- (void)commonInitialization {
	
	[self setNoForKeys:@[
    @"grammarCheckingEnabled",@"continuousSpellCheckingEnabled", @"richText",@"importsGraphics",
    @"automaticDashSubstitutionEnabled", @"automaticTextReplacementEnabled",
    @"automaticSpellingCorrectionEnabled", @"automaticQuoteSubstitutionEnabled"]];
  [self setYesForKeys:@[@"usesFindBar", @"automaticLinkDetectionEnabled"]];
	[self setTabWidth:2];
	
	self.enclosingScrollView.verticalRulerView      = _lineNumberView
                                                  = [NoodleLineNumberView.alloc initWithScrollView:self.enclosingScrollView];
	self.enclosingScrollView.hasHorizontalRuler     = NO;
	self.enclosingScrollView.hasVerticalRuler       = YES;
	self.horizontallyResizable                      = YES;
	self.enclosingScrollView.hasHorizontalScroller  = NO;
	_syntaxHighlighter = [DSSyntaxHighlighter.alloc initWithTextStorage:self.textStorage];
  _syntaxHighlighter.syntaxDefinition = DSObjectiveCSyntaxDefinition.new;
	[self setFont:AtoZ.controlFont];
	[self setNeedsDisplay:YES];
}

///-----------------------------------------------------------------------------
#pragma mark - Properties
///-----------------------------------------------------------------------------
- (DSSyntaxDefinition *)syntaxDefinition 	{  return _syntaxHighlighter.syntaxDefinition; }
- (AZSyntaxTheme*)theme 						{	return _syntaxHighlighter.theme; }

- (void)setSyntaxDefinition:(DSSyntaxDefinition *)syntaxDefinition {
	
	_syntaxHighlighter.syntaxDefinition = syntaxDefinition;
  	[self setNeedsDisplay:TRUE];
}


- (void)setTheme:(AZSyntaxTheme *)theme {  if (!theme) return; _syntaxHighlighter.theme = theme;
	
	[self setBackgroundColor:_syntaxHighlighter.theme.backgroundColor];
	[self setInsertionPointColor:_syntaxHighlighter.theme.cursorColor];
	[self setSelectedTextAttributes: @{ NSBackgroundColorAttributeName : _syntaxHighlighter.theme.selectionColor}];
	[self setNeedsDisplay:YES];
}

- (void) setLineNumbersVisible:(BOOL)v { self.enclosingScrollView.rulersVisible = v; 		}
- (BOOL) lineNumbersVisible 				{ return self.enclosingScrollView.rulersVisible; 	}
#pragma mark - Insertions

- (void)setString:(NSString *)string { [super setString:string]; }

- (void)configureContainer {

	[self.textContainer setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
	[self.textContainer setWidthTracksTextView:NO];
}

- (void)setTextContainer:(NSTextContainer *)container {
	[super setTextContainer:container];
	[self configureContainer];
}

// TODO: this shold not be here.
- (void)insertNewline:(id)sender {

	NSS * string            = self.textStorage.string;
	NSRNG insertionRange    = [self.selectedRanges[0] rangeValue];
	NSRNG lineRange         = [string lineRangeForRange:insertionRange];
	NSS * previousLine      = [string substringWithRange:lineRange];
	
	NSRNG nextCharRange     = NSMakeRange(insertionRange.location, 1);
	NSS * nextChar          = [string substringWithRange:nextCharRange];
	BOOL isRangeAtEndOfLine = [nextChar isEqualToString:@"\n"];
	
	[super insertNewline:sender];
	[self insertText:previousLine.indentation];
	
	NSRange newCursorRange = [self.selectedRanges[0] rangeValue];

	if (isRangeAtEndOfLine) {

		NSString *completion = [self.syntaxDefinition completionForNewLineAfterLine:previousLine
																							 indentation:[previousLine indentation]];
		if (completion) [self insertText:completion];
	}
	[self setSelectedRange:newCursorRange];
}

- (NSString*)partialLineToCursorPosition {
	NSString* string    = self.textStorage.string;
	NSRange cursorRange = [[[self selectedRanges] objectAtIndex:0] rangeValue];
	NSRange lineRange   = [string lineRangeForRange:cursorRange];
	lineRange.length = cursorRange.location - lineRange.location;
	return [string substringWithRange:lineRange];
}

- (NSArray *)completionsForPartialWordRange:(NSRange)charRange
                        indexOfSelectedItem:(NSInteger *)index {
	
	NSString *partialWord = [self.string substringWithRange:charRange];
	NSString *partialLine = [self partialLineToCursorPosition];
	return [self.syntaxDefinition completionsForPartialWord:partialWord
															  partialLine:partialLine
													indexOfSelectedItem:index];
}

// insert spaces	// move to auto completion
- (void)insertTab:(id)sender { _tabWidth? [self insertText:[NSS spaces:_tabWidth]]: [super insertTab:sender];	}
	
@end

