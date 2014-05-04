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

- (void) miniSuite:(id<RectLike>)testee {

  STAssertTrue(testee.width     == 200, @"got %f", testee.width);
  STAssertTrue(testee.height    == 200, @"got %f", testee.height);
  STAssertTrue(testee.h         == 200, @"got %f", testee.h);
  STAssertTrue(testee.w         == 200, @"got %f", testee.w);
  STAssertTrue(testee.x         == 100, @"got %f", testee.x);
  STAssertTrue(testee.y         == 100, @"got %f", testee.y);
  STAssertTrue(testee.maxX      == 300, @"got %f", testee.maxX);
  STAssertTrue(testee.maxY      == 300, @"got %f", testee.maxY);
  STAssertTrue(testee.area      == 40000, @"got %f", testee.area);
  STAssertTrue(testee.perimeter == 800, @"got %f", testee.perimeter);
}

- (void)testExistenceAndEquality {

  STAssertTrue(w && azr && v && l, @"none may be nil!");
  STAssertTrue(NSEqualRects(w.r, azr.r), @"%@ %@", AZString(w.r),AZString(azr.r));
  STAssertTrue(NSEqualRects(v.r, azr.r), @"%@ %@", AZString(v.r),AZString(azr.r));
  STAssertTrue(NSEqualRects(v.r, l.r), @"%@ %@", AZString(v.r),AZString(l.r));

   STAssertTrue(AZEqualRects(w.r, azr.r, v.r, l.r), @"%@ %@ %@ %@",
        AZString(w.r),AZString(azr.r),AZString(v.r),AZString(l.r));
}

- (void) testWindowConformance {
  [self miniSuite:w];
}
- (void) testLayerConformance {
  [self miniSuite:l];
}
- (void) testViewConformance {
  [self miniSuite:v];
}
- (void) testAZRConformance {
  [self miniSuite:azr];
}


- (void) testSupeframe {
  [w setSuperframe:AZScreenFrameUnderMenu()];
  STAssertTrue(w.insideEdge & AZTop|AZRgt, @"should be at bottom left, was %@", AZAlignToString(w.insideEdge));
  printf("\n\n%s\n\n%s", w.insideEdgeHex.UTF8String, AZAlignByHex().cDesc);
//  printf("\n\n%s\n\n%s", w.insideEdgeHex.UTF8String, AZAlignByValue().cDesc);

}


@end
