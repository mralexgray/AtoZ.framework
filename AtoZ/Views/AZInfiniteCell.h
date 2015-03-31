
//  AZInfiniteCell.h
//  AtoZ

//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <AtoZ/AtoZ.h>
@class AZFile;
@interface AZInfiniteCell : NSView
{
	NSTrackingArea *tArea;		NSBezierPath *standard;
 	float mPhase;  				float all;
	NSTextView *tv;				NSTimer *timer;
	NSButton *close;
	NSImage *image;
	NSColor *color;
}
@prop_RO float dynamicStroke;

@property (assign) 			  BOOL 		selected;
@property (assign) 			  BOOL 		hovered;
@property (assign) 			  BOOL 		hasText;
@property (nonatomic, strong) NSColor 	*backgroundColor;
@property (nonatomic, strong) NSString 	*uniqueID;
@property (nonatomic, strong) AZFile	*file;

@property (NA, ASS) float radius;
@property (NA, ASS) float inset;
@property (nonatomic, strong) id 	representedObject;
@property (nonatomic, readonly) NSString *cellIdentifier;

//@property (nonatomic, strong) NSImage 	*image;
//@property (nonatomic, strong) NSAttributedString *string;
//@property (nonatomic, strong) NSTrackingArea *tArea;
//@property (nonatomic, strong) AJSiTunesAPI *itunesApi;
//@property (nonatomic, strong) NSArray *itunesResults;
@end
