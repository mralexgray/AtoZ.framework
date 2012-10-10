
#import <Cocoa/Cocoa.h>

@interface NSTableView (NUExtensions)

- (NSTableRowView*) firstMatchingRowView:(BOOL(^)(NSTableRowView *rowView))test;
- (NSTableCellView*) firstMatchingCellView:(BOOL(^)(NSTableRowView *rowView, NSTableCellView *cellView))test;

@end
