//
//  AppDelegate.m
//  AZView
//
//  Created by Alex Gray on 7/24/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AppDelegate.h"
#import <AtoZ/AtoZ.h>
#import <QuartzCore/QuartzCore.h>
@implementation AppDelegate
{
	NSUInteger hoveredIndex;
	NSRange scaledRange;
	NSMutableIndexSet *set;
	__block NSScrollView *i;
	NSRect doc;
	__block NSMutableArray *crap;
	
}
//@synthesize mouseTest;
//@synthesize mouseAction;
//@synthesize point1x;
//@synthesize point1y;
//@synthesize point2x;
//@synthesize point2y;
@synthesize window = _window, unit;



- (void)setUnit:(NSNumber *)someUnit {
	
	float min = i.contentSize.width / crap.count;
	unit = $int( MAX( min, someUnit.floatValue * min));
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
	set = [NSMutableIndexSet indexSet];
	i = [[[_window contentView] subviews]objectAtIndex:0];
	i.contentView.postsBoundsChangedNotifications = YES;
	i.postsFrameChangedNotifications = YES;
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(shuffleAndShowIfNeeded)	name: NSViewBoundsDidChangeNotification
											   object: [i contentView]];
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(shuffleAndShowIfNeeded)	name: NSViewFrameDidChangeNotification
											   object: nil];
	
	
	[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *event) {
		//		if ([event type] == NSMouseMovedMask ) {
		NSPoint localP = [[_window contentView]localPoint];
		if ( NSPointInRect(localP, i.frame) ){
			hoveredIndex = floor(localP.x / unit.floatValue);
			NSUInteger notzero = (hoveredIndex > 3 ? (hoveredIndex -3) : 0 );
			scaledRange = NSMakeRange( notzero, 6);
			NSLog(@"scaledRange set: %@", NSStringFromRange(scaledRange));
			NSLog(@"Mouse moved in window. LocalP: %@.. index:%ld", NSStringFromPoint(localP), hoveredIndex);
			[self shuffleAndShowIfNeeded];
		} else { hoveredIndex = 10101010;  NSLog(@"Index: %ld",hoveredIndex); }
		//		}
		return event;
	}];
	
	//	NSLog(@"%@",crap = [AtoZ runningApps]);//[NSStringFromClass([i class]) methodNames]);
	
	
	crap = [NSMutableArray array];
	
	
	[NSThread performBlockInBackground:^{
		[AZStopwatch start:@"performingBlockInBackground"];
		//		crap = [[NSColor fengshui] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
		
		[[AtoZ dock] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			
			AZFile *block = obj;
			//			block.color = ;
			AZInfiniteCell *e = [AZInfiniteCell new];// alloc]initWithFrame:NSZeroRect];
			e.backgroundColor = block.color;
			e.file = block;
			[crap addObject:e];
			//[AZFile instanceWithColor:obj];//RANDOMCOLOR];// obj;//[AZFile instanceWithColor:obj];CRAP=
			NSLog(@"cell: %@. color:%@",obj, e);
			//			e.backgroundColor = block.color;
			//			e.autoresizingMask = NSViewHeightSizable;
			//			NSImageView *iye = [NSImageView new];
			//			block.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
			//			iye.image = block.image;
			[i.documentView addSubview:e];
			//			return obj;
		}];//.mutableCopy;
		
		//		[i.documentView setNeedsDisplay:NO];
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
	
	[i.documentView setFrame:AZMakeRect(NSZeroPoint,NSMakeSize(crap.count*unit.floatValue,i.contentSize.height))];
	i.lineScroll = unit.floatValue;
//	__block NSMutableArray *anis = [NSMutableArray array];
//	[NSAnimationContext beginGrouping];
//	[[NSAnimationContext currentContext] setDuration:0.2];

	[crap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		float hoverOffset = 0;

		NSRect pile = AZMakeRect(NSMakePoint(([unit floatValue] * idx) + hoverOffset ,0), NSMakeSize([unit floatValue], i.contentSize.height));
		if (NSIntersectsRect(i.documentVisibleRect,pile)){
			[set addIndex:idx];
			NSPoint globalLocation = [ NSEvent mouseLocation ];
			NSPoint windowLocation = [[i window] convertScreenToBase: globalLocation ];
			NSPoint viewLocation = [[i documentView] convertPoint: windowLocation fromView: nil ];
			if(  NSPointInRect( viewLocation,pile ) ) {
				if ( NSLocationInRange(idx, scaledRange )) {
					NSUInteger dist = (scaledRange.length - (scaledRange.length - idx));
					hoverOffset += (dist * unit.floatValue);
					pile.size.width += hoverOffset;
					NSLog(@"Index at %ld is %ld from hovered: %ld",idx, dist,hoveredIndex);
//					NSDictionary *frameo = @{ obj : NSViewAnimationTargetKey,
//					[NSValue valueWithRect:pile]: NSViewAnimationEndFrameKey};
//					[anis addObject:frameo]
				}
			}
//			[[NSThread mainThread] performBlock:^{
				//			CAKeyframeAnimation *animatedIconAnimation = [CAKeyframeAnimation animationWithKeyPath: @"frame"];
				//			animatedIconAnimation.duration = 1.0;
				//			animatedIconAnimation.delegate = self;
				//			animatedIconAnimation.
				//			animatedIconAnimation.toValue = NSRectToCGRect(pile);
				//			animatedIconAnimation.path = NSRectToCGRect(pile);
				//			animatedIconAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
				//			[animatedIconView setAnimations:[NSDictionary dictionaryWithObject:animatedIconAnimation forKey:@"frame"]];// Start the icon animation.
				
//				[[obj animator] setFrame :pile];
//			} waitUntilDone:YES];
		[[NSThread mainThread] performBlock:^{
			[obj setFrame:pile];

//			NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:anis];
//			[animation setAnimationBlockingMode:NSAnimationBlocking];
//			[animation setDuration:0.3];
//			[NSAnimationContext endGrouping];
//			[animation startAnimation];
		} waitUntilDone:NO];
		}
		//			[obj setNeedsDisplay:YES];
		//			[i.documentView setNeedsDisplayInRect:pile];
		else [set removeIndex:idx];
	}];
NSLog(@"VisiIndex = %@", set);
}


- (void) boundsChanged:(NSNotification*)note{
	
	if (note.name == NSViewBoundsDidChangeNotification) {
		//		[self]
	}
}
//	NSClipView *c = note.object;
//	NSRect vrect = [[i documentView]visibleRect];
//	[crap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

//	NSLog(@"Matching %@, rect: %@", [(AZFile*)obj valueForKey:@"file"], StringFromBOOL(YES));
//	}];
//		[self shuffleAndShowIfNeeded];
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
//}
@end
