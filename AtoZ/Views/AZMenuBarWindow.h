//
//  AZMenuBarWindow.h
//  AtoZ
//
//  Created by Alex Gray on 10/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"


//@interface  Drawer : NSWindow
//@property (weak) NSView*leverView;
//@property (nonatomic,retain) NSView *bar;
//@property (nonatomic, strong) CAL *root;
//-(void) registerLevers:(NSView*)leverView;
//@end


@interface  NSWindow (BorderlessInit)
-(void) bordlerlessInit;
@end

@interface AZMenuBarWindow : NSWindow
{
//@private
	long wid;
	void * fid;
//	NSHashTable *_clickViews;
}

//- (void)addClickView:(AZSimpleView *)aView;
//@property (nonatomic, retain) Drawer *drawer;

@property (NATOM, ASS) NSI unitOffset;
@property (NATOM, ASS) CGF unit;
@property (NATOM, ASS) NSP scrollPoint, dragStart, dragDiff;
@property (NATOM, ASS) NSR perfectRect;


@property (nonatomic,retain) NSMD *spots;
@property (nonatomic,retain) CAL *scrollLayer;
@property (weak) AZSimpleView *hoveredView;
@property (nonatomic,retain) NSView *bar, *drawerView;

@end
