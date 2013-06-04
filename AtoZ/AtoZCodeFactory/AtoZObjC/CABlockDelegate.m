//
//  CABlockDelegate.m
//  AtoZCodeFactory
//
//  Created by Alex Gray on 6/1/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import "CABlockDelegate.h"
#import <objc/runtime.h>


@implementation CABlockDelegate
+ (instancetype) delegateFor:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block {

	CABlockDelegate *n = self.new;
	if (block == nil || block == NULL) return NSLog(@"delegate not set!  block is zilch!"), nil;
	if 	   ( layer.delegate != nil 			&&		(type == CABlockTypeDrawBlock   ||  
				 type == CABlockTypeAniComplete 	||    type == CABlockTypeLayerAction  ))
				 return NSLog(@"ERROR*****  NOT willing to override layer (%@)'s previous delegate: %@!", layer, layer.delegate), nil;
	if 		(type == CABlockTypeDrawBlock		) [n setDrawBlock:			[block copy]];
	else if 	(type == CABlockTypeAniComplete	) [n setAniComplete: 		[block copy]];
	else if 	(type == CABlockTypeLayerAction	) [n setLayerActionBlock:	[block copy]];
	else if 	(type == CABlockTypeLayoutBlock	) [n setLayoutBlock:			[block copy]];
	if 		(type == CABlockTypeDrawBlock		) [layer setValue:n forKey:@"CABlockTypeDrawBlock"];
	else if 	(type == CABlockTypeAniComplete	) [layer setValue:n forKey:@"CABlockTypeAniComplete"];
	else if 	(type == CABlockTypeLayerAction	) [layer setValue:n forKey:@"CABlockTypeLayerAction"];
	else if 	(type == CABlockTypeLayoutBlock	) [layer setValue:n forKey:@"CABlockTypeLayoutBlock"];
	if 		(type == CABlockTypeDrawBlock  	|| 
				 type == CABlockTypeAniComplete 	|| 
				 type == CABlockTypeLayerAction) { layer.delegate		 = n; [layer setNeedsDisplay]; NSAssert(layer.delegate != nil, @"nil");	}
	else if 	(type == CABlockTypeLayoutBlock)	{ layer.layoutManager = n; [layer  setNeedsLayout];	}
	return //NSLog(@"setdlegate:%@.. delegate: %@, lom: %@",n,  layer.delegate, layer.layoutManager), 
				n;
}

#pragma mark - CALayer Animation Delegate

//- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key
//{
//		return _layerActionBlock 	? self.layerActionBlock(layer,key) : nil;
/**
	//	 return [key isEqualToString: @"position"] ?
	//	 ^{
	//		CGP oldP  = layer.position;													CGP newP  = [[CATransaction valueForKey: @"newP"] pointValue];
	//		CGF d 	  = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2));		CGF r 	  = d / 3.0;
	//		CGF theta = atan2(newP.y - oldP.y, newP.x - oldP.x);						CGF wag   = 10 * M_PI / 180.0;
	//		CGP p1 	  = (CGP) { oldP.x + r *	 cos ( theta + wag ), 	oldP.y + r * sin 	 ( theta + wag )};
	//		CGP p2 	  = (CGP) { oldP.x + r * 2 * cos ( theta - wag ), 	oldP.y + r * 2 * sin ( theta - wag )};
	//
	//		CAKA* anim  = [CAKeyframeAnimation animation];  anim.values = @[ AZVpoint(oldP), AZVpoint(p1), AZVpoint(p2), AZVpoint(newP)];	anim.calculationMode = kCAAnimationCubic;
	//	return anim;
	//	}():
	//	return
	[key isEqualToString:kCAOnOrderOut] ?
	^{
		CABasicAnimation* anim1 	= [CABasicAnimation animationWithKeyPath:@"opacity"];
		CABasicAnimation* anim2 	= [CABasicAnimation animationWithKeyPath:@"transform"];

		anim1.fromValue = @0;  anim1.toValue 	= @1;//(layer.opacity);
//		anim2.toValue 	 = AZV3d( CATransform3DScale(layer.transform, 2, 2, 1.0));	
//		anim2.autoreverses 	= NO;  / * YES* /		
		anim2.duration 		= 3;
		CAAnimationGroup* group = CAAnimationGroup.animation;
		group.animations = @[ anim1, anim2 ];	
		group.duration = 0.2;
		return group;
		
	}():[key isEqualToString:@"opacity"] ?
	^{
		return [CATransaction valueForKey:@"byebye"] ?
		^{
			CABasicAnimation* anim1 	=  [CABasicAnimation animationWithKeyPath:@"opacity"];
			anim1.fromValue 	= @(layer.opacity);
			anim1.toValue 	= @0;
			CABA* anim2 	= [CABA animationWithKeyPath:@"transform"];
//			anim2.toValue 	= AZV3d( CATransform3DScale(layer.transform, 0.1, 0.1, 1.0));
			CAAnimationGroup* group 	= CAAnimationGroup.animation;
			group.animations = @[ anim1, anim2 ];
			group.duration = 0.2;
			return group;
		}(): nil;
	}():nil;

	// Set up an animation delegate when we are removing a layer so we can remove it from the view hierarchy when it is done
	if ( [layer valueForKey:@"toRemove"] )
	{
		CABasicAnimation *animation = CABasicAnimation.animation;
		if ( [key isEqualToString:@"bounds"] ) animation.delegate = self;
		return animation;
	}

	return nil;
*/
//}
#define SEL_LOG NSLog(@"%@", NSStringFromSelector(_cmd))
#pragma mark - CAAnimationDelegate
// works.  just need to observe
//- (void)observeValueForKeyPath:(NSString*)kp ofObject:(id)o change:(NSDictionary*)c context:(void*)x{
//	if (areSame(@"offset",keyPath)) 			[self setNeedsLayout];	}

- (void) drawLayer:(CALayer*)l inContext:(CGContextRef)x 	{ SEL_LOG; _drawBlock 	? self.drawBlock		(l,x) 					: nil;	}
- (void) layoutSublayersOfLayer:(CALayer*)layer 				{ SEL_LOG; _layoutBlock ? self.layoutBlock	(layer) 					: nil; 	}		
- (void) animationDidStop:  (CAAnimation*)theAnimation	
					  finished:				(BOOL)flag 					{SEL_LOG;  _aniComplete ? self.aniComplete	(flag, theAnimation) : nil; 	
					  
					  	// Remove any sublayers marked for removal
	//	for ( CALayer *layer in self.sublayers ) [[layer valueForKey:@"toRemove"] boolValue]  ?: [layer removeFromSuperlayer];

}
@end



@interface AZValueTransformer :NSValueTransformer
@property (nonatomic, copy) id (^transformBlock)(id value);
+ (instancetype) transformerWithBlock:    (id(^)(id value))block;
@end
@implementation AZValueTransformer									@synthesize transformBlock;
+         (BOOL) allowsReverseTransformation						{ return NO; }
-           (id) transformedValue:			  (id)value			{ return self.transformBlock(value); }
+ (instancetype) transformerWithBlock:(id(^)(id value))blk	{ NSParameterAssert(blk != NULL);
	AZValueTransformer *transformer = self.new;
	transformer.transformBlock = blk;
	return transformer;
}
@end

@implementation  NSObject (KVOTransformer)

- (NSString*)properties {
    NSMutableString* string = [NSMutableString stringWithString:@""];
    unsigned int propertyCount;
    objc_property_t* properties = class_copyPropertyList([self class], &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++) {
        NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        SEL sel = sel_registerName([selector UTF8String]);
       const char* attr = property_getAttributes(properties[i]);
        switch (attr[1]) {
            case '@':
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

                [string appendString:[NSString stringWithFormat:@"%s : %@\n", property_getName(properties[i]), [self performSelector:sel]]];
                break;
            case 'i':
                [string appendString:[NSString stringWithFormat:@"%s : %@\n", property_getName(properties[i]), [self performSelector:sel]]];
                break;
            case 'f':
                [string appendString:[NSString stringWithFormat:@"%s : %@\n", property_getName(properties[i]), [self performSelector:sel]]];
                break;
            default:
                break;
#pragma clang diagnostic pop
        }
    }    free(properties);
    return string;
}
- (BOOL)overrideSelector:(SEL)selector withBlock:(void *)block	{
	Class selfClass 	= [self class];
	Class subclass 	= nil;
	NSString *prefix 	= [NSString stringWithFormat:@"MHOverride_%p_", self];
	NSString *className = NSStringFromClass(selfClass);
	if (![className hasPrefix:prefix])	{
		NSString *name = [prefix stringByAppendingString:className];
		subclass = objc_allocateClassPair(selfClass, name.UTF8String, 0);
		if (subclass == NULL) return NSLog(@"Could not create subclass"), NO;
 		objc_registerClassPair(subclass);
		object_setClass(self, subclass);
	}
	else  // object already has an override subclass
		subclass = selfClass;
	Method m = class_getInstanceMethod(selfClass, selector);
	if (m == NULL)
		return NSLog(@"Could not find method %@ in class %@", NSStringFromSelector(selector), NSStringFromClass(selfClass)), NO;
	// See also: http://www.friday.com/bbum/2011/03/17/ios-4-3-imp_implementationwithblock/
	IMP imp = imp_implementationWithBlock((__bridge id)(block));
	//	IMP imp = imp_implementationWithBlock(block);
	return !class_addMethod(subclass, selector, imp, method_getTypeEncoding(m)) ?
		NSLog(@"Could not add method %@ to class %@", NSStringFromSelector(selector), NSStringFromClass(subclass)), NO : YES;
}
- (void *)superForSelector:(SEL)selector{
	NSString *prefix = [NSString stringWithFormat:@"MHOverride_%p_", self];
	Class theClass = [self class];
	while (theClass != nil)	{	NSString *className;		theClass = [theClass superclass];
		if ([(className = NSStringFromClass(theClass)) hasPrefix:prefix]) return (void *)[theClass instanceMethodForSelector:selector];
	}
	return NSLog(@"Could not find superclass for %@", NSStringFromSelector(selector)), NULL;
}
- (void)bind:(NSS*)b toObject:(id)o withKeyPath:(NSS*)k transform:(id (^)(id value))transformBlock {
	AZValueTransformer *transformer = [AZValueTransformer transformerWithBlock:transformBlock];
	[self bind:b toObject:o withKeyPath:k options:@{NSContinuouslyUpdatesValueBindingOption:@(YES), NSValueTransformerBindingOption:transformer}];
}
- (void)bind:(NSS*)b toKeysForObjects:(NSDictionary*)d transform:(id (^)(id value))transformBlock {

	for (NSString* key in d.allKeys) {
		AZValueTransformer *transformer = [AZValueTransformer transformerWithBlock:transformBlock];
		[self bind:b toObject:d[key] withKeyPath:d options:@{NSContinuouslyUpdatesValueBindingOption:@(YES), NSValueTransformerBindingOption:transformer}];
	}
}

@end


@implementation NSGraphicsContext (FunSize)

+(void)drawInContext:(CGContextRef)ctx 
				 flipped:(BOOL)flipped 
				 actions:(void(^)())actions	{
    [self saveGraphicsState];    
    NSGraphicsContext* context = [[self class] graphicsContextWithGraphicsPort:ctx flipped:flipped];
    [self setCurrentContext:context];   actions();  [self restoreGraphicsState];
}
+(void)state:(void(^)())actions				{    [[self currentContext] state:actions];	}
-(void)state:(void(^)())actions				{    [self saveGraphicsState];    actions();    [self restoreGraphicsState];}

@end




@implementation CALayer (CAScrollLayer_Extensions)
- (id) scanSubsForClass:(Class )c 					{

	__block CALayer * thing = nil;
	[self.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:c]) { thing = obj; *stop = YES;  }
		else if ([obj sublayers].count > 0) thing = [obj scanSubsForClass:c]; 
	}];
	return thing;
}
- (id) scanSubsForName:(NSString*)n 					{

	__block CALayer * thing = nil;
	[self.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([[obj name] isEqualToString:n]) { thing = obj; *stop = YES;  }
		else if ([obj sublayers].count > 0) thing = [obj scanSubsForName:n]; 
	}];
	return thing;
}
- (void)scrollBy:(CGPoint)inDelta					{
	if (![self isKindOfClass:[CAScrollLayer class]]) return;
	const CGRect theVisibleRect = self.visibleRect;
	const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
	[(CAScrollLayer*)self scrollToPoint:theNewScrollLocation];
}
- (void)scrollCenterToPoint:(CGPoint)inPoint;	{
	if (![self isKindOfClass:[CAScrollLayer class]]) return;
	const CGRect theBounds = self.bounds;
	const CGPoint theCenter = {
		.x = CGRectGetMidX(theBounds),
		.y = CGRectGetMidY(theBounds),
	};
	const CGPoint theNewPoint = {
		.x = inPoint.x - theCenter.x,
		.y = inPoint.y - theCenter.y,
	};
	[(CAScrollLayer*)self scrollToPoint:theNewPoint];
}

@end


@implementation CATransaction (FunSize)
+(void)transactionWithLength:(NSTimeInterval)length actions:(void (^)())block	{
    [self transactionWithLength:length easing:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] actions:block];
}
+(void)transactionWithLength:(NSTimeInterval)length easing:(id)ease actions:(void (^)())block	{
    if (length < 0.0)
    {
        NSLog(@"Attempted a transaction of negative length %f, performing all actions immediately.", length);
        [self immediately:block];
    }
    else if (length == 0.0)
    {
        [self immediately:block];
    }
    else
    {
        [self begin];
        [self setDisableActions:NO];
        [self setAnimationDuration:length];
        
        // handle easing
        if (ease)
        {
            // if the easing function is a string, substitute the media timing function
            if ([ease isKindOfClass:[NSString class]])
                ease = [CAMediaTimingFunction functionWithName:ease];
            
            [self setAnimationTimingFunction:ease];
        }
        
        block();
        [self commit];
    }
}
+(void)immediately:(void (^)())block	{
    [self begin];
    [self setDisableActions:YES];
    block();
    [self commit];
}
@end
