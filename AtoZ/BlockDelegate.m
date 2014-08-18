
#import "AtoZ.h"
#import "BlockDelegate.h"

JREnumDefine(BlockDelegateType);
JREnumDefine(NSOVBlockDelegate);

//static NSMD *delegations = nil;

@implementation NSO (KVOBlockDelegate)  @dynamic KVOBlock;

SYNTHESIZE_ASC_OBJ(blockDelegate, setBlockDelegate);

- (void) setKVOBlock:(KVOB)blk { [BlockDelegate delegateFor:self ofType:KVOChangeBlock withBlock:blk]; }

- (void) addDelegate:(BlockDelegateType)type block:(id)blk {

    [BlockDelegate delegateFor:self ofType:type withBlock:blk];
//	[self setBlockDelegate:[BlockDelegate delegateFor:self ofType:type withBlock:blk]];
}
@end

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
//	 = ((NSO*)x).blockDelegate = ((NSO*)x).blockDelegate 
//                  ? : (uid = [x vFK:@"delegationID"]) ? (delegations = delegations 
//                  ? : NSMD.new)[uid] : (delegations[(x[@"delegationID"] = NSS.newUniqueIdentifier)] = self.new);

 */
#define dCVfKSEL @selector(dCVfK:)

@implementation BlockDelegate //+ (void) load { if (!delegations) delegations = NSMD.new; }

+ (instancetype) delegateFor:(id)x ofType:(BlockDelegateType)t withBlock:(id)blk {	return

  !blk ? NSLog(@"%@",@"delegate not set!  block is zilch!"), (BlockDelegate*)nil : ^{

    BlockDelegate * bdel = ((NSO*)x).blockDelegate ?: (((NSO*)x).blockDelegate = self.new);

    if (!x || !bdel) { NSLog(@"%@",@"delegate not set!    owner or bDelegaye was zilch!"); return (id)nil; }

    if (t & (CABlockTypeDrawBlock|CABlockTypeAniComplete|CABlockTypeLayerAction) && !![x delegate])
      NSLog(@"WARNING*****  Reluctantly willing to override layer (%@)'s previous delegate: %@!", x, [x delegate]);

    if (ISA(x,CAL)) bdel.layer = x; bdel.owner = x;  [bdel sV:blk fK:BlockDelegateTypeToString(t)];
    t & (CABlockTypeDrawBlock|CABlockTypeDrawInContext|CABlockTypeAniComplete|CABlockTypeLayerAction) ? ({

      [x setDelegate:(id)bdel]; [x setNeedsDisplay]; NSAssert(!![x delegate], @"nil");

    }) : t == CABlockTypeLayoutBlock ? ({ [x setLayoutManager:(id)bdel]; [x  setNeedsLayout];
    }) : t ==  KVOChangeBlock ?

    [x az_overrideSelector:dCVfKSEL withBlock:(__bridge void*)^(id _self, NSS*k){
      void (*superIMP)(id, SEL, NSS*);
        if ((superIMP = [_self az_superForSelector:dCVfKSEL]))                       superIMP(_self,dCVfKSEL,k);

               id val = [_self vFK:k]; id valD = val ? @{@"value":val} : @{};  bdel.KVOChangeBlock(_self,k,valD);
    }] : (void)nil;

    return (id)bdel;//NSLog(@"setdlegate:%@.. delegate: %@, lom: %@",n,  layer.delegate, layer.layoutManager),
  }();
}

- (void) drawLayer:(CALayer*)l inContext:(CGContextRef)x 	{ //AZLOGCMD;

	_CABlockTypeDrawInContext ? _CABlockTypeDrawInContext(l,x) :
  _CABlockTypeDrawBlock     ? [NSGC drawInContext:x flipped:l.isGeometryFlipped actions:^{  _CABlockTypeDrawBlock(l); }] : nil;
}

//    NSGraphicsContext* newContext = [NSGraphicsContext graphicsContextWithGraphicsPort:x flipped:NO];
//    [NSGraphicsContext setCurrentContext:newContext];
//    [NSGC restoreGraphicsState];
//	[delegations fi  :[l vFK:@"CABlockTypeDrawBlock"]];
//	NSA* drawers = [delegations valueForKeyPath:@"drawBlock"];
//	NSLog(@"drawers: %@", [delegations valueForKeyPath:@"propertyNames"]);
//	[drawers each:^(id sender) { sender ? ((drawBlock)sender)(l,x) : nil;	}];

- (void) layoutSublayersOfLayer:(CALayer*)layer 				{

//	[[delegations valueForKeyPath:@"layoutBlock"] each:^(id sender) { sender ? ((layoutBlock)sender)(layer) : nil;	}]; 	AZLOGCMD;
  if (_CABlockTypeLayoutBlock)  _CABlockTypeLayoutBlock(layer);
}
- (void) animationDidStart:(CAA*)anim							{  if (_CABlockTypeAniStart)  _CABlockTypeAniStart(_layer, anim); }

- (void) animationDidStop:  (CAAnimation*)theAnimation
								 finished:				(BOOL)flag 					{ AZLOGCMD;

	NSLog(@"Block delagate, reporting for duty. Type: %@", BlockDelegateTypeToString(CABlockTypeAniComplete));
	_CABlockTypeAniComplete ? _CABlockTypeAniComplete	(_layer,flag, theAnimation) : nil;

	//	[[delegations valueForKeyPath:@"aniComplete"] each:^(id sender) { sender ? ((aniComplete)sender)(flag, theAnimation) : nil;	}];

	// Remove any sublayers marked for removal
	//	for ( CALayer *layer in self.sublayers ) [[layer valueForKey:@"toRemove"] boolValue]  ?: [layer removeFromSuperlayer];

}
- (id <CAAction>)actionForLayer:(CAL*)l forKey:(NSS*)e {
  return _CABlockTypeLayerAction ? _CABlockTypeLayerAction(l,e) : nil;
}

@end


@implementation CALayer (BlockDrawLayer) // @dynamic blockDelegate, drawInContextBlk;

@dynamic layoutBlock, drawInContextBlk, layerActionBlock, aniStartBlock, drawBlock;

- (void) setDrawBlock:(LayerBlock)blk     { [BlockDelegate delegateFor:self ofType:CABlockTypeDrawBlock withBlock:blk]; }
- (void) setLayerActionBlock:(CABACTION)blk     { [BlockDelegate delegateFor:self ofType:CABlockTypeLayerAction withBlock:blk]; }
- (void) setDrawInContextBlk:(LayerCTXBlock)blk { [BlockDelegate delegateFor:self ofType:CABlockTypeDrawInContext withBlock:blk]; }
- (void)      setLayoutBlock:(LayerBlock)blk    {	[BlockDelegate delegateFor:self ofType:CABlockTypeLayoutBlock withBlock:blk]; }
- (void)    setAniStartBlock:(CABANIS)blk       { [self addDelegate:CABlockTypeAniStart block:blk]; }

//- (NSString*) delegateDescription {  return CABlockTypeToString(self.blockDelegate.blockType); }
//- (BlockDelegate*) blockDelegate {   return [self vFK:@"blockDelegate"]; }

+ (CAL*) layerWithFrame:(NSR)f drawnUsingBlock:(void(^)(CAL*,CGCREF))drawBlock {

	CAL *l = self.class.layer;
	l.frame = f;
	l.drawInContextBlk = drawBlock;
  l.needsDisplayOnBoundsChange = YES;
//  l.drawsAsynchronously = YES;
//  [l disableResizeActions];// ys:@[@"position", @"bounds"]];
  l.arMASK = CASIZEABLE;
	return l;
}
@end

@interface CAAnimationDelegate ()
@property (strong)  NSS * kp;
@property (strong) 	id   tV;
@end

@implementation CAAnimationDelegate
static 	NSMD* referenceDic;
SYNTHESIZE_SINGLETON_FOR_CLASS(CAAnimationDelegate, sharedDelegator);

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
- (void) animationDidStart:(CAA*)anim       {

	_start ? _start(_layer,_ani) : nil;
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
	_completion ? _completion(_layer, flag, anim) : nil;
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


@interface  GenericDelegate : NSObject
//@property (weak) id owner;
@end @implementation GenericDelegate @end

@implementation NSObject (AddMethodToDelegate)
- (void) addToOrCreateDelegateMethod:(SEL)sel imp:(IMP)imp {

	id x = objc_msgSend(self,@selector(delegate));
	if (!x) {
		x = GenericDelegate.new;
		[x setOwner:self];
		[self performSelectorWithoutWarnings:@selector(setDelegate:) withObject:x];
	}
	const char *types = @"v@:".UTF8String;
  __unused BOOL success = class_addMethod([x class],sel,imp, types);
	NSLog(@"Added method:%@ to class:%@",NSStringFromSelector(sel),NSStringFromClass([x class]));

//		[x az_overrideSelector:sel withBlock:imp_implementationWithBlock(id block)
		//(__bridge void*)^(CAL* _self,NSS*k){

}
@end

@implementation NSText (LastTyped)
-(NSS*)lastLetter {
	NSS* selfs = self.string;
	return !selfs.length ? nil : self.selectedRange.length ? [selfs substringWithRange:self.selectedRange] : selfs.lastLetter;
}
@end
@implementation NSTextView (BlockChange)
- (void(^)(NSRNG,NSS*))shouldChangeTextInRangeWithReplacement { return FETCH; }
-(void) setShouldChangeTextInRangeWithReplacement:(void (^)(NSRange rng, NSString *rplcmnt))shouldChangeTextInRangeWithReplacement {
//	[self addToOrCreateDelegateMethod:@selector(textView:shouldChangeTextInRange:replacementString) 
}
- (void(^)(NSText*))textDidChange { return FETCH; }
-(void) setTextDidChange:(void (^)(NSText *))textDidChange {

	COPY(@selector(textDidChange),textDidChange);

	void (^impBlock)(id,NSNOT*) = ^(id _self, NSNOT* note) { [_self textDidChange](note.object); };
  // create an IMP from the block
  void(*impFunct)(id, SEL, NSNOT*) = (void*) imp_implementationWithBlock(impBlock);
	class_addMethod([self class], @selector(textDidChange:), (IMP)impFunct, "v@:@");

	void (^impBlock2)(id,NSNOT*) = ^(id _self, NSNOT* note) { [_self textDidChange](note.object); };
  // create an IMP from the block
  void(*impFunct2)(id, SEL, NSNOT*) = (void*) imp_implementationWithBlock(impBlock2);
	class_addMethod([self class], @selector(textViewDidChangeSelection:),(IMP)impFunct2,"v@:@");

	[self setDelegate:self];


	// call the block, call the imp. Note the argumentation differences
	//  NSLog(@"impyBlock: %d + %d = %d", 20, 22, impyBlock(nil, 20, 22));
	//  NSLog(@"impyFunct: %d + %d = %d", 20, 22, impyFunct(nil, NULL, 20, 22));
	// dynamically add the method to the class, then invoke it on the previously
	// created instance (or we could create the instance after adding, doesn't matter)
//NSLog(@"Method: %d + %d = %d", 20, 22, [a answerForThis:20 andThat:22]);

//	[self addToOrCreateDelegateMethod:@selector(textDidChange:) imp:(IMP)impFunct];
}

@end

@implementation  NSOutlineView (BlockDelegate) @dynamic outlineViewSelectionDidChange, outlineViewRowViewForItem;
//	NSTableRowView
-(NSTableRowView*(^)(NSOV*,id))																OVRowViewForItem { return FETCH; }
-(void) setOVRowViewForItem:(NSTableRowView*(^)(NSOV*ov,id x))OVRowViewForItem { COPY(@selector(OVRowViewForItem), OVRowViewForItem);
																													if (OVRowViewForItem)	 self.delegate = self;
}

//	OVSelectionDidChange
- (void(^)(NSOV*))															  OVSelectionDidChange { return FETCH; }
- (void) setOVSelectionDidChange:(void (^)(NSOV*))OVSelectionDidChange {
	if (OVSelectionDidChange) self.delegate = self;
	COPY(@selector(OVSelectionDidChange),OVSelectionDidChange);
}
- (void) outlineViewSelectionDidChange:(NSNOT*)note										 {	if (self.OVSelectionDidChange) self.OVSelectionDidChange(note.object); } // Selection Changed Notification
@end

static NSTableRowView* DynamicRowViewForItem(id self, SEL _cmd, NSOutlineView*ov,id item)	{

  XX(@"inside DynamicRowViewForItem");
	return ov.rowViewForItem(ov,item);
}
//static void DynamicDictionarySetter(id self, SEL _cmd, id value)	{ 	NSString *key = PropertyNameFromSetter(NSStringFromSelector(_cmd)); if (value == nil)		[self removeObjectForKey:key]; else self[key] = value; }

@implementation NSOV (AtoZBlocks)
- (void) setDelegateForSelector:(SEL)sel imp:(IMP)imp enc:(const char*)enc withBlock:(id)blk {

	objc_setAssociatedObject(self, sel, blk, OBJC_ASSOCIATION_COPY);
	self.delegate = (id<NSOutlineViewDelegate>)self;
	class_addMethod(self.class,sel, imp,enc);
}
- (RowViewForItem) rowViewForItem{ return objc_getAssociatedObject(self,@selector(outlineView:rowViewForItem:)); }
- (void) setRowViewForItem:(RowViewForItem)rowViewForItem {
	[self setDelegateForSelector:@selector(outlineView:rowViewForItem:)
                           imp:(IMP)DynamicRowViewForItem
                           enc:@encode(NSTableRowView*(*)(id, SEL, NSOV*, id))
                     withBlock:rowViewForItem];
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
//		if ( (AZNODEPRO x).numberOfChildren > 0 )  {
//			[c setImage:[v isItemExpanded:x] ? [NSImage imageNamed:@"up"] : [NSImage imageNamed:@"down"]];
//			//set up an action to emulate the clicking you would normally do on the triangle
//			[c setAction:@selector(toggleItem:) withTarget:self];
//		}
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

//- (NSTableRowView*)outlineView:(NSOV*)ov rowViewForItem:(id)item{
//
//}

@end


//@interface CABlockDelegator : AZSingleton
//@end
//@implementation CABlockDelegator
//static NSMA* delegations = nil;

//+ (instancetype)sharedInstance {	id shared = [super sharedInstance];	delegations = @[].mutableCopy;	return shared;	}
////+ (void) addDelegation:(BlockDelegate*)d; { [delegations addObject:d]; }

//#define SEL_LOG  NSLog(@"%@", NSStringFromSelector(_cmd), nil)
#pragma mark - CAAnimationDelegate
// works.  just need to observe
//- (void)observeValueForKeyPath:(NSString*)kp ofObject:(id)o change:(NSDictionary*)c context:(void*)x{
//	if (areSame(@"offset",keyPath)) 			[self setNeedsLayout];	}

//SYNTHESIZE_SINGLETON_FOR_CLASS(BlockDelegate, sharedDelegate);
//+ (instancetype) addAnimation:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block {



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

/*!
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

#import <objc/runtime.h>
#import "AtoZTypes.h"
#import "AtoZUmbrella.h"
#import "AtoZNodeProtocol.h"

//- (NSTableRowView*)outlineView:(NSOutlineView*)oV         rowViewForItem:(id)x { AZLOGCMD;
//
////	if (![self outlineView:oV isGroupItem:x]) return nil;
//			NSTableRowView *rowView;
//
//	if (!(rowView = [oV makeViewWithIdentifier:@"HeaderRowView" owner:nil])) {
//		rowView = [NSTableRowView.alloc initWithFrame:CGRectZero];
//		rowView.identifier = @"HeaderRowView";
//	}
//	if (!rowView && self == oV.delegate && self.OVRowViewForItem) rowView = self.OVRowViewForItem(oV,x);
//	if (!rowView && self.delegate && [self.delegate respondsToSelector:@selector(outlineView:rowViewForItem:)] ) rowView =  [self.delegate outlineView:oV rowViewForItem:x];
//	XX(rowView);
//	return rowView;
//}

 */
