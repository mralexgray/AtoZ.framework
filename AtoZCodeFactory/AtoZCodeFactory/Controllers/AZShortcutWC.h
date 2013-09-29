//

#import "AZMacroManager.h"
#import "AZMacro.h"

@interface AZShortcutWC : NSWindowController
								< NSTableViewDelegate,
								  NSControlTextEditingDelegate >

@property (nonatomic, strong) AZMacroManager *shortcutManager;
@property (nonatomic, strong) AZMacro 			*selectedShortcut;
@property (nonatomic, strong) NSFont 				*contentsFont;
@property (nonatomic, retain) NSPredicate 		*filterPredicate;
@property (nonatomic, retain) NSArray 				*sortDescriptors;

//- (id)initWithBundle:(NSBundle *)bundle;
- (IBAction)addShortcut:(id)sender;
- (IBAction)deleteSelectedShortcut:(id)sender;

@end
