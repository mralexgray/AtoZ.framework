
//  AZ4PartObject.h
//  AtoZ

//  Created by Alex Gray on 8/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
#import "AZEntitlementDelegate.h"
#import "AZQuadCell.h"

@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>

@property (assign, nonatomic) iCarouselType cType;
@property (nonatomic, assign) CGFloat fontSize,intrusion;;
@property (nonatomic, assign) NSUInteger iconStyle, selectedIndex, tilt;

@property (nonatomic, strong) IBOutlet NSMutableArray *items;
@property (nonatomic, retain) AZSegmentedRect *seg;
@property (nonatomic, assign) Option option;

- (IBAction) toggleQuadFlip: (id)sender;
- (IBAction) toggleQuad:	 (id)sender;
- (IBAction) setVeils:		 (id)sender;
- (IBAction) setType:		 (id)sender;

@property (weak) id refToSelf;

-(void) advance;
-(void) rewind;
@end


//@property (nonatomic, strong) IBOutlet NSArray *southWest;
//@property (nonatomic, strong) IBOutlet NSArray *northEast;
//@property (nonatomic, assign) iCarouselType type;
//@property (nonatomic, strong) NSMutableArray* content;
//@property (nonatomic, strong) AZTrackingWindow *floater;
//@property (nonatomic, assign) NSUInteger visibleItems;
//@property (unsafe_unretained)) iCarousel *activeMenu;
//@property (nonatomic, assign) BOOL wrap;

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
