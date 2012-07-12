//
//  AtoZAppDelegate.h
//  AZBoxTest
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>


@interface AtoZAppDelegate : NSObject <NSApplicationDelegate, AZSourceListDataSource>

//AZBoxGridDataSource, AZBoxGridDelegate,  AZBoxMagicDataSource>

@property IBOutlet NSScrollView *scroller;
@property int itemsCount;
@property IBOutlet AZSourceList *source;
@property IBOutlet NSWindow *window;
@property NSString *status;

//@property IBOutlet AZBoxGrid *boxGrid;
//@property IBOutlet AZBoxGrid *boxGrid2;
//@property IBOutlet AZBoxMagic *magic;


//infinite array test
@property (nonatomic, retain) IBOutlet NSColorWell *infiniteWell;
@property (nonatomic, retain) NSMutableArray *colorCycle;
@property (nonatomic, retain) NSMutableArray *infiniteViews;


//- (IBAction)reload:(id)sender;
//- (IBAction)log:(id)sender;
//- (IBAction)add:(id)sender;
//
//- (IBAction)save:(id)sender;
//- (IBAction)load:(id)sender;
//- (IBAction)init:(id)sender;
//
//
//- (NSUInteger)totalFilesToBeBoxedIn:(AZBoxMagic *)magicView;
//- (AZFile *)magicView:(AZBoxMagic *)magicView fileForIndex:(NSUInteger)index;

@end
