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





//I just came up with an even better way to do completion code for CAAnimations:
typedef void (^animationCompletionBlock)(void);
//And a key that I use to add a block to an animation:
#define kAnimationCompletionBlock @"animationCompletionBlock"
//typedef void (^animationCompletionBlock)(void);

//typedef void (^eventActionBlock (NSEvent*event));

@interface  NSWindow (BorderlessInit)
-(void) bordlerlessInit;
@end

@protocol  AZSemiResponder
@optional
-(void) windowEvent:(NSEvent*)event;
@end

@interface AZSemiResponderWindow : NSWindow

//@property (NATOM, STRNG) BLKVIEW *contentBlock;

@property (NATOM, STRNG) CAL *hit, *content, *root;
@property (NATOM, ASS)   NSR inactiveRect;
@property (NATOM, ASS)  NSP  scrollPoint, dragStart, dragDiff;
@property (NATOM, ASS)  BOOL dragging, noHit;

@property (ASS)  id <AZSemiResponder> semiResponder;

@property (NATOM, ASS) NSI unitOffset;
@property (NATOM, ASS) CGF unit;
@end


//@property (NATOM, ASS) NSR perfectRect;


//@property (nonatomic,retain) NSMD *spots;
//@property (nonatomic,retain) CAL *scrollLayer;
//@property (nonatomic,retain) NSView *bar, *drawerView;


