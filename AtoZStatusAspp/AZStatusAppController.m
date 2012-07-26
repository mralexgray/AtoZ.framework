//
//  AppController.m
//  NSStatusItemTest

#import "AZStatusAppController.h"

@implementation AZStatusAppController {
	BOOL menuWindowIsShowing;
	NSMutableArray *datasource;
}

@synthesize attachedWindow, scroller, grid;

- (void)awakeFromNib {
    // Create an NSStatusItem.
    NSRect menuFrame = NSMakeRect(0, 0, 30, [[NSStatusBar systemStatusBar] thickness]);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:menuFrame.size.width];
	statusView = [[AZStatusItemView alloc] initWithFrame:menuFrame];
	[statusView setDelegate: self];
    [statusItem setView:statusView];//// controller:self]];
	NSRect barFrame = AZMakeRectMaxXUnderMenuBarY(100);
	[attachedWindow setStyleMask:NSBorderlessWindowMask];
	[attachedWindow setFrame:barFrame display:NO];
	[attachedWindow slideUp];

//	attachedWindow = [[NSWindow alloc]initWithContentRect:barFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
//	bar = [[AZToggleView alloc]initWithFrame:barFrame];
//	[attachedWindow setContentView:bar];	
//	[attachedWindow setFrame:barFrame display:NO];
//	[attachedWindow setBackgroundColor:CLEAR];
    datasource = [[NSMutableArray alloc] init];
    [AZStopwatch start:@"makingBoxes:100"];
	
//			for(int i=0; i<; i++) // This creates 59000 elements!    {
		[[[[NSWorkspace sharedWorkspace] runningApplications]valueForKeyPath:@"icon"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[datasource addObject:obj];
		}];

		NSRect win = [bar bounds];
		float adjust = win.size.width*.5;
		win.size.width -= adjust;
		win.origin.x += adjust;
	scroller = [[NSScrollView alloc]initWithFrame:win];
//	[scroller setHasHorizontalScroller:YES];
//	win.size.width = [datasource count]*1000 * bar.bounds.size.height;
//	grid = [[AZBoxGrid alloc] initWithFrame:win];
	grid.desiredNumberOfRows= 1;
	grid.desiredNumberOfColumns = 10000;
	grid.dataSource = self;
	[grid setDesiredNumberOfColumns:NSUIntegerMax];
	[grid setCellSize:NSMakeSize(bar.bounds.size.height, bar.bounds.size.height)];
//	[grid ];
	
//	[[attachedWindow contentView]addSubview:s];
//	[attachedWindow setInitialFirstResponder:s];
	[grid reloadData];
    [AZStopwatch stop:@"makingBoxes:100"];
	//	[grid setAllowsMultipleSelection:YES];
}
//	NSScrollView *sc = [[NSScrollView alloc]initWithFrame:barFrame];
//	[sc setHasHorizontalRuler:YES];
//	[[sc documentView] setBackgroundColor:RED];
//	[[NSImage systemImages] arrayUsingBlock:^id(id obj) {
////		AZBox *b = [[AZBox alloc]initWithObject:[[NSImage systemImages]randomElement]];
//		[datasource addObject:obj];
////		b.color = RANDOMCOLOR;
////		b.frame = NSMakeRect(0,0,100,100);
//		return obj;
//	}];
////	[sc setDocumentView:grid];
//	[rootView addSubview:grid];
	
//	float w = viewf.size.width / 10;
//	for (int i =0; i <10; i++) {
//		NSRect r = NSMakeRect( i*w, 0, w, viewf.size.height*.9);
//		NSLog(@"%@", NSStringFromRect(r));
//		NSImage *image = [[NSImage systemImages]randomElement];
//		[image setValue:BLUE forKeyPath:@"dictionary.color"];
//		AZBox *n = [[AZBox alloc]initWithObject:image];
//		n.frame = r;
//		n.tag = i;
//		[rootView addSubview:n];
//	}

- (NSUInteger)numberOfCellsInCollectionView:(AZBoxGrid *)view {
    return  [datasource count]*1000;
}
- (AZBox *)collectionView:(AZBoxGrid *)view cellForIndex:(NSUInteger)index {
	NSUInteger inindex = index;
	while (inindex >= [datasource count]) inindex -= [datasource count];	NSLog(@"%ld", inindex);
    AZBox 	  *cell = [view dequeueReusableCellWithIdentifier:	$(@"cell.%ld",inindex)];
    if(!cell)  cell = [[AZBox alloc] initWithReuseIdentifier:	$(@"cell.%ld", inindex)];
//    [cell setImage:[datasource objectAtIndex:inindex]];
//	[cell setColor:RANDOMCOLOR];
		return cell;
}
- (void)collectionView:(AZBoxGrid *)_collectionView didSelectCellAtIndex:(NSUInteger)index {
    NSLog(@"Selected cell at index: %u", (unsigned int)index);
    NSLog(@"Position: %@", NSStringFromPoint([_collectionView positionOfCellAtIndex:index]));
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}


//- (NSUInteger)numberOfBoxesInGrid:(AZBoxGrid *)grid {
//	return  datasource.count;
//}
///** * This method is involed to ask the data source for a cell to display at the given index. You should first try to dequeue an old cell before creating a new one! **/
//- (AZBox*)grid:(AZBoxGrid *)grid boxForIndex:(NSUInteger)index {
//	return  [datasource objectAtIndex:index];
//}

- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active{
	[attachedWindow makeKeyAndOrderFront:self];
	[NSApp activateIgnoringOtherApps:YES];
	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;
	
}


//- (void)toggleAttachedWindowAtPoint:(NSPoint)pt {
//	[NSApp activateIgnoringOtherApps:YES];
//    if (!attachedWindow) {
//        attachedWindow = [[AZAttachedWindow alloc] initWithView:rootView 
//                                                attachedToPoint:pt 
//                                                       inWindow:nil 
//                                                         onSide:AZPositionBottom 
//                                                     atDistance:5.0];
////        [textField setTextColor:[attachedWindow borderColor]];
////        [textField setStringValue:@"Your text goes here..."];
//		menuWindowIsShowing = NO;	
//			//	[attachedWindow makeKeyAndOrderFront:self];
//    }
////	if (![attachedWindow isAnimating]) {
//	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
//	menuWindowIsShowing =! menuWindowIsShowing;
//}
//        [attachedWindow orderOut:self];
//        attachedWindow = nil;
- (void) applicationDidResignActive:(NSNotification *)notification {
	[attachedWindow slideUp];// orderOut:self];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification{
	if (!menuWindowIsShowing) { [attachedWindow slideDown];
		
		}
}

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

@end
