//
//  AppDelegate.m
//  AZView
//
//  Created by Alex Gray on 7/24/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AppDelegate.h"
#import <AtoZ/AtoZ.h>

@implementation AppDelegate
{
	__block NSScrollView *i;
	NSRect doc;
	__block NSMutableArray *crap;
	__block float unit;
}
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	crap = [AtoZ runningApps].mutableCopy;
	unit = 100;
	doc = NSZeroRect;
	i = [[[_window contentView] subviews]objectAtIndex:0];
	i.contentView.postsBoundsChangedNotifications = YES;
	[[NSNotificationCenter defaultCenter] addObserver: self
		selector: @selector(boundsChanged:)	name: NSViewBoundsDidChangeNotification
		object: [i contentView]];
//	NSLog(@"%@",[NSStringFromClass([i class]) methodNames]);
	[NSThread performBlockInBackground:^{
		crap = [[AtoZ appFolderSorted] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
			AZFile *block = obj;
			AZInfiniteCell *e = [AZInfiniteCell new];
			e.file = block;
			e.backgroundColor = block.color;
			e.autoresizingMask = NSViewHeightSizable;
			NSImageView *iye = [NSImageView new];
			iye.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
			iye.image = block.image;
			[e addSubview:iye];
			return e;
		}].mutableCopy;
		[[NSThread mainThread] performBlock:^{
			[i.documentView setFrame:AZMakeRect(NSZeroPoint,NSMakeSize(crap.count*unit,i.contentSize.height))];
			[crap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				NSRect pile = AZMakeRect(NSMakePoint(unit*idx,0), NSMakeSize(unit, i.contentSize.height));
				[obj setFrame :pile];
				[i.documentView addSubview:obj];
			}];
		}];
	}];
//		if ((orientation == AZOrientTop ) || ( orientation == AZOrientBottom))
//			pile.origin.x = idx * localunit.size.width;
//		else
//			pile.origin.y = idx * localunit.size.height;
//		[obj setNeedsDisplay:NO];
//		[obj setFrame: pile];
//	}];

//	doc.size.height = i.contentSize.height;

}

- (void) boundsChanged:(NSNotification*)note{

	NSClipView *c = note.object;
	NSRect vrect = [[i documentView]visibleRect];

//	if
//	doc.size.width += unit;
//	[i.documentView setFrame:doc];
//	NSRect spot = AZRightEdge(doc,unit);
//	AZSimpleView *ss = [[AZSimpleView alloc]initWithFrame:spot];
	//		NSLog(@"%@",obj);
//	ss.backgroundColor = [obj valueForKey:@"color"];
	//		ss.autoresizingMask = NSViewWidthSizable;
	//		NSRect f = AZMakeRect(NSZeroPoint , NSMakeSize((vertical ? i.contentSize.width : make.width *idx), (vertical ? make.height *idx : i.contentSize.height)));
	
	
//	[i.documentView addSubview:ss];


//	NSIndexSet *vital = [grid indexesOfCellsInRect: vrect];
	//	NSRange
	NSLog(@"docrect = %@  vrect:%@ ", NSStringFromRect([[i documentView]frame]), NSStringFromRect(vrect));
}
@end
