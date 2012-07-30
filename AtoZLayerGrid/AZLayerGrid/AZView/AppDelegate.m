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
	NSScrollView *i;
	NSRect doc;
	NSMutableArray *crap;
	float unit;
}
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	crap = [AtoZ runningApps].mutableCopy;
	unit = 100;
	doc = NSZeroRect;
	i = [[[_window contentView] subviews]objectAtIndex:0];
	i.contentView.postsBoundsChangedNotifications = YES;
	[[NSNotificationCenter defaultCenter] addObserver: self
		selector: @selector(boundsChanged:)	name: NSViewBoundsDidChangeNotification
		object: [i contentView]];
//	NSLog(@"%@",[NSStringFromClass([i class]) methodNames]);
	doc.size.height = i.contentSize.height;

}

- (void) boundsChanged:(NSNotification*)note{

	NSClipView *c = note.object;
	NSRect vrect = [[i documentView]visibleRect];

	if
	doc.size.width += unit;
	[i.documentView setFrame:doc];
	NSRect spot = AZRightEdge(doc,unit);
	AZSimpleView *ss = [[AZSimpleView alloc]initWithFrame:spot];
	//		NSLog(@"%@",obj);
	ss.backgroundColor = [obj valueForKey:@"color"];
	//		ss.autoresizingMask = NSViewWidthSizable;
	//		NSRect f = AZMakeRect(NSZeroPoint , NSMakeSize((vertical ? i.contentSize.width : make.width *idx), (vertical ? make.height *idx : i.contentSize.height)));
	
	
	[i.documentView addSubview:ss];


//	NSIndexSet *vital = [grid indexesOfCellsInRect: vrect];
	//	NSRange
	NSLog(@"note.obj.%@.  vrect:%@ ",note, NSStringFromRect(vrect));
}
@end
