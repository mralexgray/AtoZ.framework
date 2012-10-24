
//  AZWindowExtend.h
//  AtoZ

//  Created by Alex Gray on 8/6/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "AtoZ.h"

@class AZWindowExtend;
@interface AZWindowExtendController : NSObject
@property (weak) AZWindowExtend *window;
@end


@interface AZContentView : NSView
@end

@interface AZWindowExtend : NSWindow

//@property (nonatomic, retain) IBOutlet NSTextField *coordinates;
@property (weak) IBOutlet NSTextField *coordinates;

@property (NATOM, ASS) 	 CGPoint point;
@property (STRNG, NATOM) NSHashTable *eventViews;
@property (STRNG, NATOM) NSView	*contentV;

//- (void)addEventView:(NSView *)aView;
- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere;

@end
