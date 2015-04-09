


#import <AtoZ/AtoZ.h>
#import "AtoZSwizzles.h"

@implementation AZBlockSwizzle

AZSwizzleRevertBlock AZSwizzleWithBlock(NSS *className, SEL selector, BOOL isClassMethod, id block) {

  Class class = NSClassFromString(className);
  Method method = isClassMethod ? class_getClassMethod(class, selector) : class_getInstanceMethod(class, selector) ?: nil;
  IMP origImp = method_getImplementation(method), testImp = imp_implementationWithBlock(block);
  method_setImplementation(method, testImp);
  return ^{ method_setImplementation(method, origImp); };
};

void AZSwizzleWithBlockAndRun(NSS *className, SEL selector, BOOL isClassMethod, id imp, void(^run)()) {
  AZSwizzleRevertBlock revert = nil;
  revert = AZSwizzleWithBlock(className, selector, isClassMethod, imp);
  run();
  revert();
};

void AZSwizzleWithBlockFallback( NSS *className, SEL selector, BOOL isClassMethod, id imp){
  /*
   Class class = NSClassFromString(className);
   Method method = isClassMethod ? class_getClassMethod(class, selector) : class_getInstanceMethod(class, selector) ?: nil;
   IMP origImp = method_getImplementation(method),
   testImp = imp_implementationWithBlock(imp);

   method_setImplementation(method,testImp);
   //class_addMethod([self class],
   //   SEL viewWillAppearSelector = @selector(viewWillAppear:);
   //   SEL tourGuideWillAppearSelector =  @selector(tourGuideWillAppear:);
   Method originalMethod = class_getInstanceMethod(self, viewWillAppearSelector);
   Method newMethod = class_getInstanceMethod(self, tourGuideWillAppearSelector);

   BOOL methodAdded = class_addMethod([self class],
   viewWillAppearSelector,
   method_getImplementation(newMethod),
   method_getTypeEncoding(newMethod));

   if (methodAdded) {
   class_replaceMethod([self class],
   tourGuideWillAppearSelector,
   method_getImplementation(originalMethod),
   method_getTypeEncoding(originalMethod));
   } else {
   method_exchangeImplementations(originalMethod, newMethod);
   }
   */
}

@end

@implementation NSO (ConciseKitSwizzle)

+ (BOOL)      swizzleMethod:(SEL)sel1 with:(SEL)sel2                              { return [self swizzleMethod:sel1 in:self with:sel2 in:self]; }
+ (BOOL)      swizzleMethod:(SEL)sel1 with:(SEL)sel2                in:(Class)k1  { return [self swizzleMethod:sel1 in:k1 with:sel2 in:k1]; }
+ (BOOL)      swizzleMethod:(SEL)sel1   in:(Class)k1 with:(SEL)sel2 in:(Class)k2  {

  Method originalMethod = class_getInstanceMethod(k1, sel1);
  Method anotherMethod  = class_getInstanceMethod(k2, sel2);

  if(!originalMethod || !anotherMethod) return NO;

  IMP originalMethodImplementation = class_getMethodImplementation(k1, sel1);
  IMP anotherMethodImplementation  = class_getMethodImplementation(k2, sel2);

  if(class_addMethod(k1, sel1, originalMethodImplementation, method_getTypeEncoding(originalMethod)))
    originalMethod = class_getInstanceMethod(k1, sel1);

  if(class_addMethod(k2, sel2,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod)))
    anotherMethod = class_getInstanceMethod(k2, sel2);

  return method_exchangeImplementations(originalMethod, anotherMethod), YES;
}
+ (BOOL) swizzleClassMethod:(SEL)sel1 with:(SEL)sel2                in:(Class)k1  {
  return [self swizzleClassMethod:sel1 in:k1 with:sel2 in:k1];
}
+ (BOOL) swizzleClassMethod:(SEL)sel1   in:(Class)k1 with:(SEL)sel2 in:(Class)k2  {
  Method originalMethod = class_getClassMethod(k1, sel1);
  Method anotherMethod  = class_getClassMethod(k2, sel2);

  if(!originalMethod || !anotherMethod) return NO;

  Class metaClass = objc_getMetaClass(class_getName(k1));
  Class anotherMetaClass = objc_getMetaClass(class_getName(k2));
  IMP originalMethodImplementation = class_getMethodImplementation(metaClass, sel1);
  IMP anotherMethodImplementation  = class_getMethodImplementation(anotherMetaClass, sel2);
  if(class_addMethod(metaClass, sel1, originalMethodImplementation, method_getTypeEncoding(originalMethod)))
    originalMethod = class_getClassMethod(k1, sel1);

  if(class_addMethod(anotherMetaClass, sel2,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod)))
    anotherMethod = class_getClassMethod(k2, sel2);

  return method_exchangeImplementations(originalMethod, anotherMethod), YES;
}

+ (void) waitUntil:(BOOL(^)(void))cond {  [self waitUntil:cond timeOut:10.0 interval:0.1];}
+ (void) waitUntil:(BOOL(^)(void))cond timeOut:(NSTimeInterval)to { [self waitUntil:cond timeOut:to interval:0.1]; }
+ (void) waitUntil:(BOOL(^)(void))cond timeOut:(NSTimeInterval)to interval:(NSTimeInterval)interval {
  NSTimeInterval sleptSoFar=0;
  while(1) {
    if(cond() || (sleptSoFar >= to)) return;
    [AZRUNLOOP runUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    sleptSoFar += interval;
  }
}

- (NSS*) swizzleNSValueDescription {

  NSValue *v = (id)self;

  if (strcmp([v objCType],@encode(AZPOS)) == 0 ) {
    NSUInteger pos = NSNotFound;
    [v getValue:&pos];
    return AZPositionToString(pos);
  }
  NSA *raw = v.swizzleNSValueDescription.words;
  NSA*left = [NSA arrayWithArrays:[(NSA*)raw map:^id(id obj) {
    return [obj rangeOfString:@"{"].location != NSNotFound ? [obj split:@"{"] : @[obj]; }]];
  NSA*right = [NSA arrayWithArrays:[left map:^id(id obj) {
    return [obj rangeOfString:@"}"].location != NSNotFound ? [obj split:@"}"] : @[obj]; }]];
  NSA*comma = [NSA arrayWithArrays:[right map:^id(id obj) {
    return [obj rangeOfString:@","].location != NSNotFound ? [obj split:@","] : @[obj]; }]];

  return //[@"SWIZ " withString:[
  [[comma map:^id(id obj) {
    return [obj isFloatNumber] ? $(@"%.2f",[obj floatValue]) : obj;
  }]componentsJoinedByString:@" "];//];
}

+ (void) swizzle:(SEL)oMeth toMethod:(SEL)newMeth forBlock:(void(^)(void))swizzledBlock {

  if (!swizzledBlock) return;

  @try      { [self swizzleMethod:oMeth with:newMeth in:self.class]; swizzledBlock(); }
  @finally  { [self swizzleMethod:newMeth with:oMeth in:self.class];                  }
} // TEMPORARY SWIZ

/*!  AG says: This compensates for NSObject's inability to set a selector for a key...
    Implementations of shadyValueForKey: and shadySetValue:forKey: Adapted from Mike Ash's "Let's Build KVC" article
    http://www.mikeash.com/pyblog/friday-qa-2013-02-08-lets-build-key-value-coding.html
    Original MAObject implementation on github at https://github.com/mikeash/MAObject 
    @see selectorForKey:
*/

-       shadyValueForKey:(NSS*)key {
  SEL getterSEL = NSSelectorFromString(key);
  if ([self respondsToSelector: getterSEL]) {
    NSMethodSignature *sig = [self methodSignatureForSelector: getterSEL];
    char              type = [sig methodReturnType][0];
    IMP                imp = [self methodForSelector: getterSEL];
    if (type == @encode(SEL)[0]) return [NSValue valueWithPointer:((SEL (*)(id, SEL))imp)(self, getterSEL)];
  }
  // We will have swapped implementations here, so this call's NSObject's valueForKey: method
  return [self shadyValueForKey:key];
}

- (void)   shadySetValue:value
                  forKey:(NSS*)key {

  NSString * capitalizedKey = [[key substringToIndex:1].uppercaseString stringByAppendingString:[key substringFromIndex:1]];
  NSString     * setterName = $(@"set%@:",capitalizedKey);
  SEL             setterSEL = NSSelectorFromString(setterName);
  if ([self respondsToSelector:setterSEL]) {
    NSMethodSignature *sig = [self methodSignatureForSelector: setterSEL];
    char type = [sig getArgumentTypeAtIndex: 2][0];
    IMP imp = [self methodForSelector: setterSEL];
    if (type == @encode(SEL)[0]) {
      SEL toSet;
      [(NSValue *)value getValue:&toSet];
      ((void (*)(id, SEL, SEL))imp)(self, setterSEL, toSet);
      return;
    }
  }

  [self shadySetValue:value forKey:key];
}
@end

__attribute__((constructor)) static void do_the_swizzles() {


//  [NSO swizzleMethod:@selector(valueForKey:)
//                with:@selector(shadyValueForKey:)];
//
//  [NSO swizzleMethod:@selector(setValue:forKey:)
//                with:@selector(shadySetValue:forKey:)];


  [NSO swizzleMethod:@selector(colorWithKey:)
                with:NSSelectorFromString(@"swizzleColorWithKey:")
                  in:NSCL.class];


  [NSO swizzleMethod:@selector(description)
                  in:objc_getClass("NSConcreteValue")
                with:@selector(swizzleNSValueDescription)
                  in:NSO.class];

//  [NSWC swizzleMethod:@selector(init)             { return [super initWithWindowNibName:NSStringFromClass([self class])]; }
//  [$ swizzleMethod:d with:@selector(swizzleDescription) in:self.class];

//  [$ swizzleMethod:@selector(actionForKey:) with:@selector(swizzleActionForKey:) in:self.class];
//  [$ swizzleMethod:@selector(hitTest:) with:@selector(swizzleHitTest:) in:CAL.class];
//  [$ swizzleMethod:@selector(needsDisplayForKey:) with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
//  [$ swizzleClassMethod:@selector(defaultActionForKey:) with:@selector(swizzleDefaultActionForKey:) in:CAL.class];
//  [$ swizzleClassMethod:@selector(initWithLayer:) with:@selector(swizzleInitWithLayer:) in:CAL.class];

}

@implementation NSD (AtoZSwizzles)

- (NSS*) swizzleDescription {	AZSWIZ //	[NSPropertyListWriter_vintage stringWithPropertyList:self];	NSS *normal =
  return !AZLogDictsASXML ? self.swizzleDescription
  : [[NSS stringWithData:[AZXMLWriter dataWithPropertyList:(NSD*)self]
                encoding:NSUTF8StringEncoding]
     substringBetweenPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"
     andSuffix:@"</plist>"];
}

@end

@implementation NSView (AtoZSwizzles)

- (void) swizzleDidMoveToWindow { AZSWIZ	[self swizzleDidMoveToWindow];
  [AZNOTCENTER postNotificationName:NSViewDidMoveToWindowNotification object:self userInfo:@{@"window":self.window}];
}

- (void) swizzleSetWantsLayer:(BOOL)b { // AZSWIZ // IF_RETURN(b && self.layer != nil);

  if (self.wantsLayer == b && self.layer) { self.layer.hostView =self; return; }
  [self swizzleSetWantsLayer:b];
  if (b){

    if (!self.layer || !({ self.layer.hostView = self; self.layer.hostView; }))
      NSLog(@"whoa! cant or didnt set host view:%@ on layer:%@", self, self.layer);
    //    if (!self.layer.name) self.layer.name = @"hostLayer";
  }
}

@end

@implementation CAL (AtoZSwizzles)

- (NSS*) swizzleDescription { AZSWIZ NSA*sclasses = self.superclassesAsStrings;

  return JATExpand(@"{0} #{1} of {2}! {3} f:{4} b:{5}", AZCLSSTR,
                   self.siblingIndex,
                   self.siblingIndexMax,
                   self.name ? $(@"name:%@", ((CAL*)self).name) : zNIL,
                   AZStringFromRect(self.frame),
                   AZStringFromRect(self.bounds),
                   sclasses.count > 1 ? [zSPC withString:[sclasses componentsJoinedByString:@" -> "]] : zNIL);//, nil);
  //                                          AZAlignToString(self.alignment));
}

- (BOOL) swizzleContainsPoint:(NSP)p { return self.noHit ? NO : [self swizzleContainsPoint:p]; }

- (void) swizzleAddSublayer:(CAL*)c {   if (!c) return; AZBlockSelf(newSuper);

  [c triggerKVO:@"superlayer" block:^(id _self) { [newSuper swizzleAddSublayer:_self]; }];

  //  [c didChangeValueForKey:@"superlayer"];

  if (![c respondsToSelector:@selector(didMoveToSuperlayer)]) return;

  AZSWIZ  // REMOVE ME IF THIS SHIT NEVER GETS CALLED / IMPLEMETED!

  NSAssert(c.superlayer && [self isEqual:c.superlayer], @"%@ should be REALLY be %@'s superlayer, which is:%@!",self, c,c.superlayer);

  objc_msgSend(c, @selector(didMoveToSuperlayer));//  [c performSelectorIfResponds:];

}

- swizzleHitTest:(NSP)p { CAL*x = [self swizzleHitTest:p] ?: nil;

  return !x ? nil :x.onHit ? x.onHit(x) : nil, x;
}

/* NOTE TO SELF Wednesday, June 4, 2014 at 7:15:38 AM  This is toobroad. */
/*+ (BOOL) swizzleNeedsDisplayForKey:(NSS*)k  { AZSWIZ
 return [@[@"hovered", @"backgroundNSColor", @"expanded",
 @"siblingIndex", @"selected"] containsObject:k] ?: [self swizzleNeedsDisplayForKey:k];
 }
 */

@end

@implementation NSIMG (AtoZSwizzles)

+ (NSIMG*) swizzledImageNamed:(NSS*)name {   AZSTATIC_OBJ(NSMD,nameToImageDict,NSMD.new);

  if (!name || !name.length) return nil;								// there is no unnamed image...

  NSIMG *image; id cached = nil;

  if((cached = [nameToImageDict objectForKey:name])) return ISA(cached,AZNULL) ? nil : cached; // found a record in cache

  if ((image = [self swizzledImageNamed:name])) return (nameToImageDict[name] = image); 		// locate by name or load from main bundle

  //	if ( SameString( name, @"NSApplicationIcon") )	{ 			// try to load application icon 	NSS *subst = [NSB.mainBundle objectForInfoDictionaryKey:@"CFBundleIconFile"];	// replace from Info.plist name = subst.length > 0 ? subst : name;			// try to load
 	NSBundle *bundle;
  //	NSA*fileTypes = [NSImageRep imageFileTypes]; locate in specific bundle (e.g. a loaded bundle) and then in AppKit.framework

  __unused NSS * ext, *	path = [AZFWORKBUNDLE recursiveSearchForPathOfResourceNamed:name];
  if (!path) {
    bundle= [NSB bundleForClass:AZSHAREDAPP.delegate.class];		// If not found in app bundle search for image in system
    path = [bundle recursiveSearchForPathOfResourceNamed:name];
    if (!path)
      bundle= [NSBundle bundleForClass:NSIMG.class];					// If not found in app bundle search for image in system
    path = [bundle recursiveSearchForPathOfResourceNamed:name];
  }
  if(path && ((nameToImageDict[name] = (image = [NSImage.alloc initByReferencingFile:path]))))		// file really exists
    [image setName:name];	// will save in __nameToImageDict - and increment retain count   [image autorelease];	// don't leak if everything is released - unfortunately we are never deleted from the image cache

  image = image ?: [[self monoIcons] objectWithValue:name forKey:@"name"];

  if(!image)	nameToImageDict[name] = AZNULL;	// save a tag that we don't know the image

  NSUI ct; if ((ct = nameToImageDict.count) % 10 == 0) NSLog(@"Keys in imageD:%lu",ct);

  return image;
}

@end

#pragma mark - NSMENUITEM IS SWIZZED OUT IN NSMENU>DARK

@implementation AtoZ (AtoZSwizzles)

+ (void) load { // AZLOGCMD;

  [NSO swizzleClassMethod:@selector(imageNamed:)                in:NSIMG.class
                     with:@selector(swizzledImageNamed:)        in:NSIMG.class];

  [self swizzleMethod:@selector(description)                     in:NSC.class
                 with:@selector(swizzleColorDescription)         in:self.class];

  [self swizzleMethod:@selector(description)                     in:NSJSONSerialization.class
                 with:@selector(swizzleJSONDescription)          in:self.class];

  [self swizzleMethod:@selector(description)
                 with:@selector(swizzleDescription) in:NSD.class];

  [self swizzleMethod:@selector(setWantsLayer:)                  in:View.class
                 with:@selector(swizzleSetWantsLayer:)           in:View.class];
  [self swizzleMethod:@selector(didMoveToWindow)                 in:View.class
                 with:@selector(swizzleDidMoveToWindow)          in:View.class];

  [self swizzleMethod:@selector(description)                     in:Layr.class
                 with:@selector(swizzleDescription)              in:Layr.class];
  [self swizzleMethod:@selector(hitTest:)                        in:Layr.class
                 with:@selector(swizzleHitTest:)                 in:Layr.class];
  [self swizzleMethod:@selector(containsPoint:)                  in:Layr.class
                 with:@selector(swizzleContainsPoint:)           in:Layr.class];
  [self swizzleMethod:@selector(addSublayer:)
                 with:@selector(swizzleAddSublayer:)             in:Layr.class];
  //	[NSO swizzleClassMethod:@selector(needsDisplayForKey:)        in:CAL.class
  //                   with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];

}

- (NSS*) swizzleColorDescription {

  //  [AZSHAREDLOG setForegroundColor:self backgroundColor:nil forFlag:0];
  return [@"\e[38;5;${value}m for foreground colors" withString:@"not done"];

}

- (NSS*) swizzleJSONDescription {

  //	[self swizzleDescription];

  return [[AZXMLWriter dataWithPropertyList:(NSJSONSerialization*)self].UTF8String
                     substringBetweenPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"
                                  andSuffix:@"</plist>"];
}

@end

@implementation NSNumber (AtoZSwizzles)

- (NSS*) swizzleDescription {

  return // NSStringFromClass(self.class);
  [self isEqualToNumber:@YES] || [self isEqualToNumber:@NO] ? StringFromBOOL(self.boolValue) : [self swizzleDescription];
}

- (NSS*) typeFormedDescription {
  if ([self.className isEqualToString:@"__NSCFNumber"]) {
    NSString *defaultDescription = [self description];
    if (strcmp(self.objCType, @encode(float)) == 0 || strcmp(self.objCType, @encode(double)) == 0) {
      if (![defaultDescription hasSubstring:@"."]) {
        return [defaultDescription stringByAppendingString:@".0"];
      }
    }
    return defaultDescription;
  } else if ([self.className isEqualToString:@"__NSCFBoolean"]) {
    return [self boolValue] ? @"YES" : @"NO";
  }
  return [self description];
}

@end


/* NSARRAY

 -  (NSS*) swizzleDescription {
 //	[NSPropertyListWriter_vintage stringWithPropertyList:self];
 //	NSS *normal =
	[self swizzleDescription];
 //	NSLog(@"normal: %@", normal);
	return [[[NSS stringWithData:[AZXMLWriter dataWithPropertyList:self] encoding:NSUTF8StringEncoding] stringByRemovingPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"]stringByRemovingSuffix:@"</plist>"];

 }

 - (NSObject*) swizzledObjectAtIndexedSubscript: (NSUInteger) i {

	return i < self.count ? [self swizzledObjectAtIndexedSubscript:i]  : [self normal:i];
 //	id try = nil;
 //	if (i < self.count) {
 //			try =  (id)[self swizzledObjectAtIndexedSubscript:i];
 //		if (!try) {
 //				try = [[self normal:i]copy];
 //				try ? NSLog(@"found indexed subscript for arrray starting with: %@ from NORMALIZED subscript!", self[0]) :
 //								NSLog(@"Array of length :%ld, with first item: %@ could not find index at subscript: %ld", self.count, self.first, i);
 //		}
 //	} else {	__block NSBag *b = NSBag.new; [self do:^(id obj) { [b add:NSStringFromClass([obj class])]; }];
 //				NSS *types = [[b objects] reduce:^id(id memo, id obj) {
 //					return [memo withString:$(@"%ld instances of class: %@\n", [b occurrencesOf:obj], obj)]; } withInitialMemo:@"In this array there are..\n"];
 //				NSLog(@"%@ %s indexed subscript out of bounds.  last good valu was :%@.... my length is %ld.  I start with %@\n", types,__PRETTY_FUNCTION__, [self.last propertiesPlease], self.count, self[0] ); }
 //	return try ?: @"";// AZNULL;
 }

 + (void) load  {

 //	[$ swizzleMethod:@selector(description) with:@selector(swizzleDescription) in:self.class];
 //	[$ swizzleMethod:@selector(objectAtIndexedSubscript:) with:@selector(swizzledObjectAtIndexedSubscript:) in:self.class];

 // *
 Method original, swizzle;

 // Get the "- (id)initWithFrame:" method.
 original = class_getInstanceMethod(self, @selector(objectat:));
 // Get the "- (id)swizzled_initWithFrame:" method.
 swizzle = class_getInstanceMethod(self, @selector(swizzledObjectAtIndexedSubscript:));
 // Swap their implementations.
 //	method_exchangeImplementations(original, swizzle);

 //	[self exchangeInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(swizzledObjectAtIndexedSubscript:)];
 //	[$ swizzleMethod:@selector(objectAtIndexedSubscript:) with:@selector(swizzledObjectAtIndexedSubscript:) in:NSA.class];
 }
 - (id)swizzledObjectAtIndexedSubscript:(NSUI)index
 {
 //	id anObj = [self swizzledObjectAtIndexedSubscript:index];
 //	if (!anObj)

 id anObj = [self objectAtIndexedSubscript:index];
 //	if (!anObj) anObj = [self normal:index];
 if (anObj)	NSLog(@"swizzle objAtSubscript.. found %@", anObj);
 return anObj ?: nil;
 */
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

 + (NSString *)homePath {
 return NSHomeDirectory();
 }

 + (NSString *)desktopPath {
 return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 }

 + (NSString *)documentPath {
 return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 }

 + (NSString *)appPath {
 return [[NSBundle mainBundle] bundlePath];
 }

 + (NSString *)resourcePath {
 return [[NSBundle mainBundle] resourcePath];
 }
	[$ swizzleMethod:@selector(actionForKey:) with:@selector(swizzleActionForKey:) in:self.class];
	[$ swizzleMethod:@selector(hitTest:) with:@selector(swizzleHitTest:) in:CAL.class];
	[$ swizzleMethod:@selector(needsDisplayForKey:) with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
	[$ swizzleClassMethod:@selector(defaultActionForKey:) with:@selector(swizzleDefaultActionForKey:) in:CAL.class];
	[$ swizzleClassMethod:@selector(initWithLayer:) with:@selector(swizzleInitWithLayer:) in:CAL.class];


 */

