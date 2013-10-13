
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#import "AtoZNodeProtocol.h"
#import "extobjc_OSX/extobjc.h"

#ifdef AtoZFramework
#define VOMIT @"vageen"
#else
#import "CABlockDelegate.h"
#endif

#ifdef JRENUM 
JREnumDefine(AZMethod);
#endif

@interface  AZNode()
@property id keyValue, valueValue;
@property NSMA* contentObject;
@end
@implementation AZNode
- (id)init
{
   if (!(self = [super init])) return nil;
	_contentObject = NSMA.new;
	return self;
}
//- (NSString*) description {  return [self.propertyNames reduce:@"" withBlock:^id(id sum, id obj) { return [sum withString:$(@"\n%@...%@", obj, [self vFK:obj])];}]; }
- (AZNodeProtocolKeyPaths) keyPaths { return AZNodeProtocolKeyPathsMake(@"keyValue", @"valueValue", @"contentObject"); }
- (void) addChild:(id<AtoZNodeProtocol>)c { [self.contentObject addObject:c]; }
@end


//@interface NSObject (AtoZNodeProtocolPrivate)
//@property (readonly) NSA* azChildren;
//@property (readonly) id azValue, azKey;
//@end
//@implementation  NSObject (AtoZNodeProtocolPrivate)
//-      (NSA*) azChildren 			{  return [self vFK:(AZNODEPRO self).keyPaths.childrenPath]; 	}
//-        (id) azValue 				{  return [self vFK:(AZNODEPRO self).keyPaths.valuePath]; 		}
//-      	(id) azKey 					{  return [self vFK:(AZNODEPRO self).keyPaths.keyPath]; 			}
//@end
@concreteprotocol  (AtoZNodeProtocol) //NSObject (AtoZNodeProtocol)

+ (instancetype) instanceInNode:(id)p {
	id newone = [self.class new];
	[newone setAssociatedValue:p forKey:@"nodeParent" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	return newone;
}
- (void) setNodeState:
  (NSCellStateValue)s 			{ [self respondsToSelector:_cmd]	 ? [self setInteger:s forKey:@"nodeState"] : [self setAssociatedValue:@(s) forKey:@"nodeState"]; }
- (NSCellStateValue)cellState {
	return [self respondsToSelector:_cmd] ? [[self vFK:@"nodeState"]iV]
													  : [[self associatedValueForKey:@"nodeState" orSetTo:@(NSOffState)]iV];
}
- (void) dlog  					{
	fprintf(stderr, "%s", $(@"AZNode v:%@ k:%@ i:%ld max:%ld ch:%ld leaf:%@ node:%@ p:%@\n"
									 "KPS: 	v:%@ k:%@ c:%@\n",
	self.value, self.key, self.siblingIndex, self.siblingIndexMax, self.numberOfChildren,
	StringFromBOOL(self.isaLeaf), StringFromBOOL(self.isaNode), self.parent, self.keyPaths.valuePath, self.keyPaths.keyPath, self.keyPaths.childrenPath).UTF8String);
}
- (NSA*) children					{ return [self vFK:self.keyPaths.childrenPath];}
- (void) setValue:(id)v    	{ [self setValue:v forKey:self.keyPaths.valuePath]; }
-   (id) value             	{ return [self vFK:self.keyPaths.valuePath]; }
-   (id) key              		{ return [self vFK:self.keyPaths.keyPath]; }
- (void) setKey:(id)k      	{  [self setValue:k 	forKey:self.keyPaths.keyPath]; 	}
- (BOOL) isaNode 					{ return [self implementsProtocol:@"AtoZNodeProtocol"]; 	}
- (BOOL) isaRoot 					{ return [self parent] == nil; }
- (void) addChild:(id)c 		{ [c setAssociatedValue:self forKey:@"nodeParent"]; NSAssert([self respondsToSelector:@selector(addChild:)] == YES, @"You must implement \"addChild:\"!"); [self addChild:c]; }
- (AZNodeProtocolKeyPaths) keyPaths {}
- AZNODEPRO parent 				{ return [self hasAssociatedValueForKey:@"nodeParent"] ?
	
	(AZNODEPRO objc_getAssociatedObject(self, (__bridge const void*)@"nodeParent")) : nil;
}
- (NSA*) allSiblings 			{ return [self.parent.children arrayWithoutObject:self]; 					}
- (BOOL) isaLeaf					{ if (!self.isaNode) return NO; else return self.numberOfChildren == 0; }
- (NSA*) allDescendants			{
	
	// declare a __block variable to use inside the block itself for its recursive phase.
	if (!self.isaNode) return nil;
	NSA* __block (^enumerateAndAdd_recurse)(NSA*);	// then define the block, blow
	NSA*         (^enumerateAndAdd)			 (NSA*) = ^(NSA*kids){ // looks like calling another block, but not really.
		NSMA  *allDs = NSMA.new;	for (NSO<AtoZNodeProtocol>*k in kids) { 	 [allDs addObject:k];
		if (!k.isaLeaf)  [allDs addObjectsFromArray:enumerateAndAdd_recurse(k.children)]; }return allDs;
	};	// kickstart the block	
	enumerateAndAdd_recurse = enumerateAndAdd; // initialize the alias
   return enumerateAndAdd(self.children); // starts the block
}
-   (id) expanded 				{  AZMethod m = [self.class implementationOfSelector:@selector(expanded:)];

	if 		(m == AZMethodAuthor  ||
				 m == AZMethodInherits ) return objc_getAssociatedObject(self, (__bridge const void*)@"nodeExpanded");
	else if 	(m == AZMethodOverrider) return [self valueForKey:@"expanded"];
	else if 	(m == AZMethodNotFound ) return nil; return nil;
}
- (void) setExpanded:(id)e	 	{ AZMethod m = [self.class implementationOfSelector:@selector(e:)];
	if 	  (m == AZMethodAuthor || m == AZMethodInherits) return objc_setAssociatedObject(self, (__bridge const void*)@"nodeExpanded", e, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	else if (m == AZMethodOverrider)  [self setValue:e forKey:@"expanded"];
}
- (NSI) siblingIndex 			{ return self.isaRoot ? -1 : [self.parent.children indexOfObject:self]; }
- (NSI) siblingIndexMax			{ return self.isaRoot ? -1 : self.parent.numberOfChildren; 	}
- (NSI) numberOfChildren 		{ return self.isaLeaf ? -1 : self.children.count; 				}
@end

//	if (!self.isaNode || ![c isaNode]) return; [[self vFK:(AZNODEPRO self).keyPaths.childrenPath] addObject:c];
//	objc_setAssociatedObject(c, (__bridge const void *)@"nodeParent", self, OBJC_ASSOCIATION_ASSIGN); }


//@interface NSCoder (AZNodeProtocolKeyPaths)
//- (struct AZNodeProtocolKeyPaths)decodeKeyPaths:(id)arg1;
//- (void)encodeKeyPaths:(struct AZNodeProtocolKeyPaths)kps;
//@end

@implementation NSObject (ProtocolConformance)

+ (AZMethod) implementationOfSelector:(SEL)selector 			{

	Method method = NULL, superclassMethod = NULL;	 Class superclass;
	if( !(method = class_getClassMethod(self.class, selector)) || !(superclass = class_getSuperclass(self.class))) return AZMethodNotFound;
	return !(superclassMethod = class_getClassMethod(superclass, selector)) ? AZMethodAuthor
															 : method == superclassMethod ? AZMethodInherits : AZMethodOverrider;
}

@end
// 2008-11-07 23:25:43.374 Test[2580:10b] NSObject    - LRMethodNotFound
// 2008-11-07 23:25:43.377 Test[2580:10b] LRModel     - LRMethodImplement
// 2008-11-07 23:25:43.377 Test[2580:10b] AMUser      - LRMethodOverride
// 2008-11-07 23:25:43.379 Test[2580:10b] AMModerator - LRMethodSuper



/*
- (NSS*) valuePath { return @"value"; }
- (NSS*) childrenPath { return @"arrangedObjects"; }
- (NSS*) keyPath { return @"key"; }

@synthesize nChildren = _nChildren,nKey = _nKey, nValue = _nValue, 
				key = _nKey, value = _nValue, children = _nChildren;
- (id) init {

return  (self = super.init) ? [self setArranged:NSMA.new],

[self bind:@"contentArray" toObject:_arranged withKeyPathUsingDefaults:NSValueBinding], [self setKey:nil], [self setValue:nil], self : nil; }

-      (void) addChild:(AZNode*)c		{    [self willChangeValueForKey:@"numberOfChildren"]; 

	[self.nChildren addObject:c]; [c setParent:self];// make sure this child knows its parent	
}
- 					(id) value					{ return 	  _nValue	= [self implementsProtocol:@protocol(AtoZNodeProtocol)] 
																				? (AZNODEPRO self).value : _nValue ?: nil; 
}
- 					(id) key						{ return _nKey 	= [self implementsProtocol:@protocol(AtoZNodeProtocol)] 
																		? ((id<AtoZNodeProtocol>)self).key : _nKey ?: nil; 
}
- (NSMutableArray*) children				{ 	return  _nChildren = [self implementsProtocol:@protocol(AtoZNodeProtocol)] 
																				? [(id <AtoZNodeProtocol>)self children] 
																				: _nChildren ?: NSMutableArray.new;
}
-			    (BOOL) isLeaf					{ return (self.nChildren.count == 0); }
-   (NSArray*) allDescendants		{   // declare a __block variable to use inside the block itself for its recursive phase.
	NSArray* __block (^enumerateAndAdd_recurse)(NSArray*);	// then define the block, blow
	NSArray*         (^enumerateAndAdd)			 (NSArray*) = ^(NSArray*kids){ // looks like calling another block, but not really.
		NSMutableArray  *allDs = NSMutableArray.new;	for (AZNode*k in kids) { 	 [allDs addObject:k];  
		if (!k.isLeaf)  [allDs addObjectsFromArray:enumerateAndAdd_recurse(k.children)]; }return allDs;
	};	// kickstart the block	
	enumerateAndAdd_recurse = enumerateAndAdd; // initialize the alias
   return enumerateAndAdd(self.nChildren); // starts the block
}
- (NSNumber*) index 				{ return @([self.parent.children indexOfObject:self]); }
- (NSNumber*) of 					{ return @(self.parent.children.count); }
- (NSNumber*) countOfChildren 																{ return @(self.children.count); }
-       (void) insertObject:(AZNode*)o inChildrenAtIndex:(NSUInteger)i 			{ NSAssert(o.class == AZNode.class, @"Needs to be a node!");
	[[self mutableArrayValueForKey:@"children"] addObject:o]; o.parent = self;
}
-    (AZNode*) objectInChildrenAtIndex:						(NSUInteger)i 			{  return self.children[i]; }
-       (void) removeObjectFromChildrenAtIndex:(NSUInteger)i	 					{ 

	[[self mutableArrayValueForKey:@"children" ]removeObjectAtIndex:i];   
}
- 		  (void) replaceObjectInChildrenAtIndex: (NSUInteger)i withObject:(id)o { NSAssert([o class] == AZNode.class, @"must be node!");
	[_nChildren replaceObjectAtIndex:i withObject:o]; [o setParent:self];
}
-  (NSString*) debugDescription 	{ return 				[NSString stringWithFormat:@"nodeClass:%@ nKey:%@ nValue:%@ childCt:%ld", 
																			NSStringFromClass(self.class), self.key, self.value, self.children.count]; 
}
- (void) insertChild: (AZNode*)o atIndex:(NSUInteger)i { [self insertObject:o inChildrenAtIndex:i]; }
*/

/*
-       (void) insertObject:(AZNode*)o inChildrenAtIndex:(NSUInteger)i 			{ NSAssert(o.class == AZNode.class, @"Needs to be a node!");
	[[self mutableArrayValueForKey:@"children"] addObject:o]; o.parent = self;
}
-    (AZNode*) objectInChildrenAtIndex:						(NSUInteger)i 			{  return self.children[i]; }
-       (void) removeObjectFromChildrenAtIndex:(NSUInteger)i	 					{ 

	[[self mutableArrayValueForKey:@"children" ]removeObjectAtIndex:i];   
}
- 		  (void) replaceObjectInChildrenAtIndex: (NSUInteger)i withObject:(id)o { NSAssert([o class] == AZNode.class, @"must be node!");
	[_nChildren replaceObjectAtIndex:i withObject:o]; [o setParent:self];
}
-  (NSString*) debugDescription 	{ return 				[NSString stringWithFormat:@"nodeClass:%@ nKey:%@ nValue:%@ childCt:%ld", 
																			NSStringFromClass(self.class), self.key, self.value, self.children.count]; 
}

- (void) insertChild: (AZNode*)o atIndex:(NSUInteger)i { [self insertObject:o inChildrenAtIndex:i]; }

- (void) setChildren:(NSMutableArray *)children { [self set]
- 					(id) nodeKey				{ return key; }
- 					(id) nodeValue				{ return self.value;	}
- (NSMutableArray*) nodeChildren 		{ return self.children; }

@implementation AZBundle
- (void)forwardInvocation:(NSInvocation *)anInvocation	{
	NSString* theString = NSStringFromSelector(anInvocation.selector);
	SEL newSel = NSSelectorFromString([theString stringByAppendingString:@"azBundle_"]);
    if ([self respondsToSelector:newSel]){
	 	[anInvocation setSelector:newSel];
		[anInvocation invokeWithTarget:self];
	}
	else [super forwardInvocation:anInvocation];
}
-     (NSString*)	bundleTitle 				{	return [self       azBundle_bundleTitle];	}
-     (NSString*) bundleDescription 		{	return [self azBundle_bundleDescription];	}
-      (NSImage*) bundleIcon					{	return [self        azBundle_bundleIcon];	}
-			  (BOOL) open							{	return [self              azBundle_open];	}
-          (void) close 						{			 [self 				 azBundle_close];	}
-          (BOOL) isOpen 						{	return [self 				azBundle_isOpen];	}
- 			  (BOOL) select						{	return [self 				azBundle_select];	}
@end

@implementation NSObject (AtoZBundleProtocol)

-   (BOOL) azBundle_open					{ return [self.azBundle_windowController showWindow:self], YES;	}
-   (void) azBundle_close  				{ [self.azBundle_windowController close];									}
-   (BOOL) azBundle_isOpen 				{ return self.azBundle_windowController.isWindowLoaded && 
																self.azBundle_windowController.window. isVisible;			}
-   (BOOL) azBundle_select 				{ return self.azBundle_isOpen ? 
															  [self.azBundle_windowController.window makeKeyWindow], YES : NO; 	 		}
-   (NSS*) azBundle_bundleTitle 			{	return [CLSSBNDL localizedStringForKey:@"BundleTitle" value:@"" table:nil];			}
-   (NSS*) azBundle_bundleDescription 	{	return [CLSSBNDL localizedStringForKey:@"BundleDescription" value:@"" table:nil] 
															 ?: [CLSSBNDL.infoDictionary objectForKey:@"description"]; 	}
-  (NSWC*) azBundle_windowController 	{	return [self associatedValueForKey:@"azBundle_windowController" orSetTo:[[NSClassFromString([AZCLSSTR withString:@"WindowController"]) alloc] initWithWindowNibName:AZCLSSTR] policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
- (NSIMG*) azBundle_bundleIcon			{	NSString *resource;
	NSBundle *b = CLSSBNDL;
	NSString * icns = [b objectForInfoDictionaryKey:@"CFBundleIconFile"];  NSLog(@"Looking in Bundle: %@ for icns: %@",b, icns);
	return (resource = [CLSSBNDL pathForImageResource:icns]) ?
		[NSImage.alloc initWithContentsOfFile:resource] : [NSImage imageNamed:@"1"];					
}
@end

//	NSLog(@"Using class:%@'s protocol %@ to obtain value...",  NSStringFromClass(self.class), NSStringFromProtocol( @protocol (AtoZNodeProtocol))); return _value = ; [(id<AtoZNodeProtocol>)self nodeValue]; 	if (aVal) {   aVal; NSLog(@"Success, got %@", _value); } 	else { NSLog(@"FAILS!");	}

-        (id) init										{

	if (self != super.init ) return nil;
	[self bind:@"numberOfChildren" toObject:self withKeyPath:@"children" transform:^id(id value) {
		 NSLog(@"value: %@", value);
		 return @([value count]);
	}];
	_children = NSMA.new;
	return self;
	//	Add observer
//    return self = [super init] ? [self setParent:nil], [self setChildren:NSMutableArray.new], [self setColumnValues:NSDictionary.new], 
//	 [self addObserver:self forKeyPath:@"children" options:0 context:@"context"], self : nil;
}
- (NSString*) description								{
    return [NSString stringWithFormat:@"%@: %@ parent object;\n\tvalues: \"%@\"\n\tchildren: \"%@\"", [super description], self.parent ? @"Has":@"No", self.columnValues, self.children];
}
-        (id) initWithCoder:  		(NSCoder*)c	{	     return self = [super init] ?
	[self setChildren:		[c decodeObjectForKey:    @"children"]],
	[self setColumnValues:	[c decodeObjectForKey:@"columnValues"]],
	[self setParent:			[c decodeObjectForKey:		  @"parent"]], self : nil;
}
-      (void) encodeWithCoder:		(NSCoder*)c	{
    [c encodeObject:self.children 				forKey:	  @"children"];
    [c encodeObject:self.columnValues 			forKey:@"columnValues"];
    [c encodeConditionalObject:self.parent 	forKey:		 @"parent"];
}
-        (id) copyWithZone:	       (NSZone*)z	{	id node;
	return node = [self.class.alloc init] ?
	// deep copy the array of children, since the copy could modify the original
	[node setChildren:self.children.mutableCopy],
	[node setColumnValues:self.columnValues], node : nil;

}
- 			(id) valueForUndefinedKey:(NSString*)k	{ 	return [self.columnValues valueForKey:k]; }
-      (void) setValue:(id)value 
       forUndefinedKey:(NSString*)key				{   NSParameterAssert(nil != value);  NSParameterAssert(nil != key);
    [self.columnValues setValue:value forKey:key];
}

- 			(id) childAtIndex:(NSUInteger)x			{ return self.children[x];	}
-      (void) removeChild:(AZNode*)z				{   [z setParent:nil];    // make sure to orphan this child
																	 [[self mutableArrayValueForKey:@"children"] removeObject:z];
}
-      (void) setChildren:(NSArray*)c				{
    
	 [self setChildren:c]; [_children makeObjectsPerformSelector:@selector(setParent:) withObject:self];
}
-      (void) sortChildrenUsingFunction:(NSComparisonResult (*)(id, id, void *))compare context:(void *)context	{
    [_children sortUsingFunction:compare context:context];
}
-  (NSArray*) children { return [self mutableArrayValueForKey:@"children"]; }
- (NSUInteger)numberOfChildren { return [_children count]; }
-     (BOOL)isLeaf { return [self numberOfChildren] > 0 ? NO : YES; }
-     (void) observeValueForKeyPath:(NSString*)k ofObject:(id)o change:(NSDictionary*)c context:(void*)x {       
    //View change
    NSLog(@"it changed: %@ %@  %@", k, o, c);
}    
*/
