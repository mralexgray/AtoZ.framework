
#import <XCTest/XCTest.h>

#import <AtoZ/AtoZ.h>

AZTESTCASE(CALayerTests) 
{
   NSV * _view;
   CAL * _layer,
       * _noHitLayer;
 CASHL * _shapeLayer;
   NSP   _point;
    id   _hit;
}

- (void) setUp { [super setUp];

  _view             = [NSView viewBy:@100,nil];
  _layer            = _view.setupHostView;
  _layer.sublayers  = @[_noHitLayer = [CAL noHitLayerWithFrame:AZRectFromDim(100)],
                        _shapeLayer = [CASHL    layerWithFrame:AZRectFromDim( 50)]];

  XCTAssertTrue(_view && _layer && _view.layer == _layer && _noHitLayer && _shapeLayer, @"should all exist");
}

- (void) testSettingSuperlayer {

  XCTAssertNotNil(_shapeLayer.superlayer, @"shapeLayer is in the heirarchy, but superlayer was %@", _shapeLayer.superlayer);
  _shapeLayer.superlayer = nil;
     XCTAssertNil(_shapeLayer.superlayer, @"shapeLayer should have been removed, but superlayer is %@", _shapeLayer.superlayer);
    XCTAssertTrue(_shapeLayer.siblingIndexMax == -1, @"outside of heirarchy, siblingIndexMax is 0, but was %lu", _shapeLayer.siblingIndexMax);
}
- (void) testNoHit { /* OK! */

               _point = AZPointFromDim(23);
  XCTAssertEqual(_hit = [_layer hitTest:_point], _shapeLayer, @"Hittest at 50 should hit shape, but it hit:%@", _hit);
                 _hit = nil;
  _shapeLayer.superlayer = nil;
  XCTAssertEqual(_hit = [_layer hitTest:_point], _layer, @"Hittest at 50 with shape removed should hit layer, but it hit:%@", _hit);
    _noHitLayer.noHit = NO;
  XCTAssertEqual(_hit = [_layer hitTest:_point], _noHitLayer, @"Hittest at 50 with nohit set TO HIT should hit noHit, but it hit:%@", _hit);
}

- (void) testSublings {

    XCTAssertNil(_layer.siblings,               @"layer has no sisters or bros, but found %@",                     _layer.siblings);
   XCTAssertTrue(_shapeLayer.siblingIndex == 1, @"shape is sibling 1, got %lu",                           _shapeLayer.siblingIndex);
  XCTAssertFalse(_shapeLayer.siblingIndexIsEven,@"shape is sibling 1, odd, got %@", StringFromBOOL(_shapeLayer.siblingIndexIsEven));

   XCTAssertTrue(_noHitLayer.siblingIndex    == 0,  @"nohit is sibling 0, got %lu",                                        _noHitLayer.siblingIndex);
   XCTAssertTrue(_noHitLayer.siblingIndexIsEven,    @"_noHitLayer is sibling 0, even, got %@",       StringFromBOOL(_noHitLayer.siblingIndexIsEven));
   XCTAssertTrue(_noHitLayer.siblingIndexMax == 1,  @"shape and nohit are eachothers only siblings, max is 1, got %lu", _noHitLayer.siblingIndexMax);

  XCTAssertEqualObjects(@[_layer], _shapeLayer.superlayers, @"shape's superlayers array is just layer..  got %@", _shapeLayer.superlayers);

  __block NSInteger newIndex = -1, newCount = -1;

  [_noHitLayer addObserverForKeyPath:@"siblingIndexMax" task:^(id l) { newIndex = [l siblingIndexMax]; }];
  [_noHitLayer.superlayer addSublayer:CAL.layer];

  XCTAssertTrue(WaitFor(^BOOL { return newIndex != -1; }), @"still waiting");
  XCTAssertTrue( newIndex == 2, @"new max should be 2, got %ld", newIndex);
  XCTAssertTrue(_noHitLayer.siblings.count == 2, @"new sibling ct should be 2, got %ld", _noHitLayer.siblings.count);

  [_noHitLayer addObserverForKeyPath:@"siblings" task:^(id l) { newCount = [l siblings].count; }];
  [_noHitLayer.superlayer addSublayer:CAL.layer];

  XCTAssertTrue(WaitFor(^BOOL { return newCount != -1; }), @"still waiting");
  XCTAssertTrue(newCount == 3, @"");
}

- (void) testDependentPropertyBinding { CAL *hoster = CAL.new, *l = CAL.new;

   XCTAssertNil(l.name, @"name should be nil, was %@", l.name);
  XCTAssertTrue(l.siblingIndexParity == AZUndefined, @"indexParity should be undefined, got %@", AZParity2Text(l.siblingIndexParity));
  XCTAssertTrue(l.siblingIndex == -1, @"");

  // binding to a tree-dependent property should still update.. later..  when actuall added to the heirarchy.
  [l b:@"name" to:@"siblingIndexIsEven" using:^id(id v) { return [v bV] ? @"EVEN" : @"ODD"; } type:BindTypeTransform];

  [hoster addSublayer:l];  // finally, add to layer tree.

  XCTAssertNotNil(l.name, @"name should have been set, but was %@", l.name);
    XCTAssertTrue(l.siblingIndexParity == AZEven, @"indexParity should be even, got %@", AZParity2Text(l.siblingIndexParity));
    XCTAssertTrue(l.siblingIndexIsEven, @"should be Even at 0");
    XCTAssertTrue(SameString(@"EVEN", l.name), @"should be named EVEN, but she is %@", l.name);
}

- (void) testHostView {

  XCTAssertEqual(_layer.hostView, _view, @"host layer's host view should be view, it was %@", _layer.hostView);
  XCTAssertEqual(_shapeLayer.hostView, _view, @"shape layer's host view should ALSO be view, it was %@", _shapeLayer.hostView);
  CAL* randomLayer = CALayer.new;
     XCTAssertNil(randomLayer.hostView, @"some radom, unhosted layer's view should be nil, it was %@",randomLayer.hostView);
}
- (void) testActuallyVisibleRect {

//  STAssertTrue(NSEqualRects(AZRectFromDim(50), _shapeLayer.actuallyVisibleRect), @"visible rect should be 50x50, it was %@", AZString(_shapeLayer.actuallyVisibleRect));
//  STAssertTrue(NSEqualRects(AZRectFromDim(50), _shapeLayer.actuallyVisibleRect), @"visible rect should be 50x50, it was %@", AZString(_shapeLayer.actuallyVisibleRect));
}

- (void) testModifiers {

  XCTAssertEqualObjects(@"alex", [_shapeLayer named:@"alex"].name, @"renamed to alex, but got %@", _shapeLayer.name);
  XCTAssertTrue(NSEqualRects(AZRectFromDim(55), [_shapeLayer withFrame:AZRectFromDim(55)].frame), @"reframed to 55, got %@",AZString(_shapeLayer.frame));
}
@end
