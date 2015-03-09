//
//  NSTextView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import <AtoZ/AtoZ.h>
//#import "AtoZCategories.h"
//#import "NSTextView+AtoZ.h"

@implementation AZTextViewResponder
- (void) mouseDown:(NSEvent *)theEvent {
	[[self nextResponder] mouseDown:theEvent];
}
@end

#import <AppKit/AppKit.h>

@implementation NSControl (AtoZ)

- (void) setSizeToFit:(BOOL)sizeTo {



//  [self.cell az_overrideSelector:@selector(drawInteriorWithFrame:inView:)
//                  withBlock:(__bridge void*)^(id _self, NSR cellFrame,NSView *controlView){

  [self.cell interceptSelector:@selector(drawInteriorWithFrame:inView:)  /* here we add a proxy to an existing object */
                         atPoint:InterceptPointStart
                           block:^(NSInvocation *inv, InterceptionPoint intPt) {

    XX(@"well hello!");
    NSMAS *maString = [self attributedStringValue].mC;
    NSR cellFrame = self.bounds;
    NSSZ stringSize = maString.size;

    if (stringSize.width > cellFrame.size.width) {
      while (stringSize.width > cellFrame.size.width) {
        NSFont *font = [maString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        [maString addAttribute:NSFontAttributeName value:
                 [NSFont fontWithName:font.fontName size:[font.fontDescriptor[NSFontSizeAttribute] floatValue] - 0.5]
                                                   range:[(NSS*)maString range]];
          stringSize = maString.size;
      }
    }
    NSR dRect            = cellFrame;
    dRect.size.height    = stringSize.height;
    dRect.origin.y      += (cellFrame.size.height - stringSize.height) / 2;
    [maString drawInRect:dRect];
  }];

  [[self cell] drawInteriorWithFrame:NSZeroRect inView:self];
//To make the font correctly center vertically, the following line is needed right before the while:
//  [mutableAttributedString removeAttribute:@"NSOriginalFont" range:NSMakeRange(0, [mutableAttributedString length])];
}
@end


@implementation NSTextView (AtoZ)
- (NSString*) highlightColorDefaultsKeyName 	{	  return @"CurrentLineHighlightColor";	}
- (void) setHighlightCurrentLine:(BOOL)hl 	{

	AZCOLORPANEL;
	[self setAssociatedValue:hl?@(YES):@(NO) forKey:self.highlightColorDefaultsKeyName policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	if (!hl) return;
//	[AZNOTCENTER observeName:NSViewFrameDidChangeNotification usingBlock:^(NSNotification *m) {
	[AZNOTCENTER observeNotificationsUsingBlocks: NSViewFrameDidChangeNotification, ^(NSNotification *m){
		 m.object == self ? [self highlightLineContainingRange:self.selectedRange] : nil;
	}, NSTextViewDidChangeSelectionNotification, 
	^(NSNotification *z) {
		[self addItemToApplicationMenu];
		if (z.object != self) return;
		[self removeHighlightFromLineContainingRange:[z.userInfo[@"NSOldSelectedCharacterRange"] rangeValue]];
		self.selectedRange.length  ? nil : [self highlightLineContainingRange:self.selectedRange]; // not a multi-line selection
	}, nil];
//	[AZNOTCENTER observeName:NSTextViewDidChangeSelectionNotification usingBlock:^(NSNotification *z) {
//		if (z.object != self) return;
//		[self removeHighlightFromLineContainingRange:[z.userInfo[@"NSOldSelectedCharacterRange"] rangeValue]];
//		self.selectedRange.length  ? nil : [self highlightLineContainingRange:self.selectedRange]; // not a multi-line selection
//	}];
}
- _IsIt_ highlightCurrentLine 					{   return [[self associatedValueForKey:self.highlightColorDefaultsKeyName orSetTo:@(NO)] bV]; }
- (NSC*) highlightCurrentLineColor 				{
	NSData* colorAsData = [AZUSERDEFS objectForKey:self.highlightColorDefaultsKeyName];
	__block NSC* c = colorAsData ? [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData] : ^{
		return  c = RANDOMCOLOR, [self setHighlightCurrentLineColor:c], c;
	}();
	return c;
}

/* selector:@selector( highlightFrameChanged:) name:  object: nil];
	[AZNOTCENTER addObserver:self selector: @selector( highlightSelectionChanged:) name: NSTextViewDidChangeSelectionNotification object: nil];
- (void) highlightFrameChanged:	  (NSNOT*)n { n.object == self ? [self highlightLineContainingRange:self.selectedRange] : nil; }
- (void) highlightSelectionChanged:(NSNOT*)n {  	
	if (n.object != self) return;
	[self removeHighlightFromLineContainingRange:[n.userInfo[@"NSOldSelectedCharacterRange"] rangeValue]];
	self.selectedRange.length  ? nil : [self highlightLineContainingRange:self.selectedRange]; // not a multi-line selection	}*/

- (void) highlightLineContainingRange:				(NSRNG)r	{
                
  	NSD *attrs = @{NSBackgroundColorAttributeName : self.highlightCurrentLineColor};                                                                                                           
	[self.layoutManager addTemporaryAttributes:attrs
									 forCharacterRange:[self.string lineRangeForRange:r]];
}
- (void) removeHighlightFromLineContainingRange:(NSRNG)r	{

    [self.layoutManager removeTemporaryAttribute:NSBackgroundColorAttributeName 
										 forCharacterRange:[self.string lineRangeForRange:r]];
}

- (void) setHighlightCurrentLineColor:(NSC*)c	{

  	[AZUSERDEFS setColor:c forKey:self.highlightColorDefaultsKeyName];
	[AZUSERDEFS synchronize];
}
- (void) selectHighlightColor:		  (id)send	{

  [AZCOLORPANEL bind:@"color" toObject:self withKeyPathUsingDefaults:@"highlightCurrentLineColor"];
//  [(NSControl*)AZCOLORPANEL setAction:@selector(changeHighlightColor:) withTarget:self];
  [AZCOLORPANEL observeName:NSWindowWillCloseNotification usingBlock:^(NSNOT  *m) {
//		[AZNOTCENTER stopObserving:AZCOLORPANEL forName:NSWindowWillCloseNotification];
//  		[AZNOTCENTER stopObserving:AZCOLORPANEL forName:NSColorPanelColorDidChangeNotification];
//		[(NSControl*)AZCOLORPANEL setAction:nil withTarget:nil];
		[AZCOLORPANEL unbind:@"color"];
  }];
//  [AZCOLORPANEL observeName:NSColorPanelColorDidChangeNotification usingBlock:^(NSNOT *c){
//  	self.highlightCurrentLineColor = AZCOLORPANEL.color;
//  }];
  [NSApp orderFrontColorPanel:nil];
}
//- (IBAction) changeHighlightColor:	  (id)send	{
//
//  [self setHighlightCurrentLineColor:AZCOLORPANEL.color];
//  // Update window size (grow then back to what it was) in order to cause frame
//  // change even. This is because we can't have a guaranteed valid reference to
//  // the view. Kind of silly, but better than crashing.
////  id window = [NSApp mainWindow];
////  NSRect frame = [window frame];      
////  NSRect tempFrame = NSMakeRect( frame.origin.x, 
////                                 frame.origin.y, 
////                                 frame.size.width, 
////                                 frame.size.height + 1.0 );
////
////  [window setFrame:tempFrame display:YES];
//  [self.window setFrame:AZRectExtendedOnBottom(self.window.frame,1) display:YES];
//}
//- (void) colorPanelWillClose:(NSNOT*)n	{
//}
#define HIGHLIGHTMENUWORDS @"Highlight Current Line"

- (id) validateHighlightMenuReturnsTargetIfUnset {

	NSUI indexOfView = [[NSApp mainMenu] indexOfItemWithTitle:@"View"];
  	NSMenu* editorMenu = [[[NSApp mainMenu] itemAtIndex:indexOfView] submenu];
	return editorMenu && !([editorMenu itemWithTitle:HIGHLIGHTMENUWORDS]) ? editorMenu : nil;
}
- (void) addItemToApplicationMenu {

	NSMenu *editorMenu = self.validateHighlightMenuReturnsTargetIfUnset;
	if (!editorMenu) return;
	NSMenuItem* newItem;
	[editorMenu addItems:@[NSMenuItem.separatorItem, newItem = NSMenuItem.new]];
	[newItem setTitle:HIGHLIGHTMENUWORDS];  // note: not localized
	[(NSControl*)newItem setAction:@selector( selectHighlightColor: ) withTarget:self];
	[newItem setEnabled:YES];
	[newItem bind:@"state" toObject:self withKeyPath:@"highlightCurrentLine" options:nil];
	[editorMenu insertItem:newItem atIndex:editorMenu.numberOfItems];
}

//+ (void) load {

//	[$ swizzleMethod:@selector(insertText:) with:@selector(swizzledInsert:) in:self.class];
//}


- (void) swizzledInsert: text; {	[self autoScrollText:text];	}

-	(void) autoScrollText:(id) text	{

	NSRange theEnd				= NSMakeRange([self.string length], 0);
	theEnd.location	   	+= [text length];
	// Smart Scrolling
	if (NSMaxY(self.visibleRect) == NSMaxY(self.bounds)) {
		// Append string to textview and scroll to bottom
		[text isKindOfClass:NSAS.class]
			?	[self.textStorage appendAttributedString:text]
			:	[self.textStorage appendString:text];
			[self scrollRangeToVisible:theEnd];
	} else	// Append string to textview
		[text isKindOfClass:NSAS.class]
			?	[self.textStorage appendAttributedString:text]
			:  [self.textStorage appendString:text];
}

-	(void) autoScrollAndStyleText:(NSString*) text;{

	static	NSColor *c = nil;  c = c ?: RANDOMCOLOR;
	static	NSDictionary *dict = nil;

	dict = dict ?: @{ @"NSFontAttributeName" : AtoZ.controlFont,
				   @"NSForegroundColorAttributeName" : c };
	[self autoScrollText:[NSAttributedString stringWithString:text attributes: dict]];
	// Get the length of the textview contents
}

+ (AZTextViewResponder*)  textViewForFrame:(NSRect)frame withString:(NSAttributedString*)s {

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];//
	// alloc] init];
	//	[theStyle setLineSpacing:[s enumerateAttributesInRange:[s length] options:nil usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
	//	}]  floor((int)(.8 * s.font.pointSize)];
	AZTextViewResponder *anAtv = [[AZTextViewResponder alloc]initWithFrame:frame];
	anAtv.selectable					= NO;
	anAtv.defaultParagraphStyle	   		= style;
	anAtv.backgroundColor			 	= CLEAR;
	anAtv.textStorage.attributedString 	= s;
	style.lineSpacing = (anAtv.textStorage.font.pointSize * .8);
	anAtv.defaultParagraphStyle	   		= style;
	//	[anAtv textStorage].foregroundColor = [NSColor blackColor]];
	return  anAtv;
}

- (IBAction)increaseFontSize: sender
{
	NSTextStorage *textStorage = [self textStorage];
	[textStorage beginEditing];
	[textStorage enumerateAttributesInRange: NSMakeRange(0, [textStorage length])
									options: 0
								 usingBlock: ^(NSDictionary *attributesDictionary,
											   NSRange range,
											   BOOL *stop)
	 {
#pragma unused(stop)
		 NSFont *font = attributesDictionary[NSFontAttributeName];
		 if (font) {
			 [textStorage removeAttribute:NSFontAttributeName range:range];
			 font = [[NSFontManager sharedFontManager] convertFont:font toSize:[font pointSize] + 1];
			 [textStorage addAttribute:NSFontAttributeName value:font range:range];
		 }
	 }];
	[textStorage endEditing];
	[self didChangeText];

}

- _Void_ changeFontSize:(CGFloat)delta;
{
	NSFontManager * fontManager = [NSFontManager sharedFontManager];
	NSTextStorage * textStorage = [self textStorage];
	[textStorage beginEditing];
	[textStorage enumerateAttribute:NSFontAttributeName
							inRange:NSMakeRange(0, [textStorage length])
							options:0
						 usingBlock:^(id value,
									  NSRange range,
									  BOOL * stop)
	 {
		 NSFont * font = value;
		 font = [fontManager convertFont:font
								  toSize:[font pointSize] + delta];
		 if (font != nil) {
			 [textStorage removeAttribute:NSFontAttributeName
									range:range];
			 [textStorage addAttribute:NSFontAttributeName
								 value:font
								 range:range];
		 }
	 }];
	[textStorage endEditing];
	[self didChangeText];
}

-  (IBAction)decrementFontSize: sender;
{
	[self changeFontSize:-1.0];
}

-  (IBAction)incrementFontSize: sender;
{
	[self changeFontSize:1.0];
}

@end

@implementation NSSegmentedControl (FitTextNice)

- _Void_ fitTextNice {
	NSInteger N = [self segmentCount] ;
	NSInteger i ;

	CGFloat totalWidthAvailable = 0.0 ;
	for (i=0; i<N; i++) {
		totalWidthAvailable += [self widthForSegment:i] ;
	}

	CGFloat totalTextWidth = 0.0 ;
	NSMutableArray* textWidths = NSMA.new ;
	for (i=0; i<N; i++) {
		CGFloat textWidth = [[self labelForSegment:i] widthForHeight:CGFLOAT_MAX
																font:[self font]] ;
		[textWidths addObject:[NSNumber numberWithDouble:textWidth]] ;
		totalTextWidth += textWidth ;
	}

	CGFloat factor = totalWidthAvailable/totalTextWidth ;

	for (i=0; i<N; i++) {
		CGFloat textWidth = [[textWidths objectAtIndex:i] doubleValue] * factor ;
		[self setWidth:textWidth
			forSegment:i] ;
	}

//	[textWidths release] ;
}

@end
