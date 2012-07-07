//
//  AZButton.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZButtonCell : NSButtonCell
@property (nonatomic, retain) NSColor *color;
@property (assign) BOOL isTopTab;
@end


@interface AZButton : NSButton

@end
