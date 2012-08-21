
//
//  AppDelegate.h
//  AtoZ Encyclopedia
//
//  Created by Alex Gray on 8/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

#import "iCarouselViewController.h"

#import "SDToolkit.h"
#import "SDCommonAppDelegate.h"
//#import "IsometricView.h"
#import "AZStatusItemView.h"

#define kCompositeIconHeight 155.0
#define kIconWidth 128.0
#define kFontHeight 25.0
#define kMargin 30.0


@interface AZEncyclopediaDelegate : SDCommonAppDelegate <NSApplicationDelegate, NSWindowDelegate, AZSourceListDataSource, AZToggleArrayViewDelegate, AZStatusItemDelegate	>
{
	AZStatusItemView *statusView;

//	IBOutlet NSMatrix *matrix;
//	IBOutlet NSTextField *selectedItemLabel;
	NSArray *sourceListItems;
	IBOutlet AZSourceList *sourceList;
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	NSMutableArray *noteControllers;
}

@property (assign, nonatomic) 	IBOutlet NSProgressIndicator *pIndi;
@property (assign, nonatomic)   IBOutlet TransparentWindow *controlWindow;
//@property (nonatomic, retain)  IBOutlet NSWindow *attachedWindow;

- (IBAction) addNote:(id)sender;
- (IBAction) removeAllNotes:(id)sender;
- (IBAction) goMouseTest:(id)sender;
- (IBAction) reload:(id)sender;
- (IBAction) moveThemAll:(id) sender;
- (IBAction) cancel:(id) sender;


@property (assign, nonatomic) CGRect scaledUnit;
@property (nonatomic, strong) IBOutlet iCarouselViewController *vc;


//@property (nonatomic, retain) IBOutlet AtoZInfinity *infinityView;
//@property (nonatomic, strong) AZWindowExtend *window;
//@property (assign) IBOutlet NSView *rootView;
@property (strong, nonatomic) NSNumber *scale;

//@property (assign) IBOutlet NSView *isoView;
@property (assign) IBOutlet TransparentWindow *window;
@property (weak, nonatomic) IBOutlet NSView *mouseTest;
@property (weak, nonatomic) IBOutlet NSMatrix *mouseAction;
@property (weak, nonatomic) IBOutlet NSTextField *point1x;
@property (weak, nonatomic) IBOutlet NSTextField *point1y;
@property (weak, nonatomic) IBOutlet NSTextField *point2x;
@property (weak, nonatomic) IBOutlet NSTextField *point2y;

@property (weak, nonatomic) IBOutlet NSTextField *coords;

//@property (retain) CALayer *root;
//@property (retain) CALayer *contentLayer;
//@property (retain) NSArray *demos;

@property (nonatomic, strong) IBOutlet AZToggleArrayView   *sortToggle;

//-(IBAction)toggleShake:(id)sender;

@end
/*
@class Cell;
@interface MineField : NSObject {
    NSMutableArray *cells; // grid of cells
    int numMines;          // total number of mines
    int numExposedCells;   // num of cells exposed
    BOOL kablooey;         // mine field detonated
}

@property(readonly) int numMines;
@property(readonly) int numExposedCells;
@property(readonly) BOOL kablooey;

-(id)initWithWidth:(int)w Height:(int)h Mines:(int)m;
-(int)width;
-(int)height;
-(Cell*)cellAtRow:(int)r Col:(int)c;
-(void)reset;
-(int)unexposedCells;
-(int)exposeCellAtRow:(int)r Col:(int)c;
-(BOOL)autoExposeCellAtRow:(int)r Col:(int)c;

@end


@interface Cell : NSObject {
    BOOL hasMine; // cell has a mine
    BOOL exposed;   // cell has been exposed (may or may not have mine)
    BOOL marked;    // cell marked as having a mine (perhaps incorrectly)
    char numSurroundingMines;  // number of mines in 8 neighbors
}

@property(readwrite) BOOL hasMine;
@property(readwrite) BOOL exposed;
@property(readwrite) BOOL marked;
@property(readwrite) char numSurroundingMines;

-(id)init;

@end

*/