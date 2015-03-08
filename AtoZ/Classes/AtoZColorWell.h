//  SPColorWell.h  SPColorWell
//  Created by Philip Dow on 11/16/11. Copyright 2011 Philip Dow / Sprouted. All rights reserved.


/**
 - (void) pplicationDidFinishLaunching:(NSNotification *)aNotification {

 // Make sure the shared color panel is available from the git go so that it will reflect the initial color in our text view

 [NSColorPanel sharedColorPanel];
 [self.window setBackgroundColor:[NSColor colorWithCalibratedWhite:0.64 alpha:1.]];
 self.bgColorWell.title = NSLocalizedString(@"a", @"");

 // A means is required to coordinate the color at the insertion point of the text view
 // with the color displayed in the color well.

 // Normally color wells manage this automatically if they are active, SPColorWell does
 // too. But it is also possible that we need to update the color even when the
 // well is not active, as the well only becomes active when we show the color panel.
 // Why? Activating the well automatically shows the panel, and we don't want this when
 // the menu is popped

 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(updateColorWell:)
 name:NSTextViewDidChangeSelectionNotification
 object:self.textView];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(updateColorWell:)
 name:NSTextViewDidChangeTypingAttributesNotification
 object:self.textView];

 // if you'd like the color well to be able to remove the color selection, enable
 // the logic for actually doing so is not yet implemented

 //	self.colorWell.removeColorAction = @selector(removeColorSelection:);
 //	self.colorWell.removeColorTarget = self;
 //	self.colorWell.canRemoveColor = YES;
 }

 - (void) updateColorWell:(NSNotification*)aNotification
 {
 NSDictionary *attrs = [[aNotification object] typingAttributes];
 NSColor *color = [attrs objectForKey:NSForegroundColorAttributeName];
 if ( color == nil ) color = [NSColor blackColor];
 colorWell.color = color;
 [colorWell setNeedsDisplay:YES];
 }

 - (IBAction) removeColorSelection:(id)sender
 {
 NSLog(@"%s",__PRETTY_FUNCTION__);
 [[self window]setBackgroundColor:colorWell.color];
 // do something here like remove NSBackgroundColorAttributeName from an
 // attributed string
 }
	*/
	

@interface AtoZColorWell : NSColorWell <NSMenuDelegate>

@property    (CP) void(^selectionBlock)(NSColor*);

@property (NATOM) 		NSMenu *colorPickerMenu;
@property    (CP)     		NSS *title;
@property 			NSBorderType borderType; // suported borderType values: NSNoBorder / NSLineBorder / NSBezelBorder

- (void) drawTitleInside:(NSRect)insideRect;
- (void) drawWellInside:(NSRect)insideRect;
@end




//@property(readwrite) BOOL canRemoveColor;
//@property(readwrite) SEL removeColorAction;
//@property(readwrite,unsafe_unretained) id removeColorTarget;


//
//  SPColorPicker.h
//  SPColorWell
//
//  Created by Philip Dow on 11/16/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//


//{ HighlightingView
//{
//@private
//	BOOL _highlighted;

//@private AtoZColorWellMenuView
//	HighlightingView *__unsafe_unretained showColorsView;
//	AtoZColorPicker *__unsafe_unretained colorPickerView;
//	AtoZColorWell *__unsafe_unretained colorWell; // don't care for the coupling
//
//	NSTrackingArea *_colorPickerTrackingArea;
//	NSTrackingArea *_highlightTrackingArea;
//}

//{
//@private
//	NSString *title;
//	BOOL canRemoveColor;
//
//	NSBorderType borderType;
//
//	SEL removeColorAction;
//	id __unsafe_unretained removeColorTarget;
//
//	NSMenu *_colorPickerMenu;
//	AtoZColorPicker *_colorPicker;
//}
