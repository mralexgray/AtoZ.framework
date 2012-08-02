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

}
@synthesize window = _window, unit;



- (void)setUnit:(NSNumber *)someUnit {
	unit = someUnit;
//	[[i documentView] setAutoresizesSubviews:YES];
////	NSSize e = [[i documentView]bounds].size;
	NSRect r = NSMakeRect(0,0,crap.count * unit.floatValue, i.contentSize.height);
	[i.documentView setFrame:r];
//	[[i documentView]setNeedsDisplayInRect:[i documentVisibleRect]];
	[self shuffleAndShowIfNeeded];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	crap = [AtoZ runningApps].mutableCopy;
	crap = [NSMutableArray array];
//	unit = @100;
//	doc = NSZeroRect;
	i = [[[_window contentView] subviews]objectAtIndex:0];
	i.contentView.postsBoundsChangedNotifications = YES;
	i.postsFrameChangedNotifications = YES;
	[[NSNotificationCenter defaultCenter] addObserver: self
		selector: @selector(boundsChanged:)	name: NSViewBoundsDidChangeNotification
		object: [i contentView]];
	NSLog(@"%@",[AtoZ runningApps]);//[NSStringFromClass([i class]) methodNames]);
	[NSThread performBlockInBackground:^{
		[AZStopwatch start:@"performingBlockInBackground"];
//		crap = [[NSColor fengshui] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {

		[[AtoZ dockSorted] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

			AZFile *block = obj;
//			block.color = ;
			AZInfiniteCell *e = [AZInfiniteCell new];// alloc]initWithFrame:NSZeroRect];
			e.backgroundColor = block.color;
			e.file = block;
			[crap addObject:e];
			//[AZFile instanceWithColor:obj];//RANDOMCOLOR];// obj;//[AZFile instanceWithColor:obj];
			NSLog(@"cell: %@. color:%@",obj, e);
//			e.backgroundColor = block.color;
//			e.autoresizingMask = NSViewHeightSizable;
//			NSImageView *iye = [NSImageView new];
//			block.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//			iye.image = block.image;
			[i.documentView addSubview:e];
//			return obj;
		}];//.mutableCopy;
		[i.documentView setFrame:AZMakeRect(NSZeroPoint,NSMakeSize(crap.count*unit.floatValue,i.contentSize.height))];
		[i.documentView setNeedsDisplay:NO];
		[[NSThread mainThread] performBlock:^{

			[self shuffleAndShowIfNeeded];
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

- (void) shuffleAndShowIfNeeded  {
	[crap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSRect pile = AZMakeRect(NSMakePoint([unit floatValue]*idx,0), NSMakeSize([unit floatValue], i.contentSize.height));
		[obj setFrame :pile];
//		[i.documentView addSubview:obj];
		if ( NSIntersectsRect(pile,i.documentVisibleRect))
			[i.documentView setNeedsDisplayInRect:pile];
	}];
}

- (void) boundsChanged:(NSNotification*)note{

//	NSClipView *c = note.object;
//	NSRect vrect = [[i documentView]visibleRect];
	[self shuffleAndShowIfNeeded];
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
//	NSLog(@"docrect = %@  vrect:%@ ", NSStringFromRect([[i documentView]frame]), NSStringFromRect(vrect));
}
@end
