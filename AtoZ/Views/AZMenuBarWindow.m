//
//  AZMenuBarWindow.m
//  AtoZ
//
//  Created by Alex Gray on 10/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZMenuBarWindow.h"

@implementation AZMenuBarWindow
- (id) init {    self = [self initWithContentRect:[[NSScreen mainScreen] frame]
										styleMask:NSBorderlessWindowMask	backing:NSBackingStoreBuffered	defer:NO];

	if ( self != nil ) {
		self.bar = [[AZSimpleView alloc]initWithFrame:self.frame];
		NSArray *r = [NSColor randomPalette];
		CGF unit	= ScreenWidess() / r.count;
//		NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
		NSEventMask mask = NSMouseEnteredMask|NSMouseExitedMask|NSMouseMovedMask;
		[r eachWithIndex:^(id obj, NSInteger idx) {
			NSRect h = (NSRect) {  unit * idx, 0, unit, 22 };
			NSLog(@"fengshui by %ld : %@", idx, NSStringFromRect(h));
			AZSimpleView *s = [[AZSimpleView alloc]initWithFrame:h];
			s.backgroundColor = obj;
			[s trackFullView];
			[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask|NSMouseExitedMask handler:^NSEvent *(NSEvent *e) {
				NSLog(@"event: %@", e);
				return e;
			}];
			[_bar addSubview:s];
		}];
		_bar.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
		[_bar setHidden: YES];
		[_bar trackFullView];
		[NSEvent addGlobalMonitorForEventsMatchingMask:mask handler:^(NSEvent *d) {
			AZLOG(d);
			if (NSPointInRect(mouseLoc(), _bar.frame))
				_bar.isHidden ? [_bar fadeIn] : nil;
			else  !_bar.isHidden ? [_bar fadeOut] : nil;
				//			d.type == NSMouseExitedMask ? [_bar fadeOut] : [_bar fadeIn];
			AZLOG(@"entered or ewxit");
				//			return d;
		}];
		[self.contentView addSubview:_bar];
        [self setHidesOnDeactivate:NO];
        [self setCanHide:NO];
        [self setIgnoresMouseEvents:NO];
        [self setLevel:CGWindowLevelForKey(kCGCursorWindowLevelKey)];
        [self setOpaque: NO];
        [self setBackgroundColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.0]];
        [self setLevel:kCGStatusWindowLevel + 1];
			//      if ( [self respondsToSelector:@selector(toggleFullScreen:)] ) {
			//            [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
			//             NSWindowCollectionBehaviorTransient];
			//   	} else {
		[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces|NSWindowCollectionBehaviorStationary];
			//        }
        wid = [self windowNumber];
    }
    return self;
}

	//- (void)setFilter:(NSString *)filterName{
	//    if ( fid ){	CGSRemoveWindowFilter( cid, wid, fid );	CGSReleaseCIFilter( cid, fid );	}
	//    if ( filterName ) {	CGError error = CGSNewCIFilterByName( cid, (CFStringRef)filterName, &fid );
	//        if ( error == noErr ) 		{	CGSAddWindowFilter( cid, wid, fid, 0x00003001 );
	//}	}	}
	//
	//-(void)setFilterValues:(NSDictionary *)filterValues{
	//    if ( !fid ) {	return;		}
	//    CGSSetCIFilterValuesFromDictionary( cid, fid, (CFDictionaryRef)filterValues );
	//}

@end
