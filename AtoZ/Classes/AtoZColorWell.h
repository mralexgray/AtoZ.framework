//
//  SPColorWell.h
//  SPColorWell
//
//  Created by Philip Dow on 11/16/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

/**
 - (void)applicationDidFinishLaunching:(NSNotification *)aNotification
 {
 // Insert code here to initialize your application

 // Make sure the shared color panel is available from the git go so that it will
 // reflect the initial color in our text view
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

#import "AtoZ.h"

@interface AtoZColorPicker : NSView

@property(readwrite,copy) NSArray *colors;
@property(readwrite,copy) NSIndexSet *selectionIndex;
//@property(readwrite) BOOL canRemoveColor;

@property(readwrite) SEL action;
@property(readwrite,unsafe_unretained) id target;

//@property(readwrite) SEL removeColorAction;
//@property(readwrite,unsafe_unretained) id removeColorTarget;

+ (NSSize) proposedFrameSizeForAreaDimension:(CGFloat)dimension;

// used by AtoZColorWell to remember the current selection prior to popping so that it may be returned if no new selection is made
- (void) pushCurrentSelection;
- (void) popCurrentSelection;

- (BOOL) updateSelectionIndexWithColor:(NSColor*)aColor;
- (void) takeColorFrom:(id)sender;
- (NSColor*) color;

@end


@interface AtoZColorWell : NSColorWell <NSMenuDelegate>
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

@property (nonatomic, retain) NSMenu *colorPickerMenu;
@property (nonatomic, retain) AtoZColorPicker *colorPicker;

@property(readwrite,copy) NSString *title;
//@property(readwrite) BOOL canRemoveColor;

@property(readwrite) NSBorderType borderType;

// suported borderType values: NSNoBorder / NSLineBorder / NSBezelBorder

//@property(readwrite) SEL removeColorAction;
//@property(readwrite,unsafe_unretained) id removeColorTarget;

- (void)drawTitleInside:(NSRect)insideRect;
- (void)drawWellInside:(NSRect)insideRect;

@end

//
//  SPColorPicker.h
//  SPColorWell
//
//  Created by Philip Dow on 11/16/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//


@interface HighlightingView : NSView
//{
//@private
//	BOOL _highlighted;

@property (nonatomic,assign, getter=isHighlighted) BOOL highlighted;
@end

@interface AtoZColorWellMenuView : NSView
//{
//@private
//	HighlightingView *__unsafe_unretained showColorsView;
//	AtoZColorPicker *__unsafe_unretained colorPickerView;
//	AtoZColorWell *__unsafe_unretained colorWell; // don't care for the coupling
//
//	NSTrackingArea *_colorPickerTrackingArea;
//	NSTrackingArea *_highlightTrackingArea;
//}
@property(unsafe_unretained) NSTrackingArea *colorPickerTrackingArea, *highlightTrackingArea;

@property(unsafe_unretained) HighlightingView *showColorsView;
@property(unsafe_unretained) AtoZColorPicker *colorPickerView;
@property(unsafe_unretained) AtoZColorWell *colorWell;

@end
