//
//  SenTestLog+RedGreen.h
//  RedGreen
//
//  Created by Neil on 20/04/2013.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SenTestLog (RedGreen)

+ (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end
