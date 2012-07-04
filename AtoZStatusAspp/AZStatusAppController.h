//
//  AppController.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>


@interface AZStatusAppController : NSObject 
<NSApplicationDelegate, NSWindowDelegate, AZBoxGridDataSource>
{
	AZBoxGrid *grid;
    NSStatusItem *statusItem;
    AZAttachedWindow *attachedWindow;
    BOOL menuWindowIsShowing;
    IBOutlet NSView *rootView;
    IBOutlet NSTextField *textField;
	NSArray *datasource;
}

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;
- (NSUInteger)numberOfBoxesInGrid:(AZBoxGrid *)grid;
/** * This method is involed to ask the data source for a cell to display at the given index. You should first try to dequeue an old cell before creating a new one! **/
- (AZBox*)grid:(AZBoxGrid *)grid boxForIndex:(NSUInteger)index;


@end
