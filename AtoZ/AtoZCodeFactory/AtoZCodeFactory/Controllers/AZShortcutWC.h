//

#import "AZShortcutManager.h"
#import "AZShortcut.h"

@interface AZShortcutWC : NSWindowController <NSTableViewDelegate,NSControlTextEditingDelegate>

@property (nonatomic, strong) AZShortcutManager *shortcutManager;
@property (nonatomic, strong) AZShortcut 			*selectedShortcut;
@property (nonatomic, strong) NSFont 				*contentsFont;
@property (nonatomic, retain) NSPredicate 		*filterPredicate;
@property (nonatomic, retain) NSArray 				*sortDescriptors;


- (id)initWithBundle:(NSBundle *)bundle;
- (IBAction)addShortcut:(id)sender;
- (IBAction)deleteSelectedShortcut:(id)sender;

@end
