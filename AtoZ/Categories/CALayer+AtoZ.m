
#import "AtoZ.h"
#import "BoundingObject.h"
#import "CALayer+AtoZ.h"

@interface EventCoordinator : BaseModel
@end
@implementation EventCoordinator
@end
@implementation CALayer (AtoZ)

- (void) setAnimations:(NSA*)a { AZBlockSelf(_self); [a do:^(CAPropertyAnimation* z){  id x; 

      ((x = [z respondsToStringThenDo:@"keyPath"])) ? [_self addAnimation:z forKey:x] : [_self addAnimation:z]; 
  }];
}

- (CAL*) hostLayer { return self.hostView.layer?: self; }

#pragma mark - EVENT HANDLER

                SYNTHESIZE_ASC_OBJ(eventMonitor,setEventMonitor);          // Saved Monitor

           SYNTHESIZE_ASC_OBJ_LAZY(eventBlocks,IndexedKeyMap.class);       // Indexed Key Map of handlers

SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO(eventMask,setEventMask,NSEventMask, ^{}, ^{

  if(self.eventMonitor) [NSEvent removeMonitor:self.eventMonitor]; // remove old mointor
  if (value) {
    self.eventMonitor = [NSEVENTLOCALMASK:value handler:^NSEvent *(NSEvent *e) {
      [self.eventBlocks enumerate:^(id key, SenderEvent obj, BOOL *stop, int idx) {
        if (e.type == idx) obj(self,e);
      }];
      return e;
    }];
  }
});
@dynamic onHover, onHit;
/** TODO : FIX
- (SenderEvent) onHit { return [self.eventBlocks] setOnHit, SenderEvent, ^{ });
- (void) on:(NSEventMask)mask do:(SenderEvent)b {

  self.eventBlocks[mask] = b;
  self.eventMask = self.eventMask | mask;
}
*/

// AtoZFIX  this layer touch stuff is a mess!

//         SYNTHESIZE_ASC_CAST(wasHit,     setWasHit,     LayerBlock);
//         SYNTHESIZE_ASC_CAST(mouseOver,  setMouseOver,  LayerBlock);
//@dynamic sublayerMouseOverBlock;


- (void) setSublayerMouseOverBlock:(void(^)(CAL*layer))block {

  id monitor = self[@"mouseOverBlock"];                   // saved monitor

	if (!monitor && block)                                  // "attempt" to dispatch once
    self.hostView.window.acceptsMouseMovedEvents = YES;   // make window listen.

  if (monitor || !block)                                  // if werealready handling
                                                          // OR we're simply here to stop
    [NSE removeMonitor:monitor];                          // remove old handler

	self[@"mouseOverBlock"] =  !block ? nil :               // nil the handler on NULL block

    (monitor = [NSEVENTLOCALMASK:NSMouseMovedMask         // on MOVE
                         handler:^NSE*(NSE *e){

		CAL* hit; if ((hit = [self hitTestSubs:[self layerPoint:e]])) block(hit); return e;

	}]);

}
//  __block CAL* hitLayer;                                  // needle
//		if (hit && hit != hitLayer) {  hitLayer = hit;  block(hitLayer); }


- (NSP) layerPoint:(NSE*)e { return [self convertPoint:e.locationInWindow fromLayer:nil]; }


//@prop_RO NSA* eventBlocks;//  EventBlock eventBlock;
//@prop_CP  SenderEvent onHit, onHover;
//SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO(eventMask,      setEventMask,            NSEventMask,
//                                        ^{},^{

//);

//         SYNTHESIZE_ASC_CAST(eventBlock, setEventBlock, EventBlock);
//         , ^{}, ^{ NSEventMask x = self.eventMask; if (X)});

- (void)    addActionsForKeys:(NSD*)ks { self.actions = [self.actions ?: @{} dictionaryByAppendingEntriesFromDictionary:ks]; }
- (void)    setActionsForKeys:(NSD*)ks { self.actions = [self.actions ?: @{} dictionaryByAddingEntriesFromDictionary:ks]; }
- (void) removeActionsForKeys:(NSA*)ks { self.actions = [self.actions dictionaryWithValuesForKeys:[self.actions.allKeys arrayWithoutArray:ks]]; }

#pragma mark - SIBLINGS / INDEX

@dynamic siblings, siblingIndex, siblingIndexIsEven, siblingIndexMax;

SetKPfVA(Siblings,      @"siblingIndexMax")                             SetKPfVA(SiblingIndexIsEven, @"siblingIndex")
SetKPfVA(SiblingIndex,  @"superlayer", @"superlayer.sublayers.@count")  SetKPfVA(SiblingIndexMax,    @"superlayer", @"superlayer.sublayers.@count")

-     (INST) siblingNext         {	return self.siblingIndex == self.siblingIndexMax || !self.siblings.count ? nil : self.siblings[self.siblingIndex]; }
-     (INST) siblingPrev         {	NSUI idx = self.siblingIndex-1; return self.siblingIndex == 0 || self.siblings.count == 0 || self.siblings.count < idx ? nil : self.siblings[idx]; }
-     (NSA*) siblings            {	return !self.superlayer ? nil : [self.superlayer.sublayers arrayWithoutObject:self]; }
-      (NSI) siblingIndex        {	return !self.superlayer ? -1 : (NSI)[self.superlayer.sublayers indexOfObject:self];      }

- (AZParity) siblingIndexParity  { return self.siblingIndex == -1 ? AZUndefined : isEven(self.siblingIndex) ? AZEven : AZOdd; }

-     (BOOL) siblingIndexIsEven  { return isEven(self.siblingIndex);                           }
-      (NSI) siblingIndexMax    { return !self.superlayer ? -1 : self.superlayer.sublayers.count - 1; }

-     (void) setFilterName:(NSS*)n  {

	CIFilter *fltr = [CIFilter filterWithName:n]; [fltr setDefaults];	[fltr setName:n];
  self.hostView.layerUsesCoreImageFilters = YES; self.compositingFilter = fltr;
}
-     (INST) permaPresentation	  {	if (!self.presentationLayer) NSLog(@"no presenta para: %@", self);
	return self.presentationLayer ? : self.modelCALayer ? : self;
}

@dynamic backgroundNSColor;

- (void) setBackgroundNSColor:(NSC*)c  { self.bgC = c.CGColor;                                                       }
- (NSC*)    backgroundNSColor          { return self.bgC == NULL ? CLEAR : [NSC colorWithCGColor:self.bgC];          }

#define LOGREASON NSLog(@"reacting to key:%@",k) 

@dynamic animatesResize, needsLayout, needsDisplay;

- (void) disableResizeActions             { [self addActionsForKeys: @{ @"position":AZNULL, @"bounds":AZNULL}]; }
- (void) disableActionsForKeys:(NSA*)ks   {	self.actions = [self.actions ?: @{} dictionaryWithValue:AZNULL forKeys:ks]; }
- (void)     setAnimatesResize:(BOOL)a    { a ? [self removeActionsForKeys:@[@"bounds",@"position"]] : [self disableResizeActions]; }
- (BOOL)        animatesResize            { return [self actionForKey:@"bounds"] || [self actionForKey:@"position"]; }

SYNTHESIZE_ASC_OBJ_BLOCK(needsLayoutForKeys,setNeedsLayoutForKeys,^{},^{

  value ? [[value arrayWithoutArray:self.needsLayoutForKeys ?: @[]] do:^(id k){ [self setNeedsLayoutForKey:k]; }]

        :                          [self.needsLayoutForKeys do:^(id x){ [self unbind:x]; }];
});

SYNTHESIZE_ASC_OBJ_BLOCK(needsDisplayForKeys,setNeedsDisplayForKeys,^{},^{

  value ? [[value arrayWithoutArray:self.needsDisplayForKeys ?: @[]] do:^(id k) {    [self setNeedsDisplayForKey:k]; }]

        :                          [self.needsDisplayForKeys do:^(id x){ [self unbind:x]; }];
});

- (void)        setNeedsLayout:(BOOL)x  { x ? [self setNeedsLayout]  : nil; }
- (void)       setNeedsDisplay:(BOOL)x  { x ? [self setNeedsDisplay] : nil; }
- (void)  setNeedsLayoutForKey:(NSS*)k  { [self addObserverForKeyPath:k task:^(id x) { LOGREASON; [x setNeedsLayout]; }];  }
- (void) setNeedsDisplayForKey:(NSS*)k  { [self addObserverForKeyPath:k task:^(id x) { LOGREASON; [x setNeedsDisplay]; }];  }

-   (id)   scanSubsForClass:(Class)c    {
  return [self.sublayers filterOneBlockObject:^id(CAL*sub) { return ISA(sub,c) ? sub : sub.sublayers.count ? [sub scanSubsForClass:c] : nil;	}];
}
-   (id)    scanSubsForName:(NSS*)n     {
  return [self.sublayers filterOneBlockObject:^id(CAL*sub) { return SameString(sub.name,n) ? sub : sub.sublayers.count ? [sub scanSubsForName:n] : nil;	}];
}
- (NSA*) sublayersAscending             { return [self.sublayers sortedWithKey:@"frameX" ascending:YES]; }


SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(hostView, setHostView, ^{ value = value ?: [self.superlayers filterOneBlockObject:^id(CAL *l) { return l.hostView; }]; }, ^{});

-  (NSR) actuallyVisibleRect;                    {
	return [self actuallyVisibleRectInView:nil];
}
-  (NSR) actuallyVisibleRectInView:(NSV *)v;     {

  __unused NSView *view = v ?: self.hostView;
  // ? : [[self.superlayers cw_mapArray:^id (id o) { return [o hostView]; }]
//	  sortedWithKey:@"minDim" ascending:NO].first;
	NSR actual = NSIntersectionRect(self.visibleRect, AZRectFromSize(v.window.size));
	//	NSLog(@"%@ vs %@ in %@ %@", AZString(self.visibleRect), AZString(actual), AZString(v.bounds), [v class]);
	return actual;
}
- (NSA*) visibleSublayers           {  BOOL inScroller = ISA(self.superlayer,CASCRLL);

 return [self.sublayers filter:^BOOL(CAL*sub) {
      return !CGRectIsEmpty( inScroller ? NSIntersectionRect(sub.bounds, self.visibleRect)
                                        : sub.actuallyVisibleRect);
  }];
  //	NSLog(@"%ld/%ld subs Visible.", i.count, self.sublayers.count);
}
- (CAL*) sublayerOfClass:(Class)k   {
	return [self.sublayers filterOne:^BOOL (id object) {
	return [object ISKINDA:k];
	}];
}
- (NSA*) sublayersOfClass:(Class)k  {
	return [self.sublayers filter:^BOOL (id object) {
	return [object ISKINDA:k];
	}];
}

- (CATXTL*) addTextLayer:(NSS *)text font:(NSFont *)font align:(enum CAAutoresizingMask)align {
	return AddTextLayer(self, text, font, align);
}
- (CAL*) addImageLayer:(NSIMG *)image scale:(CGF)scale    {
	//	u.contentsCenter = AZCenterRectOnRect(superlayer.bounds, new); , scale), superlayer.frame);
	CAL *u = ReturnImageLayer(self, image, scale);
	[self addSublayer:u];
	[self layoutIfNeeded];
	return u;
}

- (INST) colored:        (NSC*)color  {
	self.bgC = [color CGColor];  return self;
}
- (INST) named:          (NSS*)name   {
	self.name = name;  return self;
}
- (INST) withFrame:      (NSR)frame   {
	self.frame = frame; return self;
}
- (INST) withConstraints:(NSA*)cnst   {
	[self addConstraints:cnst]; return self;
}

- (void) removeConstraintWithAttribute:(CACONSTATTR)att1 rel:(NSS*)relORnil attr:(CACONSTATTR)att2 {

  if (!self.constraints.count) return;

   CACONST * match =[self.constraints filterOne:^BOOL(CACONST *candidate) {

    if ((NSUInteger)att2 != NSNotFound && candidate.sourceAttribute != att2)  return NO;
    if (!SameString(relORnil ?: @"superlayer", candidate.sourceName))         return NO;
    if ((NSUInteger)att1 != NSNotFound && candidate.attribute       != att1)  return NO;
    return YES;
  }];
  if (match) self.constraints = [self.constraints arrayByRemovingObject:match];
}

- (CAL*) hitTestSubs:  (CGP)pt     {

  BOOL savedNoHit = self.noHit;
  self.noHit = YES;
  id x = [self hitTest:pt];
  if (x == self) x = nil;
#ifdef DEBUG1
  LOGCOLORS(AZSELSTR, @" at pt:", AZString(pt),
                      @" in frame:", AZString(self.frame),
                      @" found subview:", x, @"atSublayerIdx:", @([x siblingIndex]), nil);
#endif
  [self setNoHit:savedNoHit];
  return x;
//  NSA* a = [self.sublayers filter:^BOOL(id object) {
//    return [object hitTest:[object convertPoint:point fromLayer:nil]];
//  }];
//	if (!a.count) return  LOGCOLORS(@"Found Nothing, and I have sublayers:", @(self.sublayers.count), nil), nil;

//	id x = [a sortedWithKey:@"zPosition" ascending:NO].first;
//	LOGCOLORS(JATExpand(@"Hittest found {0} layer(s) out of {1} ... Returning topmost,{x} with Zpos:{3}", a.count, self.sublayers.count,x, [x zPosition]), nil);
//	return x; //[self hitTest:point];
}
-   (id) copyLayer                                      {
	//	id newOne = [self.class.alloc init];
	//	NSD* newD =
	//	NSLog(@"copying layer with props: %@", newD);
	//	return AZ_RETAIN
	id layer = CALayer.layer;  NSLog(@"copying layer: %@", self);
	//	[layer setPropertiesWithDictionary:	[[self.modelLayer properties] subdictionaryWithKeys:
	//		 [[[self.modelLayer propertyNames]filter:^BOOL(id object) {
	//			  return [self respondsToSelector:NSSelectorFromString(
	//			[@"set" withString:[(NSS*)object capitalizedString]])];
	//			}]allKeys]]];
	//	[[self.class propertyNames] each:^(id obj) {
	//	if ([layer respondsToSelector:[CAL setterForPropertyNamed:obj]] )
	//		[((CAL*)layer) setValue:(id)[((CAL*)self) valueForKey:obj] forKey:obj];
	//	}];
	BOOL copy = [self.name contains:@".copy."];
	if (copy) {
	NSI generation	       = [[self.name pathExtension] integerValue] + 1;
	((CAL *)layer).name      = [self.name stringByReplacingPathExtensionWithExtension:AZString(generation)];
	}
	else ((CAL *)layer).name	= [self.name withString:@".copy.1"];
	((CAL *)layer).frame	  = self.frame;
	((CAL *)layer).bgC	 = self.bgC;
	((CAL *)layer).borderColor       = self.borderColor;
	((CAL *)layer).borderWidth       = self.borderWidth;
	((CAL *)layer).constraints       = self.constraints;
	((CAL *)layer).arMASK	 = self.arMASK;
	((CAL *)layer).mask	= self.mask;
	((CAL *)layer).contents          = self.contents;

	return layer;
	//	}];// setPropertiesWithDictionary:newD];
	//	return newOne;
}
- (void) addSublayer:(CAL*)layer named:(NSS*)name       {
	layer.name = name; [self addSublayer:layer];
}
- (void) addSublayerImmediately:(CAL *)sub       {
	[CATransaction immediately:^{   [self addSublayer:sub]; }];
}
- (void) addSublayersImmediately:(NSA *)subArray {
	[CATransaction immediately:^{   [self addSublayers:subArray];   }];
}
- (void) insertSublayerImmediately:(CAL *)sub atIndex:(NSUI)idx {
	[CATransaction immediately:^{   [self insertSublayer:sub atIndex:idx];  }];
}
- (void) setValueImmediately: v forKey: key {
	[CATRANNY immediately:^{ [self setValue:v forKey:key];  }];
}
- (void) setFrameImmediately:(NSR)r {	[CATRANNY immediately:^{ [self setValue:AZVrect(r) forKey:@"frame"];  }]; }

- (AZStatus) toggleSpin {  return ({ self.spinning =! self.spinning; }); }

- (void) setSpinning:(AZStatus)state { AZStatus now = self.spinning;  
	if (now   == state) return;
	if (state == AZOFF) // || ( state == (AZState)NSNotFound && exist == AZOn)) {
    [self removeAllAnimations];
	else 
    [self addAnimation:[[CABA animationWithKeyPath:@"transform.rotation" from: @0 to: @(TWOPI) duration:8. repeat:HUGE_VALF]
                              objectBySettingValue:@NO forKey:@"autoreverses"]
                                            forKey:@"rotation"];

    [self setInteger:state forKey:@"spinState"];
}

- (AZStatus) spinning { return (AZStatus)[self integerForKey:@"spinState"]; }
- (void) moveToFront {
	[self removeFromSuperlayer];
	[self.superlayer addSublayer:self];
}
- (void) setValue: value forKeyPath:(NSS*)keyPath
        duration:(CFTI)duration  delay:(CFTI)delay {
	[CATransaction immediately:^{
	[self setValue:value forKeyPath:keyPath];
	CABA *anim = [CABA animationWithKeyPath:keyPath];
	anim.duration = duration;
	anim.beginTime = CACurrentMediaTime() + delay;
	anim.fillMode = kCAFillModeBoth;
	anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
	anim.toValue = value;
	[self addAnimation:anim forKey:keyPath];
	}];
}

- (CAL*) lastSublayer       {  return self.sublayers.lastObject; }
- (NSA*) sublayersRecursive { return [self.sublayers reduce:@[].mutableCopy withBlock:^id(NSMA* sum, id obj) {
			if (![obj sublayers].count) [sum addObject:obj]; else [sum addObjectsFromArray:[obj sublayersRecursive]];
			return sum;
	}];
}

/*
// @dynamic root, text, orient;

- (CAL *)labelLayer {
	return [self sublayerWithName:kCALayerLabel];
}

- (CAL *)setLabelString:(NSS *)label {
	CATXTL *layer = (CATXTL *)[self sublayerWithName:kCALayerLabel];
	if (!label) {
	[layer removeFromSuperlayer]; return nil;
	}
	if (!layer) {
	layer = [CATXTL layer];	      layer.doubleSided = NO;
	layer.wrapped = TRUE;	     layer.fontSize = 14.0;
	layer.alignmentMode = kCAAlignmentCenter;
	layer.anchorPoint = CGPointZero;        layer.name = kCALayerLabel;
	[self addSublayer:layer];
	}
	layer.string = label;
	NSLog(@"created text layer %@", layer);
	layer.position = CGPointZero; //CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
	layer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	layer.bounds = self.bounds;
	return layer;
}

static char ORIENT_IDENTIFIER, ROOT_IDENTIFIER, TEXT_IDENTIFIER;
#define kCALayerLabel @"CALayerLabel"

- (void)setText:(CATXTL *)text	     {
	objc_setAssociatedObject(self, &TEXT_IDENTIFIER, text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.text ? [self replaceSublayer:self.text with:text] : [self addSublayer:text];
	[self setNeedsLayout];  [self setNeedsDisplay];
}
- (CATXTL *)text	 {
	return (CATXTL *)objc_getAssociatedObject(self, &TEXT_IDENTIFIER);
}
- (void)setRoot:(CAL *)root	      {

	objc_setAssociatedObject(self, &ROOT_IDENTIFIER, root, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.root ? [self replaceSublayer:self.root with:root] : [self addSublayer:root];
	[self setNeedsLayout];  [self setNeedsDisplay];
}
- (CAL*) root	   {
	return (CAL *)objc_getAssociatedObject(self, &ROOT_IDENTIFIER);
}
- (void) setOrient:(AZPOS)orient	  {
	objc_setAssociatedObject(self, &ORIENT_IDENTIFIER, @(orient), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self hasPropertyForKVCKey:@"anchorPoint"] ) {
	CGP newA = AZAnchorPtAligned(orient);
	if ( !NSEqualPoints(newA, self.anchorPoint) ) [self setAnchorPoint:newA];
	}
	[self sublayersBlock:^(CAL *layer) {
	[layer setNeedsDisplay];
	[layer setNeedsLayout];
	}];
}
- (AZPOS) orient	 {
	return (AZPOS)[objc_getAssociatedObject(self, &ORIENT_IDENTIFIER) unsignedIntegerValue];
}
*/

- (NSN*)            addValues:(int)count, ... {
	va_list args;
	va_start(args, count);
	NSNumber *value;
	double retval = 0.0;
	for ( int i = 0; i < count; i++ ) {
	value = va_arg(args, NSNumber *);
	retval += [value doubleValue];
	}
	va_end(args);
	return @(retval);
}
- (void) animateXThenYToFrame:(NSR)toRect
                    duration:(NSUI)time       {
	//	NSRect max, min;
	//	max = AZIsRectRightOfRect(self.frame,toRect) ? self.frame : toRect;
	//	min = NSEqualRects(max, self.frame) ? toRect : self.frame;
	//	NSPOint dist = AZNormalizedDistanceToCenterOfRect(self.position,toRect);
	//	AZCenterDistanceOfRects(self.frame, ).x	//	self > AZCenterOfRect( toRect).x ? self.position :
	NSP interim     = (NSP) {AZCenterOfRect(toRect).x, self.position.y}; //AZPointOffsetX(self.position, );
	//	[CATransaction transactionWithLength:1 actions:^{
	//	[CATransaction transactionWithLength:1 actions:^{
	[self boolForKey:@"animating"] ? [CATransaction immediately:^{  self.position = self.position;  }] : nil;
	[self setBool:YES forKey:@"animating"];
	[CATransaction transactionWithLength:1 actions:^{
	[CATransaction setCompletionBlock:^(void) {
		[CATransaction transactionWithLength:1 actions:^{
		self.position = AZCenterOfRect( toRect);
		[CATransaction setCompletionBlock:^{
	[self setBool:NO forKey:@"animating"];
		}];
		}];
	}];
	self.position = interim;
	}];
}
- (void)  blinkLayerWithColor:(NSC *)color    {

//  CAGradientLayer
  CABA *blinkAnimation;
  if (ISA(self, CAGL)) {

    [self animate:@"colors" to:@[(id)color.lighterColor.CGColor,(id)color.darkerColor.CGColor] time:2 completion:^{
      XX(@"im done!");
    }];

//    blinkAnimation = [CABA animationWithKeyPath:@"colors"];
//     [blinkAnimation setFromValue:((CAGL*)self).colors];
//     blinkAnimation.toValue = @[(id)color.lighterColor.CGColor,(id)color.darkerColor.CGColor];
  }
  else {
    blinkAnimation = [CABA animationWithKeyPath:@"backgroundColor"];
    [blinkAnimation setFromValue:(id)self.backgroundColor];
    [blinkAnimation setToValue:(id)color.CGColor];

  [blinkAnimation setAutoreverses:YES];
  [blinkAnimation setDuration:0.2];

	[self addAnimation:blinkAnimation forKey:ISA(self, CAGL)? @"colors" : @"blink"];

  }
}
- (CAL*)         hitTestEvent:(NSE*)e
                       inView:(NSV*)v         {

	NSPoint mD = [NSScreen convertAndFlipEventPoint:e relativeToView:v];

	return [self hitTest:mD];/// ?: (id)$(@"nada para:%@", AZString(mD));
}
- (CAL*)              hitTest:(NSP)p
                      inView:(NSV*)v
                    forClass:(Class)k         {

	CAL *l = [self hitTest:[NSScreen convertAndFlipMousePointInView:v]]; while(l && !ISA(l,k)) l = l.superlayer;	return l;
}

//How to set the CATransform3DRotate along the x-axis for a specified height with perspective
- (void) addPerspectiveForVerticalOffset:(CGF)pixels	      {
	CGF totalHeight = self.bounds.size.height; //height is 30
	CGF heightToSetViewTo = 5;
	CGF rad = acosf( heightToSetViewTo / totalHeight);
	CATransform3D rT = CATransform3DIdentity;
	rT = CATransform3DRotate(rT, rad, 1.0f, 0.0f, 0.0f);
	self.transform = rT;
	CGF zDist = 1000;
	rT.m34 = 1.0f /  -zDist;
}

- (CAL*) selectionLayerForLayer:(CAL *)layer {

	CAL *aSelectionLayer = CALayer.new;
	//	selectionLayer.bounds = CGRectMake (0.0,0.0,width,height);
	aSelectionLayer.borderWidth = 4.0;
	aSelectionLayer.cornerRadius = layer.cornerRadius;
	aSelectionLayer.borderColor = cgWHITE;
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:@5.0f forKey:@"inputRadius"];
	[filter setName:@"pulseFilter"];
	[aSelectionLayer setFilters:@[filter]];
	// The selectionLayer shows a subtle pulse as it is displayed. This section of the code create the pulse animation setting the filters.pulsefilter.inputintensity to range from 0 to 2. This will happen every second, autoreverse, and repeat forever
	CABA *pulseAnimation = [CABA animation];
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	pulseAnimation.fromValue = @0.0f;
	pulseAnimation.toValue = @2.0f;
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = HUGE_VALF;
	pulseAnimation.autoreverses = YES;
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
		kCAMediaTimingFunctionEaseInEaseOut];
	[aSelectionLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];

	aSelectionLayer.constraints = @[
      AZConstRelSuper(kCAConstraintWidth),
		  AZConstRelSuper(kCAConstraintHeight),
		  AZConstRelSuper(kCAConstraintMidX),
		  AZConstRelSuper(kCAConstraintMidY)
  ];
	//	// set the first item as selected
	//	[self changeSelectedIndex:0];
	//
	//	// finally, the selection layer is added to the root layer
	//	[rootLayer addSublayer:self.selectionLayer];
	return aSelectionLayer;
}
- (void) toggleLasso:(BOOL)state	{	//:(CATransform3D)transform {
	if (state) {
	AZLOG($(@"TOGGLING LASSO ON for %@", self));
	[[[[self superlayers] filterOne:^BOOL (id object) {
		return [object[@"name"] isEqualToAnyOf:@[@"root", @"host"]];
	}] sublayers]each:^(id obj) {
		[obj sublayersBlockSkippingSelf:^(CAL *layer) {
		if ([layer.name isEqualToString:@"lasso"]) [layer removeFromSuperlayer];
		}];
	}];
	}
	else { __unused CAShapeLayer *lasso = [self.class lassoLayerForLayer:self]; }
//	lasso.name = @"lasso";  [self addSublayer:lasso]; }
	//	[self sublayersBlockSkippingSelf:^(CAL*layer) {
	//	[layer[@"name"] isEqualToString:@"lasso"
	//	}]
	//	BOOL isFlipped = [[self valueForKey:@"flipped"]boolValue];
	//	isFlipped ? [self flipBack] : [self flipOver];
	//	[self setValue:@(isFlipped =! isFlipped) forKey:@"flipped"];
}
+ (CASHL*)lassoLayerForLayer:(CAL*)layer	  { return [layer lasso]; }
- (CASHL*)lasso {


	//	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );


	CGF            dynnamicStroke = .05 * AZMaxDim(self.size);
	CGF                      half = dynnamicStroke / 2;
  CASHL *shapeLayer = [CASHL noHitLayerWithFrame:NSInsetRect(self.bounds, dynnamicStroke, dynnamicStroke)];
	shapeLayer[@"mommy"]          = self;
  shapeLayer.arMASK             = kCALayerWidthSizable | kCALayerHeightSizable;
	shapeLayer.constraints        = @[	 AZConstScaleOff( kCAConstraintMinX, @"superlayer", 1, half),
			//         AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
			AZConstScaleOff( kCAConstraintMinY, @"superlayer", 1, half),	  /*2),*/
			AZConstScaleOff( kCAConstraintMaxY, @"superlayer", 1, half),
			AZConstScaleOff( kCAConstraintWidth, @"superlayer", 1, -dynnamicStroke),
			AZConstScaleOff( kCAConstraintHeight, @"superlayer", 1, -dynnamicStroke),
			AZConstRelSuper(kCAConstraintMidX),
			AZConstRelSuper(kCAConstraintMidY) ];
	//	[shapeLayer setPosition:CGPointMake(.5,.5)];
	//	shapeRect.size.width -= dynnamicStroke;	shapeRect.size.height -= dynnamicStroke;
	shapeLayer.fillColor    = cgCLEARCOLOR;
	shapeLayer.strokeColor  = cgBLACK; // [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor];
	shapeLayer.lineWidth    = half;
	shapeLayer.lineJoin	  = kCALineJoinRound;
	shapeLayer.lineDashPattern = @[ @(20), @(20)];
	shapeLayer.path = [[NSBezierPath bezierPathWithRoundedRect:shapeLayer.bounds cornerRadius:self.cornerRadius] quartzPath];
	shapeLayer.zPosition = 3300;
	CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setValuesForKeysWithDictionary:@{        @"fromValue": @(0.0),    @"toValue": @(40.0),
				  @"duration": @(0.75), @"repeatCount": @(10000) }];
	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
	[shapeLayer needsDisplay];
  [self addSublayer:(self[@"lasso"] = shapeLayer) named:@"lasso"];
	return shapeLayer;
}
- (CAT3D)makeTransformForAngle:(CGF)angle	       { // from:(CATransform3D)start{
	CATransform3D transform = self.transform; // = start;
		// the following two lines are the key to achieve the perspective effect
	CATransform3D persp = CATransform3DIdentity;
	persp.m34 = 1.0 / -500;
	transform = CATransform3DConcat(transform, persp);
	transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
	return transform;
}

- (void)rotateAroundYAxis:(CGF)radians	  {

	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[CATransaction transactionWithLength:1 easing:CAMEDIAEASY actions:^{
		self.sublayerTransform = CATransform3DMakeRotation(radians, 0, 1, 0);
	}]; } ();
}
- (void)setHostingLayerAnchorPoint:(CGP)point	      {
	CAL *topLayer = [self.superlayers lastObject];
	topLayer.anchorPoint = point;
	//	topLayer.frame = [layerView bounds];
}
- (void)animateCameraToPosition:(CGP)point	      {
	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[CATransaction transactionWithLength:2 easing:CAMEDIAEASY actions:^{
		//	} setCompletionBlock:^ { // referencing mBeingAnimated creates a retain cycle as the block will retain self mBeingAnimated = NO; }];
		CGF cameraX = percent(point.x); //[cameraXField doubleValue]);
		CGF cameraY = percent(point.y); //[cameraYField doubleValue]);
		[self setHostingLayerAnchorPoint:(CGPoint) {cameraX, cameraY}];
	}];
	[self setValue:@(NO) forKey:@"animating"]; } ();
}
- (void)rotateBy45     {
	[self vFK:@"animating"] ? ^{ return; } () : ^{ [self setValue:@(YES) forKey:@"animating"];
	[self rotateAroundYAxis:M_PI_4];
	[self setValue:@(NO) forKey:@"animating"]; } ();
}
- (void)rotateBy90     {
	[self rotateAroundYAxis:M_PI_2];
}
- (void)animateToColor:(NSC*)color {
	[self animateToColor:color duration:2 withCallBack:NO];
}
- (VBlk) animateToColor:(NSC*)color duration:(NSTI)interval withCallBack:(BOOL)itRezhuzhesTheColor {

	NSColor *saved = self.bgC == NULL ? CLEAR : [NSColor colorWithCGColor:self.bgC];
	NSString *key = [self isKindOfClass:[CAShapeLayer class]] ? @"fillColor" : @"backgroundColor";
	CABA *anime = [CABA animationWithKeyPath:key];
	anime.fromValue      = self.bgC == NULL ? (id)cgCLEARCOLOR : (id)self.bgC;
	anime.toValue	= (id)color.CGColor;
	anime.duration          = interval;
	anime.autoreverses      = NO;
	anime.fillMode          = kCAFillModeBoth; //kCAFillModeForwards;
	anime.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	anime.removedOnCompletion = NO;
	[self addAnimation:anime forKey:@"color"];
	return itRezhuzhesTheColor ? ^{  [self animateToColor:saved duration:interval withCallBack:NO]; } : ^{};
}
/*

 + (NSA*)uncodableKeys {	return [self propertyNames];	}
 - (void)setWithCoder:(NSCoder *)coder{	[super setWithCoder:coder];[self autoEncodeWithCoder:coder];}
 - (void)encodeWithCoder:(NSCoder *)coder{	[super encodeWithCoder:coder];
 [self autoDecode:coder]; //encodeObject:ENCODE_VALUE(self.newProperty) forKey:@"uncodableProperty"];	}
 [[self.class uncodableKeys] each:^(NSS* key) {
 [self autoEncodeWithCoder:coder]  ;//]}= DECODE_VALUE([[coder decodeObjectForKey:@"uncodableProperty"];	}];
 }
 - (void)encodeWithCoder:(NSCoder *)coder	{	[super encodeWithCoder:coder];
 [coder encodeObject:ENCODE_VALUE(self.newProperty) forKey:@"uncodableProperty"];	}
 - (id)copyWithZone:(NSZone *)zone {  return [self.class.alloc initWithCoder:NSCoder.new];	}
 self.position = nanPointCheck(AZCenterOfRect(toRect));
 self.bounds =	AZMakeRectFromSize( nanSizeCheck( toRect.size ));
 }];
 CAAG *group = [CAAG animation];
 CABA *posX	= [CABA animationWithKeyPath:@"position.x"];
 CABA *posY  = [CABA animationWithKeyPath:@"position.y"];
 CABA *bndr	= [CABA animationWithKeyPath:@"bounds"];
 CGF baseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
 //	anim.beginTime = baseTime + (delay * i++);
 group.animations    = [@[posX, posY, bndr] nmap:^id(CABA *obj, NSUInteger idx) {
 obj.removedOnC	= NO;
 obj.fillMode    = kCAFillModeForwards;
 obj.duration	= idx <= 1 ? (time / 2) : time;
 obj.beginTime	= idx == 0 || idx == 2  ? baseTime : (baseTime + (time / 2));
 NSP interim     = NSMakePoint( AZCenterOfRect(toRect).x, self.position.y);
 obj.fromValue   = idx == 0 ? AZVpoint( self.position )
 : idx == 1 ? AZVpoint( interim )
 :		 AZVrect( self.bounds );
 obj.toValue	= idx == 0 ? AZVpoint( interim )
 : idx == 1 ? AZVpoint( AZCenterOfRect(toRect) )
 :	 AZVrect ( AZMakeRectFromSize(toRect.size) );
 return obj;
 }];
 [self addAnimation:group forKey:nil];
 [CATransaction commit];

 - (CAShapeLayer*) lassoLayerForLayer:(CAL*)layer {
 NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
 CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 [shapeLayer setValue:layer forKey:@"mommy"];
 //	float total =   ( (2*contentLayer.bounds.size.width) + (2*contentLayer.bounds.size.height) - (( 8 - ((2 * pi) * contentLayer.cornerRadius))));
 CGRect shapeRect = layer.bounds;
 [shapeLayer setBounds:shapeRect];
 //	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
 NSArray *constraints = [NSArray arrayWithObjects:
 AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-4),
 AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, -4),
 AZConst( kCAConstraintMidX,@"superlayer"),
 AZConst( kCAConstraintMidY,@"superlayer"),  nil];
 shapeLayer.constraints = constraints;
 //	[shapeLayer setPosition:CGPointMake(.5,.5)];
 [shapeLayer setFillColor:cgCLEARCOLOR];
 [shapeLayer setStrokeColor: [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
 [shapeLayer setLineWidth:4];
 [shapeLayer setLineJoin:kCALineJoinRound];
 [shapeLayer setLineDashPattern:@[ @(10), @(5)]];
 //	 [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
 //	  [NSNumber numberWithInt:5],
 //	  nil]];
 // Setup the path
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(shapeRect) cornerRadius:layer.cornerRadius];
 //	CGMutablePathRef path = CGPathCreateMutable();
 //	CGPathAddRect(path, NULL, shapeRect);
 //	[shapeLayer setPath:path];
 //	CGPathRelease(path);
 [shapeLayer setPath:[p quartzPath]];
 CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
 [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
 [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
 [dashAnimation setDuration:0.75f];
 [dashAnimation setRepeatCount:10000];
 [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	float total = (((2* NSMaxX(contentLayer.frame)) + (2 * NSMaxY(box.frame)))/16);
 //	CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
 //	dashAnimation.fromValue     = $float(0.0f);	dashAnimation.toValue   = $float
 //	(total);
 //
 //	dashAnimation.duration	= 3;		dashAnimation.repeatCount = 10000;
 //	//	dashAnimation.beginTime = CACurrentMediaTime();// + 2;
 //	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	shapeLayer.fillColor        = cgRED;
 //	shapeLayer.strokeColor	= cgBLACK;
 //	shapeLayer.lineJoin		= kCALineJoinMiter;
 //	shapeLayer.lineDashPattern  = $array( $int(total/8), $int(total/8));
 //
 //	//		srelectedBox.shapeLayer.lineDashPattern     = $array( $int(15), $int(45));
 //	shapeLayer.lineWidth = 5;
 //	[shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:contentLayer.bounds cornerRadius:contentLayer.cornerRadius ] quartzPath]];
 return shapeLayer;
 }


 CAAnimation * animation = [[CAAnimation animation] animationWithKeyPath:@"backgroundColor"];
 NSDictionary *dic = $map(	(id)[color1 CGColor],   @"fromValue",		 (id)[color2 CGColor],  @"toValue",
 $float(2.0),	  @"duration",	 YES,	@"removedOnCompletion",
 kCAFillModeForwards,     @"fillMode");
 [animation setValuesForKeysWithDictionary:dic];	[theLayer addAnimation:animation forKey:@"color"];
 + (CAShapeLayer*) lassoLayerForLayer:(CAL*)layer {
 //	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
 CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 //	[shapeLayer setValue:layer forKey:@"mommy"];
 //	float total =   ( (2*contentLayer.bounds.size.width) + (2*contentLayer.bounds.size.height) - (( 8 - ((2 * pi) * contentLayer.cornerRadius))));
 CGRect shapeRect = layer.bounds;
 shapeLayer.frame = shapeRect;
 //	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
 NSArray *constraints = [NSArray arrayWithObjects:
 AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,2),
 AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-4),
 AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, -4),
 AZConst( kCAConstraintMidX,@"superlayer"),
 AZConst( kCAConstraintMidY,@"superlayer"),  nil];
 shapeLayer.constraints = constraints;
 [shapeLayer setFillColor:cgCLEARCOLOR];
 [shapeLayer setStrokeColor: [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
 [shapeLayer setLineWidth:4];
 [shapeLayer setLineJoin:kCALineJoinRound];
 [shapeLayer setLineDashPattern:@[ @(10), @(5)]];
 // Setup the path
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 //	CGMutablePathRef path = CGPathCreateMutable();
 //	CGPathAddRect(path, NULL, shapeRect);
 //	[shapeLayer setPath:path];
 //	CGPathRelease(path);
 [shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:shapeRect
 cornerRadius:layer.cornerRadius] quartzPath]];
 CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
 [dashAnimation setFromValue:@(0.0f)];
 [dashAnimation setToValue:@(15.0f)];
 [dashAnimation setDuration:0.75f];
 [dashAnimation setRepeatCount:10000];
 [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	float total = (((2* NSMaxX(contentLayer.frame)) + (2 * NSMaxY(box.frame)))/16);
 //	CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
 //	dashAnimation.fromValue     = $float(0.0f);	dashAnimation.toValue   = $float
 //	(total);
 //
 //	dashAnimation.duration	= 3;		dashAnimation.repeatCount = 10000;
 //	//	dashAnimation.beginTime = CACurrentMediaTime();// + 2;
 //	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //	shapeLayer.fillColor        = cgRED;
 //	shapeLayer.strokeColor	= cgBLACK;
 //	shapeLayer.lineJoin		= kCALineJoinMiter;
 //	shapeLayer.lineDashPattern  = $array( $int(total/8), $int(total/8));
 //
 //	//		srelectedBox.shapeLayer.lineDashPattern     = $array( $int(15), $int(45));
 //	shapeLayer.lineWidth = 5;
 //	[shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:contentLayer.bounds cornerRadius:contentLayer.cornerRadius ] quartzPath]];
 [layer addSublayer:shapeLayer];
 [shapeLayer addConstraintsSuperSize];
 return shapeLayer;
 }
 - (void) redrawPath {
 CAL*selected = [_lassoLayer valueForKey:@"mommy"];
 CGRect shapeRect = selected.bounds;
 shapeRect.size.width -= 4;
 shapeRect.size.height -= 4;
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathAddRect(path, NULL, shapeRect);
 [_lassoLayer setPath:path];
 CGPathRelease(path);
 [_contentLayer setNeedsDisplay];
 }
 */
/*
 CATransform3D t =
 CATransform3DConcat(
 CATransform3DMakeRotation(x, 0, 1, 0),
 CATransform3DMakeRotation( y, 1, 0, 0));
 t        = [self hasPropertyForKVCKey:@"sublayerTransform"] ? CATransform3DConcat(self.sublayerTransform, t) : t;
 t.m34	= [self hasPropertyForKVCKey:@"sublayerTransform.m34"] ? self.sublayerTransform.m34 : 1.0 / -450;
 self.sublayerTransform = t;
 - (void)orientOnEvent: (NSEvent*)event;
 {
 CGPoint point = NSPointToCGPoint([self convertPoint:theEvent.locationInWindow fromView:nil]);
 draggedDuringThisClick = true;
 deltaX = (point.x - dragStart.x)/200;
 deltaY = - (point.y - dragStart.y)/200;
 [self orientWithX:(angleX+deltaX) andY:(angleY+deltaY)];
 */
- (void) orientWithPoint:(CGP)pt                { [self orientWithX:pt.x andY:pt.y]; }
- (void)     orientWithX:(CGF)x   andY:(CGF)y   {	self.sublayerTransform = ({

  CAT3D t = CATransform3DConcat(CATransform3DMakeRotation(x, 0, 1, 0),
                                CATransform3DMakeRotation(y, 1, 0, 0));	t.m34	= 1. / -450.; t; });
}
- (void)         setAnchorPoint:(CGP)pt inView:(NSV*)v  { [self setAnchorPoint:pt inRect:v.bounds]; }
- (void) setAnchorPointRelative:(CGP)pt                 { [self setAnchorPoint:pt inRect:self.bounds]; }

- (void)         setAnchorPoint:(CGP)pt inRect:(NSR)r   {

	CGP newPoint = (CGP) {r.size.width *pt.x, r.size.height *pt.y },
      oldPoint = (CGP) {r.size.width *self.anchorPoint.x, r.size.height *self.anchorPoint.y },
      position = self.position;

  position.x += (newPoint.x - oldPoint.x);
  position.y += (newPoint.y - oldPoint.y);

	self.position	= position;
	self.anchorPoint = pt;

}

//	newPoint = CGPo CGPointApplyAffineTransform(newPoint,
//  self.transform); oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
//- (void) flipHorizontally {	[self flipForward:YES vertically:NO atPosition:99]; } - (void) flipVertically;  {	[self flipForward:YES vertically:YES atPosition:99]; }

- (void)    flipBackAtEdge:(AZA)pos { [self flipForward:NO atPosition:pos]; }
- (void) flipForwardAtEdge:(AZA)pos {	[self flipForward:YES atPosition:pos]; }

- (void) toggleFlip  {
	BOOL isFlipped = [self boolForKey:@"flipped"];// defaultValue:NO];
	isFlipped ? [self flipBack] : [self flipOver];
	[self setBool:isFlipped = !isFlipped forKey:@"flipped"];
}
- (void)flipDown  {        //:(CATransform3D)transform {
	self.anchorPoint = CGPointMake(.5, 0);
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform = CATransform3DRotate(transform, 180 * M_PI / 180, 1, 0, 0);
}
- (void)flipOver  {        //:(CATransform3D)transform {
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform = CATransform3DRotate(transform, 180 * M_PI / 180, 1, 0, 0);
}
- (void)flipBack  {        //:(CATransform3D)transform {
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 1.0 / 700.0;
	self.transform =  CATransform3DRotate(transform, 180 * M_PI / 180, -1, 0, 0);
}
+ (CATransform3D)flipAnimationPositioned:(AZPOS)pos {
	CGPoint dir = (CGPoint) {pos == AZTop || pos == AZBtm ? 1 : 0,
	pos == AZTop || pos == AZBtm ? 0 : 1 };
	return CATransform3DMakeRotation(DEG2RAD(180), dir.x, dir.y, 0.0f);
}
- (void)flipForward:(BOOL)forward atPosition:(AZPOS)pos duration:(NSTI)time   {

	CAT3D flip = [self flipForward:forward atPosition:pos];
	[self animate:@"transform" toTransform:flip time:time eased:CAMEDIAEASY completion:^{
    NSLog(@"flipped: %@", StringFromCATransform3D(flip));
	}];
}
- (CAT3D)flipForward:(BOOL)forward atPosition:(AZPOS)pos      {

	[self setAnchorPoint:AZAnchorPtAligned(pos) inRect:self.frame];

	CATransform3D flip = forward ? CATransform3DIdentity :

  pos == AZTop || pos == AZBtm ? CA3DxRotation(90) : CA3DyRotation(90);

	flip.m34 = -1 / 700;

	return flip;
}

#ifdef DEBUGTALKER
//	AZTALK($(@"Old: %.1f by %.1f and new is: %.1f by %.1f", self.anchorPoint.x, self.anchorPoint.y, new.x, new.y));
#endif
#ifdef DEBUGTALKER
//	AZTALK($(@"%@ flipped", newFlipState ? @"IS" : @"is NOT "));
#endif
- (void)setScale:(CGF)scale {
	[self setValue:[NSValue valueWithSize:NSSizeToCGSize((NSSize) {scale, scale})] forKeyPath:@"transform.scale"];
}
- (ReverseAnimationBlock)pulse  {

  self.hostView.layerUsesCoreImageFilters = YES;
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"]; [filter setDefaults];
	[filter setValue:@5.0f forKey:@"inputRadius"];
	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
	// set the filter to the selection layer's filters
	[self setFilters:@[filter]];
	// create the animation that will handle the pulsing.
	CABA *pulseAnimation = [CABA animation];
	// the attribute we want to animate is the inputIntensity of the pulseFilter
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue = @0.0f;
	pulseAnimation.toValue = @1.5f;
	// over one a one second duration, and run an infinite number of times
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = MAXFLOAT;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity input to go from 0 to 1 to 0
	pulseAnimation.autoreverses = YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[self addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	return ^{ [self removeAnimationForKey:@"pulseAnimation"]; };
}
- (void)addAnimations:(NSA *)anims forKeys:(NSA *)keys;   {
	[anims enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	[self addAnimation:obj forKey:keys[idx]];
	}];
}
- (void)fadeIn  {
	//	CABA *theAnimation=[CABA animationWithKeyPath:@"opacity"];
	//	theAnimation.duration=3.5;		theAnimation.repeatCount=1;
	//	theAnimation.autoreverses=YES;	theAnimation.fromValue=@(1.0);
	//	theAnimation.toValue=@(0.0);
	//	[self addAnimation:theAnimation forKey:@"animateOpacity"];
	CABA *theAnimation = [CABA animationWithKeyPath:@"opacity"];
	theAnimation.duration =  [self animationKeys]
	? [[[self animationForKey:[self animationKeys].first] valueForKey:@"duration"]floatValue] : .5;
	theAnimation.repeatCount = 1;
	theAnimation.fillMode = kCAFillModeForwards;
	theAnimation.removedOnCompletion = NO;
	//	theAnimation.autoreverses=NO;
	theAnimation.fromValue = @(0.0);
	theAnimation.toValue = @(1.0);
	[self addAnimation:theAnimation forKey:@"animateOpacity"];
	//	disable
}
- (void)fadeOut {
	CABA *theAnimation = [CABA animationWithKeyPath:@"opacity"];
	theAnimation.duration =  [self animationKeys]
	? [[[self animationForKey:[self animationKeys].first] valueForKey:@"duration"]integerValue] : .5;
	theAnimation.repeatCount = 1;
	theAnimation.fillMode = kCAFillModeForwards; //kCAFillModeBoth;
		//  theAnimation.autoreverses=NO;
	theAnimation.removedOnCompletion = NO;
	theAnimation.fromValue = @(1.0);
	theAnimation.toValue = @(0.0);
	[self addAnimation:theAnimation forKey:@"animateOpacity"];
}

- (CATransform3D)makeTransformForAngleX:(CGF)angle      {
	return [self makeTransformForAngle:angle from:CATransform3DIdentity];
}
- (CATransform3D)makeTransformForAngle:(CGF)angle from:(CATransform3D)start {
	CATransform3D transform = start;
	CATransform3D persp = CATransform3DIdentity;
	persp.m34 = 1.0 / -1000;
	transform = CATransform3DConcat(transform, persp);
	transform = CATransform3DRotate(transform, DEG2RAD(angle), 0.0, 1.0, 0.0);
	return transform;
}
- (BOOL)containsOpaquePoint:(CGPoint)p {
	if (![self containsPoint:p]) return NO;
	if (self.backgroundColor && CGColorGetAlpha(self.backgroundColor) > 0.15) return YES;
	float alpha = 0.0;
	// RESTORE if ([self isKindOfClass:[CATXTL class]]) return YES;
	CGImageRef image = (CGImageRef)[self.contents CGImage];
	if ( image ) {
	alpha = 1.0;	 //RESTORE GetPixelAlpha(image, self.bounds.size, p);
	}
	return alpha > 0.15;
}
- (id)sublayerWithName:(NSS *)n {
	return SameString(self.name,n) ? self : [self.sublayers filterOne:^BOOL(CAL*s) { return SameString(s.name,n); }];
}
- (id)sublayerWithNameContaining:(NSS*)n {
	return [self.name caseInsensitiveContainsString:n] ? self :
         [self.sublayers filterOne:^BOOL(CAL*s) { return [s.name caseInsensitiveContainsString:n]; }];
}

- (CAL *)magnifier:(NSView *)view {
	CAL *lace = CALayer.new;
	lace.frame = [view bounds];
	lace.borderWidth = 10; lace.borderColor = cgRANDOMCOLOR;
	CGContextRef context = NULL;         CGColorSpaceRef colorSpace;
	__unused int bitmapByteCount;	      int bitmapBytesPerRow;
	int pixelsHigh = (int)[[view layer] bounds].size.height;
	int pixelsWide = (int)[[view layer] bounds].size.width;
	bitmapBytesPerRow   = (pixelsWide * 4);
	//	bitmapByteCount	 = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,  8, bitmapBytesPerRow,   colorSpace,     kCGImageAlphaPremultipliedLast);
	if (context == NULL) {
	NSLog(@"Failed to create context."); return nil;
	}
	CGColorSpaceRelease( colorSpace );
	[[[view layer] presentationLayer] renderInContext:context];
	//	[[[view layer] presentationLayer] recursivelyRenderInContext:context];
	lace.contents = [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
	lace.contentsGravity = kCAGravityCenter;
	return lace;
	//	CGImageRef img =	NSBitmapImageRep *bitmap = [NSBitmapImageRep.alloc initWithCGImage:img];	CFRelease(img);	return bitmap;
}

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a        {
	double X = rect.origin.x;
	double Y = rect.origin.y;
	double W = rect.size.width;
	double H = rect.size.height;
	double y21 = y2a - y1a;
	double y32 = y3a - y2a;
	double y43 = y4a - y3a;
	double y14 = y1a - y4a;
	double y31 = y3a - y1a;
	double y42 = y4a - y2a;
	double a = -H * (x2a * x3a * y14 + x2a * x4a * y31 - x1a * x4a * y32 + x1a * x3a * y42);
	double b = W * (x2a * x3a * y14 + x3a * x4a * y21 + x1a * x4a * y32 + x1a * x2a * y43);
	double c = H * X * (x2a * x3a * y14 + x2a * x4a * y31 - x1a * x4a * y32 + x1a * x3a * y42) - H * W * x1a * (x4a * y32 - x3a * y42 + x2a * y43) - W * Y * (x2a * x3a * y14 + x3a * x4a * y21 + x1a * x4a * y32 + x1a * x2a * y43);
	double d = H * (-x4a * y21 * y3a + x2a * y1a * y43 - x1a * y2a * y43 - x3a * y1a * y4a + x3a * y2a * y4a);
	double e = W * (x4a * y2a * y31 - x3a * y1a * y42 - x2a * y31 * y4a + x1a * y3a * y42);
	double f = -(W * (x4a * (Y * y2a * y31 + H * y1a * y32) - x3a * (H + Y) * y1a * y42 + H * x2a * y1a * y43 + x2a * Y * (y1a - y3a) * y4a + x1a * Y * y3a * (-y2a + y4a)) - H * X * (x4a * y21 * y3a - x2a * y1a * y43 + x3a * (y1a - y2a) * y4a + x1a * y2a * (-y3a + y4a)));
	double g = H * (x3a * y21 - x4a * y21 + (-x1a + x2a) * y43);
	double h = W * (-x2a * y31 + x4a * y31 + (x1a - x3a) * y42);
	double i = W * Y * (x2a * y31 - x4a * y31 - x1a * y42 + x3a * y42) + H * (X * (-(x3a * y21) + x4a * y21 + x1a * y43 - x2a * y43) + W * (-(x3a * y2a) + x4a * y2a + x2a * y3a - x4a * y3a - x2a * y4a + x3a * y4a));
	//Transposed matrix
	CATransform3D transform;
	transform.m11 = a / i;
	transform.m12 = d / i;
	transform.m13 = 0;
	transform.m14 = g / i;
	transform.m21 = b / i;
	transform.m22 = e / i;
	transform.m23 = 0;
	transform.m24 = h / i;
	transform.m31 = 0;
	transform.m32 = 0;
	transform.m33 = 1;
	transform.m34 = 0;
	transform.m41 = c / i;
	transform.m42 = f / i;
	transform.m43 = 0;
	transform.m44 = i / i;
	return transform;
}

- (void) flipLayer:(CAL *)top withLayer:(CAL *)bottom      {
#define ANIMATION_DURATION_IN_SECONDS (1.0)
	// Hold the shift key to flip the window in slo-mo. It's really cool!
	CGF flipDuration = ANIMATION_DURATION_IN_SECONDS; // * (self.isDebugging || window.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);
	// The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
	CAL *hiddenLayer = bottom; //[frontView.isHidden ? frontView : backView layer];
	CAL *visibleLayer = top; // [frontView.isHidden ? backView : frontView layer];
	// Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
	[CATransaction begin]; {
	[CATransaction setValue:@YES forKey:kCATransactionDisableActions];
	[hiddenLayer setValue:@M_PI forKeyPath:@"transform.rotation.y"];
	//	if (self.isDebugging) // Shadows screw up corner finding
	//		[self _hideShadow:YES];
	}[CATransaction commit];
	// There's no way to know when we are halfway through the animation, so we have to use a timer. On a sufficiently fast machine (like a Mac) this is close enough. On something like an iPhone, this can cause minor drawing glitches
	//	[self performSelector:@selector(_swapViews) withObject:nil afterDelay:flipDuration / 2.0];
	// For debugging, sample every half-second
	//	if (self.isDebugging) {
	//	[debugger reset];
	//	NSUInteger frameIndex;
	//	for (frameIndex = 0; frameIndex < flipDuration; frameIndex++)
	//		[debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGF)frameIndex / 2.0];
	// We want a sample right before the center frame, when the panel is still barely visible
	//	[debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGF)flipDuration / 2.0 - 0.05];
	//	}
	// Both layers animate the same way, but in opposite directions (front to back versus back to front)
	[CATransaction begin]; {
	[hiddenLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
	[visibleLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
	}[CATransaction commit];
}
- (CAAG*) _flipAnimationWithDuration:(CGF)duration isFront:(BOOL)isFront;   {
	// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
	CABA *flipAnimation = [CABA animationWithKeyPath:@"transform.rotation.y"];
	// The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
	//#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
	//	flipAnimation.toValue = [NSNumber numberWithDouble:[backView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];
	// Shrinking the view makes it seem to move away from us, for a more natural effect
	CABA * shrinkAnimation = [CABA animationWithKeyPath:@"transform.scale"];
	//	shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];
	// We only have to animate the shrink in one direction, then use autoreverse to "grow"
	shrinkAnimation.duration = duration / 2.0;
	shrinkAnimation.autoreverses = YES;
	// Combine the flipping and shrinking into one smooth animation
	CAAG *animationGroup = [CAAG animation];
	animationGroup.animations = @[flipAnimation, shrinkAnimation];
	// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
	animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	// Set ourselves as the delegate so we can clean up when the animation is finished
	animationGroup.delegate = self;
	animationGroup.duration = duration;
	// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
	animationGroup.fillMode = kCAFillModeForwards;
	animationGroup.removedOnCompletion = NO;
	return animationGroup;
}

- (void)addSublayers:(NSA *)subLayers;  { self.sublayers = [self.sublayers ?: @[] arrayByAddingObjectsFromArray:subLayers]; } //	[subLayers do :^(id obj) { self addSublayer:obj]; }]; }
@end

@implementation CALayer (AtoZLayerFactory) @dynamic gridPalette;

+ (instancetype)layerNamed:(NSS *)name { id a = [self.class new]; [a sV:name fK:@"name"];	return a; }

+ (CAL *)withName:(NSString *)name inFrame:(NSRect)rect
		 colored:(NSColor *)color withBorder:(CGF)width colored:(NSColor *)borderColor;   {
	CAL *new		= [CALayer layer];
	if (name) new.name	= name;
	new.frame	= rect;
	new.position	= AZCenterOfRect(rect);
	new.borderWidth		= width;
	if (width) {
	new.borderWidth	   = width;
	new.borderColor	   = borderColor.CGColor;
	}
	if (color) new.backgroundColor = color.CGColor;
	new.contentsGravity     = kCAGravityResizeAspect;
	new.autoresizingMask    = kCALayerWidthSizable | kCALayerHeightSizable;
	return new;
}

+ (CAL *)veilForView:(CAL *)view {
	int pixelsHigh = (int)[view bounds].size.height;
	int pixelsWide = (int)[view bounds].size.width;
	int bitmapBytesPerRow   = (pixelsWide * 4);
	__unused int bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	//	context = NULL;
	CGContextRef context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,
		 8,     bitmapBytesPerRow,
		 colorSpace, kCGImageAlphaNoneSkipLast);	//kCGImageAlphaNoneSkipLastkCGImageAlphaPremultipliedLast);
	if (context == NULL) {
	NSLog(@"Failed to create context.");    return nil;
	}
	CGColorSpaceRelease( colorSpace );
	[[view presentationLayer] renderInContext:context];
	CAL *layer = [CALayer layer];
	[layer setFrame:view.bounds];
	[layer setBackgroundColor:cgBLACK];
	if (view) [layer setDelegate:view];
	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	layer.contents =  [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
	//	.frame = [view bounds];
	layer.zPosition = 1000;
	return layer;
	//	CFBridgingRetain(//	NS)BitmapImageRep *bitmap = [NSBitmapImageRep.alloc initWithCGImage:img];
	//	CFRelease(img);
	//	return bitmap;
}

+ (CAL*)         closeBoxLayer          {
	CAL *layer = [CALayer closeBoxLayerForLayer:nil];
	return layer;
}
+ (CAL *)closeBoxLayerForLayer:(CAL *)parentLayer;        {
	CAL *layer = [CALayer layer];
	[layer setFrame:CGRectMake(0.0, 0,
	30.0, 30.0)];
	[layer setBackgroundColor:cgBLACK];
	[layer setShadowColor:cgBLACK];
	[layer setShadowOpacity:1.0];
	[layer setShadowRadius:5.0];
	[layer setBorderColor:cgWHITE];
	[layer setBorderWidth:3];
	[layer setCornerRadius:15];
	if (parentLayer) [layer setDelegate:parentLayer];
	return layer;
}

+ (CAL*) gridLayerWithFrame:(NSR)r rows:(NSUI)rowCt cols:(NSUI)colCt palette:(NSA*)pal  {   NSN *rows = @(rowCt); NSN*cols = @(colCt);

  CAL *grid = [[self layerWithFrame:r mask:CASIZEABLE] objectBySettingValue:AZLAYOUTMGR forKey:@"layoutManager"];

  [rows times:^(NSN *r) {
    [cols times:^(NSN *c) {

      CAL *cell         = pal ? [CAGL gradientWithColor:pal.nextNormalObject] : [self layer];
      cell.borderColor  = cgWHITE;
      cell.borderWidth  = 1;
      cell.constraints  = @[  AZConstRelSuperScaleOff( kCAConstraintWidth,  1/cols.fV, 0),
                              AZConstRelSuperScaleOff( kCAConstraintHeight, 1/rows.fV, 0),
                       AZConstAttrRelNameAttrScaleOff( kCAConstraintMinX, AZSLayer, kCAConstraintMaxX, c.iV/cols.fV,0),
                       AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, AZSLayer, kCAConstraintMaxY, r.iV/rows.fV,0)];
      [cell disableResizeActions];
      [grid addSublayer:cell];
    }];
  }];
  [grid disableResizeActions];
  return grid;
}

+ (CAL*) gridLayerWithFrame:(NSR)r rows:(NSUI)rowCt
                                   cols:(NSUI)colCt { return [self gridLayerWithFrame:r rows:rowCt cols:colCt palette:nil]; }


/*
+ (CAL*) gridLayerWithFrame:(NSR)r rows:(NSUI)rowCt
                                   cols:(NSUI)colCt
                                palette:(NSA*)pal   { // NSN *rows = @(rowCt); NSN*cols = @(colCt);

  CAL *grid = [[self layerWithFrame:r mask:CASIZEABLE] wVsfKs:AZLAYOUTMGR,@"layoutManager",nil];//AZVSZBy(colCt, rowCt), @"dimensions", nil];

  [grid  setSizeChanged:^(NSSize oldSz, NSSize newSz) {

  [grid iterateGrid:^(NSInteger r, NSInteger c) {

    if ([grid.sublayers.count] != (r + c) - 2)

          cell.constraints  = @[  AZConstRelSuperScaleOff( kCAConstraintWidth,  1/(float)colCt, 0),
                              AZConstRelSuperScaleOff( kCAConstraintHeight, 1/(float)rowCt, 0),
                       AZConstAttrRelNameAttrScaleOff( kCAConstraintMinX, AZSLayer, kCAConstraintMaxX, c/(float)colCt,0),
                       AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, AZSLayer, kCAConstraintMaxY, r/(float)rowCt,0)];

  }];


  [grid iterateGrid:^(NSInteger r, NSInteger c) {  // equiv to [rows times:^(NSN *r) { [cols times:^(NSN *c) { }]; }};

      CAL *cell         = pal ? [CAGL gradientWithColor:pal.nextNormalObject] : [self layer];
      cell.borderColor  = cgWHITE;
      cell.borderWidth  = 1;
      [cell disableResizeActions];
      cell.name = $(@"%lu:%lu",r,c);
      [grid addSublayer:cell];
    }];
  [grid disableResizeActions];
  return grid;
}

- (void) setGridPalette:(NSArray *)gridPalette {

  [self iterateGrid:^(NSInteger r1, NSInteger c) {  }]
}
*/

SYNTHESIZE_ASC_PRIMITIVE_KVO(noHit, setNoHit, BOOL);

+ (INST) noHitLayerWithFrame:(NSR)r mask:(NSUI)m  { id x = [self.class noHitLayer]; [x setFrame:r]; [(CAL*)x setAutoresizingMask:m]; return x; }
+ (INST) noHitLayerWithFrame:(NSR)r               { id x = [self.class noHitLayer]; [x setFrame:r];    return x; }
+ (INST) noHitLayer                               { id x = [self.class layer]; [x setNoHit:YES]; return x; }

+ (INST) layerWithFrame:(NSR)f mask:(CAMASK)m { CAL* x = [self layerWithFrame:f]; [x setAutoresizingMask:m]; return x;      }
+ (INST) layerWithFrame:(NSR)f                { CAL* l = self.class.layer; l.frame = f; return l;    }
+ (INST) layerWithValue: v forKey:(NSS*)k  { return [self.class.layer objectBySettingValue:v forKey:k];                  }
+ (INST) layerWithValuesForKeys: x,...     { azva_list_to_nsarray(x, vals); return [self.class.new objectBySettingVariadicPairs:vals]; }

// create a new "sphere" layer and add it to the container layer
+ (CAGL*) gradientWithColor:(NSC*)c {
	CAGL *h	      = CAGL.layer;
	h.colors	     =  @[ (id)c.darker.CGColor, (id)c.CGColor, (id)c.brighter.CGColor];
	h.locations     = @[ @0, @.5, @1 ];
	return h;
}

//Metallic grey gradient background
+ (CAGL*) greyGradient              {
	CAGL *headerLayer = CAGL.layer;
	return headerLayer.colors = @[(id)[NSC white: 0.15f a: 1.0f].CGColor,
		(id)[NSC white: 0.19f a: 1.0f].CGColor,
		(id)[NSC white: 0.20f a: 1.0f].CGColor,
		(id)[NSC white: 0.25f a: 1.0f].CGColor],
	headerLayer.locations = @[      $float(0),
		$float(.5),
		$float(.5),
		$float(1)], headerLayer;
}

+  (CAL*) newGlowingSphereLayer     {
	// generate a random size scale for glowing sphere
	NSUInteger randomSizeInt	     = (random() % 200 + 50 );
	CGF sizeScale	= (CGF)randomSizeInt / 100.0;
	NSImage *compositeImage         = [NSImage glowingSphereImageWithScaleFactor:sizeScale coreColor:WHITE glowColor:RANDOMCOLOR];
	//	CGImageRef cgCompositeImage = [compositeImage cgImage];
	// generate a random opacity value with a minimum of 15%
	NSUInteger randomOpacityInt = (random() % 100 + 15 );
	CGF opacityScale = (CGF)randomOpacityInt / 100.0;
	CAL *sphereLayer	  = [CALayer layer];
	sphereLayer.name	  = @"glowingSphere";
	sphereLayer.bounds	  = CGRectMake ( 0, 0, 20, 20 );
	sphereLayer.contents	 = compositeImage;
	sphereLayer.contentsGravity      = kCAGravityCenter;
	//	sphereLayer.delegate		= self;
	sphereLayer.opacity	= opacityScale;
	return sphereLayer;
	// "movementPath" is a custom key for just this app
	//	[self.containerLayerForSpheres addSublayer:sphereLayer];
	//	[sphereLayer addAnimation:[self randomPathAnimation] forKey:@"movementPath"];
	//	CGImageRelease ( cgCompositeImage );
}

@end
//	CALayer+LTKAdditions.m LTKit	Copyright (c) 2012 Michael Potter	http://lucas.tiz.ma	lucas@tiz.ma  <LTKit/LTKit.h>
NSTI const LTKDefaultTransitionDuration = 0.25;
#pragma mark - LTKAnimationDelegate Internal Class
@interface LTKAnimationDelegate : NSObject
@property (readwrite, nonatomic, copy) void (^startBlock)();
@property (readwrite, nonatomic, copy) void (^stopBlock)(BOOL finished);
@end
#pragma mark - Category Implementation
@implementation LTKAnimationDelegate @synthesize startBlock, stopBlock;
#pragma mark - Protocol Implementations CAAnimation Methods (Informal)
- (void)animationDidStart:(CAA*)animation                           {
	if (self.startBlock != nil) {
	self.startBlock();
	}
}
- (void)animationDidStop:(CAA*)animation finished:(BOOL)finished   {
	if (self.stopBlock != nil) {
	self.stopBlock(finished);
	}
}
@end

//#import <Zangetsu/Zangetsu.h>

@implementation CALayer (LTKAdditions)
/*
+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSString *)key {

  NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

  if ([@[ @"frameOrigin",@"frameSize",
@"frameX",
@"frameY",
@"frameWidth",
@"frameHeight",
@"frameMinX",
@"frameMidX",
@"frameMaxX",
@"frameMinY",
@"frameMidY",
@"frameMaxY",
@"frameTopLeftPoint",
@"frameTopMiddlePoint",
@"frameTopRightPoint",
@"frameMiddleRightPoint",
@"frameBottomRightPoint",
@"frameBottomMiddlePoint",
@"frameBottomLeftPoint",
@"frameMiddleLeftPoint",
@"boundsOrigin",
@"boundsSize",
@"boundsX",
@"boundsY",
@"boundsWidth",
@"boundsHeight",
@"boundsMinX",
@"boundsMidX",
@"boundsMaxX",
@"boundsMinY",
@"boundsMidY",
@"boundsMaxY", @"boundsTopLeftPoint", @"boundsTopMiddlePoint", @"boundsTopRightPoint",@"boundsMiddleRightPoint",
@"boundsBottomRightPoint",@"boundsBottomMiddlePoint", @"boundsBottomLeftPoint",@"boundsMiddleLeftPoint",@"positionX", @"positionY"]
  containsObject:key]) keyPaths = [keyPaths setByAddingObjectsFromArray:@[@"bounds", @"position"]];

  return keyPaths;

} 

- (id) initWithFrame:(CGRect)rect	      {

	//from starlayer
	if (!(self = [super init])) return nil;
	self.root	= [CAL layer];
	self.text	= [CAL layer];
	self.root.delegate  = self;
	self.root.frame     = rect;
	self.root.arMASK    = CASIZEABLE;
	self.root.NDOBC     = YES;
	//	_star	= [CAL layer];
	//	[@[_star, _text] do:^(CAL *obj){
	//	obj.frame	= AZMakeRectFromSize(rect.size);
	//	    obj.delegate	= self;
	//	[obj setNeedsDisplay];
	//	[_root addSublayer:obj];
	//	}];
	//	[self toggleSpin:AZOn];
	[self addSublayer:self.root];
	[self setNeedsDisplay];
	return self;
}

//	![self[@"flipped"] || ![self hasPropertyForKVCKey:@"orient"] ? ^{
////	[self setAnchorPointRelative:self.position];
//	[self setAnchorPoint:AZAnchorPtAligned(pos)
//	  inRect:self.bounds];
////	CATransform3D orig = CATransform3DIsIdentity(self.transform) ? CATransform3DIdentity : self.transform;
//	self[@"savedTransform"] = AZV3d(self.transform);//AZV3d(orig);
//	self[@"flippedTransform"] = AZV3d([CAL flipAnimationPositioned:pos]);
//	self[@"flipped"] = @NO;
//	}():nil;

//	CATransform3D savedFlip = [self[@"flippedTransform"]CATransform3DValue];
//	CATransform3D now = self[@"flipped"] ? CATransform3DConcat(savedOrig, savedFlip) : savedOrig;
//	CATransform3D savedOrig = [self[@"savedTransform"]	CATransform3DValue];
//	CATransform3D savedFlip = [self[@"flippedTransform"]CATransform3DValue];
//	CATransform3D now = self[@"flipped"] ? CATransform3DConcat(savedOrig, savedFlip) : savedOrig;
//		self[@"flipped"] = [self[@"flipped"]boolValue] ? @NO :@YES;
//		self.transform = now;
//		[self lassoLayerForLayer:self];

//NSImage *image = // load a image
//CAL*layer = [CALayer layer];
//[layer setContents:image];
//[view setLayer:myLayer];
//[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
//view.layer.transform = [self rectToQuad:view.frame quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];
//[1]: http://codingincircles.com/2010/07/major-misunderstanding/

*/
#pragma mark - CALayer (LTKAdditions) Methods
- (void)setAnchorPointAndPreserveCurrentFrame:(CGPoint)anchorPoint;     {
	CGPoint newPoint = CGPointMake((self.width * anchorPoint.x), (self.height * anchorPoint.y));
	CGPoint oldPoint = CGPointMake((self.width * self.anchorPoint.x), (self.height * self.anchorPoint.y));
	newPoint = CGPointApplyAffineTransform(newPoint, self.affineTransform);
	oldPoint = CGPointApplyAffineTransform(oldPoint, self.affineTransform);
	CGPoint position = self.position;
	position.x -= oldPoint.x;
	position.x += newPoint.x;
	position.y -= oldPoint.y;
	position.y += newPoint.y;
	self.position = position;
	self.anchorPoint = anchorPoint;
}
+ (CGF)smallestWidthInLayers:(NSA *)layers       {
	CGF smallestWidth = 0.0f;
	for (CAL * layer in layers) {
	if (layer.width < smallestWidth) {
		smallestWidth = layer.width;
	}
	}
	return smallestWidth;
}
+ (CGF)smallestHeightInLayers:(NSA *)layers      {
	CGF smallestHeight = 0.0f;
	for (CAL * layer in layers) {
	if (layer.height < smallestHeight) {
		smallestHeight = layer.height;
	}
	}
	return smallestHeight;
}
+ (CGF)largestWidthInLayers:(NSA *)layers        {
	CGF largestWidth = 0.0f;
	for (CAL * layer in layers) {
	if (layer.width > largestWidth) {
		largestWidth = layer.width;
	}
	}
	return largestWidth;
}
+ (CGF)largestHeightInLayers:(NSA *)layers       {
	CGF largestHeight = 0.0f;
	for (CAL * layer in layers) {
	if (layer.height > largestHeight) {
		largestHeight = layer.height;
	}
	}
	return largestHeight;
}
- (CAL*)presentationCALayer     {
  id x = [self presentationLayer];
  x = x ?: [self modelLayer];
  x = x ?: self;
  return x;
}
- (CAL *)modelCALayer    {
	return (CAL *)[self modelLayer];
}
- (void)addDefaultFadeTransition        {
	[self addFadeTransitionWithDuration:LTKDefaultTransitionDuration];
}
- (void)addDefaultMoveInTransitionWithSubtype:(NSS *)subtype     {
	[self addMoveInTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addDefaultPushTransitionWithSubtype:(NSS *)subtype       {
	[self addPushTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addDefaultRevealTransitionWithSubtype:(NSS *)subtype     {
	[self addRevealTransitionWithSubtype:subtype duration:LTKDefaultTransitionDuration];
}
- (void)addFadeTransitionWithDuration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];  // kCATransitionFade is the default type
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addMoveInTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionMoveIn;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addPushTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration    {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionPush;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addRevealTransitionWithSubtype:(NSS *)subtype duration:(NSTimeInterval)duration  {
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionReveal;
	transition.subtype = subtype;
	transition.duration = duration;
	[self addAnimation:transition forKey:kCATransition];
}
- (void)addAnimation:(CAAnimation *)animation   {
	[self addAnimation:animation forKey:nil];
}
- (void)addAnimation:(CAAnimation *)animation forKey:(NSS *)key withStopBlock:(void (^)(BOOL finished))stopBlock {
	[self addAnimation:animation forKey:key withStartBlock:nil stopBlock:stopBlock];
}
- (void)addAnimation:(CAAnimation *)animation forKey:(NSS *)key withStartBlock:(VoidBlock)startBlock stopBlock:(void (^)(BOOL finished))stopBlock        {

	LTKAnimationDelegate *animationDelegate = LTKAnimationDelegate.new;
	animationDelegate.startBlock  = startBlock;
	animationDelegate.stopBlock   = stopBlock;
	animation.delegate          = animationDelegate;
	[self addAnimation:animation forKey:key];
}
- (void)replaceAnimationForKey:(NSS *)key withAnimation:(CAAnimation *)animation {

  if ([self.animationKeys containsObject:key]) [self removeAnimationForKey:key];
	[self addAnimation:animation forKey:key];
}
- (NSA *)keyedAnimations {
	NSMutableArray *keyedAnimations = [NSMutableArray array];
	for (NSString * animationKey in [self animationKeys]) {
	[keyedAnimations addObject:[self animationForKey:animationKey]];
	}
	return [keyedAnimations copy];
}
- (NSImage *)renderToImage      {
	return [self renderToImageWithContextSize:CGSizeZero contextTransform:CGAffineTransformIdentity];
}
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize   {
	return [self renderToImageWithContextSize:contextSize contextTransform:CGAffineTransformIdentity];
}
- (NSImage *)renderToImageWithContextSize:(CGSize)contextSize contextTransform:(CGAffineTransform)contextTransform      {
	int pixelsHigh	       = (int)self.height;
	int pixelsWide	       = (int)self.width;
	int bitmapBytesPerRow   = (pixelsWide * 4);
	__unused int bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	CGColorSpaceRef cSpc    = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef ctx     = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
		 bitmapBytesPerRow, cSpc, kCGImageAlphaPremultipliedLast);
	if (ctx == NULL) {
	NSLog(@"Failed to create context."); return nil;
	}
	CGColorSpaceRelease(cSpc);
	[[self presentationLayer] ? [self presentationLayer]:self renderInContext:ctx];
	CGImageRef img	       = CGBitmapContextCreateImage(ctx);
	return [[NSImage alloc]initWithCGImage:img size:contextSize];
}
- (void)enableDebugBordersRecursively:(BOOL)recursively { IF_VOID(ISA(self,AZDebugLayer));

	AZDebugLayer *l = ({ id x; if (!(x = [self scanSubsForClass:AZDebugLayer.class])) [self addSublayer: x = AZDebugLayer.new]; x; });

  if (!recursively || !self.sublayers.count)  return;
  [[self.sublayers arrayWithoutObject:l] do:^(id obj) { [obj enableDebugBordersRecursively:YES]; }];

}
@end

@implementation CALayerNonAnimating
- (id<CAAction>)actionForKey:(NSS *)key; {
	// return nil to disable animations on this layer
	return nil;
}
@end
@implementation CAScrollLayer  (CAScrollLayer_Extensions) 

//- (void)scrollBy:(CGPoint)inDelta       {
//	const CGRect theVisibleRect = self.visibleRect;
//	const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
//	[self scrollToPoint:theNewScrollLocation];
//}
- (void)scrollTo:(CGF)off        { CGF delta = 0;
  objswitch(self.scrollMode)
//    objcase(@"both") 
    objcase(@"none") return;
    objcase(@"vertically")   	delta = self.position.y - off;
    objcase(@"horizontally") 	delta = self.position.x - off;
  endswitch
  [self scrollBy:delta];
}
- (void)scrollBy:(CGF)inDelta       {
  objswitch(self.scrollMode)
    objcase(kCAScrollVertically)   	[self scrollToPoint: AZPointOffsetY(self.bounds.origin, inDelta)];
    objcase(kCAScrollHorizontally) 	[self scrollToPoint: AZPointOffsetX(self.bounds.origin, inDelta)];
    objcase(kCAScrollBoth) 	        [self scrollToPoint:AZPointOffsetBy(self.bounds.origin, inDelta, inDelta)];
    objcase(kCAScrollNone)           return;
  endswitch

//	const CGRect theVisibleRect = self.visibleRect;
//	const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
//	[self scrollToPoint:theNewScrollLocation];
}
- (void)scrollCenterToPoint:(CGPoint)inPoint;   {
	const CGRect theBounds = self.bounds;
	const CGPoint theCenter = {
	.x = CGRectGetMidX(theBounds),
	.y = CGRectGetMidY(theBounds),
	};
	const CGPoint theNewPoint = {
	.x = inPoint.x - theCenter.x,
	.y = inPoint.y - theCenter.y,
	};
	[self scrollToPoint:theNewPoint];
}
@end
static const char *kRenderAsciiBlockKey = "-";
@implementation CALayer (MPPixelHitTesting)
- (void)setRenderASCIIBlock:(MPRenderASCIIBlock)block  {
	objc_setAssociatedObject(self, kRenderAsciiBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (MPRenderASCIIBlock)renderASCIIBlock {
	return objc_getAssociatedObject(self, kRenderAsciiBlockKey);
}
- (BOOL)pixelsIntersectWithRect:(CGRect)rect   {
	CGRect bounds = CGRectIntersection(self.pixelsHitTestRect, rect);
	// If our pixel bounds do not intersect with the rect then we have nothing to test!
	if (CGRectIsNull(bounds)) return NO;
	// For pretty ascii art uncomment this line
	MPRenderASCIIBlock renderBlock = self.renderASCIIBlock;
	if (renderBlock) bounds = self.pixelsHitTestRect;
	uint64_t width  = ceil(bounds.size.width);
	uint64_t height = ceil(bounds.size.height);
	uint64_t count  = width * height;
	uint64_t hit    = 0;
	// We render directly into our result if it takes only 1 byte.
	uint8_t *buf = (count == 1) ? &hit : calloc(count, 1);
	CGContextRef theMask = CGBitmapContextCreate(buf, width, height, 8, width, NULL, kCGImageAlphaOnly);
	if (theMask) {
	// Translate so that our bounds origin is at 0,0 in our buffer
	CGContextTranslateCTM(theMask, -bounds.origin.x, -bounds.origin.y);
	// By adding a blurry shadow we make it easier to click on little things
	CGContextSetShadow(theMask, CGSizeMake(0, 0.0f), 2.0f);
	// We can now render the presentatinLayer
	[self.presentationLayer renderInContext:theMask];
	// CAShapeLayers don't renderInContext so we need a workaround
	if ([self isKindOfClass:[CAShapeLayer class]]) [self renderShapeLayer:(CAShapeLayer *)self inContext:theMask];
	// Additional code for rendering the ascii art.
	// Requires the CocoaPuffs framework at https://github.com/macprog-guy/CocoaPuffs
	if (renderBlock) renderBlock([[NSData dataWithBytesNoCopy:buf length:count freeWhenDone:NO] asciiArtOfWidth:(int)width andHeight:(int)height]);
	// Check the more complicated case where we are looking at a larger rect
	if (count > 1) {
		for (int i = 0; i < count && !hit; i++) {
		hit += buf[i];
		}
		free(buf);
	}
	CGContextRelease(theMask);
	}
	return (hit != 0);
}
- (void)renderShapeLayer:(CAShapeLayer *)layer inContext:(CGContextRef)context  {
	if (layer.path) {
	// TODO: still incomplete. Should finish implementation.
	CGColorRef whiteColor = CGColorGetConstantColor(kCGColorWhite);
	CGColorRef clearColor = CGColorGetConstantColor(kCGColorClear);
	CGContextAddPath(context, layer.path);
	CGContextSetLineWidth(context, layer.lineWidth);
	CGLineCap cap = kCGLineCapButt;
	if ([layer.lineCap isEqualToString:kCALineCapRound]) cap = kCGLineCapRound;	// COV_NF_LINE
	else if ([layer.lineCap isEqualToString:kCALineCapSquare]) cap = kCGLineCapSquare;    // COV_NF_LINE
	CGLineJoin join = kCGLineJoinMiter;
	if ([layer.lineJoin isEqualToString:kCALineJoinBevel]) join = kCGLineJoinBevel;       // COV_NF_LINE
	else if ([layer.lineJoin isEqualToString:kCALineJoinRound]) join = kCGLineJoinRound;  // COV_NF_LINE
	CGContextSetLineCap(context, cap);
	CGContextSetLineJoin(context, join);
	if (layer.fillColor && !CGColorEqualToColor(layer.fillColor, clearColor)) {
		CGContextSetFillColorWithColor(context, whiteColor);
		CGContextFillPath(context);
	}
	if (layer.strokeColor && !CGColorEqualToColor(layer.strokeColor, clearColor)) {
		CGContextSetStrokeColorWithColor(context, whiteColor);
		CGContextStrokePath(context);
	}
	}
}
- (BOOL)pixelsHitTest:(CGPoint)p       {
	return [self pixelsIntersectWithRect:CGRectMake(p.x - 0.5, p.y - 0.5, 1, 1)];
}
- (CGRect)pixelsHitTestRect    {
	return CGRectInset(self.bounds, -3, -3);
}
@end

/*	__block CAL* hit = [self hitTestSubs:p];
 __block CAL* try = hit;
 CGF(^top)(void) = ^CGF{ return  [self.superlayer.sublayers floatForKeyPath:@"@max.zPosition"]; };
 while (try && hit.zPosition < top() ){
 if ([hit respondsToSelector:@selector(count)]) {
 CGF top = [hit floatForKeyPath:@"@max.zPosition"];
 if (top != 0) hit = [hit objectWithValue:@(top) forKey:@"zPosition"];
 NSLog(@"sorted the hittest by zPosition... winnder %f", top);
 }
 if ([hit respondsToString:@"last"]) { hit = [hit last]; NSLog(@"giving the last hittest"); }
 //	NSLog(@"newZpos:%f", top);
 CABA *topper = [CABA animationWithKeyPath:@"zPosition" andDuration:1 andSet:hit];
 topper.toValue = @(top);
 topper.fromValue = @([hit presentationCALayer].zPosition);
 [CAAnimationDelegate delegate:topper forLayer:hit];
 [hit addAnimation:topper forKey:nil];
 //	[hit animate:@"zPosition" toInt:top  time:2 completion:^{
 if (hit && [hit respondsToString:@"selected"] && [hit respondsToString:@"setSelected:"]) {
 [hit setSelected:![hit boolForKey:@"selected"]];
 return hit;
 }
 }
 
 //  static SEL contains = NULL;  if (contains == NULL) contains = @selector(containsPoint:);

  if (self[@"noHit"] && self.noHit == yesDontHit) return;
  if (self[@"noHitState"]) { self[@"noHitState"] = @(yesDontHit); return; }

  NSLog(@"overridding contains point %p", self);
	[self az_overrideSelector:contains withBlock:(__bridge void*)^BOOL(id _self,NSP p) {
    BOOL(*superIMP)(id,SEL,NSP) = [_self az_superForSelector:contains];
    BOOL noHitSet = (_self[@"noHitState"]);
    BOOL noHitVal = [_self[@"noHitState"] boolValue];
    NSLog(@"%@ noHitSet:%@  noHitVal:%@",_self, StringFromBOOL(noHitSet),StringFromBOOL(noHitVal));
    return noHitSet && noHitVal ? NO : superIMP(_self, contains, p);
	}];
  self[@"noHitState"] = @(yesDontHit);
//  XX(self[@"noHitState"]);

	id booool = objc_getAssociatedObject(self,(__bridge const void *)@"noHit");
	return booool ? [booool boolValue]	: NO;
  if (self[@"unhittable"]) return [self sV:@(yesDontHit) fK:@"unhittable"];
  LOGCOLORS( @"Setting nohit:", StringFromBOOL(yesDontHit),
             @" Current nohit:", StringFromBOOL(self.noHit), nil);
  self[@"unhittable"] = @(yesDontHit);
  SEL contains = @selector(containsPoint:);
#import "AtoZFunctions.h"
#import "NSObject+AtoZ.h"

 [bp scaledToFrame:self.frame].CGPath;
  [self setPath:[NSBP bezierPathWithRect:self.bounds].quartzPath];
  [self setNeedsDisplay];
  NSBP *bp = [NSBP bezierPathWithCGPath:self.path];
  NSR r = [bp bounds];
  LOGCOLORS(@"resizing old path:", bp,  @" with Newbounds:", AZStringFromRect(self.bounds), nil);
  [self didChangeValueForKey:@"path"];
  [self setNeedsDisplay];
	CAL *selected = [self valueForKey:@"mommy"];
	CGRect shapeRect = selected.bounds;
	shapeRect.size.width -= 4;
	shapeRect.size.height -= 4;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, shapeRect);
	[self setPath:path];
	CGPathRelease(path);
	[self.superlayer setNeedsDisplay];

 */
/*
 struct CATransform3D	 {	CGF m11, m12, m13, m14;
 CGF m21, m22, m23, m24;
 CGF m31, m32, m33, m34;
 CGF m41, m42, m43, m44; };	typedef struct CATransform3D CATransform3D;
 @property CATransform3D  transform,
 sublayerTransform;
 @property CGPoint	 anchorPoint;
 @property CGF	 anchorPointZ;
 ***  CATransform3D Matrix Operations ***
 CATransform3D CATransform3DMakeTranslation ( CGF tx,         CGF ty,     CGF tz	);
 CATransform3D CATransform3DMakeScale (	CGF sx,	  CGF sy,	CGF sz	);
 CATransform3D CATransform3DMakeRotation (	CGF angle,      CGF x,      CGF y,      CGF z	);
 CATransform3D CATransform3DTranslate (	CATransform3D t,    CGF tx,     CGF ty,     CGF tz	);
 CATransform3D CATransform3DScale (		CATransform3D t,    CGF sx,     CGF sy,     CGF sz	);
 CATransform3D CATransform3DRotate (		CATransform3D t,    CGF angle,	CGF x,	CGF y,	CGF z	);
 CATransform3D CATransform3DConcat (		CATransform3D a,    CATransform3D b	);
 CATransform3D CATransform3DInvert (		CATransform3D t	);
 ***  Scale the layer along the x-axis ***
 [layer setValue:[NSNumber numberWithFloat:1.5] forKeyPath:@"transform.scale.x"];
 ***  Same result as above ***
 CGSize biggerX = CGSizeMake(1.5, 1.);
 [layer setValue:[NSValue valueWithCGSize:biggerX] forKeyPath:@"transform.scale"];
 // Makes this function run when the app loads
 //__attribute__((constructor))	static void InitQuartzUtils()	{ }
 */
/*	File: QuartzUtils.m  Abstract: Assorted CoreGraphics / Core Animation utility functions.	*/
/*
 CATXTL* AddTextLayer( CAL*superlayer,	NSString *text, NSFont* font,	enum CAAutoresizingMask align ) {
 CATXTL *label     = CATXTL.new;
 label.foregroundColor = kBlackColor;
 label.string        = text;
 label.font          = (__bridge CGFontRef)font;
 label.fontSize      = font.pointSize;
 NSString *mode	    = align & kCALayerWidthSizable  ? @"center"
 : align & kCALayerMinXMargin    ? @"right"	: @"left";
 align |= kCALayerWidthSizable;
 label.alignmentMode = mode;
 CGF inset       = superlayer.borderWidth + 3;
 CGRect bounds       = CGRectInset(superlayer.bounds, inset, inset);
 CGF height      = font.ascender;
 CGF y	= bounds.origin.y;
 y	       += align & kCALayerHeightSizable	? ((bounds.size.height-height) / 2.0)
 : align & kCALayerMinYMargin    ? bounds.size.height - height : 0;
 align &= ~kCALayerHeightSizable;
 label.bounds        = (CGRect) { 0, font.descender, bounds.size.width, height - font.descender };
 label.position      = (CGPoint) { bounds.origin.x, y+font.descender };
 label.anchorPoint   = (CGPoint) { 0, 0 };
 label.autoresizingMask = align;
 [superlayer addSublayer: label];
 return label;
 }
 NSString *mode;
 if( align & kCALayerWidthSizable )
 mode = @"center";
 else if( align & kCALayerMinXMargin )
 mode = @"right";
 else
 mode = @"left";
 align |= kCALayerWidthSizable;
 label.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
 CGF inset = superlayer.borderWidth + 3;
 CGRect bounds = AZScaleRect(superlayer.bounds, scale);//(superlayer.bounds, inset, inset);
 CGF height = font.ascender;
 CGF y = bounds.origin.y;
 if( align & kCALayerHeightSizable )
 y += (bounds.size.height-height)/2.0;
 else if( align & kCALayerMinYMargin )
 y += bounds.size.height - height;
 align &= ~kCALayerHeightSizable;
 label.bounds = CGRectMake(0, font.descender,
 bounds.size.width, height - font.descender);
 CGPointMake(bounds.origin.x,y+font.descender);
 label.anchorPoint = CGPointMake(.5,.5);
 label.autoresizingMask = align;
 CGImageRef GetCGImageFromPasteboard( NSPasteboard *pb )	{
 CGImageSourceRef src = NULL;
 NSArray *paths = [pb propertyListForType: NSFilenamesPboardType];
 if( paths.count==1 ) {
 // If a file is being dragged, read it:
 CFURLRef url = (CFURLRef) [NSURL fileURLWithPath: [paths objectAtIndex: 0]];
 src = CGImageSourceCreateWithURL(url, NULL);
 } else {
 // Else look for an image type:
 NSString *type = [pb availableTypeFromArray: [NSImage imageUnfilteredPasteboardTypes]];
 if( type ) {
 NSData *data = [pb dataForType: type];
 src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
 }
 }
 if(src) {
 CGImageRef image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
 CFRelease(src);
 return image;
 } else
 return NULL;
 }

 + (ACT)swizzleDefaultActionForKey:(NSString *)key {
 return [@[@"selected", @"hovered", @"siblingIndex", @"backgroundNSColor"]containsObject:k]
 ?: [self swizzleNeedsDisplayForKey:k]; }
- (CAL*) hitEvent:(NSEvent*) forClass @dynamic permaPresentation;
	return [[self associatedValueForKey:@"_selected" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
	return [[self associatedValueForKey:@"_hovered" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
- initWithFrame:(CGRect)newFrame    { 	return self = [super init] ? self.frame = newFrame, self : nil;  }
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey { return [@[@"sublayers", @"siblings", @"siblingIndex", @"siblingIndexMax"]containsObject:theKey]
	 ?: [super automaticallyNotifiesObserversForKey:theKey]; }
	return [@[@"siblingIndex", @"siblingIndexMax",@"siblings", @"sublayers"]containsObject:key] ?: [super automaticallyNotifiesObserversForKey:key]; }
	return [@[@"siblingIndex", @"siblingIndexMax",@"siblings"]containsObject:key] ?: [super automaticallyNotifiesObserversForKey:key]; }
+ (NSSet*) keyPathsForValuesAffectingSiblings { return NSSET(@"sublayers"); }  //@"superlayer.sublayers"); }
+ (NSSet*) keyPathsForValuesAffectingSiblingIndex { return NSSET(@"siblings"); }  //@"superlayer.sublayers"); }
- (void)setHostView:(NSV *)hostView     {	[self setAssociatedValue:hostView forKey:@"hostView" policy:OBJC_ASSOCIATION_ASSIGN]; }
- (NSV *)hostView	{
*/


static CGColorRef CreateDeviceGrayColor(CGF w, CGF a) {	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGF comps[] = {w, a};	CGColorRef color = CGColorCreate(gray, comps);	CGColorSpaceRelease(gray); return color;
}
static CGColorRef CreateDeviceRGBColor  (CGF r, CGF g, CGF b, CGF a) {	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGF comps[] = {r, g, b, a};	CGColorRef color = CGColorCreate(rgb, comps);	CGColorSpaceRelease(rgb);	return color;
}
CAL * NewLayerInLayer	( CAL *superlayer ) {
	CAL *layer	 = [CAL layerWithFrame:nanRectCheck(superlayer.frame)];
	layer.delegate	       = superlayer;
	[superlayer addSublayer:layer];
	[layer addConstraintsSuperSize];
	return layer;
}
CATXTL * AddLabel	  		( CAL *superlayer, NSS *text) {
	NSFont *font = [NSFont fontWithName:@"UbuntuTitling-Bold" size:29];
	return AddTextLayer(superlayer, text, font, kCALayerWidthSizable);
}
CATXTL * AddLabelLayer  ( CAL *superlayer, NSS *text, NSF *font ) {
	return AddTextLayer(superlayer, text, font, kCALayerWidthSizable);
}
CATXTL * AddTextLayer	( CAL *superlayer, NSS *text, NSF *font, enum CAAutoresizingMask align ) {
	CATXTL *label = CATXTL.new;
	[label setValue:@(YES) forKey:@"label"];
	label.string = text;
	label.font = (__bridge CGFontRef)font;
	label.fontSize = font.pointSize;
	//	CGColorRef sup = superlayer.backgroundColor;
	label.foregroundColor =  kBlackColor;
	// sup ? sup :
	//	NSString *mode;
	//	if( align & kCALayerWidthSizable )	mode = @"center";
	//	else if( align & kCALayerMinXMargin )   mode = @"right";
	//	else			mode = @"left";
	//	align |= kCALayerWidthSizable;
	//	label.alignmentMode = mode;
	//	CGF inset   = superlayer.borderWidth + 3;
	CGRect bounds  = nanRectCheck(superlayer.bounds);     // CGRectInset(superlayer.bounds, inset, inset));
				//	CGF height  = font.ascender;
				//	CGF y       = bounds.origin.y;
				//	if	( align & kCALayerHeightSizable )	y += (bounds.size.height-height)/2.0;
				//	else if	( align & kCALayerMinYMargin    )	y += bounds.size.height - height;
				//		  align &= ~kCALayerHeightSizable;
	label.bounds    = bounds;    // nanRectCheck(  CGRectMake(0, font.descender, bounds.size.width, height - font.descender));
	label.position  = nanPointCheck(AZCenterOfRect(superlayer.bounds));    //CGPointMake(bounds.origin.x,y+font.descender));
				  //	label.anchorPoint = (CGPoint) { .5,.5 };
				  //	label.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;// align;
	[superlayer addSublayer:label];
	return label;
}
CAL * ReturnImageLayer   ( CAL *superlayer, NSIMG *image, CGF scale) {

	CAL *label	 = [CAL layerWithFrame:superlayer.frame];
	NSSize old	= superlayer.frame.size;
	image.size	= (NSSize) {old.width *scale, old.height *scale};
	label.contentsGravity   = kCAGravityCenter;
	label.contentsRect	   = AZMakeRectFromSize(old);
	label.contents	       = image;
	[label setValue:@(YES) forKey:@"image"];
	//	label.layoutManager     = [CAConstraintLayoutManager layoutManager];
	//	[label addConstraintsSuperSizeScaled:scale];
	return label;
}
CGImageRef CreateCGImageFromFile        ( NSS *path ) {
	CGImageRef image = NULL;
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
	CGDataProviderRef provider = CGDataProviderCreateWithURL(url);
	if ( provider ) {
	image = CGImageCreateWithPNGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
	if (!image) {
		//		NSLog(@"INFO: Cannot load image as PNG file %@ (ptr size=%u)",path,sizeof(void*));
		//fall back to JPEG
		image = CGImageCreateWithJPEGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
	}
	CFRelease(provider);
	}
	return image;
}
CGIREF GetCGImageNamed	( NSS *name ) {
	// For efficiency, loaded images are cached in a dictionary by name.
	static NSMutableDictionary *sMap;
	if ( !sMap ) sMap = [NSMutableDictionary dictionary];
	CGIREF image = [(NSImage *)[NSImage imageNamed:sMap[name]] cgImage];
	if ( !image ) {
	// Hasn't been cached yet, so load it:
	NSS *path;
	if ( [name hasPrefix:@"/"] ) path = name;
	else {
		path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
		NSCAssert1(path, @"Couldn't find bundle image resource '%@'", name);
	}
	image = CreateCGImageFromFile(path);
	NSCAssert1(image, @"Failed to load image from %@", path);
	sMap[name] = (__bridge id)image;
	}
	return image;
}
CGCLRREF GetCGPatternNamed	 ( NSS *name ) {	// can be resource name or abs. path
				  // For efficiency, loaded patterns are cached in a dictionary by name.
	static NSMutableDictionary *sMap;
	if ( !sMap ) sMap = [NSMutableDictionary dictionary];
	CGCLRREF pattern = [NSColor colorWithPatternImage:sMap[name]].CGColor;
	if ( !pattern ) {
	pattern = CreatePatternColor( GetCGImageNamed(name) );
	sMap[name] = (__bridge id)pattern;
	}
	return pattern;
}
CGF GetPixelAlpha	( CGImageRef image, CGSZ imageSize, CGP pt ) {
	// Trivial reject:
	if ( pt.x < 0 || pt.x >= imageSize.width || pt.y < 0 || pt.y >= imageSize.height ) return 0.0;
	// sTinyContext is a 1x1 CGBitmapContext whose pixmap stores only alpha.
	static UInt8 sPixel[1];
	static CGContextRef sTinyContext;
	if ( !sTinyContext ) {
	sTinyContext = CGBitmapContextCreate(sPixel, 1, 1,
			 8, 1,	     // bpp, rowBytes
			 NULL,
			 kCGImageAlphaOnly);
	CGContextSetBlendMode(sTinyContext, kCGBlendModeCopy);
	}
	// Draw the image into sTinyContext, positioned so the desired point is at
	// (0,0), then examine the alpha value in the pixmap:
	CGContextDrawImage(sTinyContext,
		 CGRectMake(-pt.x, -pt.y, imageSize.width, imageSize.height),
		 image);
	return sPixel[0] / 255.0;
}
#pragma mark - PATTERNS:
static void drawPatternImage	 ( void *info, CGContextRef ctx) {
	CGImageRef image = (CGImageRef)info;
	CGContextDrawImage(ctx,
		 CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)),
		 image);
}       // callback for CreateImagePattern.
static void releasePatternImage ( void *info ) {
	CGImageRelease( (CGImageRef)info );
} // callback for CreateImagePattern.
CGPatternRef CreateImagePattern ( CGImageRef image ) {
	NSCParameterAssert(image);
	int width = CGImageGetWidth(image);
	int height = CGImageGetHeight(image);
	static const CGPatternCallbacks callbacks = {0, &drawPatternImage, &releasePatternImage};
	return CGPatternCreate (image,
			CGRectMake (0, 0, width, height),
			CGAffineTransformMake (1, 0, 0, 1, 0, 0),
			width,
			height,
			kCGPatternTilingConstantSpacing,
			true,
			&callbacks);
}
CGCLRREF CreatePatternColor	( CGImageRef image ) {
	CGPatternRef pattern = CreateImagePattern(image);
	CGColorSpaceRef space = CGColorSpaceCreatePattern(NULL);
	CGF components[1] = {1.0};
	CGCLRREF color = CGColorCreateWithPattern(space, pattern, components);
	CGColorSpaceRelease(space);
	CGPatternRelease(pattern);
	return color;
}
extern CAT3D CATransform3DMake(CGF m11, CGF m12, CGF m13, CGF m14,
	   CGF m21, CGF m22, CGF m23, CGF m24,
	   CGF m31, CGF m32, CGF m33, CGF m34,
	   CGF m41, CGF m42, CGF m43, CGF m44) {
	CAT3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

CAT3D CA3Dm34           (CGF divisor) { return ({ CATransform3D xyz = CATransform3DIdentity; xyz.m34 = 1.0 / -divisor; xyz; }); }
CAT3D CA3DxRotation(CGF x) { return CATransform3DMakeRotation(x * M_PI / 180., 1., 0., 0.); }
CAT3D CA3DyRotation(CGF y) { return CATransform3DMakeRotation(y * M_PI / 180., 0., 1., 0.); }
CAT3D CA3DzRotation(CGF z) { return CATransform3DMakeRotation(z * M_PI / 180., 0., 0., 1.); }
CAT3D CA3DTransform3DConcat (CAT3D xR,  CAT3D yR) {	return CATransform3DConcat(xR, yR);       }
CAT3D CA3DxyZRotation       (CAT3D xYR, CAT3D zR) { return CATransform3DConcat(xYR, zR);      }

@implementation  NSGraphicsContext (CTX)
+ (void) prepareContext:(CGCREF)ctx { id nsCTX = [self graphicsContextWithGraphicsPort:ctx flipped:NO]; [self saveGraphicsState]; self.currentContext = nsCTX; }
@end

@implementation CAL (UsedToBeFunctions)
- (void) applyPerspective                       { self.sublayerTransform = CA3Dm34(-850); } //prspctvTrnsfrm;
- (void) setSuperlayer:(CAL*)sl                 { [self setSuperlayer:sl index:-1]; }
- (void) setSuperlayer:(CAL*)sl index:(int)idx  { IF_VOID(self.superlayer == sl);

	[CATRANNY flush]; [CATRANNY immediately:^{  	// Disable actions, else the layer will move to the wrong place and then back!
    [self removeFromSuperlayer];
    if (!sl) return;
    CGPoint pos = [sl convertPoint:self.position fromLayer:self.superlayer];
    idx >= 0 ? [sl insertSublayer:self atIndex:idx] : [sl addSublayer:self];
    self.position = pos;
  }];
}
- (void) removeImmediately  { [CATRANNY immediately:^{ [self removeFromSuperlayer]; }]; }
- (void) removeSublayers    { [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)]; }
- (void) addBloom           { 	// create the filter and set its default values

	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:@5 forKey:@"inputRadius"];
	[filter setName:@"pulseFilter"]; 	// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
  self.hostView.layerUsesCoreImageFilters = YES; 	// set the filter to the selection layer's filters
  self.filters = self.filters.count ? [self.filters arrayByAddingObject:filter] : @[filter];
}
- (void) addShadow          {

	CGF base            = NSEqualRects(self.bounds, NSZeroRect) ? 50 : self.width;
	self.shadowOffset	  = (CGSZ){.1 * base, -.1 * base };
	self.shadowRadius	  = .2 * base;
	self.shadowColor	  = cgBLACK;
	self.shadowOpacity  = .8;
}
- (void) addPulsatingBloom  {

	[self addBloom];
	// create the animation that will handle the pulsing.
	CABA *pulseAnimation = [CABA animation];
	// the attribute we want to animate is the inputIntensity	of the pulseFilter
	pulseAnimation.keyPath	       = @"filters.pulseFilter.inputIntensity";
	// we want it to animate from the value 0 to 1
	pulseAnimation.fromValue	     = @(0.0);
	pulseAnimation.toValue	       = @(4.5);
	// over a one second duration, and run an infinite number of times
	pulseAnimation.duration	   = 1.0;
	pulseAnimation.repeatCount	   = HUGE_VALF;
	// we want it to fade on, and fade off, so it needs to automatically autoreverse.. this causes the intensity	input to go from 0 to 1 to 0
	pulseAnimation.autoreverses     = YES;
	// use a timing curve of easy in, easy out..
	pulseAnimation.timingFunction   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	// add the animation to the selection layer. This causes it to begin animating. We'll use pulseAnimation as the animation key name
	[self addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}
@end

@implementation CALayer (WasClicked)
- (void) layerWasClicked:(CAL *)layer	{ /*	[layer toggleBoolForKey:@"clicked"]; [layer setNeedsDisplay]; */ }
- (void)      wasClicked	            { /*	[self toggleBoolForKey:@"clicked"];  [self setNeedsDisplay]; */  }
@end

@implementation CAConstraint (Mask)

+ (NSA*) attributesForMask:(AZConstraintMask)mask {

  return [AZConstraintMaskByLabel().allValues.ascending reduce:@[] with:^id(id sum, NSN* bit, NSUInteger idx) {

    return mask & bit.iV ? [sum arrayByAddingObject:@(idx)] : sum;
  }];
}
@end

@implementation CALayer (VariadicConstraints)

- (void) addConstraintsWithMaskRelSuper:(AZConstraintMask)mask {

  [[CAConstraint attributesForMask:mask] do:^(NSN *attr) { [self addConstraint:AZConstRelSuper(attr.iV)]; }];
}

- (void)       addConstraintsSuperSize                        {

  self.superlayer.isLayoutManager = YES;
	self.constraints = [self.constraints.count ? self.constraints : @[] arrayByAddingObjectsFromArray:
  @[  AZConstRelSuper(kCAConstraintMidX),   AZConstRelSuper(kCAConstraintMidY),
      AZConstRelSuper(kCAConstraintHeight), AZConstRelSuper(kCAConstraintWidth)	 ]];
}
- (void)          addConstraintObjects:(CACONST*)constr,...   { azva_list_to_nsarray(constr,constrnts);  [self addConstraints:constrnts]; }
- (void)        addConstraintsRelSuper:(CACONSTATTR)attr,...  { /* REQUIRES NSNotFound termination */

	va_list args;   va_start(args, attr);
	for (NSUInteger arg = attr;
                  arg != NSNotFound && arg != (NSUInteger)NULL;
                  arg = va_arg(args, NSUInteger))
	[self addConstraint:AZConstRelSuper(arg)];
	va_end(args);
}
- (void) addConstraintsSuperSizeScaled:(CGF)f                 {	[self addConstraintsSuperSize];
	[self addConstraint:AZConstRelSuperScaleOff(kCAConstraintWidth, f, 0)];
	[self addConstraint:AZConstRelSuperScaleOff(kCAConstraintHeight, f, 0)];
}
- (void)                addConstraints:(NSA*)cs               {	self.superlayer.isLayoutManager = YES; for (CACONST* x in cs) [self addConstraint:x]; }

- (void) addConstraintsSuperSizeHorizontal { [self addConstraintsRelSuper:kCAConstraintWidth, kCAConstraintMinX, kCAConstraintMaxX, kCAConstraintMidX, NSNotFound]; }

@dynamic isLayoutManager;

- (BOOL) isLayoutManager            { return self.layoutManager == AZLAYOUTMGR; }
- (void) setIsLayoutManager:(BOOL)l { self.layoutManager = l ? AZLAYOUTMGR : nil; }

#pragma mark LayoutManager

- (void) setDefaultLayoutManager {
    self.layoutManager = [CAConstraintLayoutManager layoutManager];
}
- (void) makeSuperlayer {
    [self setDefaultLayoutManager];
}
- (void) superConstrain {
    [self superConstrainEdges: 0];
    if (self.superlayer) self.superlayer.layoutManager = [CAConstraintLayoutManager layoutManager];
}
- (void) superConstrainEdgesH: (CGFloat) offset {
    [self superConstrain: kCAConstraintMinX offset: offset];
    [self superConstrain: kCAConstraintMaxX offset: -offset];
}
- (void) superConstrainEdgesV: (CGFloat) offset {
    [self superConstrain: kCAConstraintMinY offset: offset];
    [self superConstrain: kCAConstraintMaxY offset: -offset];
}
- (void) superConstrainEdges: (CGFloat) offset {
    [self superConstrain: kCAConstraintMinX offset: offset];
    [self superConstrain: kCAConstraintMaxX offset: -offset];
    [self superConstrain: kCAConstraintMinY offset: offset];
    [self superConstrain: kCAConstraintMaxY offset: -offset];
}
- (void) superConstrain: (CAConstraintAttribute) edge {
    [self superConstrain: edge offset: 0];
}
- (void) superConstrainTopEdge {
    [self superConstrain: kCAConstraintMinY to: kCAConstraintMinY offset: 0];
}
- (void) superConstrainTopEdge: (CGFloat) offset {
    [self superConstrain: kCAConstraintMinY to: kCAConstraintMinY offset: offset];
}
- (void) superConstrainBottomEdge: (CGFloat) offset {
    [self superConstrain: kCAConstraintMaxY to: kCAConstraintMaxY offset: offset];
}
- (void) superConstrain: (CAConstraintAttribute) edge offset: (CGFloat) offset {
    [self superConstrain: edge to: edge offset: offset];
}
- (void) superConstrain: (CAConstraintAttribute) subviewEdge to: (CAConstraintAttribute) superlayerEdge {
    [self superConstrain: subviewEdge to: superlayerEdge offset: 0];
}

#pragma mark Do-er methods

- (void) superConstrain: (CAConstraintAttribute) subviewEdge to: (CAConstraintAttribute) superlayerEdge offset: (CGFloat) offset {
    [self addConstraint: [CAConstraint constraintWithAttribute: subviewEdge relativeTo: @"superlayer" attribute: superlayerEdge offset: offset]];
}

@end

@implementation CALayer (ShouldBeInProtocol)
SYNTHESIZE_ASC_PRIMITIVE_KVO(isListItem,setIsListItem,BOOL);
- (NSS*)sisterName {   return SameString(@"0", self.name) ? AZSL : @(self.name.iV - 1).strV; }
@end

/*
@protocol          KeyBoundShape @concrete @prop_RO NSS *binding, *keypath; - (void) remove; @end

@concreteprotocol(KeyBoundShape)                         @dynamic binding,  keypath;

- (void) remove { [self unbind:self.binding]; [(CAL*)self removeFromSuperlayer]; }

@end

@interface AnchorPointLayer   : CASHL  <KeyBoundShape> @end
@interface PositionPointLayer : CASHL  <KeyBoundShape> @end
@interface BoundsLayer        : CASHLA <KeyBoundShape> @end

@implementation AnchorPointLayer  + (id) dVfK:(NSS*)k { objswitch(k)

  objcase(@"path")      return (id)[NSBP bezierPathWithOvalInRect:AZRectFromDim(20)].quartzPath;
  objcase(@"fillColor") return (id)cgRED;
  objcase(@"binding")   return @"position";
  objcase(@"keypath")   return @"anchorPoint";
  objcase(@"zPosition") return @2200;
  endswitch             return [super dVfK:k];
}
@end
@implementation PositionPointLayer  + (id) dVfK:(NSS*)k { objswitch(k)

  objcase(@"path")      return (id)[NSBP withR:AZRectFromDim(20)].quartzPath;
  objcase(@"fillColor") return (id)cgGREEN;
  objcase(@"binding")   return @"position";
  objcase(@"keypath")   return @"position";
  endswitch             return [super dVfK:k];
}
@end
@implementation BoundsLayer
//+ (id) dVfK:(NSS*)k { objswitch(k)
//  objcase(@"fillColor")     return (id)cgBLUE;
//  objcase(@"strokeColor")   return (id)cgBLACK;
//  objcase(@"binding")       return @"bounds";
//  objcase(@"keypath")       return @"bounds";
//  objcase(@"lineWidth")     return @1;
//  objcase(@"lineDashPattern")   return @[@20,@20];
//  defaultcase               return [super dVfK:k];  endswitch }
@end
*/

@implementation CALayer (AtoZDebug)

- (NSString *)debugDescription   {
	return [NSString stringWithFormat:@"<%@ (%@) frame=%@ zAnchor=%1.1f>", NSStringFromClass([self class]),
		  self.name, NSStringFromRect(self.frame), self.zPosition];
}
- (NSString *)debugLayerTree     {
	NSMutableString *str = [NSMutableString string];
	[self debugAppendToLayerTree:str indention:@""];
	return str;
}

SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO(debug,setDebug, BOOL, ^{}, ^{

  if (value) { __block CATXTL *aT; __block CATXTL *pT; CAL* supersuper = self.superlayers.lastObject;

    CAL*dLayer = [supersuper sublayerWithName:@"debuggingHost"];
        dLayer = dLayer ?: ({ dLayer = [[CAL noHitLayerWithFrame:supersuper.bounds mask:CASIZEABLE] named:@"debuggingHost"]; [supersuper addSublayer:dLayer]; dLayer; });

    CASHL * anchor              = [[CASHL noHitLayerWithFrame:AZRectFromDim(20)] named:  @"anchorDebugger"];
    anchor.path                 = [NSBP bezierPathWithOvalInRect:anchor.bounds].quartzPath;
    anchor.fillColor            = cgRED;
    anchor.loM                  = AZLAYOUTMGR;
    anchor.sublayers            = @[aT = [CATXTL noHitLayerWithFrame:anchor.bounds]];

    CASHL * positn              = [[CASHL noHitLayerWithFrame:AZRectFromDim(20)] named:@"positionDebugger"];
    positn.path                 = [NSBP withR:positn.bounds].quartzPath;
    positn.fillColor            = cgGREEN;
    positn.loM                  = AZLAYOUTMGR;
    positn.sublayers            = @[pT = [CATXTL noHitLayerWithFrame:positn.bounds]];
    [({ @[pT,aT]; }) do:^(id o) {
      [o setValuesForKeysWithDictionary:({ @{@"fontSize":@14,@"font":@"UbuntuMono-Bold", @"foregroundColor": (id)cgWHITE, @"alignmentMode": @"center", @"string":@"n/a" }; })];
      [o addConstraintsWithMaskRelSuper:AZConstraintMaskMidX|AZConstraintMaskMidY];
      [o b:@"string" tO:self wKP:@"stblingIndex" s:@selector(stringValue)];
    }];
    [({ @[anchor,positn]; }) makeObjectsPerformSelector:@selector(setNeedsLayout)];

    CASHL * bounds              = [CASHL.noHitLayer named:  @"boundsDebugger"];
    bounds.fillColor            = cgBLUE;
    bounds.strokeColor          = cgBLACK;
    bounds.lineWidth            = 5;
    bounds.lineDashPattern      = ({ @[@20,@20]; });

    [dLayer addSublayers:({ @[anchor,positn,bounds]; })];
    [self addObserverForKeyPaths:({ @[@"bounds", @"position", @"anchorPoint"]; }) options:NSKeyValueObservingOptionNew task:^(id obj, NSString *keyPath, NSDictionary *change) {


        JATLog(@"obj:{obj} kp:{keyPath} change:{change}", obj, keyPath, change);
        objswitch(keyPath)
        objcase(@"anchorPoint")
          anchor.position = [obj convertPoint:change.newVal.pointValue fromLayer:obj];
          [anchor blinkLayerWithColor:RANDOMCOLOR];
        objcase(@"position")
            positn.position = change.newVal.pointValue;
            [positn blinkLayerWithColor:RANDOMCOLOR];
//        objcase(@"siblingIndex") [({@[pT,aT];}) do:^(id o) { [o setString:change.newNum.strV]; }];
        endswitch
    }];
  }
//  else [({ @[@"anchorDebugger", @"positionDebugger", @"boundsDebugger"]; }) do:^(id obj) {id x = [ sublayerWithName:obj]; if(x) [x removeFromSuperlayer];  }];
});

- (void)debugAppendToLayerTree:(NSMutableString *)treeStr indention:(NSString *)indentStr {
	[treeStr appendFormat:@"%@%@\n", indentStr, self.debugDescription];
	for (CAL *aSub in self.sublayers) {
	[aSub debugAppendToLayerTree:treeStr indention:[indentStr stringByAppendingString:@"\t"]];
	}
}

- (NSS*) infoString {  NSMS *ret = @"{\n".mutableCopy; static NSS *baseFormat = @"\t%@\n";

  [self cornerRadius];
  [self needsDisplayOnBoundsChange];
  [self backgroundColor];

  [ret appendFormat:baseFormat,$(@"animationKeys = %@", self.animationKeys)];
  [ret appendFormat:baseFormat,$(@"actions = %@", self.actions)];
  [ret appendFormat:baseFormat,$(@"autoresizingMask = %u", self.autoresizingMask)];
  [ret appendFormat:baseFormat,$(@"backgroundColor = %p", self.backgroundColor)];
  [ret appendFormat:baseFormat,$(@"backgroundFilters = %lu", self.backgroundFilters.count)];
  [ret appendFormat:baseFormat,$(@"beginTime = %f", self.beginTime)];
  [ret appendFormat:baseFormat,$(@"borderColor = %@", [NSColor colorWithCGColor: self.borderColor])];
  [ret appendFormat:baseFormat,$(@"borderWidth = %f", self.borderWidth)];
  [ret appendFormat:baseFormat,$(@"bounds = %@", NSStringFromRect(self.bounds))];
  [ret appendFormat:baseFormat,$(@"cornerRadius = %f", self.cornerRadius)];
  [ret appendFormat:baseFormat,$(@"contents = %@", self.contents)];
  [ret appendFormat:baseFormat,$(@"compositingFilter = %@", self.compositingFilter)];
  [ret appendFormat:baseFormat,$(@"contentsAreFlipped = %d", self.contentsAreFlipped)];
  [ret appendFormat:baseFormat,$(@"contentsCenter = %@", NSStringFromRect(self.contentsCenter))];
  [ret appendFormat:baseFormat,$(@"contentsGravity = %@", self.contentsGravity)];
  [ret appendFormat:baseFormat,$(@"contentsRect = %@", NSStringFromRect(self.contentsRect))];
  [ret appendFormat:baseFormat,$(@"constraints = %@", self.constraints)];
  [ret appendFormat:baseFormat,$(@"delegate = %@", self.delegate)];
  [ret appendFormat:baseFormat,$(@"doubleSided = %d", self.doubleSided)];
  [ret appendFormat:baseFormat,$(@"drawsAsynchronously = %d", self.drawsAsynchronously)];
  [ret appendFormat:baseFormat,$(@"duration = %f", self.duration)];
  [ret appendFormat:baseFormat,$(@"frame = %@", NSStringFromRect(self.frame))];
  [ret appendFormat:baseFormat,$(@"filters = %lu", self.filters.count)];
  [ret appendFormat:baseFormat,$(@"fillMode = %@", self.fillMode)];
  [ret appendFormat:baseFormat,$(@"geometryFlipped = %d", self.geometryFlipped)];
  [ret appendFormat:baseFormat,$(@"hidden = %d", self.hidden)];
  [ret appendFormat:baseFormat,$(@"layoutManager = %@", self.layoutManager)];
  [ret appendFormat:baseFormat,$(@"mask = %@", self.mask)];
  [ret appendFormat:baseFormat,$(@"masksToBounds = %d", self.masksToBounds)];
  [ret appendFormat:baseFormat,$(@"name = %@", self.name)];
  [ret appendFormat:baseFormat,$(@"needsDisplayOnBoundsChange = %d", self.needsDisplayOnBoundsChange)];
  [ret appendFormat:baseFormat,$(@"opacity = %f", self.opacity)];
  [ret appendFormat:baseFormat,$(@"opaque = %d", self.opaque)];
  [ret appendFormat:baseFormat,$(@"position = %@", NSStringFromPoint(self.position))];
  [ret appendFormat:baseFormat,$(@"preferredFrameSize = %@", NSStringFromSize(self.preferredFrameSize))];
  [ret appendFormat:baseFormat,$(@"presentationLayer = %@", self.presentationLayer)];
  [ret appendFormat:baseFormat,$(@"rasterizationScale = %f", self.rasterizationScale)];
  [ret appendFormat:baseFormat,$(@"repeatCount = %f", self.repeatCount)];
  [ret appendFormat:baseFormat,$(@"sublayers = %lu", self.sublayers.count)];
  [ret appendFormat:baseFormat,$(@"superlayer = %@", self.superlayer)];
  [ret appendFormat:baseFormat,$(@"shadowColor = %p", self.shadowColor)];
  [ret appendFormat:baseFormat,$(@"shadowOffset = %@", NSStringFromSize(self.shadowOffset))];
  [ret appendFormat:baseFormat,$(@"shadowOpacity = %f", self.shadowOpacity)];
  [ret appendFormat:baseFormat,$(@"shadowPath = %p", self.shadowPath)];
  [ret appendFormat:baseFormat,$(@"shadowRadius = %f", self.shadowRadius)];
  [ret appendFormat:baseFormat,$(@"shouldRasterize = %d", self.shouldRasterize)];
  [ret appendFormat:baseFormat,$(@"speed = %f", self.speed)];
  [ret appendFormat:baseFormat,$(@"style = %@", self.style)];
  [ret appendFormat:baseFormat,$(@"sublayerTransform = %@", StringFromCATransform3D(self.sublayerTransform))];
  [ret appendFormat:baseFormat,$(@"transform = %@", StringFromCATransform3D(self.transform))];
  [ret appendFormat:baseFormat,$(@"timeOffset = %f", self.timeOffset)];
  [ret appendFormat:baseFormat,$(@"visibleRect = %@", NSStringFromRect(self.visibleRect))];
  [ret appendFormat:baseFormat,$(@"zPosition = %f", self.zPosition)];
  [ret appendFormat:baseFormat,$(@"hidden = %d", self.hidden)];
  [ret appendString: @"}\n"];
  return ret.copy;
}
+ (NSW*) debugTest {

  NSW* new                = [NSW.alloc initWithContentRect:AZRectFromDim(100) styleMask:0|1|2|8 backing:2 defer:NO];
  new.level               = NSNormalWindowLevel;
  CAL *tester;
  [new.contentLayer addSublayer:tester = [self gridLayerWithFrame:new.contentRect rows:8 cols:8 palette:AtoZ.globalPalette]];
  tester.bgC              = cgPURPLE;
  tester.anchorPoint      = AZAnchorTop;
  tester.position         = AZAnchorPointOfActualRect(new.contentRect, AZAlignTop);
  tester.debug            = YES;
  return   [new makeKeyAndOrderFront:nil], new;
}
@end


//CATransform3D CAT3DConcatenatedTransformation(CAT3D xyZRotation, CAT3D transformation ) {	return CATransform3DConcat(xyZRotation, transformation);	}	CATransform3D concatenatedTransformation = CATransform3DConcat(xRotation, transformation);

//typedef struct KPTrifecta { __UNSFE NSS* binding; __UNSFE NSS * keypath; __UNSFE id transform; } KPTrifecta;
//  XX([p.sublayers vFK:@"string"]);
//  [aT b:@"string" tO:self wKP:@"siblingIndex" t:^id(id value) { return [value sV]; }];
//  [pT b:@"string" tO:self wKP:@"siblingIndex" t:^id(id value) { return [value sV]; }];
//  [pT bindFrameToBoundsOf:p];



//    [a b:a.binding tO:self wKP:a.keypath t:^(id a){ return AZVpoints(self.superlayer.width * [a pointValue].x, self.superlayer.height * [a pointValue].y); }];
//    [p b:p.binding tO:self];
//    a.sublayers = @[aT = [CATXTL noHitLayerWithFrame:AZRectFromDim(20)]];
//    p.sublayers = @[pT = [CATXTL noHitLayerWithFrame:AZRectFromDim(20)]];
//    [self addObserverForKeyPath:@"siblingIndex" task:^(id me) { aT.string = pT.string = [me[@"siblingIndex"] sV]; }];
//    pT.fontSize         = aT.fontSize         = 19;
//    pT.foregroundColor  = aT.foregroundColor  = cgWHITE;
//    aT.alignmentMode = pT.alignmentMode = @"center";
//    [pT addConstraints:({ @[AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY)]; })];
//    [pT addConstraints:({ @[AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY)]; })];
//    [a setNeedsLayout];
//    [p setNeedsLayout];

//    [({ @[AnchorPointLayer.class, PositionPointLayer.class, BoundsLayer.class]; }) do:^(id k) { id x = [self.superlayer sublayerOfClass:k]; if(x) [x remove];  }];
