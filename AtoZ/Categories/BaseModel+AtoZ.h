//  BaseModel+AtoZ.h
//  AtoZ
//  Created by Alex Gray on 4/10/13.

#import <objc/runtime.h>

#define BaseModelDidAddNewInstance @"BaseModelDidAddNewInstanceNotification"
#define iClass 	[self class]
#define sharedI 	[[self class] sharedInstance]


void logClassMethods(NSString *className);


typedef void (^KVOLastChangedBlock)( NSS *whatKeyChanged, id whichInstance, id newVal);
typedef void (^KVONewInstanceBlock)( id newInstance );

@interface BaseModel (AtoZ)

- (instancetype) sharedInstance;

/* Shared instance is the object modified after each key change. 
 	After being notified of change to the shared instance, call this to get last modified key of last modified instance */
+ (NSS*)	lastModifiedKey;
+ (INST)	lastModifiedInstance;
+ (void)	setLastModifiedKey:	(NSS*)key instance:(id)object;

+ (void)	setLastChangedBlock:	(KVOLastChangedBlock) lastChangedBlock;
+ (void)	setNewInstanceBlock: (KVONewInstanceBlock) onInitBlock;

+ (NSS*) saveSharedFile;	+ (NSS*) saveFolder;

@property (NATOM,ASS) 	BOOL 	 convertToXML;
-   (id) objectForKeyedSubscript:					(id)  key;
-   (id) objectAtIndexedSubscript:					(NSUI)idx;
- (void) setObject: (id)obj atIndexedSubscript: (NSUI)idx;
- (void) setObject: (id)obj forKeyedSubscript:  (IDCP)key;


@prop_RO NSA *classSiblings;

AZPROPRDO (NSUI, classSiblingIndex);
AZPROPRDO (NSUI, classSiblingIndexMax);

// A readonly accessor that searches forst if methods are defaults collection, then for
AZPROPRDO (NSMA, defaultCollection);

@prop_RO 		NSS 	*uniqueID, *saveFile, *saveFolder;
@end
//+ (NSN*) activeSubclasses;  // Root Class introspection
//+ (NSA*) allClassInstances;

//@property (STR)			NSS*	defaultCollectionKey;
//@prop_RO NSA 	*allClassInstances;//, *superProperties;

//@prop_RO NSN 	*instanceCt, 	*instanceNumber;
//@property (NATOM,ASS) 	BOOL 	defaultCollectionIsMethods;
// Key that maps the "default" cillection backing store.  defaults to @"items".  Settable.


/*
+ (INST)	objectAtIndex:(NSUI)idx;
+ (NSN*) allInstanceCt;
+ (NSN*) instanceCt;
-   (id) valueForUndefinedKey:						(NSS*)key;
+ (NSS*) saveFilePath;

@interface BaseModel ()
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
- (void) orwardInvocation:(NSInvocation*)invocation;  // FIERCE
- (BOOL)respondsToSelector:(SEL)selector;
@end
*/
