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
@interface AZVeil : NSObject
{
	NSTimer *refreshWhileActiveTimer;
	NSRect unPushedScreenRect, pushedScreenRect, barFrame, barFrameUp, flippedSnapRect;
}
@property (nonatomic, assign) IBOutlet NSWindow *leveler;
@property (nonatomic, assign) IBOutlet TransparentWindow *shroud;
@property (nonatomic, assign) IBOutlet TransparentWindow *window;
@property (nonatomic, assign) IBOutlet NSImageView* view;
@property (nonatomic, assign) ShroudIs shroudState;


//@property (nonatomic, assign) NSRect upFrame;
//@property (nonatomic, assign) NSRect dnFrame;

	//+ (instancetype) instanceWithClass:(Class)class named:(NSString*)name;
@end

