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
@interface AZVeil : NSObject <NSWindowDelegate>
{
	NSTimer *refreshWhileActiveTimer;
}

@property (weak) IBOutlet NSWindow *leveler;
@property (weak) IBOutlet TransparentWindow *shroud;
@property (weak) IBOutlet TransparentWindow *window;
@property (weak) IBOutlet NSImageView* view;
@property (nonatomic, assign) ShroudIs shroudState;
//@property (nonatomic, assign) NSRect unPushedScreenRect;
//@property (nonatomic, assign) NSRect menuLessScreen;
@property (nonatomic, assign) NSRect barFrame;
@property (nonatomic, assign) NSRect barFrameUp;
//@property (nonatomic, assign) NSRect flippedSnapRect;


//@property (nonatomic, assign) NSRect upFrame;
//@property (nonatomic, assign) NSRect dnFrame;

	//+ (instancetype) instanceWithClass:(Class)class named:(NSString*)name;
@end

