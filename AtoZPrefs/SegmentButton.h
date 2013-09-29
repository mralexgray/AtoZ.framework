//
//  SegmentButton.h
//  AtoZPrefs
//
//  Created by Josh Butts on 3/29/13.
//  Copyright (c) 2013 Josh Butts. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SegmentButton : NSSegmentedControl

@property (retain) NSString *serviceName;

@end

@interface ToggleButton : NSButton

@property (retain) NSString *serviceName;

@end
