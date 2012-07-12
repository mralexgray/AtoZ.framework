//
//  AZSimpleView.h
//  AtoZ
//
//  Created by Alex Gray on 7/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZSimpleView : NSView
{
	NSColor *backgroundColor;
	BOOL selected;
}

@property (nonatomic, retain) NSString *uniqueID;
@property (assign) BOOL selected;
@property (assign) int 	tag;
@property (strong) NSColor *backgroundColor;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
