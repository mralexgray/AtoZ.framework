
#import "AtoZ.h"
#import "AtoZColorWell.h"

@interface    HighlightingView : NSView
@property (nonatomic,getter=isHighlighted) BOOL highlighted;
@end
@interface 		AtoZColorPicker : NSView
@property (readwrite,copy)  NSA * colors;
@property (readwrite,copy) NSIS * selectionIndex;
@property (readwrite) 		SEL   action;
@property (weak) 				 id   target;

+ (NSSZ) proposedFrameSizeForAreaDimension:(CGF)dimension;
- (void) pushCurrentSelection; // used by AtoZColorWell to save current select. b4 popping so it may be returned if no new selection
- (void) popCurrentSelection;
- (BOOL) updateSelectionIndexWithColor:(NSC*)aColor;
- (void) takeColorFrom:(id)sender;
- (NSColor*) color;

@end
//@property(readwrite) BOOL canRemoveColor;
//@property(readwrite) SEL removeColorAction;
//@property(readwrite,unsafe_unretained) id removeColorTarget;

@interface AtoZColorWellMenuView : NSView

@property(unsafe_unretained) NSTrackingArea *colorPickerTrackingArea, *highlightTrackingArea;
@property(unsafe_unretained) HighlightingView *showColorsView;
@property(unsafe_unretained) AtoZColorPicker *colorPickerView;
@property(unsafe_unretained) AtoZColorWell *colorWell;
@end



@class  AtoZColorPicker;
@interface AtoZColorWell()
@property (NATOM) AtoZColorPicker *colorPicker;
- (void) updateColorFromColorPicker:(id)sender;
- (void) setUpColorPickerMenu;
@end
//- (void) colorPickerDidChoseRemoveColor:(id)sender;
@implementation AtoZColorWell
@synthesize title, /*canRemoveColor,*/ borderType;
//@synthesize removeColorAction, removeColorTarget;

-   (id) initWithFrame:(NSRect)frameRect	{
	
	if (!(self = [super initWithFrame:frameRect])) return nil;
	self.color = BLACK;
	self.borderType = NSBezelBorder;
	return self;
}
-   (id) initWithCoder:(NSCoder *)aDecoder {
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	self.color = WHITE;
	self.borderType = NSBezelBorder;
	return self;
}
- (void) dealloc	{
	
	_colorPickerMenu = nil;
	_colorPicker 	 = nil;
	self.color 		 = nil;
}
- (void) drawRect:(NSRect)dirtyRect	{
	
	NSRect colorArea 		 = self.bounds;
	if ( self.borderType	!= NSNoBorder )  {
		// frame and internal gradient
		NSRect frameArea 	 = self.bounds;
		NSRect gradientArea 	 = NSInsetRect(frameArea, 1, 1);
		if ( self.borderType == NSBezelBorder ) {
			// make room for single pixel shadow
			frameArea.size.height	-= 1;
			frameArea.origin.y		+= 1;
			gradientArea.origin.y 	+= 1;
			gradientArea.size.height-= 1;
			[NSGraphicsContext state:^{
				[NSShadow setShadowWithOffset:NSMakeSize(0,-1) blurRadius:0 color:GRAY8]; // frame
				NSRectFillWithColor(frameArea, [NSColor colorWithCalibratedWhite:0.45 alpha:1.0]);
			}];
		} else NSRectFillWithColor(frameArea, [NSColor colorWithCalibratedWhite:0.45 alpha:1.0]); // frame
		// background fill with single pixel bottom shadow
		[[NSGradient.alloc initWithStartingColor:GRAY9 endingColor:GRAY7] drawInRect:gradientArea angle:270.];
		// adjust the color area
		colorArea = NSInsetRect(gradientArea, 1., 1.);
	}
	[self drawWellInside:colorArea];
	if ( self.title ) [self drawTitleInside:colorArea];
}
- (void) drawWellInside:(NSRect)insideRect	{
	
	// NSAssert(self.color!=nil, @"color must not be nil");
	[self.color set];
	NSRectFill(insideRect);
}
- (void) drawTitleInside:(NSRect)insideRect	{
	
	NSD *attrs 	= @{ NSFontAttributeName: [AtoZ controlFont], NSForegroundColorAttributeName:BLACK };	//	[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]],
	NSSZ  size 	= [self.title sizeWithAttributes:attrs];
	NSP origin 	= (NSP) { NSMidX( insideRect ) - size.width / 2, 1 + (NSMidY( insideRect ) - size.height/2) };
	[self.title drawAtPoint:origin withAttributes:attrs];
}
- (void) takeColorFrom:(id)sender	{
	
	if ([sender respondsToSelector: @selector(color)]) self.color = (NSColor*)[sender color];
	[_colorPicker takeColorFrom:sender];
}
- (void) updateColorFromColorPicker:(id)sender	{
	
	// Send the color to the shared color panel which passes the changeColor: method to the first responder. I am unable send the changeColor: method directly TextView's don't ask me for the color
	
	//id target = [NSApp targetForAction:@selector(changeColor:)];
	//[NSApp sendAction:@selector(changeColor:) to:target from:self];
	
	// #warning we don't necessarily want to do this, instead send our target/action?
	[[NSColorPanel sharedColorPanel] setColor:[_colorPicker color]];
	self.color = [_colorPicker color];
	[AZNOTCENTER postNotificationNameOnMainThread:nAZColorWellChanged object:[_colorPicker color]];
	
}
/*
 - (void) colorPickerDidChoseRemoveColor:(id)sender	{
 if ((!self.removeColorTarget) || (!self.removeColorTarget)) return;
 if ([self respondsToSelector:self.removeColorAction])
 [self.removeColorTarget performSelectorWithoutWarnings:self.removeColorAction withObject:self];
 }
 */
- (void) mouseDown:(NSEvent *)theEvent	{
	
	// when the menu is already popped and I double-click outside it, the menu disappears but then I receive a mouseDown event again, so check where the mouse down occurred.
	if ( ![self.superview mouse:[self.superview convertPoint:theEvent.locationInWindow fromView:nil] inRect:self.frame] )		return;
	if ( _colorPickerMenu == nil )  [self setUpColorPickerMenu];
	// Unfortunately, doing so also displays the color panel, which isn't what we want thuse the necessity for the glue code you see in the app delegate
	//	[self activate:NO];
	// pop it
	[_colorPickerMenu popUpMenuPositioningItem:[_colorPickerMenu itemAtIndex:0]
											  atLocation:NSMakePoint(0,-4) // don't care for hardcoding this value
													inView:self];
}
- (void) setUpColorPickerMenu	{
	
	NSSize pickerDims = [AtoZColorPicker proposedFrameSizeForAreaDimension:13];
	static NSInteger kHighlightHeight = 22;
	static NSInteger kTextHeight	  = 14;
	static NSInteger kImageDim 		  = 18;
	static NSInteger kPadding 		  = 4;
	
	_colorPickerMenu = [NSMenu.alloc initWithTitle:@""];
	_colorPicker = [AtoZColorPicker.alloc initWithFrame: (NSR){ kPadding,kHighlightHeight+kPadding, pickerDims.width, pickerDims.height}];
	// normal action for selecting a color
	_colorPicker.action = @selector(updateColorFromColorPicker:);
	_colorPicker.target = self;
	
	AtoZColorWellMenuView *menuView = [AtoZColorWellMenuView.alloc initWithFrame:NSMakeRect(0,0,pickerDims.width+(kPadding*2), pickerDims.height+kHighlightHeight+kPadding)];
	[menuView   addSubview:_colorPicker];
	NSMenuItem  *pickerItem = [NSMenuItem.alloc initWithTitle:@"" action:nil keyEquivalent:@""];
	[pickerItem setView:menuView];
	// set up a view with image and text subviews size must be adjusted for longest localized "show colors"
	
	HighlightingView *showParent = [HighlightingView.alloc initWithFrame: AZRectBy(pickerDims.width+(kPadding*2),kHighlightHeight)];
	[menuView   addSubview: showParent];
	
	// image and text belong in the parent
	NSImageView *imageView = [NSImageView.alloc initWithFrame: NSMakeRect(kPadding,kPadding/2, kImageDim, kImageDim)];
	NSTextField *textField = [NSTextField.alloc initWithFrame: NSMakeRect(kImageDim+kPadding*3/2, kPadding, pickerDims.width-(kImageDim+(kPadding*3/2)),kTextHeight)];
	[showParent addSubview:imageView];
	[showParent addSubview:textField];
	[imageView  setImageScaling:	  NSScaleProportionally];
	[imageView  setImageFrameStyle:	 NSImageFrameNone];
	[imageView  setImage:[NSIMG imageNamed:NSImageNameColorPanel]];
	
	[textField  setStringValue:NSLocalizedString(@"More colors!", @"")];
	[textField  setFont:[AtoZ controlFont]];//[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	[textField  setDrawsBackground: NO];
	[textField  setSelectable:	   NO];
	[textField  setEditable:		   NO];
	[textField  setBordered:		   NO];
	
	menuView.colorPickerView = _colorPicker;
	menuView.showColorsView = showParent;
	menuView.colorWell = self;
	[_colorPickerMenu addItem:pickerItem];
	[_colorPickerMenu setDelegate:self];
	
}
- (void) menuWillOpen:(NSMenu *)menu	{
	
	//NSLog(@"%s",__PRETTY_FUNCTION__);
	
	// An item which can change its color automatically updates the shared color panel,
	// so we query it for the current color: there is no shared protocol which various
	// objects adopt to indicate they have a color or can change it
	
	// the HighlightView handles underlying text colors
	[(HighlightingView*)[(AtoZColorWellMenuView*)[_colorPicker superview] showColorsView]
	 setHighlighted:NO];
	
	// update the color picker from the color well, coordinated with the system color panel
	// originally we were updating self from the color panel, but we don't want to do this
	// when there is more than one color well and ours hasn't been activated yet
	// [self takeColorFrom:[NSColorPanel sharedColorPanel]];
	[_colorPicker takeColorFrom:self];
	
	// remember the picker's current selection
	// this is recalled when the mouse moves out of the picker from the
	// color well menu view mouse tracking methods
	
	[_colorPicker pushCurrentSelection];
	
	// update the remove color option and target/action
	//	_colorPicker.canRemoveColor = self.canRemoveColor;
	//	_colorPicker.removeColorAction = @selector(colorPickerDidChoseRemoveColor:);
	//	_colorPicker.removeColorTarget = self;
}
@end

@implementation HighlightingView
@synthesize highlighted = _highlighted;

// Draw with or without a highlight style
- (void) drawRect:(NSRect)dirtyRect {
	if (self.highlighted) {
		[[NSColor alternateSelectedControlColor] set];
		NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
	}else {
		[[NSColor clearColor] set];
		NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
	}
}
/* Custom highlighted property setter because when the property changes we need to redraw and update the containing text fields.	*/
- (void) setHighlighted:(BOOL)highlighted {
	_highlighted = _highlighted == highlighted ? _highlighted : ^{
		// Inform each contained text field what type of background they will be displayed on. This is how the txt field knows when to draw white text instead of black text.
		[[self subviews] each:^(NSView *subview) {
			if ([subview isKindOfClass:[NSTextField class]])
				[[(NSTextField*)subview cell] setBackgroundStyle:highlighted ? NSBackgroundStyleDark : NSBackgroundStyleLight];
		}];
		[self setNeedsDisplay:YES]; // make sure we redraw with the correct highlight style.
		return highlighted;
	}();
}
#pragma mark Accessibility
/* This view groups the contents of one suggestion.  It should be exposed to accessibility, and should report itself with the role 'AXGroup'.  Because this is an NSView subclass, most of the basic accessibility behavior (accessibility parent, children, size, position, window, and more) is inherited from NSView.  Note that even the role description attribute will update accordingly and its behavior does not need to be overridden. */

// Make sure we are reported by accessibility.  NSView's default return value is YES.
- (BOOL)accessibilityIsIgnored {	return NO; }

// When asked for the value of our role attribute, return the group role.  For other attributes, use the inherited behavior of NSView.
- (id)accessibilityAttributeValue:(NSString *)attribute {
	id attributeValue;
	
	attributeValue = [attribute isEqualToString:NSAccessibilityRoleAttribute] 	? NSAccessibilityGroupRole 
	: [super accessibilityAttributeValue:attribute];
	return attributeValue;
}
@end

//  SPColorPicker.m #import "AGColorPicker.h" "NSColor+CSSRGB.h"  "NSColor+ColorspaceEquality.h"

static NSS * kTrackerKey 			= @"SPColorPickerTrackerKey";
static CGF   kColorPickerPadding = 2.;
static NSA * SPColorPickerDefaultColorsInCSSRGB(void) {
	// Would prefer to have the values derived from a single row of initial values requires a nonlinear equation: hue and brightness values change at a changing pace The color picker expects 120 colors for drawing. The first color represents a "remove color" option
	static NSArray *cssColors = nil;
	return cssColors = cssColors ?: @[
												 
												 @"rgb(255,255,255)", 	@"rgb(255,255,255)", 	@"rgb(235,235,235)", @"rgb(214,214,214)", @"rgb(192,192,192)", @"rgb(170,170,170)",
												 @"rgb(146,146,146)", 	@"rgb(122,122,122)", 	@"rgb(96,96,96)", @"rgb(68,68,68)", @"rgb(35,35,35)", @"rgb(0,0,0)",
												 @"rgb(0,55,72)", 		@"rgb(0,31,84)", 			@"rgb(18,7,57)", @"rgb(47,8,59)", @"rgb(61,6,27)", @"rgb(95,5,3)",
												 @"rgb(92,27,6)", 		@"rgb(89,51,12)", 		@"rgb(86,61,14)", @"rgb(102,97,27)", @"rgb(78,85,24)", @"rgb(36,61,23)",
												 @"rgb(0,78,99)", 		@"rgb(0,48,118)", 		@"rgb(27,13,79)", @"rgb(70,17,85)", @"rgb(88,16,40)", @"rgb(134,12,7)",
												 @"rgb(126,40,11)", 		@"rgb(124,73,20)", 		@"rgb(121,87,24)", @"rgb(141,133,40)", @"rgb(110,118,37)", @"rgb(53,87,36)",
												 @"rgb(0,110,140)", 		@"rgb(0,69,163)",	 		@"rgb(45,23,113)", @"rgb(99,27,119)", @"rgb(123,25,60)", @"rgb(185,22,14)",
												 @"rgb(176,60,20)", 		@"rgb(171,103,32)", 		@"rgb(168,122,38)", @"rgb(196,187,60)", @"rgb(154,165,55)", @"rgb(75,121,53)",
												 @"rgb(0,141,177)",	 	@"rgb(0,90,206)", 		@"rgb(57,32,142)", @"rgb(126,37,152)", @"rgb(157,35,77)", @"rgb(232,30,20)",
												 @"rgb(222,78,28)", 		@"rgb(216,131,43)", 		@"rgb(213,156,51)", @"rgb(246,234,78)", @"rgb(194,207,73)", @"rgb(98,156,70)",
												 @"rgb(0,164,211)", 		@"rgb(0,102,245)",	 	@"rgb(79,41,172)", @"rgb(156,46,182)", @"rgb(189,44,92)", @"rgb(255,60,38)",
												 @"rgb(255,104,40)", 	@"rgb(255,168,57)", 		@"rgb(255,197,66)", @"rgb(255,250,104)", @"rgb(216,234,94)", @"rgb(113,186,85)",
												 @"rgb(0,200,247)",	 	@"rgb(51,139,246)", 		@"rgb(96,57,226)", @"rgb(194,62,234)", @"rgb(235,58,120)", @"rgb(255,96,86)",
												 @"rgb(255,132,83)",		@"rgb(255,178,85)", 		@"rgb(255,201,90)", @"rgb(255,246,129)", @"rgb(227,238,123)", @"rgb(146,210,112)",
												 @"rgb(68,215,249)", 	@"rgb(113,169,248)", 	@"rgb(137,84,244)", @"rgb(215,91,245)", @"rgb(241,112,156)", @"rgb(255,139,133)",
												 @"rgb(255,164,131)", 	@"rgb(255,197,130)", 	@"rgb(255,215,133)", @"rgb(255,247,162)", @"rgb(234,242,156)",  @"rgb(174,221,149)",
												 @"rgb(142,228,251)", 	@"rgb(166,199,250)",	 	@"rgb(179,142,246)", @"rgb(230,148,247)", @"rgb(247,163,191)", @"rgb(255,180,176)",
												 @"rgb(255,196,174)",	@"rgb(255,216,174)",  	@"rgb(255,227,175)",  @"rgb(255,250,193)", @"rgb(242,246,190)", @"rgb(203,232,186)",
												 @"rgb(200,241,253)",	@"rgb(211,227,252)",	 	@"rgb(217,202,250)", @"rgb(243,202,250)", @"rgb(251,211,223)", @"rgb(255,218,217)",
												 @"rgb(255,226,216)", 	@"rgb(255,236,215)", 	@"rgb(255,241,216)", @"rgb(254,252,224)", @"rgb(248,250,222)", @"rgb(223,237,214)",
												 ];
	
}
@interface 						  AtoZColorPicker ()
//@property (nonatomic) NSMA * trackingAreas;
@property (nonatomic) NSIS * originalSelection;

-   (NSR) frameForAreaAtRow:			 (NSI)rowIndex column:(NSI)columnIndex;
- (NSTA*) trackingAreaForIndex:		 (NSI)index;
-  (NSC*) selectionColorForAreaColor:(NSC*)aColor;
-  (void) sendAction;
@end

@implementation AtoZColorPicker
@synthesize colors, /*canRemoveColor,*/ selectionIndex, target, action;//, removeColorAction, removeColorTarget;

- (id)initWithFrame:(NSRect)frame	{
	
	// ideal frame width is factor of 12 + 12...  ideal frame height is this factor + 10
	// eg 228x190 factor 18 						  see proposedFrameSizeForAreaDimension
	if (!(self = [super initWithFrame:frame])) return nil;
//	_trackingAreas 		= [NSMA array];
	selectionIndex = [NSIndexSet indexSetWithIndex:22];
	//	canRemoveColor = NO;
	colors = [SPColorPickerDefaultColorsInCSSRGB() cw_mapArray:^id(NSString *cssColor) {
		return [NSColor colorWithCSSRGB:cssColor] ?: nil;
	}] ?: colors;
	return self;
}


//	NSMutableArray *defaultColors = [NSMutableArray array];
//	for ( NSString *cssColor in SPColorPickerDefaultColorsInCSSRGB() ) {
//		NSColor *color = [NSColor colorWithCSSRGB:cssColor];
//		if ( color == nil ) { NSLog(@"%s - There was a problem parsing the default text colors", __PRETTY_FUNCTION__);
//			defaultColors = nil; break; }[defaultColors addObject:color];	}
// default colors
//	colors = [SPColorPickerDefaultColorsInCSSRGB(void)  enumerateObjectsUsingBlock:^(NSString *cssColor, NSUInteger idx, BOOL *stop) {
//			return [NSColor colorWithCSSRGB:cssColor] ?: [NSNull null];
////			if ( color == nil ) { NSLog(@"%s - There was a problem parsing the default text colors", __PRETTY_FUNCTION__);
////				defaultColors = nil;			} //		if ( defaultColors != nil ) self.colors = defaultColors;
//
//	}];

-     (void) dealloc	{
	
	_originalSelection = nil;
//	_trackingAreas = nil;
}
-     (BOOL) isFlipped { return YES;	}
-     (void) drawRect:(NSRect)dirtyRect	{
	
	// NSAssert([self.colors count] == 120, @"Expected 120 colors for drawing");
	NSRect bds = [self bounds];
	NSRect paddedBds = NSInsetRect(bds, kColorPickerPadding, kColorPickerPadding);
	// background fill
	NSGradient *background = [NSGradient.alloc initWithStartingColor:BLACK endingColor:GRAY4];
	
	[background drawInRect:paddedBds angle:90.];
	// inset effect (shade the top, highlight the bottom)
	for ( NSInteger j = 0; j < 10; j++ ) {
		for ( NSInteger i = 0; i < 12; i++ ) {
			if ( j*12+i >= [self.colors count] ) break;
			NSRectFillWithColor([self frameForAreaAtRow:i column:j],[self.colors objectAtIndex:j*12+i]);
		}
	}
	// no color option: enabled or disabled
	// strike it out faded or full
	NSRect area = [self frameForAreaAtRow:0 column:0];
	NSColor *strikeColor = [NSColor colorWithCalibratedRed:1. green:0. blue:0. alpha:1];//
	//													 alpha:(self.canRemoveColor?1.:.5)];
	NSBezierPath *line = [NSBezierPath bezierPath];
	[line moveToPoint:NSMakePoint(NSMaxX(area),NSMinY(area))];
	[line lineToPoint:NSMakePoint(NSMinX(area),NSMaxY(area))];
	[line setLineWidth:1.];
	[strikeColor set];
	[line stroke];
	// frame
	[[NSColor colorWithCalibratedWhite:0.4 alpha:1.0] set];
	NSFrameRect(paddedBds);
	// selection
	// do not draw at 0 index if canRemoveColor = NO
	/*	if ( [self.selectionIndex count] == 1 && ( [self.selectionIndex firstIndex] > 0 || self.canRemoveColor == YES ) ) {
	 NSInteger index = [self.selectionIndex firstIndex];
	 NSInteger col 	= floor(index / 12);
	 NSInteger row 	= floor(index % 12);
	 NSRect area 	= [self frameForAreaAtRow:row column:col];
	 NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSInsetRect(area, -1, -1)];
	 // the selection color depends on the color at the index
	 NSColor *selectionColor = [self selectionColorForAreaColor:[self.colors
	 objectAtIndex:[self.selectionIndex firstIndex]]];
	 
	 [selectionColor set];
	 [path setLineWidth:2.];
	 [path stroke];
	 }
	 */
}
- (NSColor*) selectionColorForAreaColor:(NSColor*)aColor	{
	
	static CGFloat kColorLimit = 144.; // adjust to preference
	NSC *rgbColor = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	if ( !rgbColor ) return WHITE;
	CGFloat red, green, blue, alpha;
	[rgbColor getRed:&red green:&green blue:&blue alpha:&alpha];
	// given RGB values all approaching white, invert the selection color
	if ( red >= kColorLimit/255. && blue >= kColorLimit/255. && green >= kColorLimit/255. )
		return GRAY1;
	return WHITE;
	NSLog(@"%@",rgbColor);
	return nil;
}
-   (NSRect) frameForAreaAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex	{
	
	CGFloat rowWidth 	= floor ( ( NSWidth ([self bounds]) - 12) / 12 );
	CGFloat rowHeight	= floor ( ( NSHeight([self bounds]) - 10) / 10 );
	NSRect area = NSMakeRect(kColorPickerPadding + rowIndex*rowWidth + rowIndex,
									 kColorPickerPadding + columnIndex*rowHeight + columnIndex, rowWidth, rowHeight);
	return area;
}
+   (NSSize) proposedFrameSizeForAreaDimension:(CGFloat)dimension	{
	
	// ideal frame width is factor of 12 + 12
	// ideal frame height is this factor + 10
	// eg 228x190 factor 18
	return NSMakeSize((dimension+1)*24+(kColorPickerPadding*2), (dimension+1)*20+(kColorPickerPadding*2));
}
-     (void) pushCurrentSelection {
	// remember the current selection
	_originalSelection = nil;
	_originalSelection = self.selectionIndex;
}
-     (void) popCurrentSelection {
	self.selectionIndex = _originalSelection;
	[self setNeedsDisplay:YES];
}

// See sample code CustomMenus. One tracking area for every subsection in the view. It seems that mouseEntered and -Exited events don't register with NSTrackingEnabledDuringMouseDrag when NSTrackingMouseMoved is also specified, but mouseMoved events don't register with just NSTrackingEnabledDuringMouseDrag, at least in a popup menu.
- (void) updateTrackingAreas {
	
	for ( NSTrackingArea *anArea in self.trackingAreas ) [self removeTrackingArea:anArea];
	[[self mutableArrayValueForKey:@"trackingAreas"] removeAllObjects];
	for (NSInteger index = 0; index < self.colors.count; index++) {
		NSTrackingArea *trackingArea = [self trackingAreaForIndex:index];
		[[self mutableArrayValueForKey:@"trackingAreas"] addObject:trackingArea];
		[self addTrackingArea: trackingArea];
	}
	
}
- (NSTrackingArea*) trackingAreaForIndex:(NSInteger)index {
	
	NSDictionary *trackerData = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:index], kTrackerKey, nil];
	NSInteger col = floor(index / 12);
	NSInteger row = floor(index % 12);
	
	// Expand the drawing area rect by a single pixel to the right and down,
	// taking into acount the dividing line between each color box
	
	NSRect trackingRect = [self frameForAreaAtRow:row column:col];
	trackingRect.size.width+=1, trackingRect.size.height+=1;
	
	NSTrackingAreaOptions trackingOptions = NSTrackingEnabledDuringMouseDrag | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
	NSTrackingArea *trackingArea = [NSTrackingArea.alloc initWithRect:trackingRect
																					options:trackingOptions owner:self userInfo:trackerData];
	
	return trackingArea;
}
- (void) mouseEntered:(NSEvent *)theEvent	{
	
	// on the first mouse entered message, we must also clear the old selection area
	// mark the view as needing display in the old selection area
	if ( self.selectionIndex.count > 0 ) {
		NSInteger col = floor([self.selectionIndex firstIndex] / 12);
		NSInteger row = floor([self.selectionIndex firstIndex] % 12);
		[self setNeedsDisplayInRect:NSInsetRect([self frameForAreaAtRow:row column:col], -3, -3)];
	}
	// new selection index
	self.selectionIndex = [NSIndexSet indexSetWithIndex:[[(NSDictionary*)[theEvent userData]
																			objectForKey:kTrackerKey] integerValue]];
	
	// mark the receiver as needing display in the new selection area
	NSInteger col = floor([self.selectionIndex firstIndex] / 12);
	NSInteger row = floor([self.selectionIndex firstIndex] % 12);
	[self setNeedsDisplayInRect:NSInsetRect([self frameForAreaAtRow:row column:col], -3, -3)];
}
- (void) mouseExited:(NSEvent *)theEvent {
	//NSLog(@"%s",__PRETTY_FUNCTION__);
	// when the cursor completely leaves the view, we need to reset to the original value
	// this is handled by the enclosing color well menu view; don't like that coupling,
	// would rather handle it here
	//  self.selectionIndex = [NSIndexSet indexSet];
}
- (void) mouseUp:(NSEvent*)event {	[self sendAction];	}
- (void) sendAction	{
	
	
	// The action depends on the selection. At index 0 we want to remove the color, which requires a separate action
	
	if ( [self.selectionIndex count] > 0 ) {
		if ( [self.selectionIndex firstIndex] > 0 ) {
			// Send the action set on the actualMenuItem to the target set on the actualMenuItem, and make come from the actualMenuItem.
			if ([self.target respondsToSelector:self.action])
				SuppressPerformSelectorLeakWarning([self.target performSelector:self.action withObject:self]);
			//				WithoutWarnings:];
		}
		//		else if ( self.canRemoveColor )
		// separate action for remove color
		//			if ([self.removeColorTarget respondsToSelector:self.removeColorAction])
		//				SuppressPerformSelectorLeakWarning([self.removeColorTarget performSelector:self.removeColorAction withObject:self]);
	}
	
	// dismiss the menu being tracked
	NSMenuItem *actualMenuItem = [self enclosingMenuItem];
	NSMenu *menu = [actualMenuItem menu];
	[menu cancelTracking];
	[self setNeedsDisplay:YES];
}
- (NSColor*) color {
	return self.selectionIndex.count == 0 ? nil : [self.colors objectAtIndex:[self.selectionIndex firstIndex]];
}
- (void) takeColorFrom:(id)sender {
	if ([sender respondsToSelector: @selector(color)]) [self updateSelectionIndexWithColor:[sender color]];
}
- (BOOL) updateSelectionIndexWithColor:(NSColor*)aColor {
	
	// try equalivency comparison first
	NSI		  index = [self.colors indexOfObject:aColor];
	NSIS *newSelection = index == NSNotFound ? [NSIS indexSet] : [NSIS indexSetWithIndex:index];
	
	// "identical" colors in different color spaces will not be equal so compare in shared color space black in NSCalibratedWhiteColorSpace != black in NSCalibratedRGBColorSpace
	if ( newSelection.count == 0 ) {
		NSInteger i = 0;
		for ( NSColor *indexColor in self.colors ) {
			if ( [indexColor isEqualToColor:aColor colorSpace:NSCalibratedRGBColorSpace] ) {
				newSelection = [NSIndexSet indexSetWithIndex:i];
				break;
			} i++;
		}
	}
	
	[self setSelectionIndex:newSelection];
	[self setNeedsDisplay:YES];
	return (BOOL)[newSelection count];
}
@end

static NSString *kColorWellMenuViewTrackerKey = @"SPColorWellMenuViewTrackerKey";
static NSInteger kColorPickerView 			  = 0;
static NSInteger kHighlightView 			  = 1;

@class HighlightingView;
@interface AtoZColorWellMenuView()
- (NSTA*) trackingAreaForView:(NSV*)aView identifier:(NSI)viewId;
- (void) sendShowColorsAction;
@end

@implementation AtoZColorWellMenuView
@synthesize showColorsView, colorPickerView, colorWell;

- (void) dealloc	{
	
	_colorPickerTrackingArea 	= nil;
	_highlightTrackingArea 		= nil;
}
- (void) drawRect:(NSRect)dirtyRect	{ }
- (void) updateTrackingAreas	{
	
	if ( _highlightTrackingArea   ) { [self removeTrackingArea:_highlightTrackingArea  ]; _highlightTrackingArea = nil;   }
	if ( _colorPickerTrackingArea ) { [self removeTrackingArea:_colorPickerTrackingArea]; _colorPickerTrackingArea = nil; }
	_highlightTrackingArea   = [self trackingAreaForView:showColorsView identifier:kHighlightView];
	_colorPickerTrackingArea = [self trackingAreaForView:colorPickerView identifier:kColorPickerView];
	[@[_highlightTrackingArea, _colorPickerTrackingArea] do:^(id obj) { [self addTrackingArea:obj]; }];
}
- (NSTA*) trackingAreaForView:(NSV*)aView identifier:(NSI)viewId	{
	
	return [NSTrackingArea.alloc initWithRect:aView.frame options:NSTrackingEnabledDuringMouseDrag | NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
													  owner:self	   userInfo:@{ kColorWellMenuViewTrackerKey : @(viewId) }];
	
}
- (void) mouseEntered:(NSEvent *)theEvent	{
	
	// on the first mouse entered message, we must also clear the old selection area
	NSI view  = [(NSD*)[theEvent userData]integerForKey:kColorWellMenuViewTrackerKey];
	if ( view == kHighlightView ) self.showColorsView.highlighted = YES;
	else if ( view == kColorPickerView )
		// retain the original color selection - do this when the menu is popped
		[self.colorPickerView pushCurrentSelection];
	
}
- (void) mouseExited:(NSEvent *)theEvent	{
	
	NSI v = [(NSD*)[theEvent userData] integerForKey:kColorWellMenuViewTrackerKey];
	v == kHighlightView   ?  self.showColorsView.highlighted = NO
	:   v == kColorPickerView ? [self.colorPickerView popCurrentSelection] : nil;		// reset the color selection to the original color
}
- (void) mouseUp:(NSEvent*)theEvent	{
	
	// if we're inside the highlight view, send the Show Colors menu action
	[self mouse:[self convertPoint:[theEvent locationInWindow] fromView:nil] inRect:self.showColorsView.frame]
	? [self sendShowColorsAction] : nil;
}
- (void) sendShowColorsAction {
	
	// I prefer to decouple this and send the message to the color well itself.  By activating the color well we allow the color well to handle a great deal of the coordinating logic between the well and the color panel, including when it is dismissed or when a different color well becomes active
	
	[self.colorWell activate:NO]; 								// YES for exclusivity
	[NSApp orderFrontColorPanel:self.colorWell];
	NSMenuItem *actualMenuItem 	= [self enclosingMenuItem];	 // dismiss the menu being tracked
	NSMenu *menu 				= [actualMenuItem menu];
	[menu cancelTracking];
	[self setNeedsDisplay:YES];
}

@end
