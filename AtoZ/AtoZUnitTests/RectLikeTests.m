//
//  RectLikeTests.m
//  AtoZ
//
//  Created by Alex Gray on 5/4/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <AtoZ/AtoZ.h>

@interface RectLikeTests : SenTestCase @end

@implementation RectLikeTests { NSWindow *w; AZR *azr; CAL* l; NSV* v; }

- (void)setUp {  [super setUp];

    w   = [NSW              x:100 y:100 w:200 h:200];
    azr = [AZR       withRect:(NSR){100,100,200,200}];
    v   = [NSV       rectLike:@100,@100,@200,@200, nil];
    l   = [CAL layerWithFrame:(NSR){100,100,200,200}];

}
- (void)testExistenceAndEquality {

    STAssertTrue(w && azr && v && l, @"none may be nil!");
    STAssertTrue(AZEqualRects(w.r, azr.r, v.r, l.r), @"all rects must be the same!!");
}

@end
