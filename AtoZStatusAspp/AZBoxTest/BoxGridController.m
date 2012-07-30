//
//  BoxGridController.m
//  AtoZStatusApp
//
//  Created by Alex Gray on 7/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "BoxGridController.h"

@implementation BoxGridController


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


[[NSNotificationCenter defaultCenter] addObserver: self
										 selector: @selector(boundsDidChangeNotification:)
											 name: NSViewBoundsDidChangeNotification
										   object: [[grid enclosingScrollView]contentView]];


-(NSString*) activeViews {
	return $(@"%ld",[[grid subviews]count]);
}


@end
