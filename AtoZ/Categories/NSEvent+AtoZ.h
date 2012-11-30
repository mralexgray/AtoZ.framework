//
//  NSEvent+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/23/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>





typedef void(^NSControlVoidActionBlock)(void);

typedef void(^NSControlActionBlock)(id inSender);

@interface NSControl (AtoZ)

@property (readwrite, nonatomic, copy) NSControlActionBlock actionBlock;
@property (readwrite, nonatomic, copy) NSControlVoidActionBlock voidActionBlock;

- (void) setAction:(SEL)method withTarget:(id)object;
- (void) setActionString:(NSS*)methodasString withTarget:(id)object;
@end

@interface NSEvent (AtoZ)

+ (void) shiftClick:(void(^)(void))block;

@end


@interface NSTV (TargetAction)

@property (readwrite, nonatomic, copy) NSControlVoidActionBlock doubleActionBlock;

- (void) setDoubleAction:(SEL)method withTarget:(id)object;
- (void) setDoubleActionString:(NSS*)methodasString withTarget:(id)object;
- (void) setDoubleActionBlock:(NSControlVoidActionBlock)block;

@end
