//
//  NSColor+ColorPickerPopover.h
//  CocosGame

/*
	- (void)awakeFromNib {
	//	[[BFColorPickerPopover sharedPopover] setAnimates:NO];
	for (NSColorWell *well in @[colorWell1, colorWell2, colorWell3, colorWell4, colorWell5, colorWell6, colorWell7, colorWell8])
		well.color = [NSColor randomColor];
		}
- (IBAction)buttonClicked:(id)sender {
	[[BFColorPickerPopover sharedPopover] showRelativeToRect:button.frame ofView:button.superview preferredEdge:NSMinYEdge];
	[[BFColorPickerPopover sharedPopover] setTarget:self];
	[[BFColorPickerPopover sharedPopover] setAction:@selector(colorChanged:)];
	[[BFColorPickerPopover sharedPopover] setColor:backgroundView.backgroundColor];
}
- (void)colorChanged:(id)sender {
	backgroundView.backgroundColor = [BFColorPickerPopover sharedPopover].color;
}
- (IBAction)animateCheckClicked:(id)sender {
	[[BFColorPickerPopover sharedPopover] setAnimates:(animateCheckmark.state == NSOnState)];
}
- (IBAction)usePanelCheckmarkClicked:(id)sender {
	for (BFPopoverColorWell *well in @[colorWell1, colorWell2, colorWell3, colorWell4]) {
		well.useColorPanelIfAvailable = (usePanelCheckmark.state == NSOnState);
	}
}
*/
#import <Cocoa/Cocoa.h>

#define kBFColorPickerPopoverMinimumDragDistance 50.0f
@class BFIconTabBar, BFIconTabBarItem;
@protocol BFIconTabBarDelegate <NSObject>
- (void)tabBarChangedSelection:(BFIconTabBar *)tabbar;
@end
@interface BFIconTabBar : NSControl
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) BOOL multipleSelection;
@property (nonatomic, unsafe_unretained) IBOutlet id<BFIconTabBarDelegate> delegate;
@property (readonly)	BFIconTabBarItem *selectedItem;
@property (readonly) NSInteger selectedIndex;
@property (readonly) NSArray *selectedItems;
@property (readonly) NSIndexSet *selectedIndexes;
- (IBAction)selectAll;
- (void)selectIndex:(NSUInteger)index;
- (void)selectItem:(BFIconTabBarItem *)item;
- (void)selectIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extending;
- (IBAction)deselectAll;
- (void)deselectIndex:(NSUInteger)index;
- (void)deselectIndexes:(NSIndexSet *)indexes;
@end
@interface BFIconTabBarItem : NSObject
@property (nonatomic,strong) 	NSImage *icon;
@property (nonatomic,copy) 	NSString *tooltip;
@property (nonatomic,unsafe_unretained) BFIconTabBar *tabBar;
- (id)initWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString;
+ (BFIconTabBarItem *)itemWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString;
@end
@interface NSColor (BFColorPickerPopover)
- (CGColorRef)copyCGColor;
+ (NSColor*)randomColor;
@end
@interface NSColorPanel (BFColorPickerPopover)
- (void)	disablePanel;
- (void)	enablePanel;
+ (NSString*) color;
@end
@interface NSColorWell (BFColorPickerPopover)
+ (void)deactivateAll;
+ (NSColorWell *)hiddenWell;
- (void)_performActivationClickWithShiftDown:(BOOL)shift;
@end
@interface BFColorPickerPopoverView : NSView
@end
@interface BFColorPickerPopover : NSPopover
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;
@property (nonatomic, weak) NSColor *color;
+ (BFColorPickerPopover *)sharedPopover;
@end
@interface BFPopoverColorWell : NSColorWell <NSPopoverDelegate>
@property (nonatomic) NSRectEdge preferredEdgeForPopover;
@property (nonatomic) BOOL useColorPanelIfAvailable;
@end
@interface BFColorPickerViewController : NSViewController <BFIconTabBarDelegate>
@property (nonatomic, assign) NSColorPanel *colorPanel;
@end
