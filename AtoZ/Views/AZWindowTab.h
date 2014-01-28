//
//  AZWindowTab.h
//  AtoZ
//
//  Created by Alex Gray on 5/21/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAWindow.h"
#define AZR     AZRect
//#define AZP     AZPOS
#define qP      quartzPath
#define AZSLDST AZSlideState
#define AZWT    AZWindowTab
#define AZWTV   AZWindowTabViewPrivate


@interface AZWindowTabController : NSArrayController <NSWindowDelegate>
@end

@interface 				 AZWindowTab : NSWindow
//+ (id) tabWithViewClass:(Class)k;
//- (id)initWithView:(NSV *)v orClass:(Class)k frame:(NSR)r;
-(id) init;

@property (nonatomic) NSSZ inSize, outSize;
@property (nonatomic) NSView *view;
@property (readonly)  NSView *handle;

@end

//@property (STR) 			AZWindowTabController	*vc;
//+   (id) tabWithViewClass:				  (Class)k;
//-   (id) initWithView:(NSV*)c	orClass:(Class)k	frame:(NSR)r;
//@property (CP)	void (^rezhzuhz)(void);
//+ (NSA*) tabRects;
//+ (NSA*) tabs;
