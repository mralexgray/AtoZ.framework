//
//  NSTableView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


// FIERCE, by AG.

#define BASICTABLEVIEWDRAGDROP(atKeypath,tableViewKey) \
\
//static NSS* dragTypeDeclaration = nil;												\
//+ (void) load { 	[$ swizzleMethod:@selector(awakeFromNib) with:@selector(swizzleawakeFromNib) in:self.class];	\
//						dragTypeDeclaration = @"com.mrgray.BASICTABLEVIEWDRAGDROP"; 											\
//} 																																					\
//- (void) swizzleawakeFromNib {  [self swizzleawakeFromNib]; 								\
//										  NSTV*t = [self valueForKeyOrKeyPath:tableViewKey]; 	\
//										  [t setDataSource:(id<NSTableViewDataSource>)self]; 	\
//										  [t registerForDraggedTypes:@[dragTypeDeclaration]]; \
//}\
//- (NSDO) tableView:(NSTV*)tV validateDrop:(IDDRAG)info proposedRow:(NSI)row proposedDropOperation:(NSTVDO)op	\
//{\
//	return NSDragOperationEvery/*op == NSTableViewDropAbove ? NSDragOperationEvery : NSDragOperationNone;	*/\
//}\
//- (BOOL) tableView:(NSTV*)tV acceptDrop:(IDDRAG)info row:(NSI)row dropOperation:(NSTVDO)op	{\
//	NSPasteboard* pboard 		= [info draggingPasteboard];\
//	NSData		* rowData 		= [pboard dataForType:dragTypeDeclaration];\
//	NSIS			* rowIndexes 	= [NSKeyedUnarchiver unarchiveObjectWithData:rowData];\
//	NSI dragRow 					= [rowIndexes firstIndex];\
//	[[self mutable:mutableObjectArrayKey] moveObjectAtIndex:dragRow toIndex:row];\
//	return YES;\
//}\
//- (BOOL) tableView:(NSTV*)tV writeRowsWithIndexes:(NSIS*)rowIdxs toPasteboard:(NSPB*)pb		{\
//	NSData 	*data = [NSKeyedArchiver archivedDataWithRootObject:rowIdxs];\
//	[pb declareTypes:@[dragTypeDeclaration] owner:self];\
//	[pb setData:data forType:dragTypeDeclaration];	return YES;	\
//}

@interface NSTableView (AtoZ)


- (void)selectItemsInArray:(NSA*)selectedItems usingSourceArray:(NSA*)sourceArray;
@end

