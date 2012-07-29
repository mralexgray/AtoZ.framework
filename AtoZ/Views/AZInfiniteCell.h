//
//  AZInfiniteCell.h
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@class AZFile;
@interface AZInfiniteCell : NSView

@property (assign) 			  BOOL 		selected;
@property (assign) 			  BOOL 		hovered;
@property (assign) 			  BOOL 		hasText;
@property (nonatomic, strong) NSColor 	*backgroundColor;
@property (nonatomic, strong) NSString 	*uniqueID;
@property (nonatomic, strong) NSImage 	*image;
@property (nonatomic, strong) AZFile	*file;

//@property (nonatomic, strong) AJSiTunesAPI *itunesApi;
//@property (nonatomic, strong) NSArray *itunesResults;

@end
