//
//  AtoZObjC.m
//  AtoZObjC
//
//  Created by Alex Gray on 6/4/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import "AtoZObjC.h"

@implementation AtoZObjC



- (id) init { if (!(self=super.init)) return self;


	[self testTHObserverValueTransform];
	
	return self;
}

- (void) testTHObserverValueTransform {


 NSMutableDictionary *testFrom = [NSMutableDictionary dictionaryWithObject:@1 forKey:@"testFromKey"];
    NSMutableDictionary *testTo = [NSMutableDictionary dictionaryWithObject:@0 forKey:@"testToKey"];
    
    THBinder *binder = [THBinder binderFromObject:testFrom keyPath:@"testFromKey"
                                         toObject:testTo keyPath:@"testToKey"
                              transformationBlock:^id(id value) {
                                  return @([value integerValue] + 5);
                              }];
    
    testFrom[@"testFromKey"] = @5;
	 playTrumpet();
	 
    [binder stopBinding];


}
@end
