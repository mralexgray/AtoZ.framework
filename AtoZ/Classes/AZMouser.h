//
//  AZMouser.h
//  AtoZ
//
//  Created by Alex Gray on 7/15/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <AtoZ/AtoZ.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AppKit/AppKit.h>

@interface AUWindowExtend : NSWindow
- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere;
@end
@interface AZMouserIndicator : NSView
@property (nonatomic, retain) NSImage *indicatorImage;
@end
@interface AZMouserWindow : NSWindow
@property (assign) NSPoint initialLocation;
@property (assign) AZMouserIndicator *indicatorView;
@end
@interface AZMouser : BaseModel
@property (nonatomic, retain) AZMouserWindow *window;

@end
