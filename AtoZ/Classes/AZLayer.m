//  ContentAnimatingLayer.m
//  LayerContentAnimation
//
//  Created by Timothy J. Wood on 11/13/08.
//  Copyright 2008 The Omni Group. All rights reserved.
//

#import <objc/runtime.h>


const NSString* zkeyP  = @"keyPath";
const NSString* zdurA  = @"duration";
const NSString* zfromV = @"fromValue";
const NSString* ztimeF = @"timingFunction";

#import "AZLayer.h"

@interface AZLayer ()/*Private*/


//- (void)_updateTimerFired:(NSTimer *)timer;
@end

// Ghetto support for -actionFor<Key>
static CFMutableDictionaryRef ActionNameToSelector = NULL;

static SEL ActionSelectorForKey(NSString *key)
{
	// TODO: Locking, if you need it.
	// OBPRECONDITION([NSThread isMainThread]);

	SEL sel = (SEL)CFDictionaryGetValue(ActionNameToSelector, ( const void *)(key));
	if (sel == NULL) {
		NSString *selName = [NSString stringWithFormat:@"actionFor%@%@", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
		sel = NSSelectorFromString(selName);

		key = [key copy]; // Make sure it won't go away
		CFDictionarySetValue(ActionNameToSelector, (const void *)key, sel);
	}
	return sel;
}

static Boolean _equalStrings(const void *value1, const void *value2)
{
	return [(__bridge NSString *)value1 isEqualToString:(__bridge NSString *)value2];
}
static CFHashCode _hashString(const void *value)
{
	return CFHash((CFStringRef)value);
}

@implementation AZLayer

/*
-(id<CAAction>)actionForKey:(NSString *)event {
	if ([event isEqualToAnyOf:@[@"startAngle", @"endAngle"]]) {
	  return [self makeAnimationForKey:event];
	}
	return [super actionForKey:event];
}

- (id)initWithLayer:(id)layer {
	if (self = [super initWithLayer:layer]) {
	  if ([layer isKindOfClass:AZLAyer.class]) {
			AZLayer *other = (AZLayer*)layer;
			self.startAngle = other.startAngle;
			self.endAngle = other.endAngle;
			self.fillColor = other.fillColor;
			
			self.strokeColor = other.strokeColor;
			self.strokeWidth = other.strokeWidth;
			//	self.layoutManager = AZLAYOUTMGR;
			//	_tLayer = [CATransformLayer layer];
			//	_tLayer.frame = self.bounds;
			//	[self addSublayer:_tLayer];
			//	[_tLayer addConstraintsSuperSize];
//			applyPerspective(self);
	  }
	}
	
	return self;
}
*/
+ (BOOL)needsDisplayForKey:(NSString *)key {
	if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
	  return YES;
	}
	
	return [super needsDisplayForKey:key];
}


+ (id)defaultValueForKey:(NSString *)key  // ESSENTIAL

{
	static NSD* vals = nil;	vals = vals ?: @{
//												@"masksToBounds"	: @(YES),
												@"doubleSided"		: @(NO),
												@"hovered"			: @(NO),
												@"selected"			: @(NO),
//												@"flipped"			: @(NO),
												@"borderWidth"		: @4,
												@"borderColor"		: (id)cgRED	};

	return [vals.allKeys containsObject:key] ? vals[key] : [super defaultValueForKey:key];
}

@end

/*
@dynamic hovered, selected, flipped;

- (id)initWithLayer:(id)layer	{	if(!(self = [super initWithLayer:layer])) return nil;
										[[layer propertyNames]each:^(id obj) {
											[self setValue:layer[obj] forKey:obj];
										}];
//									self.delegate = self;
//									self.backgroundColor = cgRANDOMCOLOR;
//									[self setNeedsDisplay];
	return self;
}

+ (AZLayer*) layerAtIndex: (NSI)idx inRange:(RNG)rng withFrame:(CGR)frame
{
	AZLayer *z = [[self class]layer];	z.index = idx; 	z.range = rng; z.frame = frame; 	 return z;
}

//-(id<CAAction>)actionForKey:(NSString *)event {
- (void)runActionForKey:(NSString *)event object:(id)anObject arguments:(NSDictionary *)dict {
		NSLog(@"runA4:%@  on:%@  dic:%@", event, anObject, dict);
//	return [@[@"content", @"color"]containsObject:event] ? [CABA propertyAnimation : @{  zkeyP	: event, zdurA : @3, zfromV	: self.permaPresentation[event], ztimeF : CAMEDIAEASEOUT}]
//		 : [event isEqualToString:@"hovered"] 			 ? [self anim]]
	if (areSame(event, @"hovered")) [anObject animate:@"transform.rotation.y" toFloat:DEG2RAD(360) time:2];
//	else [self s //]	 : [super actionForKey:event];

//	= [CABA animationWithKeyPath:@"transform"];

}

+ (BOOL)needsDisplayForKey:(NSString *)key  //ESSENTIAL
{
	return [@[@"offset", @"position", @"hovered"] containsObject:key] ?: [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx {
	if (self.delegate) { [self.delegate drawLayer:self inContext:ctx]; return;  }
	if (self.hovered) [NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
		[[NSBezierPath bezierPathWithTriangleInRect:self.bounds orientation:AZCompassS]drawWithFill:RANDOMCOLOR andStroke:BLACK];
	}];

}

+ (void)initialize;
{
	if (self == [AZLayer class]) {
		CFDictionaryKeyCallBacks keyCallbacks;
		memset(&keyCallbacks, 0, sizeof(keyCallbacks));
		keyCallbacks.hash = _hashString;
		keyCallbacks.equal = _equalStrings;

		CFDictionaryValueCallBacks valueCallbacks;
		memset(&valueCallbacks, 0, sizeof(valueCallbacks));
		ActionNameToSelector = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &keyCallbacks, &valueCallbacks);
	}
}

#pragma mark NSObject (NSKeyValueObservingCustomization).

// Might want to rename this instead of using the KVO method; or not.
+ (NSSet *)keyPathsForValuesAffectingContent;
{
	return [NSSet set];
}

#pragma mark NSObject subclass

+ (BOOL)resolveInstanceMethod:(SEL)sel;
{
	// Called due to -respondsToSelector: in our -actionForKey:, but only if it doesn't have the method already (in which case we assume it does something reasonble).  Install a method that provides an animation for the property. Right now we are doing a forward lookup of key->sel since this shouldn't get called often, though we could invert the dictionary if needed.
	for (NSString *key in [self keyPathsForValuesAffectingContent]) {
		if (ActionSelectorForKey(key) == sel) {
			// Clone a default behavior over to this key.
			Method m = class_getInstanceMethod(self, @selector(basicAnimationForKey:));
			class_addMethod(self, sel, method_getImplementation(m), method_getTypeEncoding(m));
			return YES;
		}
	}

	return [super resolveInstanceMethod:sel];
}

#pragma mark CALayer subclass


- (id < CAAction >)actionForKey:(NSString *)key
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
	anim.duration = 5;
	anim.autoreverses = YES;
	if ([self presentationLayer] != nil)
		anim.fromValue = [[self presentationLayer] valueForKey:key];
	else anim.toValue = [self valueForKey:key];
	return [self valueForKey:key] ? anim : [super actionForKey:key];

	//		if ([key isEqualToString:@"color"]) {

	//		}
	//	}

	//	return [super actionForKey:key];
}

//- (id <CAAction>)actionForKey:(NSString *)event;
//{
//	SEL sel = ActionSelectorForKey(event);
////	if ([self respondsToSelector:sel])
////		return [self performSelector:sel withObject:event];
////		return objc_msgSend(self, sel, event); // NOTE that we pass the event here. This will be an extra hidden argument to -actionFor<Key> but will be used by the default -basicAnimationForKey:.
//	return [super actionForKey:event];
//}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key;
{
	if ([self isContentAnimation:anim]) {
		// Sadly, even though we set it, removedOnCompletion seems to do nothing (and we can't really depend on subclasses remembering to do this), so keep track of the active animations here.
		// OBASSERT(anim.delegate == nil);
		// OBASSERT([_activeContentAnimations indexOfObjectIdentialTo:anim] == NSNotFound);
		anim.delegate = self;
	}

	[super addAnimation:anim forKey:key];
}

#pragma mark CAAnimation deleate

- (void)animationDidStart:(CAAnimation *)anim;
{
	// Have to do the add here instead of in -addAnimation:forKey: since a copy is started, not the original passed in.
	if ([self isContentAnimation:anim]) {
		if (!_updateTimer)
			_updateTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(_updateTimerFired:) userInfo:nil repeats:YES];

		if (!_activeContentAnimations)
			_activeContentAnimations = NSMA.new;
		[_activeContentAnimations addObject:anim];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
	NSUInteger animIndex = [_activeContentAnimations indexOfObjectIdenticalTo:anim];
	if (animIndex == NSNotFound)
		return;

	[_activeContentAnimations removeObjectAtIndex:animIndex];
	if ([_activeContentAnimations count] == 0) {
		_activeContentAnimations = nil;
		[_updateTimer invalidate];
		_updateTimer = nil;
	}
}

#pragma mark API

- (BOOL)isContentAnimation:(CAAnimation *)anim;
{
	if (![anim isKindOfClass:[CAPropertyAnimation class]])
		return NO;

	// Will be fater if subclass +keyPathsForValuesAffectingContent don't autorelease each time we call them.  Better way to do this?
	CAPropertyAnimation *prop = (CAPropertyAnimation *)anim;
	return [[[self class] keyPathsForValuesAffectingContent] member:[prop keyPath]] != nil;
}

- (CABasicAnimation *)basicAnimationForKey:(NSString *)key;
{
	CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:key];
	basic.removedOnCompletion = NO;//YES; Doesn't actually cause one of the remove methods to be called
	basic.fromValue = [self.presentationLayer valueForKey:key]; // without this set, when our timer fires, the presentation layer won't report any changes.  Bug in CA, I hear.
	basic.toValue  = [self valueForKey:key];
	return basic;
}

- (id <CAAction>)actionForContents;
{
	// We don't want to cross-fade between content images.
	return nil;
}

#pragma mark Private API

- (void)_updateTimerFired:(NSTimer *)timer;
{
	[self setNeedsDisplay];
}

*/

/*
	// Create the path
	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	CGFloat radius = MIN(center.x, center.y);
	CGContextBeginPath(ctx);
	CGContextMoveToPoint(ctx, center.x, center.y);
	CGPoint p1 = CGPointMake(center.x + radius * cosf(self.startAngle), center.y + radius * sinf(self.startAngle));
	CGContextAddLineToPoint(ctx, p1.x, p1.y);
	int clockwise = self.startAngle > self.endAngle;
	CGContextAddArc(ctx, center.x, center.y, radius, self.startAngle, self.endAngle, clockwise);
	//	CGContextAddLineToPoint(ctx, center.x, center.y);
	CGContextClosePath(ctx);
	// Color it
	CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
	CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
	CGContextSetLineWidth(ctx, self.strokeWidth);
	CGContextDrawPath(ctx, kCGPathFillStroke);
*/


/*
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	if ([layer.name contains:@"back"] ) {
		NSBezierPath*  k = [NSBezierPath bezierPathWithRect:[self bounds]];
		NSColor*	main = (NSColor*)[_object valueForKey:@"color"];
		[k fillGradientFrom:main.muchDarker to:main.brighter angle:270];// to:[(NSColor*)
	}else {

		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: desc.firstLetter attributes:@{ NSFontAttributeName: [NSFont fontWithName:@"Ubuntu Mono Bold" size:190],
															  NSForegroundColorAttributeName :WHITE} ];
			[theStyle setLineSpacing:12];
			NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
			[atv setDefaultParagraphStyle:theStyle];
			[atv setBackgroundColor:CLEAR];
			[[atv textStorage] setForegroundColor:BLACK];
			[[atv textStorage] setAttributedString:string];
		[NSShadow setShadowWithOffset:AZSizeFromDimension(3) blurRadius:10 color:c.contrastingForegroundColor];
		[string drawAtPoint:NSMakePoint(10,8)]; main.contrastingForegroundColor
		NSLog(@"didnt dfraw in context");
	}
	[NSGraphicsContext restoreGraphicsState];

}
	NSImage* i = [_object valueForKey:@"image"];
	[i drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	drawRepresentation:[i bestRepresentationForSize:AZSizeFromDimension(256)] inRect:[self bounds]];
	drawCenteredinRect:[self bounds] operation:NSCompositeSourceOver fraction:1];
	CGContextAddPath(ctx, [k quartzPath]);   CGContextFillPath(ctx);
	NSBezierPath *k = [NSBezierPath bezierPathWithRect:[self bounds]];
	[self.object valueForKey:@"color"] brighter] angle:270];
	[NSGraphicsContext restoreGraphicsState];

- (void) setImage:(NSImage*)image
 {
 if (_iconL) 			[_iconL removeFromSuperlayer];
 //	_image 					= [image imageScaledToFitSize:AZSizeFromDimension(256)];
 self.iconL 				= ReturnImageLayer(	self, image.copy, 1);//kCALayerNotSizable
 //	_iconL.contentsGravity	= kCAGravityResizeAspect;
 //	[_iconL addConstraintsSuperSizeScaled:.4];
 }
*/
