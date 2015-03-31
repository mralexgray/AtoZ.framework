//
//  RectLikeTests.m
//  AtoZ
//
//  Created by Alex Gray on 5/4/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

@import XCTest;
@import AtoZUniversal;

@interface RectLikeTests : XCTestCase @end

@implementation RectLikeTests { NSWindow *w; AZR *azr; CAL* l; NSV* v; }

- (void)setUp {  [super setUp];

  w   = [NSW x:100 y:100 w:200 h:200];

  azr = [AZR withRect:_Rect_ {100, 100, 200, 200}];

  v   = [NSV rectLike:@100,@100,@200,@200, nil]; // Nice factory method for all RectLike Objects!

  l   = [CAL withRect: AZRectOffsetFromDim(AZRectFromDim(200),100)];

  [@[w, azr, v, l] do:^(id obj) {
    XCTAssertNotNil(obj, @"test obects should exist, but %@ didnt", [obj className]);
  }];
}

#define TesteeWas @"%@ was %f", [_NObj_ testee className]

- (void) miniSuite:(id<RectLike>)testee {

  XCTAssertTrue(testee.width     == 200,   TesteeWas, testee.width);
  XCTAssertTrue(testee.height    == 200,   TesteeWas, testee.height);
  XCTAssertTrue(testee.h         == 200,   TesteeWas, testee.h);
  XCTAssertTrue(testee.w         == 200,   TesteeWas, testee.w);
  XCTAssertTrue(testee.x         == 100,   TesteeWas, testee.x);
  XCTAssertTrue(testee.y         == 100,   TesteeWas, testee.y);
  XCTAssertTrue(testee.maxX      == 300,   TesteeWas, testee.maxX);
  XCTAssertTrue(testee.maxY      == 300,   TesteeWas, testee.maxY);
  XCTAssertTrue(testee.area      == 40000, TesteeWas, testee.area);
  XCTAssertTrue(testee.perimeter == 800,   TesteeWas, testee.perimeter);
}

- (void)testExistenceAndEquality {

  XCTAssertTrue(w && azr && v && l, @"none may be nil!");
  XCTAssertTrue(NSEqualRects(w.r, azr.r), @"%@ %@", AZString(w.r),AZString(azr.r));
  XCTAssertTrue(NSEqualRects(v.r, azr.r), @"%@ %@", AZString(v.r),AZString(azr.r));
  XCTAssertTrue(NSEqualRects(v.r, l.r), @"%@ %@", AZString(v.r),AZString(l.r));

   XCTAssertTrue(AZEqualRects(w.r, azr.r, v.r, l.r), @"%@ %@ %@ %@",
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

  XCTAssertTrue(w.insideEdge &
                  AZTop | AZRgt,
                  @"should be at bottom left, was %@",
                  AZAlignToString(w.insideEdge)
  );
//  printf("\n\n%s\n\n%s", w.insideEdgeHex.UTF8String, AZAlignByHex().cDesc);
//  printf("\n\n%s\n\n%s", w.insideEdgeHex.UTF8String, AZAlignByValue().cDesc);

}

- (void) testIteration {   __block int ctr = 0;

  [AZRBy(4,4) iterate:^(_Cord p) {

    dispatch_uno(

      XCTAssert(NSEqualPoints(p, NSZeroPoint), @"First iteration should be 0,0, was %@", NSStringFromPoint(p));
    );

    if (ctr++ == 16) XCTAssert(NSEqualPoints(AZPt(4,4), p), @"last pt fhould be 4,4?");
  }];
  XCTAssert(ctr == 16, @"should iterate 16 times., got %i", ctr);
}

@end
