
//  AZSoftButton.h
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Foundation/Foundation.h>
#import "AtoZ.h"

@interface AZLassoView : NSView
{
	NSTrackingArea *trackingArea;
}
@property (readonly) float dynamicStroke;
@property (nonatomic, retain) NSString *uniqueID;
@property (nonatomic, assign) BOOL 	selected;
/*** YES if the mouse is hovering over cell, otherwise NO.  **/
@property (nonatomic, assign) BOOL 	nooseMode;
@property (nonatomic, assign) BOOL 	hovered;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float inset;
@property (nonatomic, strong) id 	representedObject;

@end
