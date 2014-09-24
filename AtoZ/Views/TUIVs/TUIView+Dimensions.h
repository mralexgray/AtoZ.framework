//
//  TUIView+Dimensions.h
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUmbrella.h"

#import <TwUI/TwUI.h>

@interface TUIView (Dimensions)


// Size
@property (nonatomic) CGF width;
@property (nonatomic) CGF height;
@property (nonatomic) NSSZ size;
@property (nonatomic) CGF originX, originY;

- (void) setWidth:  (CGF) t;
- (void) setHeight: (CGF) t;
- (void) setSize:   (NSSZ) size;

@end

@interface TUIView (BezierPaths)
@property (NATOM, STRNG) NSBP *path;
- (void) setPath:(NSBP*) path;
@end

@interface TUIView (Subviews)

- (void) setSubviews:  (NSA*) subs;

@end
