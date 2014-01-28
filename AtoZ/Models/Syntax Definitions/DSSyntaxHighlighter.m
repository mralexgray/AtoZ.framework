#import "DSSyntaxHighlighter.h"
#import "DSSyntaxDefinition.h"

/**
 TODO:
 - Localized updates
 - Background updates
 **/
@implementation DSSyntaxHighlighter {	  NSAttributedString* _syntaxAttributedString; }

- (id)initWithTextStorage:(NSTextStorage *)storage {

	if (self != [super init]) return nil;
	_storage = storage;
	[_storage setDelegate:self];
 	_theme = [AZSyntaxTheme defaultTheme];
	for (NSLayoutManager* layoutManager in self.storage.layoutManagers)
 		[layoutManager setDelegate:self];
	return self;
}

#pragma mark Properties

- (void)setTheme:(AZSyntaxTheme *)theme {	_theme = theme;  [self parse];	// TODO: invalidate layout?
}
- (void)setSyntaxDefinition:(DSSyntaxDefinition *)syntaxDefinition {
	_syntaxDefinition = syntaxDefinition;
	[self parse];
	// TODO: invalidate layout?
}
#pragma mark NSTextStorage delegate methods
- (void)textStorageDidProcessEditing:(NSNotification *)aNotification {
	[self parse];
}
- (void)parse {
	_syntaxAttributedString = [_syntaxDefinition parseString:_storage.string];
}
#pragma mark NSLayoutManager delegate methods
- (NSDictionary *)layoutManager:(NSLayoutManager *)layoutManager
   shouldUseTemporaryAttributes:(NSDictionary *)attrs
             forDrawingToScreen:(BOOL)toScreen
               atCharacterIndex:(NSUInteger)charIndex
                 effectiveRange:(NSRangePointer)effectiveCharRange {

	if (!toScreen || !_syntaxDefinition || !_theme ||
		 !_storage.string || [_storage.string isEqualToString:@""] ) { return nil; }

	NSMutableDictionary *result = [attrs mutableCopy];
	NSMutableDictionary *highlightAttrs = [NSMutableDictionary new];
	NSString *type = [_syntaxAttributedString attribute:DSSyntaxTypeAttribute
															  atIndex:charIndex
													 effectiveRange:effectiveCharRange];

	NSColor *color = [_theme colorForType:type];
	[highlightAttrs setObject:color forKey:NSForegroundColorAttributeName];
	[result addEntriesFromDictionary:highlightAttrs];
	return result;
}
@end

/*
 INFO:

 http://www.cocoabuilder.com/archive/cocoa/75741-syntax-colouring.html
 http://www.noodlesoft.com/blog/2012/05/29/syntax-coloring-for-fun-and-profit/

 After some research, I found that the -[NSMutableAttributedString
 addAttributes:range:] method was causing most of the slowdown in the
 code (and what a slowdown this was!).  Replacing the calls to that
 method to addAttribute:value:range: improved things exponentially (no
 exact measurements, but we're talking several minutes down to a few
 seconds).

 */

