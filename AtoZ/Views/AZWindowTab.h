//
//  AZWindowTab.h
//  AtoZ
//
//  Created by Alex Gray on 5/21/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAWindow.h"
#define AZR     AZRect
#define AZP     AZPOS
#define qP      quartzPath
#define AZSLDST AZSlideState
#define AZWT    AZWindowTab
#define AZWTV   AZWindowTabViewPrivate


@interface AZWindowTabViewPrivate : NSView
@property (STR) 				   CAL * contentLayer,
											 * tabLayer;
@property (RONLY)   			 NSIMG * indicator;
@property (RONLY) 		   	NSR	tabRect;
@property (CP) void(^closedTabDrawBlock)(NSRect tabRect);
@end

@interface 				 AZWindowTab : NSWindow
{ 										CGP	_drgStrt,
												_wOrig,
												_offset;
}

@property (STR,NATOM)		AZRect * inFrame,
											 * outFrame,
											 * grabRect,
											 * outerRect;
@property (NATOM)	 			   AZA	insideEdge; // !!!
@property (NATOM) 	AZSlideState 	slideState; // !!!
@property (NATOM)             CGF	grabInset;

@property (RONLY)    OSCornerType 	outsideCorners;

+   (id) tabWithViewClass:				  (Class)k;
-   (id) initWithView:(NSV*)c	orClass:(Class)k	frame:(NSR)r;
@end

//@property (STR) 			AZWindowTabController	*vc;
@interface AZWindowTabController : NSArrayController <NSWindowDelegate>
@end


//@property (CP)	void (^rezhzuhz)(void);
//+ (NSA*) tabRects;
//+ (NSA*) tabs;
