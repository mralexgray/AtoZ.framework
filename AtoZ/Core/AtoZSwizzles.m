//	[$ swizzleMethod:@selector(actionForKey:) with:@selector(swizzleActionForKey:) in:self.class];
//	[$ swizzleMethod:@selector(hitTest:) with:@selector(swizzleHitTest:) in:CAL.class];
//	[$ swizzleMethod:@selector(needsDisplayForKey:) with:@selector(swizzleNeedsDisplayForKey:) in:CAL.class];
//	[$ swizzleClassMethod:@selector(defaultActionForKey:) with:@selector(swizzleDefaultActionForKey:) in:CAL.class];
//	[$ swizzleClassMethod:@selector(initWithLayer:) with:@selector(swizzleInitWithLayer:) in:CAL.class];


#import "AtoZ.h"

#define AZLogDictsASXML 0


@implementation NSD (AtoZSwizzles)
- (NSS*) swizzleDescription                 {	//	[NSPropertyListWriter_vintage stringWithPropertyList:self];	NSS *normal =
	return !AZLogDictsASXML ? self.swizzleDescription 
                          : [[NSS stringWithData:[AZXMLWriter dataWithPropertyList:(NSD*)self] 
                                        encoding:NSUTF8StringEncoding] 
                          substringBetweenPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"
                                       andSuffix:@"</plist>"];
}
@end
@implementation NSView (AtoZSwizzles)
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

@implementation CAL (AtoZSwizzles)
- (NSS*)        swizzleDescription          { NSA*sclasses = self.superclassesAsStrings;

	return JATExpand(@"{0} #{1} of {2}! {3} {7} f:{4} b:{5}", AZCLSSTR,
                                          self.siblingIndex,
                                          self.siblingIndexMax,
                                          self.name ? $(@"name:%@", ((CAL*)self).name) : zNIL,
                                          AZStringFromRect(self.frame),
                                          AZStringFromRect(self.bounds),
                                          sclasses.count > 1 ? [zSPC withString:[sclasses componentsJoinedByString:@" -> "]] : zNIL,
                                          AZAlignToString(self.alignment));
}
- (BOOL)      swizzleContainsPoint:(NSP)p   { return self.noHit ? NO : [self swizzleContainsPoint:p]; }
+ (BOOL) swizzleNeedsDisplayForKey:(NSS*)k  {

  return [@[@"hovered", @"backgroundNSColor", @"expanded", @"siblingIndex", @"selected"] containsObject:k] ?: [self swizzleNeedsDisplayForKey:k];
}
- (void)        swizzleAddSublayer:(CAL*)c  {  if (!c) return;

  [c willChangeValueForKey:@"superlayer"];
  [self swizzleAddSublayer:c];
  [c didChangeValueForKey:@"superlayer"];

  NSAssert(c.superlayer && [self isEqual:c.superlayer], @"%@ should be REALLY be %@'s superlayer, which is:%@!",self, c,c.superlayer);

  [c performSelectorIfResponds:@selector(didMoveToSuperlayer)];

}
- (id)              swizzleHitTest:(NSP)p   { CAL*x = [self swizzleHitTest:p] ?: nil;  if(x && x.wasHit) x.wasHit(x); return x; }

@end

@implementation NSIMG (AtoZSwizzles)

+ (void) load {
 
  [$ swizzleClassMethod:@selector(imageNamed:)                in:NSIMG.class
                   with:@selector(swizzledImageNamed:)        in:NSIMG.class];
}

+ (NSIMG*) swizzledImageNamed:(NSS*)name 	{   AZSTATIC_OBJ(NSMD,nameToImageDict,NSMD.new);

	if (!name || !name.length) return nil;								// there is no unnamed image...

	NSIMG *image; id cached = nil;

	if((cached = [nameToImageDict objectForKey:name])) return ISA(cached,AZNULL) ? nil : cached; // found a record in cache

	if ((image = [self swizzledImageNamed:name])) return (nameToImageDict[name] = image); 		// locate by name or load from main bundle
  
//	if ( SameString( name, @"NSApplicationIcon") )	{ 			// try to load application icon 	NSS *subst = [NSB.mainBundle objectForInfoDictionaryKey:@"CFBundleIconFile"];	// replace from Info.plist name = subst.length > 0 ? subst : name;			// try to load
 	NSBundle *bundle;
	//	NSA*fileTypes = [NSImageRep imageFileTypes]; locate in specific bundle (e.g. a loaded bundle) and then in AppKit.framework
	NSS * ext, *	path = [AZFWORKBUNDLE recursiveSearchForPathOfResourceNamed:name];
	if (!path) {
		bundle= [NSB bundleForClass:AZSHAREDAPP.delegate.class];		// If not found in app bundle search for image in system
		path = [bundle recursiveSearchForPathOfResourceNamed:name];
	if (!path)
		bundle= [NSBundle bundleForClass:NSIMG.class];					// If not found in app bundle search for image in system
		path = [bundle recursiveSearchForPathOfResourceNamed:name];
	}
	if(path && ((nameToImageDict[name] = (image = [NSImage.alloc initByReferencingFile:path]))))		// file really exists
		[image setName:name];	// will save in __nameToImageDict - and increment retain count   [image autorelease];	// don't leak if everything is released - unfortunately we are never deleted from the image cache

	image = image ?: [self.class.monoIcons objectWithValue:name forKey:@"name"];

	if(!image)	nameToImageDict[name] = AZNULL;	// save a tag that we don't know the image

	NSUI ct; if ((ct = nameToImageDict.count) % 10 == 0) NSLog(@"Keys in imageD:%lu",ct);

	return image;
}
@end

@implementation AtoZ (AtoZSwizzles)
+ (void) load                               { //AZLOGCMD;

	[$ swizzleMethod:@selector(description)  in:NSJSONSerialization.class
              with:@selector(swizzleJSONDescription)          in:self];

	[$ swizzleMethod:@selector(description)                     
              with:@selector(swizzleDescription) in:NSD.class];
  
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

}

-(NSS*)swizzleJSONDescription { //	[self swizzleDescription];

	return [[[NSS stringWithData:[AZXMLWriter dataWithPropertyList:(NSJSONSerialization*)self] 
                                                        encoding:NSUTF8StringEncoding]
                                          stringByRemovingPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"]
                                          stringByRemovingSuffix:@"</plist>"];
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
*/

