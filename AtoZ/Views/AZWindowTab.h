//
//  AZWindowTab.h
//  AtoZ
//
//  Created by Alex Gray on 5/21/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZWindowTab : NSWindow
+   (id) tabWithViewClass:(Class)k;
-   (id) initWithView:(NSView*)c orClass:(Class)k frame:(NSR)r;
@property (STR) NSV	*view;
@property (ASS) CGP drgStrt, wOrig;
@property (STR, NATOM) AZRect	*inFrame, *outFrame, *grabRect;
@property (RONLY) OSCornerType outsideCorners;


@property (NATOM,STR) AZRect		*outerRect;
@property (NATOM,STR) NSNumber	*grabInset;
@property (NATOM) AZSlideState 	slideState;
@property (NATOM) AZA 				insideEdge;
@property (NATOM) NSP 	    		offset;

//@property (CP)	void (^rezhzuhz)(void);
//+ (NSA*) tabRects;
//+ (NSA*) tabs;



@end
