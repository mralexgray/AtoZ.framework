//
//  AppController.m
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import "AZStatusAppController.h"
#import "AZStatusItemView.h"

@implementation AZStatusAppController

- (void)awakeFromNib {
    // Create an NSStatusItem.
    float width = 30.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [statusItem setView:[[AZStatusItemView alloc] initWithFrame:viewFrame controller:self]];
	NSRect barFrame = AGMakeRectMaxXUnderMenuBarY(100);
	[rootView setFrame:barFrame];
	NSScrollView *sc = [[NSScrollView alloc]initWithFrame:barFrame];
	[sc setHasHorizontalRuler:YES];
	[[sc documentView] setBackgroundColor:RED];
	datasource = [[NSImage systemImages] arrayUsingBlock:^id(id obj) {
//		
		AZBox *b = [[AZBox alloc]initWithObject:[[NSImage systemImages]randomElement]];
		b.color = RANDOMCOLOR;
		b.frame = NSMakeRect(0,0,100,100);
		return b;
	}];
	grid = [[AZBoxGrid alloc] initWithFrame:[[NSScreen mainScreen]frame]];
	grid.desiredNumberOfRows= 1;
	grid.dataSource = self;
//	[sc setDocumentView:grid];
	[[attachedWindow contentView] addSubview:sc];
	
//	float w = viewf.size.width / 10;
//	for (int i =0; i <10; i++) {
//		NSRect r = NSMakeRect( i*w, 0, w, viewf.size.height*.9);
//		NSLog(@"%@", NSStringFromRect(r));
//		NSImage *image = [[NSImage systemImages]randomElement];
//		[image setValue:BLUE forKeyPath:@"dictionary.color"];
//		AZBox *n = [[AZBox alloc]initWithObject:image];
//		n.frame = r;
//
//		n.tag = i;
//		[rootView addSubview:n];
//	}

}


- (NSUInteger)numberOfBoxesInGrid:(AZBoxGrid *)grid {
	return  datasource.count;
}
/** * This method is involed to ask the data source for a cell to display at the given index. You should first try to dequeue an old cell before creating a new one! **/
- (AZBox*)grid:(AZBoxGrid *)grid boxForIndex:(NSUInteger)index {
	return  [datasource objectAtIndex:index];
}

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt
{
	[NSApp activateIgnoringOtherApps:YES];
	
    if (!attachedWindow) {
        attachedWindow = [[AZAttachedWindow alloc] initWithView:rootView 
                                                attachedToPoint:pt 
                                                       inWindow:nil 
                                                         onSide:AZPositionBottom 
                                                     atDistance:5.0];
//        [textField setTextColor:[attachedWindow borderColor]];
//        [textField setStringValue:@"Your text goes here..."];
		menuWindowIsShowing = NO;
	
			//	[attachedWindow makeKeyAndOrderFront:self];
    }
//	if (![attachedWindow isAnimating]) {
	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;
}
//        [attachedWindow orderOut:self];
//        attachedWindow = nil;

//}

- (void) applicationDidResignActive:(NSNotification *)notification {
	[attachedWindow slideUp];// orderOut:self];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification{
	if (!menuWindowIsShowing) [attachedWindow slideDown];
	
}

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

@end
