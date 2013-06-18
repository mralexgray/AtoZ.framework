//
//  CustomView.m
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//
#import "AZStatusItemView.h"

@implementation DBStatusItemController

- (id)initWithController:(id)controller {
	if (self != super.init ) return nil;
	_item = [NSStatusBar,systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
	_item.image  = [[NSIMG imageNamed:@"atoz.icns"]scaledToMax:22];
	//	statusItem.alternateImage	= [NSImage icons][11];//.randomElement; //[NSImage imageNamed:@"statusimage_pressed"]];
	statusItem.highlightMode = YES;
	statusItem.menu			= statusMenu;

	// set the controller
	_controller = controller;
	// the item must be retained to stay in the menubar
	// load the archived menu and use it, fixing the bug about it not showing when no main menubar is shown
	NSS *path = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"dbmenu"];
	[_item setMenu:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
	[_item setHighlightMode:YES];

	// uncomment this to generate the dbmenu file
	//[NSKeyedArchiver archiveRootObject:[self standardMenu] toFile:[@"~/Desktop/main.dbmenu" stringByExpandingTildeInPath]];
	return self;
}
- (void)dealloc {
	[NSStatusBar. systemStatusBar removeStatusItem:_item];
}
- (NSMenu *)standardMenu {
	// get the current menu
	NSMenu *menu = [[[NSApplication sharedApplication] mainMenu] copy];
	NSMenuItem *_m = [menu itemAtIndex:0];
	[_m setTitle:@"DeskBrowse"];
	[menu insertItem:[NSMenuItem separatorItem] atIndex:1];
	[menu addItem:[NSMenuItem separatorItem]];
	NSMenuItem *slide = [[NSMenuItem alloc] initWithTitle:@"Toggle SlideBrowser"
																  action:@selector(toggleSlideBrowse)
														 keyEquivalent:@""];
	NSMenuItem *websp = [[NSMenuItem alloc] initWithTitle:@"Toggle Webspose"
																  action:@selector(toggleWebspose)
														 keyEquivalent:@""];
	[slide setTarget:_controller];
	[websp setTarget:_controller];

	[menu addItem:slide];
	[menu addItem:websp];

	//	[slide autorelease];
	//	[websp autorelease];
	return menu;// autorelease];
}
@end

@implementation AZStatusItemView	{	NSControl *_indicator;	}

- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
		_clicked = NO;
	}
	return self;
}
- (void)drawRect:(NSRect)rect {

//	[self.color set];
//	[[NSBezierPath  bezierPathWithOvalInRect: AZMakeSquare([self center], NSMaxY([self bounds])*.8)] fill];
	// Draw background if appropriate.
	NSColor *now = RANDOMCOLOR;
	if (!_clicked) {
		NSBezierPath *frame = [NSBezierPath bezierPathWithRect:[self frame]];
		[frame fillGradientFrom:now to:now angle:270];
	} else {
		NSColor *rando = now.darker.darker;// [[RANDOMCOLOR colorWithAlphaComponent:.5]darker];
		NSBezierPath *frame = [NSBezierPath bezierPathWithRect:[self frame]];
		[frame fillGradientFrom:rando.brighter to:rando.darker angle:270];
//		[[NSColor selectedMenuItemColor] set];
//		NSRectFill(rect);
	}

}
- (void)mouseDown:(NSEvent *)event
{
	NSRect frame = [[self window] frame];
	NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));

	if (!_clicked) {
		//		[[self menu]popUpMenuPositioningItem:[self menu] atLocation:NSZeroPoint inView:self ];// [self center] inView:self];

		[delegate statusView:self isActive:YES];
		//		[controller toggleAttachedWindowAtPoint:pt];
		_clicked = YES;
	}
	else {	_clicked = NO;
		[delegate statusView:self isActive:NO]; }
	//	[controller toggleAttachedWindowAtPoint:pt]; }
	[self setNeedsDisplay:YES];
}

- (void)activeAppDidChange:(NSNotification *)notification {
	self.currentApp = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
	NSLog(@"currentApp == %@", self.currentApp);

	self.file = [AZFile instanceWithPath:[[self.currentApp valueForKeyPath:@"bundleURL"] path]];

	[self setNeedsDisplay:YES];
}

@end
//- (id)initWithFrame:(NSRect)frame controller:(AZEncyclopediaDelegate*)ctrlr {
//	if (self = [super initWithFrame:frame]) {
//		controller = ctrlr; // deliberately weak reference.
//		_clicked = NO;
////		_indicator = [[NSControl alloc]initWithFrame:NSInsetRect([self frame], 3, 3)];
////		AZIndeterminateIndicator *cell = [[AZIndeterminateIndicator alloc]init];
//		[_indicator setCell:cell];
////		[_indicator setStyle:NSProgressIndicatorSpinningStyle];
////		[self addSubview:_indicator];
////		[cell setSpinning:YES];
//
//	}
//	return self;
//}
//- (void)dealloc
//{
//	controller = nil;
//}

//	[[[[[NSImage systemImages]randomElement]

//	[[[self.file.image imageScaledToFitSize:AZScaleRect([self bounds], .6).size]coloredWithColor:WHITE]drawCenteredinRect:[self frame] operation:NSCompositeSourceOver fraction:1];
//	if (NO) {
//		// Draw some text, just to show how it's done.
//		NSString *text = @"3"; // whatever you want
//
//		NSColor *textColor = [NSColor controlTextColor];
//		if (_clicked) {
//			textColor = [NSColor selectedMenuItemTextColor];
//		}
//
//		NSFont *msgFont = [NSFont menuBarFontOfSize:15.0];
//		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//		[paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//		[paraStyle setAlignment:NSCenterTextAlignment];
//		[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//		NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//										 msgFont, NSFontAttributeName,
//										 textColor, NSForegroundColorAttributeName,
//										 paraStyle, NSParagraphStyleAttributeName,
//										 nil];
//
//		NSSize msgSize = [text sizeWithAttributes:msgAttrs];
//		NSRect msgRect = NSMakeRect(0, 0, msgSize.width, msgSize.height);
//		msgRect.origin.x = ([self frame].size.width - msgSize.width) / 2.0;
//		msgRect.origin.y = ([self frame].size.height - msgSize.height) / 2.0;
//
//		[text drawInRect:msgRect withAttributes:msgAttrs];
//	}
