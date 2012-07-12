//
//  AtoZAppDelegate.m
//  AZBoxTest
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//




#import "AtoZAppDelegate.h"



#define BOXSIZE 100

@implementation AtoZAppDelegate
{
NSMutableArray *items;
SourceListItem *boxesSourceList;
NSArray *sourceListItems;
}



@synthesize infiniteWell, colorCycle, scroller, infiniteViews;

@synthesize window = _window,  source, itemsCount, status;
//boxGrid, boxGrid2, magic
//- (NSUInteger)totalFilesToBeBoxedIn:(AZBoxMagic *)magicView {
//	return [AtoZ dock].count;
//}
//- (AZFile *)magicView:(AZBoxMagic *)magicView fileForIndex:(NSUInteger)index{
//	return [[AtoZ dock]objectAtIndex:index];
//}

- (void) cycleTheColors {
	
	NSColor * now = [self.colorCycle first];
	NSLog(@"Cycle called: color to set: %@", [now nameOfColor]);
	[self.infiniteWell setColor:now];
	[self.colorCycle firstToLast];
}

- (void) scrollerFrameDidChange:(NSNotification*)note {
	int numtoadd = 1;
	float frameheight = [[scroller contentView]frame].size.height;
	while (frameheight > BOXSIZE) { numtoadd++; frameheight -= BOXSIZE; }
	if (numtoadd) [self ensureTotal:numtoadd];
	__block	float wide = [[scroller contentView]frame].size.width;
	[[[scroller documentView]subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		NSRect curfr = [obj frame];
		curfr.size.width = wide;
		[obj setFrame:curfr];
		( (curfr.origin.y + BOXSIZE) > [[scroller documentView]visibleRect].size.height ?
		 [obj setNeedsDisplay:NO] : [obj setNeedsDisplay:YES]);
	}];


}

- (void)scrollWheel:(NSEvent *)event
{
	NSLog(@"SCROLLTIME");
//    if ([event respondsToSelector:@selector(scrollingDeltaX)]) {
//        x -= event.scrollingDeltaX;
//        y -= event.scrollingDeltaY;
//    } else {
//        x -= event.deltaX;
//        y -= event.deltaY;
//    }
}

- (void)scrollerBoundsDidChange:(NSNotification*)contentV {
	NSView *docV    	= [scroller documentView];
	NSRect	docVVisRect	= [docV visibleRect];
	int numtoadd = [[[scroller documentView]subviews]count] + 1;
//	float frameheight = [[scroller contentView]frame].size.height;
//	while (frameheight > BOXSIZE) { numtoadd++; frameheight -= BOXSIZE; }
	if (docVVisRect.origin.y < 10) [self ensureTotal:numtoadd];

	// get the changed content view from the notification
    NSClipView *clipV 	= [scroller contentView];
    // get the origin of the NSClipView of the scroll view that we're watching
    NSPoint clipOrigin 	= [clipV documentVisibleRect].origin;
	NSSize docRect		= [docV frame].size;
	
	float 	docVHeight 	= [docV frame].size.height;
//	if (docVVisRect.size.height > scroller.contentSize.height) subVsNeed++;
	//	NSLog(@"SCROLLED: %@", NSStringFromRect([contentV.object bounds]));
	self.status = $(@"%@",
//	have:%i want: %i, need:%i scrollframe:%@ visrect:%@", 
//					subVsHave, subVsWant, subVsNeed, 
//					NSStringFromSize([[scroller documentView]frame].size), 
					NSStringFromRect(docVVisRect));
	
	//	NSRect visrect = [[(NSScrollView*)[contentV.object superview]documentView]visibleRect];
	[scroller reflectScrolledClipView:[scroller contentView]];

}
- (void) ensureTotal:(NSUInteger)views {
	
    // get our current origin
//    NSPoint curOffset = [[self contentView] bounds].origin;
//    NSPoint newOffset = curOffset;
    // scrolling is synchronized in the vertical plane so only modify the y component of the offset
//    newOffset.y = changedBoundsOrigin.y;
    // if our synced position is different from our current position, reposition our content view
//    if (!NSEqualPoints(curOffset, changedBoundsOrigin)) {
		// note that a scroll view watching this one will get notified here
		// we have to tell the NSScrollView to update its scrollers
//		[self reflectScrolledClipView:[self contentView]];
//    }
	int 	subVsHave	= [[scroller documentView] subviews].count - 1;
	int		subVsWant	= views;
	int		subVsNeed	= subVsWant - subVsHave;
	NSLog(@"ensuring %i views.  Need to add: %i", subVsWant, subVsNeed);
	
	NSRect doc = [[scroller documentView] frame];
	doc.size.height = subVsHave *BOXSIZE;
	[[scroller documentView] setFrame:doc];
	
	for (int i = 0; i < subVsNeed; i++) {
		doc.size.height += BOXSIZE;
		[[scroller documentView]setFrame:doc];
		
		[[[scroller documentView]subviews]  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSRect p = [obj frame];
			p.origin.y += BOXSIZE;
			[obj setFrame:p];
			( (p.origin.y + BOXSIZE) > [[scroller documentView]visibleRect].size.height ?
				[obj setNeedsDisplay:NO] : [obj setNeedsDisplay:YES]);
			// we have to tell the NSScrollView to update its scrollers
		}];
//		AZSimpleView *sv = [infiniteViews first];
		NSData * archivedView = [NSKeyedArchiver archivedDataWithRootObject:[infiniteViews first]];
		AZSimpleView *sv = [NSKeyedUnarchiver unarchiveObjectWithData:archivedView];
		
		NSRect newbox;
			newbox.size.height = BOXSIZE;
			newbox.size.width = doc.size.width;
			newbox.origin.x = 0;
			newbox.origin.y = 0;//BOXSIZE * ([[scroller documentView] subviews].count - 1);
		[sv setFrame:newbox];
		[[scroller documentView]addSubview:sv];
		[infiniteViews firstToLast];

	}
//	NSPoint scrollto = NSMakePoint(0,scroller.contentView.frame.size.height);
//	[[scroller contentView] scrollToPoint:scrollto];

//	self.status = $(@"clipframe: %@ VIS:%@  SUBVs:%@", 
//		NSStringFromRect(), 
//		NSStringFromRect([contentV.object visibleRect]),
//		NSStringFromRect([contentV.object bounds]) );
}

- (void) awakeFromNib {
	[source setDataSource:self];
	self.colorCycle =	[[NSMutableArray alloc] initWithObjects:RED, BLUE, GREEN, YELLOw, nil];
	AZSimpleView *a = [[AZSimpleView alloc]initWithFrame:scroller.frame];
	a.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
	a.autoresizesSubviews = YES;
	[scroller setDocumentView:a];

	[scroller setHasHorizontalScroller:NO];
	[scroller setHasVerticalRuler:NO];
	[scroller setPostsFrameChangedNotifications:YES];
	[scroller reflectScrolledClipView:[scroller contentView]];
	[scroller setBorderType:NSNoBorder];
	[scroller setHorizontalScrollElasticity:NSScrollElasticityNone];
	[scroller setVerticalScrollElasticity:NSScrollElasticityNone];
	NSRect scrl = [scroller frame];
	infiniteViews = [NSMutableArray array];
	for (int i = 0; i < 3; i++) {
		NSRect r = [[scroller documentView]frame];
		r.size.height = BOXSIZE;
		AZSimpleView *e = [[AZSimpleView alloc]initWithFrame:r];
		e.autoresizingMask =  NSViewWidthSizable;
		[infiniteViews addObject:e];
	}
	[[scroller contentView] setPostsBoundsChangedNotifications:YES];
	[scroller setPostsFrameChangedNotifications:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerFrameDidChange:) name:NSViewFrameDidChangeNotification object:[scroller contentView]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerBoundsDidChange:) name:NSViewBoundsDidChangeNotification object:[scroller contentView]]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerBoundsDidChange:) name:@"scrollRequested" object:nil]; 
	
//	[boxGrid setDataSource:self];
	// create the scroll view so that it fills the entire window
	// to do that we'll grab the frame of the window's contentView
	// theWindow is an outlet connected to a window instance in Interface Builder
//	NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame: [boxGrid frame]];
//	// the scroll view should have both horizontal and vertical scrollers
//	[scrollView setHasVerticalScroller:YES];
//	[scrollView setHasHorizontalScroller:YES];
//	// configure the scroller to have no visible border
//	[scrollView setBorderType:NSNoBorder];
//	// set the autoresizing mask so that the scroll view will resize with the window
//	[scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
//	// set theImageView as the documentView of the scroll view
//	[scrollView setDocumentView:boxGrid];
////	[[scrollView documentView]setClip];
//	[[scrollView documentView]setCanDrawConcurrently:YES];
////	[scrollView setFrame:NSMakeRect(NSMaxX([[self window]frame]) - scrollView.frame.size.width,NSMaxY([[self window ]frame])-scrollView.frame.size.height,scrollView.frame.size.width,scrollView.frame.size.height)];
//	// set the scrollView as the window's contentView
//	// this replaces the existing contentView and retains
//	// the scrollView, so we can release it no
//	[[[self window]contentView]addSubview:scrollView];
//	[boxGrid setDelegate:self];
//	items = [AtoZ dockSorted].mutableCopy;
//	[boxGrid reloadData];
//	[boxGrid setDesiredNumberOfRows:NSUIntegerMax];
//	[boxGrid setDesiredNumberOfColumns:NSUIntegerMax];
	[self.window makeKeyAndOrderFront:nil];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	[boxGrid setCellSize:NSMakeSize(64.0, 64.0)];
//	[boxGrid setAllowsMultipleSelection:YES];
	boxesSourceList = [SourceListItem itemWithTitle:@"BOXES" identifier:@"boxes"];
	NSArray *classesA = [[AtoZ dockSorted] arrayUsingBlock:^id(id obj) {
		AZFile *a = obj;
		SourceListItem *ourListItem = [SourceListItem itemWithTitle:a.name identifier:a.name];
		[ourListItem setIcon:a.image];
		return ourListItem;
	}];
	[boxesSourceList setChildren:classesA];
	sourceListItems = [[NSArray alloc]initWithObjects: boxesSourceList, nil];
	[source reloadData];

	
}
- (NSUInteger)sourceList:(AZSourceList*)sourceList numberOfChildrenOfItem:(id)item {
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[boxesSourceList children] count];
	}
}
- (id)sourceList:(AZSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item {
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[boxesSourceList children] objectAtIndex:index];
	}
}
- (id)sourceList:(AZSourceList*)aSourceList objectValueForItem:(id)item {
	return [item title];
}
- (void)sourceList:(AZSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item {
	[item setTitle:object];
}
- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item {
	return [item hasChildren];
}
- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasBadge:(id)item {
	return [item hasBadge];
}
- (NSInteger)sourceList:(AZSourceList*)aSourceList badgeValueForItem:(id)item {
	return [item badgeValue];
}
- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasIcon:(id)item {
	return [item hasIcon];
}
- (NSImage*)sourceList:(AZSourceList*)aSourceList iconForItem:(id)item {
	return [item icon];
}
- (NSMenu*)sourceList:(AZSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item {
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

//- (NSUInteger)numberOfCellsInCollectionView:(AZBoxGrid *)view {
//	self.itemsCount = items.count;
//    return items.count;
//
//}

//- (AZBox *)collectionView:(AZBoxGrid *)view cellForIndex:(NSUInteger)index
//{
//    AZBox *cell = [view dequeueReusableCellWithIdentifier:$(@"cell.%ld", index)];
//	if(!cell)
//	
//        cell = [[AZBox alloc] initWithReuseIdentifier:$(@"cell.%ld", index)];
//		
//		cell.representedObject = [items objectAtIndex:index];
////		cell.color = [[items objectAtIndex:index]valueForKey:@"color"];
////		[cell setImage:[[[AtoZ dockSorted]objectAtIndex:index] valueForKey:@"image"]];
//    return cell;
//}

//- (void)collectionView:(AZBoxGrid *)_collectionView didSelectCellAtIndex:(NSUInteger)index {
//    NSLog(@"Selected cell at index: %u", (unsigned int)index);
//    NSLog(@"Position: %@", NSStringFromPoint([_collectionView positionOfCellAtIndex:index]));
//}

- (IBAction)reload:(id)sender {
//	[boxGrid reloadData];
//	[boxGrid2 reloadData];
}

- (IBAction)log:(id)sender {
//	NSLog(@"%@", boxGrid2.propertiesPlease);
}

- (IBAction)add:(id)sender {
//	[boxGrid2 in
}

- (IBAction)save:(id)sender {
//	[[AtoZ dockSorted] save];

}

- (IBAction)load:(id)sender {
//	[magic reload];
//	NSLog(@"%@",[AtoZ load]);
}

- (IBAction)init:(id)sender {
//	[boxGrid reloadData];
}
@end
