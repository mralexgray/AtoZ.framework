
//  AZ4PartObject.h
//  AtoZ

//  Created by Alex Gray on 8/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
#import "AZEntitlementDelegate.h"
#import "AZQuadCell.h"

//@class AZEntitlementDelegate;
@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>
//{ NSRange northern, southern, eastern, western;	}
@property (nonatomic, assign) NSUInteger tilt;
//@property (nonatomic, strong) NSMutableArray* content;
@property (weak) id refToSelf;
@property (nonatomic, assign) NSUInteger iconStyle;
//@property (nonatomic, assign) iCarouselType type;

@property (nonatomic, strong) AZTrackingWindow *north;
@property (nonatomic, strong) AZTrackingWindow *south;
@property (nonatomic, strong) AZTrackingWindow *east;
@property (nonatomic, strong) AZTrackingWindow *west;
@property (nonatomic, assign) CGFloat intrusion;

@property (nonatomic, strong) iCarousel *menu_N;
@property (nonatomic, strong) iCarousel *menu_S;
@property (nonatomic, strong) iCarousel *menu_E;
@property (nonatomic, strong) iCarousel *menu_W;

@property (nonatomic, strong)  NSArray 	 *menus;
@property (nonatomic, strong)  NSArray 	 *quads;

//@property (nonatomic, assign) NSUInteger visibleItems;
@property (nonatomic, assign) NSUInteger selectedIndex;
//@property (unsafe_unretained)) iCarousel *activeMenu;
@property (nonatomic, strong) NSString *activeMenuID;
@property (nonatomic, strong) NSString *activeQuadID;
@property (nonatomic, strong) NSString *windowLog;
//@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) IBOutlet NSMutableArray *items;
@property (nonatomic, strong) IBOutlet NSArray *southWest;
@property (nonatomic, strong) IBOutlet NSArray *northEast;

@property (nonatomic, retain) AZSegmentedRect *seg;
@property (nonatomic, assign) Option option;

-(void) advance;
-(void) rewind;

- (IBAction)toggleQuad:(id)sender;
- (IBAction)setVeils:(id)sender;
- (IBAction)setType:(id)sender;
@property (assign, nonatomic)	iCarouselType cType;

@property (nonatomic, assign) CGFloat fontSize;
@end

//@property (weak) IBOutlet AZEntitlementDelegate *entitler;
//@property (nonatomic, strong) AZSizer *szr;
//- (id) 		 	objectAtIndex: 	 (NSUInteger)	index 			inQuad:(AZWindowPosition)quadrant;
//- (NSUInteger) 	itemsInQuad:		 (AZWindowPosition)		quadrant;
//- (NSArray*) 	contentsOfQuad:  (AZWindowPosition)		quadrant;
//- (void) 	 	insertItem:	 	 (id)			item;
//- (void) 	 	insertItems:	 	 (NSArray*)	items;
//- (NSRange)		ofQuad:			 (AZWindowPosition)quadrant;

//- (void) removeItem:(id)item;
//- (void) removeItems:(NSArray*)items;
