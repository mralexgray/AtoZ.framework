//
//  AppController.m
//  NSStatusItemTest

#import "AZStatusAppController.h"

@implementation AZStatusAppController {
	BOOL menuWindowIsShowing;
	NSMutableArray *datasource;
	NSUInteger fakeDataSourceCount;
}

@synthesize attachedWindow, scroller, grid, activeViews;

- (void)awakeFromNib {
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
			selector:@selector(activeAppDidChange:)
			name:NSWorkspaceDidActivateApplicationNotification object:nil];

    // Create an NSStatusItem.
    NSRect menuFrame = NSMakeRect(0, 0, 30, [[NSStatusBar systemStatusBar] thickness]);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:menuFrame.size.width];
	statusView = [[AZStatusItemView alloc] initWithFrame:menuFrame];
	
	[statusView setDelegate: self];
    [statusItem setView:statusView];//// controller:self]];
	menu = [NSMenu new];
	[[AtoZ runningApps] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSMenuItem *i = [NSMenuItem new];
		__block NSImage *ii = [obj valueForKey:@"image"];
		[ii setSize:NSMakeSize(25,25)];
		__block AZSimpleView *av = [AZSimpleView new];
		av.gradient = YES;
		av.frame = AZMakeRectFromSize(NSMakeSize(150,30));
		av.backgroundColor = [obj valueForKey:@"color"];
		[av addSubview: [AZBlockView viewWithFrame:AZCenteredRect(NSMakeSize(140,26),AZMakeRectFromSize(NSMakeSize(150,30))) opaque:NO drawnUsingBlock:
		 ^(AZBlockView *view, NSRect dirtyRect) {
			 //[[blockSelf roundedRectFillColor] set]; [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; }]]; }
//			 view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
			[ii drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
			NSString *name = [obj valueForKey:@"name"];
//			[name drawAtPoint:NSMakePoint(26,0) withAttributes:
			[name drawAtPoint:NSMakePoint(26,0) withAttributes:@{/*[av.backgroundColor contrastingForegroundColor]*/ WHITE:NSBackgroundColorAttributeName}];//:[view bounds] withFont:@"Helvetica"];
//			 [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:20 yRadius:20] fill];
		 }]];
		 //positioned:NSWindowBelow relativeTo:infiniteBlocks];



		i.view = av;

//		i.title = [obj valueForKey:@"name"];
		[menu addItem:i];
	}];
	[statusItem setMenu:menu];


	NSRect barFrame = AZMakeRectMaxXUnderMenuBarY(100);
	[attachedWindow setStyleMask:NSBorderlessWindowMask];
	[attachedWindow setFrame:barFrame display:NO];
	[attachedWindow slideUp];

//	attachedWindow = [[NSWindow alloc]initWithContentRect:barFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
//	bar = [[AZToggleView alloc]initWithFrame:barFrame];
//	[attachedWindow setContentView:bar];	
//	[attachedWindow setFrame:barFrame display:NO];
//	[attachedWindow setBackgroundColor:CLEAR];
    datasource = [NSMutableArray array];
    [AZStopwatch start:@"makingBoxes:100"];
	
//			for(int i=0; i<; i++) // This creates 59000 elements!    {
		[[[[NSWorkspace sharedWorkspace] runningApplications]valueForKeyPath:@"icon"]  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[datasource addObject:obj];
		}];

//		NSRect win = [bar bounds];
//		float adjust = win.size.width*.5;
//		win.size.width -= adjust;
//		win.origin.x += adjust;
//	[[scroller documentView] setFrame:NSMakeRect(0,0,datasource.count*10,200)];
//	[scroller setHasHorizontalScroller:YES];
//	win.size.width = [datasource count]*1000 * bar.bounds.size.height;
//	grid = [[AZBoxGrid alloc] initWithFrame:win];
	grid.desiredNumberOfRows= 1;
//	grid.desiredNumberOfColumns = 10000;
	grid.dataSource = self;
//	grid.delegate = self;
	fakeDataSourceCount = datasource.count;
	[self foolBoxGrid];
    [AZStopwatch stop:@"makingBoxes:100"];
	//	[grid setAllowsMultipleSelection:YES];

	NSLog(@"grid methods %@",[ NSStringFromClass([grid class]) methodNames]);
}

- (void) foolBoxGrid{

	NSSize r =  [grid cellSize];
	// = NSMakeSize(40,40);

	[[grid.enclosingScrollView documentView]setFrame:
		NSMakeRect(	0,0,
					r.width * fakeDataSourceCount,
					r.height)];
	[grid reloadData];

	//	[grid setDesiredNumberOfColumns:NSUIntegerMax];
	//	[grid setCellSize:NSMakeSize(bar.bounds.size.width/datasource.count, bar.bounds.size.height)];
	//	[grid ];
	
	//	[[attachedWindow contentView]addSubview:s];
	//	[attachedWindow setInitialFirstResponder:s];

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
- (void)activeAppDidChange:(NSNotification *)notification {
	self.currentApp = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
	NSLog(@"currentApp == %@", self.currentApp);

	statusView.file = [AZFile instanceWithPath:[[self.currentApp valueForKeyPath:@"bundleURL"] path]];

	[statusView setNeedsDisplay:YES];
}


- (NSUInteger)numberOfCellsInCollectionView:(AZBoxGrid *)view {
    return  fakeDataSourceCount;//*1000;
}
- (AZBox *)collectionView:(AZBoxGrid *)view cellForIndex:(NSUInteger)index {

//	NSUInteger inindex = index; NSUInteger  fakeIndex = 0;
//	while (inindex >= [datasource count])
//	NSLog(@"%ld", inindex);
//	if (index < datasource.count) {
//		AZBox 	  *cell = [view dequeueReusableCellWithIdentifier:	$(@"cell.%ld",index)];
//		if (cell)
//			NSLog(@"recycling cell.%ld", index);
//		else {
			AZBox *cell = [[AZBox alloc] initWithReuseIdentifier:	$(@"cell.%ld", index)];
//			NSLog(@"a cell was BORN cell.%ld", index);
//			return cell;
//		}
//	} else {
//		NSLog(@"endex requested is TECHNICALLy beyond bounds.. it is %ld, fakeds is %ld and real is%ld", index, fakeDataSourceCount, datasource.count);
//		NSIndexSet *vital = [view indexesOfCellsInRect:[[view enclosingScrollView]documentVisibleRect]];
//		if (inindex >= datasource.count) {

//			inindex = index % (fakeDataSourceCount + 1);
//			NSLog(@"whoops, faking index index %ld with inindex... %ld",index, inindex);
//			fakeDataSourceCount = index +1;
//			AZBox *cell = [[AZBox alloc] initWithReuseIdentifier:	$(@"cell.%ld", inindex)];
			[[grid.enclosingScrollView documentView]setFrame:
				 NSMakeRect(	0,0,
							grid.cellSize.width * fakeDataSourceCount,
							grid.cellSize.height)];
	//[view dequeueReusableCellWithIdentifier:	$(@"cell.%ld",inindex)];
//		[grid setDesiredNumberOfColumns:fakeDataSourceCount];
		return cell;

//	}
//    [cell setImage:[datasource objectAtIndex:inindex]];
//	[cell setColor:RANDOMCOLOR];
}

- (void)collectionView:(AZBoxGrid *)_collectionView didSelectCellAtIndex:(NSUInteger)index {
    NSLog(@"Selected cell at index: %u", (unsigned int)index);
    NSLog(@"Position: %@", NSStringFromPoint([_collectionView positionOfCellAtIndex:index]));
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	[[NSNotificationCenter defaultCenter] addObserver: self
			   selector: @selector(boundsDidChangeNotification:)
				   name: NSViewBoundsDidChangeNotification
				 object: [[grid enclosingScrollView]contentView]];
}

- (void) boundsDidChangeNotification: (NSNotification *) notification
{
	NSClipView *c = notification.object;
	NSRect vrect = [[grid enclosingScrollView]documentVisibleRect];
	NSIndexSet *vital = [grid indexesOfCellsInRect: vrect];
//	NSRange
	NSLog(@"%@.  visirect:%@  rangecalc =%@",vital.propertiesPlease, NSStringFromRect(vrect), vital );
	if ([vital lastIndex] >= fakeDataSourceCount-2) {
		fakeDataSourceCount++;
		NSLog(@"newfakeset: %ld", fakeDataSourceCount);
		[self foolBoxGrid];
	}
	
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

	//this pops the running apps window.
//	[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showMenu) userInfo:nil repeats:NO];

	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;
//	[statusView.menu  [self menu]];

}


- (void) showMenu {
    // This will show the menu at the current mouse position
    [statusItem.menu popUpMenuPositioningItem:[[statusItem menu] itemAtIndex:0] atLocation:[NSEvent mouseLocation] inView:nil];
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
	[NSApp activateIgnoringOtherApps:YES];
	if (!menuWindowIsShowing) {

		[attachedWindow slideDown];
		[attachedWindow makeKeyAndOrderFront:attachedWindow];
		}
}

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}


-(NSString*) activeViews {
	return $(@"%ld",[[grid subviews]count]);
}

@end
