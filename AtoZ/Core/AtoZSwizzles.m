
#import "AtoZ.h"

@implementation                                            NSO (AtoZSwizzles)
+ (void)load                                {
	[$ swizzleMethod:@selector(setWantsLayer:)                  in:NSView.class
              with:@selector(swizzleSetWantsLayer:)           in:NSView.class];
	[$ swizzleMethod:@selector(didMoveToWindow)                 in:NSView.class
              with:@selector(swizzleDidMoveToWindow)          in:NSView.class];

	[$ swizzleMethod:@selector(description)                     in:CAL.class
              with:@selector(swizzleDescription)              in:CAL.class];
	[$ swizzleMethod:@selector(hitTest:)                        in:CAL.class
              with:@selector(swizzleHitTest:)                 in:CAL.class];
	[$ swizzleMethod:@selector(containsPoint:)                  in:CAL.class
              with:@selector(swizzleContainsPoint:)           in:CAL.class];
  [$ swizzleMethod:@selector(addSublayer:)
              with:@selector(swizzleAddSublayer:)             in:CAL.class];

	[$ swizzleClassMethod:@selector(needsDisplayForKey:)        in:CAL.class
                   with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
//	[$ swizzleMethod:@selector(actionForKey:) with:@selector(swizzleActionForKey:) in:self.class];
//	[$ swizzleMethod:@selector(hitTest:) with:@selector(swizzleHitTest:) in:CAL.class];
//	[$ swizzleMethod:@selector(needsDisplayForKey:) with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
//	[$ swizzleClassMethod:@selector(defaultActionForKey:) with:@selector(swizzleDefaultActionForKey:) in:CAL.class];
//	[$ swizzleClassMethod:@selector(initWithLayer:) with:@selector(swizzleInitWithLayer:) in:CAL.class];

}         @end

@implementation                                         NSView (AtoZSwizzles)
- (void) swizzleDidMoveToWindow             {	[self swizzleDidMoveToWindow];
	[AZNOTCENTER postNotificationName:NSViewDidMoveToWindowNotification object:self userInfo:@{@"window":self.window}];
}
- (void) swizzleSetWantsLayer:(BOOL)b       { // IF_RETURN(b && self.layer != nil);

  [self swizzleSetWantsLayer:b];
  if (b) {
//    if (!self.layer.name) self.layer.name = @"hostLayer";
    self.layer.hostView = self;
  }
}
@end

@implementation                                            CAL (AtoZSwizzles)
- (NSS*)        swizzleDescription          { NSA*sclasses = self.superclassesAsStrings;

	return JATExpand(@"{0} {1}/{2} {3} {7} f:{4} b:{5}", AZCLSSTR,
                                          self.siblingIndex,
                                          self.siblingIndexMax,
                                          self.name ? $(@"name:%@", self.name) : zNIL,
                                          AZStringFromRect(self.frame),
                                          AZStringFromRect(self.bounds),
                                          sclasses.count > 1 ? [zSPC withString:[sclasses componentsJoinedByString:@" -> "]] : zNIL,
                                          AZAlignToString(self.alignment));
}
- (BOOL)      swizzleContainsPoint:(NSP)p   { return self.noHit ? NO : [self swizzleContainsPoint:p]; }
+ (BOOL) swizzleNeedsDisplayForKey:(NSS*)k  {

  return [@[@"hovered", @"backgroundNSColor", @"expanded", @"siblingIndex", @"selected"] containsObject:k] ?: [self swizzleNeedsDisplayForKey:k];
}
- (void)        swizzleAddSublayer:(CAL*)c  { AZBlockSelf(myself);

  [c triggerKVO:@"superlayer" block:^(id _self) { [myself swizzleAddSublayer:_self]; }];
  
  NSAssert(self == c.superlayer, @"i should be superl!");
  [c performSelectorIfResponds:@selector(didMoveToSuperlayer)];

}
- (id)              swizzleHitTest:(NSP)p   { CAL*x = [self swizzleHitTest:p] ?: nil;  if(x && x.wasHit) x.wasHit(x); return x; }

@end
/*
	[self.sublayers each:^(id obj) { [obj didChangeValueForKeys:@[@"siblings", @"siblingIndex", @"siblingIndexMax"]]; }];
	[self addKVOBlockForKeyPath:@"sublayers.@count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld handler:^(NSS *keyPath, id object, NSD *change) {
	[self addObserver:cal keyPath:@"sublayers" options:0 block:^(MAKVONotification *notification) {
	AZLOGCMD;
	[self.sublayers each:^(id obj) { [obj willChangeValueForKeys:@[@"siblings", @"siblingIndex", @"siblingIndexMax"]]; }];

static NSMD* nDfKRef;

+ (NSA*) needsDisplayForKeys             { return nDfKRef[AZCLSSTR]; }
+ (void) setNeedsDisplayForKeys:(NSA*)ks {

	!(nDfKRef = nDfKRef ?: NSMD.new)[AZCLSSTR] || ![nDfKRef[AZCLSSTR] isEqualToArray:ks] ? nDfKRef[AZCLSSTR] = ks :nil;
	NSLog(@"current CALAYER needy key dict: %@", nDfKRef);
//	[$ swizzleClassMethod:@selector(needsDisplayForKey:) in:self.class with:@selector(swizzleNeedsDisplayForKeyFromDict:) in:self.class];
}

+ (BOOL) swizzleNeedsDisplayForKeyFromDict:(NSS*)k  {
	BOOL yeah = [(NSA*)needsDisplayKeysRef[NSStringFromClass(self.class)] containsObject:k];
	if (yeah) NSLog(@"my swizzled out self needs display for key: %@... (class: %@", k, AZCLSSTR);
	return yeah ?: [self.class swizzleNeedsDisplayForKeyFromDict:k];
}
-  (ACT) swizzleActionForKey:	(NSS*)e               {
	//	[self swizzleDidChangeValueForKey:k];
	//	id v = [self vFK:k];
	//	if ([v ISKINDA:NSA.class])
	//	v = $(@"array for Key: %@, ct:%ld", k, [v count]);	//	NSLog(@"swizzle didcvfk:%@  %@", k,v);
	objswitch(e)
	objcase(kCAOnOrderIn)
	NSLog(@"inside %@", e);
	while (self.superlayer == nil) sleep(1);
	[self willChangeValueForKey:@"siblings"];
	if ([self respondsToSelector:@selector(didMoveToSuperlayer)]) [self didMoveToSuperlayer];
	[self didChangeValueForKey:@"siblings"];
	return [CABasicAnimation animationWithKeyPath:@"opacity"];
	//	if ([self superlayer].sublayers.count > 1)
	//		[self.sublayers each:^(id obj) {
	//		[obj willChangeValueForKeys:@"siblings", @"siblingIndexMax", nil];
	//		[obj didChangeValueForKeys:@"siblings", @"siblingIndexMax", nil];
	//	}];
	endswitch
	return [self swizzleActionForKey:e] ? : [super actionForLayer:self forKey:e] ? : nil;
	//	objcase(@"sublayers")
	//	[self.sublayers makeObjectsPerformSelector:@selector(willChangeValueForKey:) withObject:@"siblings"];
	//	[self.sublayers makeObjectsPerformSelector:@selector(didChangeValueForKey:)  withObject:@"siblings"];
	//	return [self swizzleActionForKey:e];
	//	return [[self.class superclass] actionForKey:e];//didChangeValueForKey:k];
}
-   (id) swizzleHitTest:		 (NSP)p                 {
	id (^hit)(CAL*) = ^id(CAL*l) { return [l swizzleHitTest:[l convertPoint:p fromLayer:self]];
	NSA* hit = [self.sublayers reduce:@[].mutableCopy withBlock:^id(id sum, id obj) {

	return
	}];
	if (!hit) return nil;
	return [hit firstObject];
	CGF top = [self.sublayers floatForKeyPath:@"@max.zPosition"];

	LOG_EXPR(top);
	if (([[hit sortedWithKey:@"zPosition" ascending:NO].first floatForKey:@"zPosition"] < top) || (top == 0.0))

	[CATRANNY immediately:^{
	    [hit setFloat:top+100 forKey:@"zPosition"];
		NSLog(@"Changed %@ zPos to %f",hit,  hit.zPos);
	}];
	return  hit;
}
- (BOOL) swizzleNeedsDisplayForKey:(NSS*)k          {
	return [@[@"selected", @"hovered", @"siblingIndex", @"backgroundNSColor"] containsObject : k]
	? :[self swizzleNeedsDisplayForKey:k];
}
-   (id) swizzleInitWithLayer:(id)layer             {
	if (self != [self swizzleInitWithLayer:layer]) return nil;
	[@[@"siblings", @"siblingIndex", @"siblingIndexMax", @"selected", @"hovered", @"backgroundNSColor"] each : ^(id obj) { id value;
	if ((value = [layer vFK:obj])) {
		[[@"swizzle set "withString : obj]log]; [self sV:value fK:obj];
	}
	}];
	return self;
}
*/

