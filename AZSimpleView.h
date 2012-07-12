//
//  AZSimpleView.h
//  AtoZ
//
//  Created by Alex Gray on 7/12/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AZSimpleView : NSView

@property (nonatomic, retain) NSString *uniqueID;
@property (assign) BOOL selected;
@property (strong) NSColor *backgroundColor;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
