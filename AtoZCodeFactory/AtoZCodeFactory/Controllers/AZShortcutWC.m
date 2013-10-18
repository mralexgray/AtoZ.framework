

#import "AZShortcutWC.h"
#import "NSNib+XMLBase64.h"
//#import <AtoZ/AtoZ.h>

static int ShortcutKVOContext;
static NSString *const SEARCH_PREDICATE_FORMAT = @"(title contains[cd] %@ OR summary contains[cd] %@ OR shortcut contains[cd] %@)";

@implementation AZShortcutWC

- (id)init {  //WithBundle:(NSBundle *)bundle {
   if (self != [super init] ) return nil;

		AZMacro *d = [AZMacro.alloc initWithPlistURL:[NSURL URLWithString:@"/Users/localadmin/Library/Developer/Xcode/UserData/CodeSnippets/7FEA4C5B-18AD-4AC3-8218-6BDAB98FA082.codesnippet"]];
//		NSLog(@"d: %@",[d.propertyNames reduce:@"" withBlock:^id(id sum, id obj) {
//			return [[sum stringByAppendingFormat:@"%@",[d vFK:obj]] withString:zNL];
//		}]);

//	NSArray *tops;

//	NSData *s = [NSData dataWithContentsOfFile:@"/Volumes/2T/ServiceData/AtoZ.framework/AtoZ/AtoZCodeFactory/AtoZCodeFactory/SomeNib.xml" ];

//	NSString *st = s.base64EncodedString;// [NSString.alloc initWithData:s encoding:NSUTF8StringEncoding];

//	NSLog(@"Base 64 length %@", @(s.length));
//	NSData *d = [NSData dataFromBase64String:st];
//	NSString *xml = [NSString.alloc initWithData:d encoding:NSUTF8StringEncoding];
//	NSLog(@"XML length.. %@",@(xml.length));
//	NSString *save = @"/Volumes/2T/ServiceData/AtoZ.framework/AtoZ/AtoZCodeFactory/AtoZCodeFactory/SomeNib.base64.text" ;
//	[st writeToFile:save atomically:YES encoding:NSUTF8StringEncoding error:nil];
//	[NSWorkspace.sharedWorkspace openFile:save withApplication:@"TextMate"];

	NSData *s = [NSData dataFromInfoKey:@"Base64Nib"];
	NSString *xml = [NSString.alloc initWithData:s encoding:NSUTF8StringEncoding];
	NSLog(@"XML length.. %@",@(xml.length));
	NSArray *objs;
	NSNib *n = [NSNib.alloc initWithNibData:s bundle:nil];
	[n instantiateWithOwner:self topLevelObjects:&objs];
    NSPredicate *windowPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject class] == [NSWindow class];
    }];

    self.window = [objs filteredArrayUsingPredicate:windowPredicate][0];
	[self.window makeKeyAndOrderFront:self];
	// initWithData:[NSData dataFromBase64String:s] encoding:NSUTF8StringEncoding]);
//	[NSNib nibFromXMLPath:(NSString*)s owner:(id)owner topObjects:(NSArray**)objs {

	_filterPredicate = [NSPredicate predicateWithValue:YES];
	_sortDescriptors = @[[NSSortDescriptor.alloc initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	_contentsFont = [NSFont fontWithName:@"Menlo" size:14];
	self.window = [objs filteredArrayUsingPredicate:windowPredicate][0];
	self.shortcutManager = AZMacroManager.new;
	NSLog(@"%@",self.shortcutManager.shortcuts);
//	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(shortcutWillBeDeleted:) name:@"me.delisa.Attica.shortcut-deletion" object:nil];
	return self;
}

- (IBAction)addShortcut:(id)sender {
	self.selectedShortcut = [self.shortcutManager createShortcut];
//	[_arrayController insertObject:self.selectedShortcut atArrangedObjectIndex:0];
//	_arrayController.selectionIndexes = [NSIndexSet indexSetWithIndex:0];
}

- (IBAction)deleteSelectedShortcut:(id)sender {
//	[_shortcutManager deleteShortcut:_selectedShortcut] ? [_arrayController removeObject:_selectedShortcut] : nil;
}

- (void)setSelectedShortcut:(AZMacro *)selectedShortcut {
	if (_selectedShortcut != selectedShortcut) {
		[_selectedShortcut removeObserver:self forKeyPath:@"uuid" context:&ShortcutKVOContext];
		_selectedShortcut = selectedShortcut;
		[_selectedShortcut addObserver:self forKeyPath:@"uuid" options:0 context:&ShortcutKVOContext];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

	self.selectedShortcut = [[self.shortcutManager.shortcuts.childNodes filteredArrayUsingPredicate:self.filterPredicate] sortedArrayUsingDescriptors:self.sortDescriptors][((NSTableView*)notification.object).selectedRow];
}

- (void)controlTextDidChange:(NSNotification *)notification {
	NSSearchField *searchField = [notification object];
	NSString *searchText = searchField.stringValue;
	self.filterPredicate  = searchText.length > 0
	?	[NSPredicate predicateWithFormat:SEARCH_PREDICATE_FORMAT, searchText, searchText, searchText]
	: 	[NSPredicate predicateWithValue:YES];
}

#pragma mark - Private

- (void) shortcutWillBeDeleted:(NSNotification *)notification {
	if (notification.object == self.selectedShortcut) {
		[notification.object removeObserver:self forKeyPath:@"uuid" context:&ShortcutKVOContext];
		self.selectedShortcut = nil;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[(AZMacro*)object persistChanges];
}

//- (NSWindow *)mainWindowInBundle:(NSBundle *)bundle {
//	NSArray *nibElements;
//	[bundle loadNibNamed:@"MainWindow" owner:self topLevelObjects:&nibElements];
//	NSPredicate *windowPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//		return [evaluatedObject class] == [NSWindow class];
//	}];
//
//	return [nibElements filteredArrayUsingPredicate:windowPredicate][0];
//}

@end
 