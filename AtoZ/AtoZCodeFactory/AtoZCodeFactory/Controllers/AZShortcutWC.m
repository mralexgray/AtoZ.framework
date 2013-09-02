

#import "AZShortcutWC.h"

static int ShortcutKVOContext;
static NSString *const SEARCH_PREDICATE_FORMAT = @"(title contains[cd] %@ OR summary contains[cd] %@ OR shortcut contains[cd] %@)";

@implementation AZShortcutWC { IBOutlet NSArrayController 	*_arrayController; }


- (id)init {  //WithBundle:(NSBundle *)bundle {
   if (self != [super init] ) return nil;

	NSString *f = @"/Volumes/2T/ServiceData/AtoZ.framework/AtoZ/AtoZCodeFactory/AtoZCodeFactory/SomeNib.xml";
	NSData *d = [NSData.alloc initWithContentsOfFile:f];

	NSNib *n = [NSNib.alloc initWithNibData:d bundle:nil];
	NSArray *tops;
	[n instantiateWithOwner:self topLevelObjects:&tops];
	NSPredicate *windowPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject class] == [NSWindow class];
	}];
	//	NSNib *mainNib = [[NSNib alloc] initWithContentsOfURL:[[NSURL URLWithString:@"../MainMenu.xib"] absoluteURL]];
	//	[NSNib instantiateNibWithOwner:application topLevelObjects:nil];

	_filterPredicate = [NSPredicate predicateWithValue:YES];
	_sortDescriptors = @[[NSSortDescriptor.alloc initWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	_contentsFont = [NSFont fontWithName:@"Menlo" size:14];
	self.window = [tops filteredArrayUsingPredicate:windowPredicate][0];
	_shortcutManager = AZShortcutManager.new;
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(shortcutWillBeDeleted:) name:@"me.delisa.Attica.shortcut-deletion" object:nil];
	return self;
}

- (IBAction)addShortcut:(id)sender {
	self.selectedShortcut = [self.shortcutManager createShortcut];
	[_arrayController insertObject:self.selectedShortcut atArrangedObjectIndex:0];
	_arrayController.selectionIndexes = [NSIndexSet indexSetWithIndex:0];
}

- (IBAction)deleteSelectedShortcut:(id)sender {
	[_shortcutManager deleteShortcut:_selectedShortcut] ? [_arrayController removeObject:_selectedShortcut] : nil;
}

- (void)setSelectedShortcut:(AZShortcut *)selectedShortcut {
	if (_selectedShortcut != selectedShortcut) {
		[_selectedShortcut removeObserver:self forKeyPath:@"uuid" context:&ShortcutKVOContext];
		_selectedShortcut = selectedShortcut;
		[_selectedShortcut addObserver:self forKeyPath:@"uuid" options:0 context:&ShortcutKVOContext];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

	self.selectedShortcut = [[self.shortcutManager.shortcuts filteredArrayUsingPredicate:self.filterPredicate] sortedArrayUsingDescriptors:self.sortDescriptors][((NSTableView*)notification.object).selectedRow];
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
	[(AZShortcut*)object persistChanges];
}

- (NSWindow *)mainWindowInBundle:(NSBundle *)bundle {
	NSArray *nibElements;
	[bundle loadNibNamed:@"MainWindow" owner:self topLevelObjects:&nibElements];
	NSPredicate *windowPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject class] == [NSWindow class];
	}];

	return [nibElements filteredArrayUsingPredicate:windowPredicate][0];
}

@end
