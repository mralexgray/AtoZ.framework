//
//  NSEvent+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface NSTextField (TargetAction)

- (void) setAction:(SEL)method withTarget:(id)object;

@end

@interface NSControl (AtoZ)

- (void) setAction:(SEL)method withTarget:(id)object;

@end

@interface NSEvent (AtoZ)

+ (void) shiftClick:(void(^)(void))block;

@end
