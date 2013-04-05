//
//  TUIView+Dimensions.h
//  AtoZ
//
//  Created by Alex Gray on 4/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@interface TUIView (Dimensions)

// Size
@property (nonatomic, assign) CGF width;
@property (nonatomic, assign) CGF height;
@property (nonatomic, assign) NSSZ size;

- (void) setWidth:  (CGF) t;
- (void) setHeight: (CGF) t;
- (void) setSize:   (NSSZ) size;

@end

@interface TUIView (Subviews)

- (void) setSubviews:  (NSA*) subs;

@end
