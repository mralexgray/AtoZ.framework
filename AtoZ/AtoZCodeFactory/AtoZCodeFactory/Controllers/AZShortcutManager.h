
#import <Foundation/Foundation.h>
#import "AZShortcut.h"

@interface AZShortcutManager : NSObject <NSFilePresenter>

@property (nonatomic,strong) 	NSMutableArray *shortcuts;
@property (readonly) 			NSURL				*shortcutDirectory;
- (AZShortcut*)createShortcut;
- (BOOL)deleteShortcut:(AZShortcut*)shortcut;

@end
