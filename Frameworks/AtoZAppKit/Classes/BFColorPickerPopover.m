//
//  NSColor+ColorPickerPopover.m
//  CocosGame
#import "BFColorPickerPopover.h"
#import <objc/runtime.h>
@implementation NSColor (BFColorPickerPopover)

- (CGColorRef)copyCGColor{
	NSColor *colorRGB = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat components[4];
	[colorRGB getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
	CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef theColor = CGColorCreate(theColorSpace, components);
	CGColorSpaceRelease(theColorSpace);
	return theColor;
}

//+ (NSColor *)randomColor {
//	return [NSColor colorWithCalibratedRed:(float)random()/RAND_MAX green:(float) random()/RAND_MAX blue:(float) random()/RAND_MAX alpha:1.0f];
//}
@end
static BOOL colorPanelEnabled = YES;
@interface BFColorPickerPopover ()
- (void)closeAndDeactivateColorWell:(BOOL)deactivate removeTarget:(BOOL)remove removeObserver:(BOOL)removeObserver;
@property (nonatomic) 		NSColorPanel *colorPanel;
@property (nonatomic,weak) NSColorWell *colorWell;
@end
@implementation NSColorPanel (BFColorPickerPopover)
- (void)disablePanel 		{		  colorPanelEnabled = NO;		}
- (void)enablePanel 			{		  colorPanelEnabled = YES;	}
- (void)orderFront:(id)s 	{	if (!colorPanelEnabled) return;	NSColorPanel *panel = [BFColorPickerPopover sharedPopover].colorPanel; if (!panel) return;
																			 self.contentView = panel.contentView;		[super orderFront:s];
}
+ (NSString *)color {
	NSColor *color = NSColorPanel.sharedColorPanel.color;
	return [NSString stringWithFormat:@"r:%i, g:%i, b:%i, a:%i",	(int)roundf(color.redComponent	*255), (int)roundf(color.greenComponent	*255),
																					  	(int)roundf(color.blueComponent	*255), (int)roundf(color.alphaComponent	*255)];
}
@end
static NSColorWell *hiddenWell = nil;
@implementation NSColorWell (BFColorPickerPopover)
+ (void)deactivateAll {
	[NSColorPanel.sharedColorPanel disablePanel];
	hiddenWell = NSColorWell.new;
	hiddenWell.color = [NSColor colorWithCalibratedRed:1/255.0 green:2/255.0 blue:3/255.0 alpha:1];
	[hiddenWell activate:YES];
	[hiddenWell deactivate];
	[NSColorPanel.sharedColorPanel enablePanel];
}
+ (NSColorWell *)hiddenWell {	return hiddenWell;	}
- (void)_performActivationClickWithShiftDown:(BOOL)shift {
	if (!self.isActive) {
		BFColorPickerPopover *popover = BFColorPickerPopover.sharedPopover;
		if (popover.isShown) {
			BOOL animatesBackup = popover.animates;
			popover.animates = NO;
			[popover close];
			popover.animates = animatesBackup;
		}
		[BFColorPickerPopover sharedPopover].target = nil;
		[BFColorPickerPopover sharedPopover].action = NULL;
		[self activate:!shift];
	} else
		[self deactivate];
}
@end

@implementation BFIconTabBar {
	NSMutableIndexSet *_selectedIndexes;
	BFIconTabBarItem *_pressedItem;
	BOOL _firstItemWasSelected, _dragging;
}
#pragma mark - Initialization & Destruction
- (id)initWithFrame:(NSRect)frame
{
	if (self != [super initWithFrame:frame]) return  nil;
	_dragging  = _multipleSelection = NO;
	_itemWidth 	= 32.0f;
	_selectedIndexes = NSMutableIndexSet.new;
	_items = NSMutableArray.new;
	return self;
}

#pragma mark - Convenience Methods
// x coordinate of the first item.
- (CGFloat)startX { return (self.bounds.size.width - (self.items.count * _itemWidth)) / 2.0f; }

- (BFIconTabBarItem *)itemAtX:(CGFloat)x {	NSInteger index = floor((x - self.startX) / _itemWidth);
	return index >= 0 && index < self.items.count ? self.items[index] : nil;
}
#pragma mark - Getters & Setters
- (void)setItems:(NSArray *)newItems {	if (newItems != _items) {
		_items = newItems.mutableCopy;
		for (BFIconTabBarItem *item in _items) item.tabBar = self;
		if ([_selectedIndexes count] < 1) [_selectedIndexes addIndex:0];
		[self setNeedsDisplay];
	}
}
#pragma mark - Selection
- (BFIconTabBarItem *)selectedItem { return  _selectedIndexes.count ? _items[_selectedIndexes.firstIndex] : nil; }
- (NSInteger)selectedIndex {	return _selectedIndexes.count < 1 ? -1 : (NSInteger)[_selectedIndexes firstIndex];	}
- (NSArray *)selectedItems { return _selectedIndexes.count ? [_items objectsAtIndexes:_selectedIndexes] : nil; }
- (NSIndexSet *)selectedIndexes {	return [NSIndexSet.alloc initWithIndexSet:_selectedIndexes]; }
- (void)setMultipleSelection:(BOOL)multiple {
	if (multiple != _multipleSelection) {
		_multipleSelection = multiple;
		if (!_multipleSelection && [_selectedIndexes count] > 1) {
			NSUInteger firstIndex = [_selectedIndexes firstIndex];
			[_selectedIndexes removeAllIndexes];
			[_selectedIndexes addIndex:firstIndex];
			[self setNeedsDisplay];
		}
	}
}
- (void)selectIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extending {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Selection indexset empty.");
		return;
	}
	if (!extending || !_multipleSelection) {
		[self deselectAll];
	}
	if (_multipleSelection) {
		[_selectedIndexes addIndexes:indexes];
	} else {
		[_selectedIndexes addIndex:[indexes firstIndex]];
	}
	[self setNeedsDisplay];
}
- (void)selectIndex:(NSUInteger)index {
	[self selectIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:YES];
}
- (void)selectItem:(BFIconTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self selectIndex:index];
	}
}
- (IBAction)selectAll {
	[_selectedIndexes addIndexesInRange:(NSRange){0, [_items count] - 1}];
	[self setNeedsDisplay];
}
- (void)deselectIndexes:(NSIndexSet *)indexes {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Deselection indexset empty.");
		return;
	}
	[_selectedIndexes removeIndexes:indexes];
	[self setNeedsDisplay];
}
- (void)deselectIndex:(NSUInteger)index {
	[self deselectIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)deselectItem:(BFIconTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self deselectIndex:index];
	}
}
- (IBAction)deselectAll {
	[_selectedIndexes removeAllIndexes];
	[self setNeedsDisplay];
}
#pragma mark - Drawing
- (void)drawRect:(NSRect)dirtyRect
{
	//// Color Declarations
	NSColor* selectionGradientTop = [NSColor colorWithDeviceWhite:0.99 alpha:1.0];
	NSColor* selectionGradientBottom = [NSColor colorWithDeviceWhite:0.99 alpha:1.0];
	NSColor* lineColor = [NSColor colorWithDeviceWhite:0.7 alpha:1.0];
	//	if (![[self window] isKeyWindow])
	//	{
	//		selectionGradientTop = [NSColor colorWithCalibratedRed:0.961 green:0.961 blue:0.961 alpha:1.000];
	//		selectionGradientBottom = [NSColor colorWithCalibratedRed:0.855 green:0.855 blue:0.855 alpha:1.000];
	//		lineColor = [NSColor colorWithCalibratedRed:0.537 green:0.537 blue:0.537 alpha:1.000];
	//	}
	//// Prepare selection border gradients.
	//// Color Declarations
	NSColor* gradientOutsideTop = [NSColor colorWithDeviceWhite:0.9 alpha:1.0];
	NSColor* gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.6 alpha:1.0];
	NSColor* gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.8 alpha:1.0];
	NSColor* gradientInsideTop = selectionGradientTop;
	NSColor* gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.7 alpha:1.0];
	NSColor* gradientInsideBottom = selectionGradientBottom;
	NSColor* selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.8 alpha:1.0];
	if (![self.window isKeyWindow]) {
		gradientOutsideTop = [NSColor colorWithDeviceWhite:0.83 alpha:1.0];
		gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.43 alpha:1.0];
		gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.79 alpha:1.0];
	}
	NSGradient* selectionGradient = [[NSGradient alloc] initWithColorsAndLocations:
												selectionGradientTop, 0.0,
												selectionGradientMiddle, 0.50,
												selectionGradientBottom, 1.0, nil];
	NSGradient* gradientOutside = [[NSGradient alloc] initWithColorsAndLocations:
											 gradientOutsideTop, 0.0,
											 gradientOutsideMiddle, 0.50,
											 gradientOutsideBottom, 1.0, nil];
	NSGradient* gradientInside = [[NSGradient alloc] initWithColorsAndLocations:
											gradientInsideTop, 0.0,
											gradientInsideMiddle, 0.50,
											gradientInsideBottom, 1.0, nil];

	CGFloat startX = [self startX];
	[self removeAllToolTips];
	for (NSUInteger i = 0; i < [_items count]; i++) {
		BFIconTabBarItem *item = [_items objectAtIndex:i];
		CGFloat currentX = startX + i * _itemWidth;
		// Add tooltip area.
		NSRect selectionFrame = NSMakeRect(floorf(currentX + 0.5), 1, _itemWidth, self.bounds.size.height - 2);
		[self addToolTipRect:selectionFrame owner:item.tooltip userData:nil];
		if ([_selectedIndexes containsIndex:i]) {
			//// Draw selection gradients
			CGFloat gradientHeight = self.bounds.size.height - 2;
			NSRect outsideLineFrameLeft = NSMakeRect(floorf(currentX + 0.5), 1, 1, gradientHeight);
			NSRect insideLineFrameLeft = NSMakeRect(floorf(currentX + 1.5), 1, 1, gradientHeight);
			NSRect outsideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth + 0.5), 1, 1, gradientHeight);
			NSRect insideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth - 0.5), 1, 1, gradientHeight);
			NSBezierPath* selectionFramePath = [NSBezierPath bezierPathWithRect: selectionFrame];
			[selectionGradient drawInBezierPath: selectionFramePath angle: -90];
			NSBezierPath* outsideLinePathLeft = [NSBezierPath bezierPathWithRect: outsideLineFrameLeft];
			[gradientOutside drawInBezierPath: outsideLinePathLeft angle: -90];
			NSBezierPath* insideLinePathLeft = [NSBezierPath bezierPathWithRect: insideLineFrameLeft];
			[gradientInside drawInBezierPath: insideLinePathLeft angle: -90];
			NSBezierPath* outsideLinePathRight = [NSBezierPath bezierPathWithRect: outsideLineFrameRight];
			[gradientOutside drawInBezierPath: outsideLinePathRight angle: -90];
			NSBezierPath* insideLinePathRight = [NSBezierPath bezierPathWithRect: insideLineFrameRight];
			[gradientInside drawInBezierPath: insideLinePathRight angle: -90];
		}
		// Draw icon
		CGPoint center = CGPointMake(currentX + _itemWidth / 2.0f, self.bounds.size.height / 2.0f);
		NSImage *embossedImage = item.icon;
		CGRect fromRect = CGRectMake(0.0f, 0.0f, embossedImage.size.width, embossedImage.size.height);
		CGPoint position = CGPointMake(roundf(center.x - embossedImage.size.width / 2.0f), roundf(center.y - embossedImage.size.height / 2.0f));
		[embossedImage drawAtPoint:position fromRect:fromRect operation:NSCompositeSourceOver fraction:1.0f];
	}

	//// Line Drawing
	NSBezierPath* line1 = [NSBezierPath bezierPath];
	[line1 moveToPoint: NSMakePoint(0.0, 0.5)];
	[line1 lineToPoint: NSMakePoint(self.bounds.size.width, 0.5)];
	[lineColor setStroke];
	[line1 setLineWidth: 1];
	[line1 stroke];
}
#pragma mark - Events
- (void)notify { if (self.action == NULL ||  self.target == nil) return;
	[NSApp sendAction:self.action to:self.target from:self];
	if ([_delegate respondsToSelector:@selector(tabBarChangedSelection:)]) [_delegate tabBarChangedSelection:self];
}
- (void)mouseDown:(NSEvent *)theEvent {
	CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	BFIconTabBarItem *item = [self itemAtX:point.x];
	if (item) {
		_dragging = YES;
		_pressedItem = item;
		if (_multipleSelection) {
			// Remember if the first clicked item was selected or deselected. Dragging onto other items will do the same operation, if multipleSelection is enabled.
			_firstItemWasSelected = ![[self selectedItems] containsObject:_pressedItem];
			if (_firstItemWasSelected) {
				[self selectItem:_pressedItem];
			} else {
				[self deselectItem:_pressedItem];
			}
		} else {
			[self selectItem:_pressedItem];
		}
		[self notify];
		[self setNeedsDisplay];
	} else {
		[super mouseDown:theEvent];
	}
}
- (void)mouseDragged:(NSEvent *)theEvent {
	if (_dragging) {
		CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		BFIconTabBarItem *item = [self itemAtX:point.x];
		if (item != _pressedItem) {
			_pressedItem = item;
			_multipleSelection && !_firstItemWasSelected ?	[self deselectItem:_pressedItem] : [self selectItem:_pressedItem];
			[self notify];
			[self setNeedsDisplay];
		}
	} else		[super mouseDragged:theEvent];
}
- (void)mouseUp:(NSEvent *)theEvent {
	if (_dragging) {
		_pressedItem = nil;
		_dragging = NO;
		[self setNeedsDisplay];
	} else		[super mouseUp:theEvent];
}
@end
#pragma mark - -
@implementation BFIconTabBarItem
#pragma mark - Initialization & Destruction
- (id)initWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
	if (!(self = [super init])) return nil;
	_icon = image;
	_tooltip = tooltipString;
	return self;
}
+ (BFIconTabBarItem *)itemWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
	return [[BFIconTabBarItem alloc] initWithIcon:image tooltip:tooltipString];
}
#pragma mark - Getters & Setters
- (void)setIcon:(NSImage *)newIcon {	if (newIcon != _icon) {		_icon = newIcon;		[_tabBar setNeedsDisplay];	}	}
@end

@interface BFPopoverColorWell ()
@property (nonatomic, weak) BFColorPickerPopover *popover;
@property (nonatomic, readwrite) BOOL isActive;
@end

@implementation BFPopoverColorWell

- (void)setup {
	self.preferredEdgeForPopover = NSMaxXEdge;
	self.useColorPanelIfAvailable = YES;
}

- (id)initWithCoder:(NSCoder *)coder	{	if (!(self = [super initWithCoder:coder])) return nil;	[self setup]; return self; }
- (id)initWithFrame:(NSRect)frame		{	if (!(self = [super initWithFrame:frame])) return nil;	[self setup]; return self; }

- (void)activateWithPopover {
	if (self.isActive) return;

	// Setup and show the popover.
	self.popover = [BFColorPickerPopover sharedPopover];
	self.popover.color = self.color;
	[self.popover showRelativeToRect:self.frame ofView:self.superview preferredEdge:self.preferredEdgeForPopover];
	self.popover.colorWell = self;

	// Disable the shared color panel, while the NSColorWell implementation is executed.
	// This is done by overriding the orderFront: method of NSColorPanel in a category.
	[[NSColorPanel sharedColorPanel] disablePanel];
	[super activate:YES];
	[[NSColorPanel sharedColorPanel] enablePanel];

	self.isActive = YES;
}

- (void)activate:(BOOL)exclusive {
	if (self.isActive) return;

	if (self.useColorPanelIfAvailable && [NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
		[super activate:exclusive];
		self.isActive = YES;
	} else {
		[self activateWithPopover];
	}
}

- (void)deactivate {
	if (!self.isActive) return;
	[super deactivate];
	self.popover.colorWell = nil;
	self.popover = nil;
	self.isActive = NO;
}

// Force using a popover (even if useColorPanelIfAvailable = YES), when the user double clicks the well.
- (void)mouseDown:(NSEvent *)theEvent {
	if([theEvent clickCount] == 2 && [NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
		[self deactivate];
		[self activateWithPopover];
	} else {
		[super mouseDown:theEvent];
	}

}

@end

@interface NSPopover (ColorPickerPopover)
- (BOOL)_delegatePopoverShouldClose:(id)sender;
@end

@implementation BFColorPickerPopover {
	NSColor *_color;
}
#pragma mark - Initialization & Destruction
+ (BFColorPickerPopover *)sharedPopover	{
	static BFColorPickerPopover *sharedPopover = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{		sharedPopover = BFColorPickerPopover.new; 	});
	return sharedPopover;
}
- (id)init	{ return self = [super init] ? self.behavior = NSPopoverBehaviorSemitransient, _color = [NSColor whiteColor], self : nil; }

#pragma mark - Getters & Setters
- (NSColorPanel *)colorPanel {	return ((BFColorPickerViewController *)self.contentViewController).colorPanel;	}
- (NSColor *)color {	return [self.colorPanel.color copy];		}
- (void)setColor:(NSColor *)color {	_color = [color copy];	if (self.isShown)		self.colorPanel.color = [color copy];	}
#pragma mark - Popover Lifecycle
- (void)showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {

	// Close the popover without an animation if it's already on screen.
	if (self.isShown) {
		id targetBackup = self.target;
		SEL actionBackup = self.action;
		BOOL animatesBackup = self.animates;
		self.animates = NO;
		[self close];
		self.animates = animatesBackup;
		self.target = targetBackup;
		self.action = actionBackup;
	}

	self.contentViewController = [[BFColorPickerViewController alloc] init];
	[super showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];

	self.colorPanel.color = _color;
	[self.colorPanel addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:NULL];
}
// On pressing Esc, close the popover.
- (void)cancelOperation:(id)sender {
	[self close];
}
- (void)removeTargetAndAction {
	self.target = nil;
	self.action = nil;
}
- (void)deactivateColorWell {
	[self.colorWell deactivate];
	self.colorWell = nil;
}
- (void)closeAndDeactivateColorWell:(BOOL)deactivate removeTarget:(BOOL)removeTarget removeObserver:(BOOL)removeObserver {

	if (removeTarget) {
		[self removeTargetAndAction];
	}
	if (removeObserver) {
		[self.colorPanel removeObserver:self forKeyPath:@"color"];
	}

	// For some strange reason I couldn't figure out, the panel changes it's color when closed.
	// To fix this, I reset the color after it's closed.
	NSColor *backupColor = self.colorPanel.color;
	[super close];
	self.colorPanel.color = backupColor;

	if (deactivate) {
		[self deactivateColorWell];
	}
}
- (void)close {
	[self closeAndDeactivateColorWell:YES removeTarget:YES removeObserver:YES];
}
- (BOOL)_delegatePopoverShouldClose:(id)sender {
	if ([super _delegatePopoverShouldClose:sender]) {
		[self removeTargetAndAction];
		[self.colorPanel removeObserver:self forKeyPath:@"color"];
		[self deactivateColorWell];
		return YES;
	}
	return NO;
}
#pragma mark -	 Observation
// Notify the target when the color changes.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == self.colorPanel && [keyPath isEqualToString:@"color"]) {
		_color = self.colorPanel.color;
//		if (self.target && self.action && [self.target respondsToSelector:self.action]) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	 NSParameterAssert(self.target != nil);
	 NSParameterAssert(self.action != NULL);
    NSParameterAssert([self.target respondsToSelector:self.action]);

    NSMethodSignature* methodSig = [self.target methodSignatureForSelector:self.action];
    if(methodSig == nil) return;
    const char* retType = [methodSig methodReturnType];
    if(strcmp(retType, @encode(id)) == 0 || strcmp(retType, @encode(void)) == 0){
		 [self.target performSelector:self.action withObject:self];
    } else
        NSLog(@"-[%@ performSelector:@selector(%@)] shouldn't be used. The selector doesn't return an object or void", [self className], NSStringFromSelector(self.action));
#pragma clang diagnostic pop
	}
}
@end

static inline float pow2(float x) {return x*x;}
static inline NSString * NSStringFromNSEdgeInsets(NSEdgeInsets i) {return [NSString stringWithFormat:@"top: %f, left: %f, bottom: %f, right: %f", i.top, i.left, i.bottom, i.right];}
@interface BFColorPickerViewController ()
@property (nonatomic) BFIconTabBar *tabbar;
@property (nonatomic, weak) NSView *colorPanelView;
@end
@interface BFColorPickerPopoverView ()
@property (nonatomic) CGPoint originalWindowOrigin;
@property (nonatomic) CGPoint originalMouseOffset;
@property (nonatomic) BOOL dragging;
@end
@implementation BFColorPickerPopoverView
- (void)mouseDown:(NSEvent *)event {
	self.originalWindowOrigin = self.window.frame.origin;
	self.originalMouseOffset = [event locationInWindow];
	self.dragging = YES;
}
- (void)mouseDragged:(NSEvent *)event {
	if (self.dragging) {
		// Calculate the new window position.
		CGPoint currentMouseOffset = [event locationInWindow];
		CGPoint difference = CGPointMake(currentMouseOffset.x - self.originalMouseOffset.x,
													currentMouseOffset.y - self.originalMouseOffset.y);
		CGPoint currentWindowOrigin = self.window.frame.origin;
		CGPoint newWindowOrigin = CGPointMake(currentWindowOrigin.x + difference.x, currentWindowOrigin.y + difference.y);
		//		[self.window setFrameOrigin:newWindowOrigin];	// Use this to make the anchor fixed, even when moving the popover ...
		[self.window setFrame:(CGRect){newWindowOrigin, self.window.frame.size} display:YES animate:NO];   // ... instead of this
		// Hide the anchor if the popover has been dragged far enough for detachment.
		CGFloat distance = sqrt(pow2(self.originalWindowOrigin.x - currentWindowOrigin.x) + pow2(self.originalWindowOrigin.y - currentWindowOrigin.y));
		BOOL isFarEnough = (distance < kBFColorPickerPopoverMinimumDragDistance);
		[[BFColorPickerPopover sharedPopover] setValue:isFarEnough ? @0 : @1 forKey:@"shouldHideAnchor"];
	}
}
- (void)mouseUp:(NSEvent *)event {
	if (self.dragging) {
		CGPoint currentWindowOrigin = self.window.frame.origin;
		CGFloat distance = sqrt(pow2(self.originalWindowOrigin.x - currentWindowOrigin.x) + pow2(self.originalWindowOrigin.y - currentWindowOrigin.y));
		if (distance < kBFColorPickerPopoverMinimumDragDistance) {
			// If the popover isn't far enough for detachment, animate it back to it's original position.
			[self.window setFrame:(CGRect){self.originalWindowOrigin, self.window.frame.size} display:YES animate:YES];
		} else {
			// Otherwise calculate the right frame for the color panel (the content views' frames should be the same as in the popover) ...
			NSColorPanel *panel = [NSColorPanel sharedColorPanel];
			NSView *popoverView = [((BFColorPickerViewController *)[[BFColorPickerPopover sharedPopover] contentViewController]) colorPanelView];
			NSRect popoverViewFrameRelativeToWindow = [popoverView convertRect:popoverView.bounds toView:nil];
			NSRect popoverViewFrameRelativeToScreen = [popoverView.window convertRectToScreen:popoverViewFrameRelativeToWindow];
			// ... and switch from popover to panel.
			CGRect panelFrame = [panel frameRectForContentRect:popoverViewFrameRelativeToScreen];
			[panel setFrame:panelFrame display:YES];

			//			[self.window orderOut:self];
			[[BFColorPickerPopover sharedPopover] closeAndDeactivateColorWell:NO removeTarget:NO removeObserver:NO];
			//			[self.window orderOut:self];
			[panel orderFront:nil];
			//			panel.color = [BFColorPickerPopover sharedPopover].color;
		}
		[[BFColorPickerPopover sharedPopover] setValue:@0 forKey:@"shouldHideAnchor"];
		self.dragging = NO;
	}
	
}
@end

#define kColorPickerViewControllerTabbarHeight 30.0f
@implementation BFColorPickerViewController
- (void)loadView {
	CGFloat tabbarHeight = 34.0f;
	BFColorPickerPopoverView *view = [[BFColorPickerPopoverView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 400.0f)];
	self.view = view;
	// If the shared color panel is visible, close it, because we need to steal its views.
	if ([NSColorPanel sharedColorPanelExists] && [[NSColorPanel sharedColorPanel] isVisible]) {
		[[NSColorPanel sharedColorPanel] orderOut:self];
		[NSColorWell deactivateAll];
	}
	self.colorPanel = [NSColorPanel sharedColorPanel];
	self.colorPanel.showsAlpha = YES;
	// Steal the color panel's toolbar icons ...
	NSMutableArray *tabbarItems = [[NSMutableArray alloc] initWithCapacity:6];
	NSToolbar *toolbar = self.colorPanel.toolbar;
	NSUInteger selectedIndex = 0;
	for (NSUInteger i = 0; i < toolbar.items.count; i++) {
		NSToolbarItem *toolbarItem = toolbar.items[i];
		NSImage *image = toolbarItem.image;
		BFIconTabBarItem *tabbarItem = [[BFIconTabBarItem alloc] initWithIcon:image tooltip:toolbarItem.toolTip];
		[tabbarItems addObject:tabbarItem];
		if ([toolbarItem.itemIdentifier isEqualToString:toolbar.selectedItemIdentifier]) {
			selectedIndex = i;
		}
	}
	// ... and put them into a custom toolbar replica.
	self.tabbar = [[BFIconTabBar alloc] init];
	self.tabbar.delegate = self;
	self.tabbar.items = tabbarItems;
	self.tabbar.frame = CGRectMake(0.0f, view.bounds.size.height - tabbarHeight, view.bounds.size.width, tabbarHeight);
	self.tabbar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	[self.tabbar selectIndex:selectedIndex];
	[view addSubview:self.tabbar];
	// Add the color picker view.
	self.colorPanelView = self.colorPanel.contentView;
	self.colorPanelView.frame = CGRectMake(0.0f, 0.0f, view.bounds.size.width, view.bounds.size.height - tabbarHeight);
	self.colorPanelView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	[view addSubview:self.colorPanelView];
	// Find and remove the color swatch resize dimple, because it crashes if used outside of a panel.
	NSArray *panelSubviews = [NSArray arrayWithArray:self.colorPanelView.subviews];
	for (NSView *subview in panelSubviews) {
		if ([subview isKindOfClass:NSClassFromString(@"NSColorPanelResizeDimple")]) {
			[subview removeFromSuperview];
		}
	}
}
// Forward the selection action message to the color panel.
- (void)tabBarChangedSelection:(BFIconTabBar *)tabbar {
	if (tabbar.selectedIndex != -1)
	{
		NSToolbarItem *selectedItem = self.colorPanel.toolbar.items[(NSUInteger)tabbar.selectedIndex];
		SEL action = selectedItem.action;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self.colorPanel performSelector:action withObject:selectedItem];
#pragma clang diagnostic pop
	}
}
@end
