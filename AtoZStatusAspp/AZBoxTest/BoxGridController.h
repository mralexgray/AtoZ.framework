//
//  BoxGridController.h
//  AtoZStatusApp
//
//  Created by Alex Gray on 7/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxGridController : NSObject
<AZBoxGridDataSource, 	AZBoxGridDataSource>
{
	AZBoxGrid *grid;
	IBOutlet NSScrollView *scroller;
	IBOutlet NSView *rootView;
	IBOutlet AZToggleView *bar;
//    IBOutlet NSTextField *textField;
}

@property (nonatomic, retain)  IBOutlet AZBoxGrid *grid;
@property (nonatomic, retain)  IBOutlet NSScrollView *scroller;



@end
