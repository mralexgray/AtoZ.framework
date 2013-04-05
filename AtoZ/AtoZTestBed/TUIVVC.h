//
//  TUIV.h
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TUIVVC : NSViewController <AHLayoutDataSource>

@property (STRNG) IBOutlet TUINSView *containerView;
@property (STRNG) TUIV* rootView;
@property AHLayout *horizontalLayout, *verticalLayout;
@property (RONLY) NSArray* visibleViews;
@end
