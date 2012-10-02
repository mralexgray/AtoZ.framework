//
//  AZMenuBarWindow.h
//  AtoZ
//
//  Created by Alex Gray on 10/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZMenuBarWindow : NSWindow
{
@private
	long wid;
	void * fid;
}

@property (nonatomic,retain) AZSimpleView *bar;
@end
