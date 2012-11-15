//
//  AZMenuBarWindow.h
//  AtoZ
//
//  Created by Alex Gray on 10/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"


//@interface  Drawer : NSWindow
//@property (weak) NSView*leverView;
//@property (nonatomic,retain) NSView *bar;
//@property (nonatomic, strong) CAL *root;
//-(void) registerLevers:(NSView*)leverView;
//@end


typedef struct _AZRange {	NSI min;	NSI max;	} AZRange;

FOUNDATION_EXPORT AZRange   AZMakeRange ( 		NSI min,  NSI max      );
FOUNDATION_EXPORT NSUI      AZIndexInRange (	NSI fake, AZRange rng  );
FOUNDATION_EXPORT NSI   	AZNextSpotInRange (	NSI spot, AZRange rng  );
FOUNDATION_EXPORT NSI   	AZPrevSpotInRange (	NSI spot, AZRange rng  );
FOUNDATION_EXPORT NSUI      AZSizeOfRange ( 	AZRange rng            );




//I just came up with an even better way to do completion code for CAAnimations:
typedef void (^animationCompletionBlock)(void);
//And a key that I use to add a block to an animation:
#define kAnimationCompletionBlock @"animationCompletionBlock"
//typedef void (^animationCompletionBlock)(void);

//typedef void (^eventActionBlock (NSEvent*event));

@interface  NSWindow (BorderlessInit)
-(void) bordlerlessInit;
@end

@interface AZSemiResponderWindow : NSWindow


@property (NATOM, ASS) NSI unitOffset;
@property (NATOM, ASS) CGF unit;
@property (NATOM, ASS) NSP scrollPoint, dragStart, dragDiff;
@property (NATOM, ASS) NSR perfectRect;


@property (nonatomic,retain) NSMD *spots;
@property (nonatomic,retain) CAL *scrollLayer;
@property (weak) AZSimpleView *hoveredView;
@property (nonatomic,retain) NSView *bar, *drawerView;

@end
