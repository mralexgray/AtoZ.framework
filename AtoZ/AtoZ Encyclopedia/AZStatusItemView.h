

@class  AZStatusItemView;
@protocol AZStatusItemDelegate <NSObject>
@optional
/*** Invoked when the cell at the given index was selected.  **/
- (void) tatusView:(AZStatusItemView *)statusItem isActive:(BOOL)active;
@end

@interface AZStatusItemView : NSView
@property (assign)  BOOL clicked;
/*** The delegate of the collection view.  **/
@property (nonatomic, unsafe_unretained) IBOutlet id <AZStatusItemDelegate> delegate;
@property (nonatomic, retain) NSProgressIndicator *indicator;
@end

@interface AZStatusItemController : NSObject
@property (strong) NSStatusItem *item;

- (id)initWithController:(id)controller;
- (NSMenu *)standardMenu;
@end

//- (id)initWithFrame:(NSRect)frame controller:(A*)controller;
//@property (retain) NSRunningApplication *currentApp;
//@property (nonatomic, retain) AZFile *file;
