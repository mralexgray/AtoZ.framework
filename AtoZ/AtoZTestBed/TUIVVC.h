//
//  TUIV.h
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//


@interface TUIVVC : NSViewController <AHLayoutDataSource>

@property (STR) IBOutlet TUINSView *containerView;
@property (STR) TUIV* rootView;
@property AHLayout *horizontalLayout, *verticalLayout;

@prop_RO NSArray* visibleViews;
@prop_RO AHLayoutHandler reloadHandler;
- (IBAction)clearFaviconCache _ C ___
                              @end
