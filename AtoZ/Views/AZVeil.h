//
//  ShroudWindow.h
//  AtoZ
//
//  Created by Alex Gray on 8/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"
@class  TransparentWindow;
typedef enum { 	ShroudIsUp, ShroudIsDown} ShroudIs;
@interface AZVeil : NSObject <NSWindowDelegate, NSApplicationDelegate, NSSplitViewDelegate>
{
	NSTimer *refreshWhileActiveTimer;
}

//@property (nonatomic, assign) NSRect flippedSnapRect;


//@property (nonatomic, assign) NSRect upFrame;
//@property (nonatomic, assign) NSRect dnFrame;

	//+ (instancetype) instanceWithClass:(Class)class named:(NSString*)name;
@end

