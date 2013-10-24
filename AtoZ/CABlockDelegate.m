//
//  CABlockDelegate.m
//  AtoZCodeFactory
//
//  Created by Alex Gray on 6/1/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import "CABlockDelegate.h"
#import <objc/runtime.h>
#import "AtoZUmbrella.h"
#import "AtoZNodeProtocol.h"

/* inspiration
@implementation CAAnimationBlockDelegate
 Delegate method called by CAAnimation at start of animation
- (void) animationDidStart:(CAA*)a {
	if( !self.blockOnAnimationStarted ) return;
	self.blockOnAnimationStarted();
}
 Delegate method called by CAAnimation at end of animation
- (void) animationDidStop:(CAA*)a finished:(BOOL)flag {
	if( flag ) {	if( !self.blockOnAnimationSucceeded ) return;	self.blockOnAnimationSucceeded();
		return;	}
	if( !self.blockOnAnimationFailed ) return;
	self.blockOnAnimationFailed();
}
*/

JROptionsDefine(CABlockType);
JROptionsDefine(NSOVBlockDelegate);

static NSTableRowView* DynamicRowViewForItem(id self, SEL _cmd, NSOutlineView*ov,id item)	{
	return ((NSOV*)self).rowViewForItem(ov,item); 
}
//static void DynamicDictionarySetter(id self, SEL _cmd, id value)	{
//	NSString *key = PropertyNameFromSetter(NSStringFromSelector(_cmd));
//	if (value == nil)		[self removeObjectForKey:key]; else self[key] = value;
//}

@implementation NSOV (AtoZBlocks)
- (void) setDelegateForSelector:(SEL)sel imp:(IMP)imp enc:(const char*)enc withBlock:(id)blk {

	objc_setAssociatedObject(self, sel, blk, OBJC_ASSOCIATION_COPY);
	self.delegate = (id<NSOutlineViewDelegate>)self;
	class_addMethod(self.class,sel, imp,enc);
}
- (RowViewForItem) rowViewForItem{ return objc_getAssociatedObject(self,@selector(outlineView:rowViewForItem:)); }
- (void) setRowViewForItem:(RowViewForItem)rowViewForItem { 
	[self setDelegateForSelector:@selector(outlineView:rowViewForItem:) imp:(IMP)DynamicRowViewForItem enc:@encode(NSTableRowView*(*)(id, SEL, NSOV*, id)) withBlock:rowViewForItem];	
}

@end

@implementation NSOutlineViewBlockDelegate

- (instancetype) init { if (!(self = super.init)) return nil; _toggleActionReference = NSMD.new; return self;	}

+ (instancetype) delegateFor:(NSOV*)v ofType:(NSOVBlockDelegate)type withBlock:(id)block {

	NSOutlineViewBlockDelegate *d = self.new;	d.ov = v; d.block = [block copy]; d.blockType = type;	return d;
}
- (void) outlineView:(NSOV*)v willDisplayOutlineCell:(id)c forTableColumn:(NSTC*)tc item:(id)x {
// Approach 1 - Just replace the triangle images with other images. (This requires the image to be the same size as the triangle)
	if (_disclosureImage) [c setImage:_disclosureImage(c, tc, x)];
//Approach 2 -First, hide the triangle completely.	//if (item)[cell setTransparent:YES];
} 
- (void) outlineView:(NSOV*)v willDisplayCell:(id)c forTableColumn:(NSTC*)tc item:(id)x 	{
//Now we use the non-outline delegate method to set up a button cell to do the expand and collapse for the row.

	if ([tc.identifier isEqualToString:@"outline"]) { //use the appropriate identifier for you column
		if ( (AZNODEPRO x).numberOfChildren > 0 )  {
			[c setImage:[v isItemExpanded:x] ? [NSImage imageNamed:@"up"] : [NSImage imageNamed:@"down"]];
				//set up an action to emulate the clicking you would normally do on the triangle
				[c setAction:@selector(toggleItem:) withTarget:self];
		}
	} else 
		[c setImage:[NSImage imageNamed:@"unexpandable"]];
}
- (BOOL) outlineView:(NSOV*)v isGroupItem:(id)x {
	return YES;
}
- (void) setToggleActionForItem:(id)item block:(OVTOGA)itemBlock	{
	self.toggleActionReference[(id)item] = [itemBlock copy];
}
- (void) toggleItem:(id)sender {

	id item = [_ov itemAtRow:_ov.selectedRow];
	if ([_ov isItemExpanded:item])
		[_ov collapseItem:item];
	else [_ov expandItem:item];
}

- (NSTableRowView*)outlineView:(NSOV*)ov rowViewForItem:(id)item{

}

@end


//@interface CABlockDelegator : AZSingleton
//@end
//@implementation CABlockDelegator
//static NSMA* delegations = nil;

//+ (instancetype)sharedInstance {	id shared = [super sharedInstance];	delegations = @[].mutableCopy;	return shared;	}
////+ (void) addDelegation:(CABlockDelegate*)d; { [delegations addObject:d]; }

//#define SEL_LOG  NSLog(@"%@", NSStringFromSelector(_cmd), nil)
#pragma mark - CAAnimationDelegate
// works.  just need to observe
//- (void)observeValueForKeyPath:(NSString*)kp ofObject:(id)o change:(NSDictionary*)c context:(void*)x{
//	if (areSame(@"offset",keyPath)) 			[self setNeedsLayout];	}

//SYNTHESIZE_SINGLETON_FOR_CLASS(CABlockDelegate, sharedDelegate);
//+ (instancetype) addAnimation:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block {

static NSMD *delegations = nil;
@implementation CABlockDelegate
+ (void) load { if (!delegations) delegations = NSMD.new; }

+ (instancetype) delegateFor:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block {

	CABlockDelegate *n; NSS* uid;
	if (!(n = (uid = [layer vFK:@"delegationID"]) ? delegations[[layer vFK:@"delegationID"]] : nil )) {
		[layer setValue:uid = NSS.newUniqueIdentifier forKey:@"delegationID"];
		n = delegations[uid] = self.new;
	}
	
	if (block == nil || block == NULL) return NSLog(@"delegate not set!  block is zilch!"), nil;
	if 	   ( layer.delegate != nil 			&&		(type == CABlockTypeDrawBlock   ||  
				 type == CABlockTypeAniComplete 	||    type == CABlockTypeLayerAction  ))
				NSLog(@"ERROR*****  Reluctantly willing to override layer (%@)'s previous delegate: %@!", layer, layer.delegate);
	if 		(type == CABlockTypeDrawBlock		) [n setDrawBlock:					[block copy]];
	else if 	(type == CABlockTypeDrawInContext) [n setDrawInContextBlk:			[block copy]];
	else if 	(type == CABlockTypeAniComplete	) [n setAniComplete: 				[block copy]];
	else if 	(type == CABlockTypeLayerAction	) [n setLayerActionBlock:			[block copy]];
	else if 	(type == CABlockTypeLayoutBlock	) [n setLayoutBlock:					[block copy]];
	else if 	(type == CABlockTypeKVOChange		) [n setKvoObserverBlock:  		[block copy]];
	if 		(type == CABlockTypeDrawBlock		) [layer sV:n fK:@"CABlockTypeDrawBlock"		];
	else if 	(type == CABlockTypeDrawInContext) [layer sV:n fK:@"CABlockTypeDrawInContext"	];
	else if 	(type == CABlockTypeAniComplete	) [layer sV:n fK:@"CABlockTypeAniComplete"	];
	else if 	(type == CABlockTypeLayerAction	) [layer sV:n fK:@"CABlockTypeLayerAction"	];
	else if 	(type == CABlockTypeLayoutBlock	) [layer sV:n fK:@"CABlockTypeLayoutBlock"	];
	else if 	(type == CABlockTypeKVOChange		) [layer sV:n fK:@"CABlockTypeKVOChange"		];
	if 		(type == CABlockTypeDrawBlock  	||
				type == CABlockTypeDrawInContext	||
				 type == CABlockTypeAniComplete 	||
				 type == CABlockTypeLayerAction	) 	{ 	layer.delegate = n; [layer setNeedsDisplay];
																	NSAssert(layer.delegate != nil, @"nil");	}
	else if 	(type == CABlockTypeLayoutBlock	)	{	layer.layoutManager = n; [layer setNeedsLayout];	}
	else if 	(type == CABlockTypeKVOChange		)	{
		[(CAL*)layer az_overrideSelector:@selector(didChangeValueForKey:) withBlock:(__bridge void*)^(CAL* _self,NSS*k){
			n.kvoObserverBlock(layer, k);
//			SEL sel = @selector(didChangeValueForKey:);	void (*superIMP)(id, SEL, NSS*) = [_self az_superForSelector:sel];
//																			    superIMP(_self, sel, k);
		}];
	}
	return n;//NSLog(@"setdlegate:%@.. delegate: %@, lom: %@",n,  layer.delegate, layer.layoutManager),
}

- (void) drawLayer:(CALayer*)l inContext:(CGContextRef)x 	{ //AZLOGCMD;

	if (_drawInContextBlk) [NSGC drawInContext:x flipped:NO actions:^{
		_drawInContextBlk(l);
	}];
	else if (_drawBlock) _drawBlock(l,x);

//	[delegations fi  :[l vFK:@"CABlockTypeDrawBlock"]];
//	NSA* drawers = [delegations valueForKeyPath:@"drawBlock"];
//	NSLog(@"drawers: %@", [delegations valueForKeyPath:@"propertyNames"]);
//	[drawers each:^(id sender) { sender ? ((drawBlock)sender)(l,x) : nil;	}];
}
	
- (void) layoutSublayersOfLayer:(CALayer*)layer 				{ 

//	[[delegations valueForKeyPath:@"layoutBlock"] each:^(id sender) { sender ? ((layoutBlock)sender)(layer) : nil;	}];
AZLOGCMD; _layoutBlock ? self.layoutBlock	(layer) 					: nil;
}
- (void) animationDidStop:  (CAAnimation*)theAnimation	
					  finished:				(BOOL)flag 					{ AZLOGCMD;

	NSLog(@"Block delagate, reporting for duty. Type: %@", CABlockTypeToString(CABlockTypeAniComplete));
   _aniComplete ? _aniComplete	(flag, theAnimation) : nil;

//	[[delegations valueForKeyPath:@"aniComplete"] each:^(id sender) { sender ? ((aniComplete)sender)(flag, theAnimation) : nil;	}];
				  
					  	// Remove any sublayers marked for removal
	//	for ( CALayer *layer in self.sublayers ) [[layer valueForKey:@"toRemove"] boolValue]  ?: [layer removeFromSuperlayer];

}

@end


@implementation CALayer (BlockDrawLayer)

- (void) setDelegateType:(CABlockType)type block:(id)blk {

	[self setBlockDelegate:[CABlockDelegate delegateFor:self ofType:type withBlock:blk]];
}
- (void) setKVOBlock:(CABKVO)blk { [CABlockDelegate delegateFor:self ofType:CABlockTypeKVOChange withBlock:blk]; }
- (void) setLayoutBlock:(CABLAYOUT)blk { 	[CABlockDelegate delegateFor:self ofType:CABlockTypeLayoutBlock withBlock:blk]; }
	
//- (NSString*) delegateDescription {  return CABlockTypeToString(self.blockDelegate.blockType); }

- (CABlockDelegate*) blockDelegate {   return [self vFK:@"blockDelegate"]; }

+ (CAL*) layerWithFrame:(NSR)f drawnUsingBlock:(void(^)(CAL*))drawBlock {
	CAL *l = [self.class.alloc init];
	l.frame = f;
	[CABlockDelegate delegateFor:l ofType:CABlockTypeDrawInContext withBlock:drawBlock];
	return l;
}
@end


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

//@interface AZValueTransformer :NSValueTransformer
//@property (nonatomic, copy) id (^transformBlock)(id value);
//+ (instancetype) transformerWithBlock:    (id(^)(id value))block;
//@end
//@implementation AZValueTransformer									@synthesize transformBlock;
//+         (BOOL) allowsReverseTransformation						{ return NO; }
//-           (id) transformedValue:			  (id)value			{ return self.transformBlock(value); }
//+ (instancetype) transformerWithBlock:(id(^)(id value))blk	{ NSParameterAssert(blk != NULL);
//	AZValueTransformer *transformer = self.new;
//	transformer.transformBlock = blk;
//	return transformer;
//}
//@end

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
/**
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
//- (void)bind:(NSS*)b toKeysForObjects:(NSDictionary*)d transform:(id (^)(id value))transformBlock {
//
//	for (NSString* key in d.allKeys) {
//		AZValueTransformer *transformer = [AZValueTransformer transformerWithBlock:transformBlock];
//		[self bind:b toObject:d[key] withKeyPath:d options:@{NSContinuouslyUpdatesValueBindingOption:@(YES), NSValueTransformerBindingOption:transformer}];
//	}
//}
*/
@end

/*
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
            if ([ease isKindOfClass:NSString.class])
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
 */


@interface CAAnimationDelegate ()
@property (strong)  NSS * kp;
@property (strong) 	id   tV;
@end

@implementation CAAnimationDelegate	static 	NSMD* referenceDic;		SYNTHESIZE_SINGLETON_FOR_CLASS(CAAnimationDelegate, sharedDelegator);

+ (instancetype) delegate:(CAA*)a forLayer:(CAL*)l 		{
	CAAnimationDelegate*d = self.new;
	d.layer = l;
	d.ani = a;
//	if ([a vFK:@"keyPath"]) [d sV:[a vFK:@"keyPath"] fK:@"kp"];
	[d.ani setDelegate:d];
	[d.ani sV:d fK:@"aniDelegate"];
	return d;
}
- 	 (id) init															{	return self = super.init ? _andSet=YES,_completion=nil, _start=nil,self : nil;	}
- (void) animationDidStart:(CAA*)anim							{
	_start ? _start() : nil;
	_startWithInfo ? _startWithInfo(self) : nil;
	if (_andSet) {

		NSS* kP = [anim vFK: @"keyPath"];
		id val = [anim vFK:@"toValue"];
		if (!_layer || !kP || !val) return NSLog(@"warning, couldnt set value");
		[[_layer modelCALayer] sV:val fK:kP];
		NSLog(@"delegated start of animation on %@ with KP:%@",_layer, kP);
	}
}
- (void) animationDidStop:(CAA*)anim finished:(BOOL)flag	{
	_completion ? _completion() : nil;
	_completionWithInfo ? _completionWithInfo(self) : nil;
//	if (self.layer && [anim vFK:@"toValue"])
//		{
//			id aToVal = ((CABA*)anim).toValue;
//			NSS* kp = ((CAPropertyAnimation*)anim).keyPath;
//			[[anim.layer modelCALayer] setValue:aToVal forKey:kp];
//		}
}
@end

@implementation CAAnimation (BlocksAddition)
- (CAL*) layer 														{ return [self valueForKey:@"_layer"]; }
- (void) setLayer:(CAL*)l 											{ [self setValue:l forKey:@"_layer"]; }
- (void) setCompletion:(CAABCOMPINFO)comp forLayer:(CAL*)l 	{

	CAAnimationDelegate *s =	[CAAnimationDelegate delegate:self forLayer:l];
	s.completionWithInfo = comp;
}
- (void) setCompletion:(CAABCOMPINFO)comp							{

	[self.delegate isKindOfClass:CAAnimationDelegate.class] ? [((CAAnimationDelegate *)self.delegate) setCompletionWithInfo:comp] : ^{
		CAAnimationDelegate *delegate = [CAAnimationDelegate delegate:self forLayer:nil];	delegate.completionWithInfo = comp;	 } ();
}
- (CAABCOMPINFO) completion 											{
	return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).completionWithInfo: nil;
}
- (void)setStart:(CAABSTRTINFO)start								{
	if ([self.delegate isKindOfClass:[CAAnimationDelegate class]])
		((CAAnimationDelegate *)self.delegate).startWithInfo = start;
	
	else {
		CAAnimationDelegate *delegate = [CAAnimationDelegate delegate:self forLayer:nil];
		delegate.startWithInfo = start;
	}
}
- (CAABSTRTINFO)start 													{
	return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).startWithInfo: nil;
}

@end


