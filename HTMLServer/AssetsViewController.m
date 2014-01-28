//
//  AssetsViewController.m
//  HTMLServer
//
//  Created by Alex Gray on 9/30/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import "AssetsViewController.h"

@interface AssetsViewController ()

@end

@implementation AssetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
    // Copy the row numbers to the pasteboard.
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:AssetDataType] owner:self];
    [pboard setData:zNSIndexSetData forType:AssetDataType];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    // Add code here to validate the drop
    //NSLog(@"validate Drop");
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:AssetDataType];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow = [rowIndexes firstIndex];

    // Move the specified row to its new location...
	// if we remove a row then everything moves down by one
	// so do an insert prior to the delete
	// --- depends which way we're moving the data!!!
	if (dragRow < row) {
		[_assets insertObject:[_assets.assets objectAtIndex:dragRow] inAssetsAtIndex:row];
		[_assets removeObjectFromAssetsAtIndex:dragRow];
//		[_assetTable noteNumberOfRowsChanged];
//		[self.nsTableViewObj reloadData];

		return YES;

	} // end if

//	MyData * zData = [nsAryOfDataValues objectAtIndex:dragRow];
//	[nsAryOfDataValues removeObjectAtIndex:dragRow];
//	[nsAryOfDataValues insertObject:zData atIndex:row];
//	[self.nsTableViewObj noteNumberOfRowsChanged];
//	[self.nsTableViewObj reloadData];

	return YES;
}


- (IBAction) selectAssets: (id) sender
{

	NSLog(@"opening");
	NSOpenPanel* openPanel = NSOpenPanel.openPanel;
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setAllowsMultipleSelection: YES];
	NSA *tarr 		= @[@"js", @"css", @"txt", @"html", @"php", @"shtml"];
	[openPanel setAllowedFileTypes:tarr];
    [openPanel beginSheetModalForWindow: self.view.window completionHandler: ^(NSI result) {
		if (result == NSFileHandlingPanelOKButton) {
//		NSURL *url = [[panel URLs] objectAtIndex: 0];
//			   url = [openPanel URL];
//		[ @[ @[_cssPathBar, @"style"], @[_htmlPathBar, @"div"], @[_jsPathBar, @"javascript"]] each:^(NSA *obj) {
			[openPanel.URLs each:^(NSURL* obj) {
				NSS* path = obj.path;
				AssetType type = [path.pathExtension assetFromString];
				NSLog(@"adding type: %@ from path: %@", assetStringValue[type], path);
				[self.assets insertObject:[Asset instanceOfType:type withPath:path orContents:nil printInline:NO]inAssetsAtIndex:_assets.countOfAssets];
//				/instanceOfType:type withPath:path orContents:nil isInline:NO] inAssetsAtIndex:_assets.countOfAssets];
//				[self.assets addFolder:path matchingType:type];
			}];
		}
	}];
} // openEarthinizerDoc



@end
