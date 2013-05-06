//
//  AtoZTests.h
//  AtoZTests
//
//  Created by Alex Gray on 6/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <AtoZ/AtoZ.h>

@interface NSAlpha : AtoZ
@end
@interface NSBravo : AtoZ
@end
@interface NSCharlie : NSBravo
@end

@interface AtoZTestCase : NSObject
- (void)runTests;
@end

@interface AtoZTest : SenTestCase
- (NSString *)stringFromClass;
@end

