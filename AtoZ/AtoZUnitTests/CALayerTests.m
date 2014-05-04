
#import <SenTestingKit/SenTestingKit.h>

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

  STAssertTrue(_view && _layer && _view.layer == _layer && _noHitLayer && _shapeLayer, @"should all exist");
}

- (void) testSettingSuperlayer {

  STAssertNotNil(_shapeLayer.superlayer, @"shapeLayer is in the heirarchy, but superlayer was %@", _shapeLayer.superlayer);
  _shapeLayer.superlayer = nil;
     STAssertNil(_shapeLayer.superlayer, @"shapeLayer should have been removed, but superlayer is %@", _shapeLayer.superlayer);
    STAssertTrue(_shapeLayer.siblingIndexMax == -1, @"outside of heirarchy, siblingIndexMax is 0, but was %lu", _shapeLayer.siblingIndexMax);
}
- (void) testNoHit { /* OK! */

               _point = AZPointFromDim(23);
  STAssertEquals(_hit = [_layer hitTest:_point], _shapeLayer, @"Hittest at 50 should hit shape, but it hit:%@", _hit);
                 _hit = nil;
  _shapeLayer.superlayer = nil;
  STAssertEquals(_hit = [_layer hitTest:_point], _layer, @"Hittest at 50 with shape removed should hit layer, but it hit:%@", _hit);
    _noHitLayer.noHit = NO;
  STAssertEquals(_hit = [_layer hitTest:_point], _noHitLayer, @"Hittest at 50 with nohit set TO HIT should hit noHit, but it hit:%@", _hit);
}

- (void) testSublings {

    STAssertNil(_layer.siblings,               @"layer has no sisters or bros, but found %@",                     _layer.siblings);
   STAssertTrue(_shapeLayer.siblingIndex == 1, @"shape is sibling 1, got %lu",                           _shapeLayer.siblingIndex);
  STAssertFalse(_shapeLayer.siblingIndexIsEven,@"shape is sibling 1, odd, got %@", StringFromBOOL(_shapeLayer.siblingIndexIsEven));

   STAssertTrue(_noHitLayer.siblingIndex    == 0,  @"nohit is sibling 0, got %lu",                                        _noHitLayer.siblingIndex);
   STAssertTrue(_noHitLayer.siblingIndexIsEven,    @"_noHitLayer is sibling 0, even, got %@",       StringFromBOOL(_noHitLayer.siblingIndexIsEven));
   STAssertTrue(_noHitLayer.siblingIndexMax == 1,  @"shape and nohit are eachothers only siblings, max is 1, got %lu", _noHitLayer.siblingIndexMax);

  STAssertEqualObjects(@[_layer], _shapeLayer.superlayers, @"shape's superlayers array is just layer..  got %@", _shapeLayer.superlayers);

  __block NSInteger newIndex = -1, newCount = -1;

  [_noHitLayer addObserverForKeyPath:@"siblingIndexMax" task:^(id l) { newIndex = [l siblingIndexMax]; }];
  [_noHitLayer.superlayer addSublayer:CAL.layer];

  STAssertTrue(WaitFor(^BOOL { return newIndex != -1; }), @"still waiting");
  STAssertTrue( newIndex == 2, @"new max should be 2, got %ld", newIndex);
  STAssertTrue(_noHitLayer.siblings.count == 2, @"new sibling ct should be 2, got %ld", _noHitLayer.siblings.count);

  [_noHitLayer addObserverForKeyPath:@"siblings" task:^(id l) { newCount = [l siblings].count; }];
  [_noHitLayer.superlayer addSublayer:CAL.layer];

  STAssertTrue(WaitFor(^BOOL { return newCount != -1; }), @"still waiting");
  STAssertTrue(newCount == 3, @"");
}

- (void) testDependentPropertyBinding { CAL *hoster = CAL.new, *l = CAL.new;

   STAssertNil(l.name, @"name should be nil, was %@", l.name);
  STAssertTrue(l.siblingIndexParity == AZUndefined, @"indexParity should be undefined, got %@", AZParityToString(l.siblingIndexParity));
  STAssertTrue(l.siblingIndex == -1, @"");

  // binding to a tree-dependent property should still update.. later..  when actuall added to the heirarchy.
  [l b:@"name" to:@"siblingIndexIsEven" using:^id(id v) { return [v bV] ? @"EVEN" : @"ODD"; } type:BindTypeTransform];

  [hoster addSublayer:l];  // finally, add to layer tree.

  STAssertNotNil(l.name, @"name should have been set, but was %@", l.name);
    STAssertTrue(l.siblingIndexParity == AZEven, @"indexParity should be even, got %@", AZParityToString(l.siblingIndexParity));
    STAssertTrue(l.siblingIndexIsEven, @"should be Even at 0");
    STAssertTrue(SameString(@"EVEN", l.name), @"should be named EVEN, but she is %@", l.name);
}

- (void) testHostView {

  STAssertEquals(_layer.hostView, _view, @"host layer's host view should be view, it was %@", _layer.hostView);
  STAssertEquals(_shapeLayer.hostView, _view, @"shape layer's host view should ALSO be view, it was %@", _shapeLayer.hostView);
  CAL* randomLayer = CALayer.new;
     STAssertNil(randomLayer.hostView, @"some radom, unhosted layer's view should be nil, it was %@",randomLayer.hostView);
}
- (void) testActuallyVisibleRect {

//  STAssertTrue(NSEqualRects(AZRectFromDim(50), _shapeLayer.actuallyVisibleRect), @"visible rect should be 50x50, it was %@", AZString(_shapeLayer.actuallyVisibleRect));
//  STAssertTrue(NSEqualRects(AZRectFromDim(50), _shapeLayer.actuallyVisibleRect), @"visible rect should be 50x50, it was %@", AZString(_shapeLayer.actuallyVisibleRect));
}

- (void) testModifiers {

  STAssertEqualObjects(@"alex", [_shapeLayer named:@"alex"].name, @"renamed to alex, but got %@", _shapeLayer.name);
  STAssertTrue(NSEqualRects(AZRectFromDim(55), [_shapeLayer withFrame:AZRectFromDim(55)].frame), @"reframed to 55, got %@",AZString(_shapeLayer.frame));
}
@end
