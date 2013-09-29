
#import "NSObject+AZBlockObservation.h"

static NSS *AZObserverTrampolineContext = @"AZObserverTrampolineContext";

@interface AZObserverTrampoline : NSObject
AZPROPERTY( id,  					WK,	observee   );
AZPROPERTY( NSS, 					CP, 	*keyPath   );
AZPROPERTY( AZBlockTask, 		CP, 	task       );
AZPROPERTY( NSOQ, 				STR, 	*queue	  );
AZPROPERTY( dispatch_once_t, 	ASS, 	cancelPred );
@end

@implementation AZObserverTrampoline

- (AZObserverTrampoline*) initObservingObject:(id)obj keyPath:(NSS*)kp onQueue:(NSOQ*)q task:(AZBlockTask)tsk {

	return self 				= super.init ?
	_task 						= [tsk copy],
	_keyPath 					= [kp copy],
	_queue 						= q ?: AZSOQ,        // retain];
	_observee 					= obj,
	_cancelPred		 			= 0,
	[_observee addObserver:self forKeyPath:_keyPath options:0 context:(__bridge void*)AZObserverTrampolineContext],
	self : nil;
}
- (void)observeValueForKeyPath:(NSS*)kp ofObject:(id)o change:(NSD*)c context:(void*)x {

	c = [c ?: @{} dictionaryByAddingEntriesFromDictionary:@{@"keyPath":_keyPath.copy}];
	if (x == (__bridge const void*)AZObserverTrampolineContext)
		_queue ? [_queue addOperationWithBlock:^{ _task(o,c); }]
				 : [AZSOQ  addOperationWithBlock:^{ _task(o,c); }];
}
- (void)cancelObservation 	{ dispatch_once(&_cancelPred, ^{	[_observee removeObserver:self forKeyPath:_keyPath]; }); }
- (void)dealloc 				{	[self cancelObservation]; [_task release]; [_keyPath release]; [_queue release]; 		}

@end

static NSS *AZObserverMapKey = @"com.github.mralexgray.observerMap";

static dispatch_queue_t AZObserverMutationQueue = NULL;

static dispatch_queue_t AZObserverMutationQueueCreatingIfNecessary(void) {

	static dispatch_once_t queueCreationPredicate = 0;
	dispatch_once(&queueCreationPredicate, ^{
		AZObserverMutationQueue = dispatch_queue_create("com.github.mralexgray.observerMutationQueue", 0);
	});
	return AZObserverMutationQueue;
}

@interface NSObject ()
@property (readonly) NSMutableArray *azBlockObservationTokens;
@end

@implementation NSObject (AZBlockObservation)
SYNTHESIZE_ASC_OBJ_LAZY(azBlockObservationTokens, NSMutableArray);

-          (void) observeNotificationsUsingBlocks:(NSS*) firstNotificationName, ... 			{

	azva_list_to_nsarray(firstNotificationName, namesAndBlocks);
	NSA* names 			= [namesAndBlocks   subArrayWithMembersOfKind:NSS.class];
	NSA* justBlocks 	= [namesAndBlocks arrayByRemovingObjectsFromArray:names];
	[names eachWithIndex:^(id obj, NSInteger idx){ [self observeName:obj usingBlock:^(NSNOT*n){ ((void(^)(NSNOT*))justBlocks[idx])(n); }]; }];
}
- 			  (NSA*) observeKeyPaths:(NSA*)keyPaths 							 task:(AZBlockTask)task {

	__block NSMutableArray *tokenStore = self.azBlockObservationTokens;
	return [keyPaths map:^id (id obj){
		[tokenStore addObject:[self observeKeyPath:obj onQueue:nil task:task]];
		return tokenStore.lastObject;
}];
}
- (AZBlockToken*) observerKeyPath:(NSS*)keyPath  							 task:(AZBlockTask)task {

	return [self observeKeyPath:keyPath onQueue:nil task:task];
}
- (AZBlockToken*) observeKeyPath:(NSS*)kp task:(AZBlockTask)t { return [self observeKeyPath:kp onQueue:AZSOQ task:t]; }

- (AZBlockToken*) observeKeyPath: (NSS*)keyPath onQueue:(NSOQ *)queue task:(AZBlockTask)task {
	AZBlockToken *token = [NSProcessInfo.processInfo globallyUniqueString];
	dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
		NSMutableDictionary *dict = [self associatedValueForKey:AZObserverMapKey orSetTo:NSMD.new policy:OBJC_ASSOCIATION_RETAIN];
		AZObserverTrampoline *trampoline = [AZObserverTrampoline.alloc initObservingObject:self keyPath:keyPath onQueue:queue task:task];
		dict[token] = trampoline;	//		[trampoline release];
	});
	if (token) [self.azBlockObservationTokens addObject:token];
	return token;
}
- (void) removeObserverTokens { [self.azBlockObservationTokens do:^(id t) { [self removeObserverWithBlockToken:t]; }]; }
- 			  (void) removeObserverWithBlockToken:(AZBlockToken *)token {

	dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
		NSMD *observationDictionary = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
		AZObserverTrampoline *trampoline = observationDictionary[token];
		if (!trampoline) return
			NSLog(@"[NSObject(AZBlockObservation) removeObserverWithBlockToken]: Ignoring attempt to remove non-existent observer on %@ for token %@.", self, token);
		[trampoline cancelObservation];
		[observationDictionary removeObjectForKey:token];
		// Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC.
		if ([observationDictionary count] == 0) objc_setAssociatedObject(self, (__bridge const void *)(AZObserverMapKey), nil, OBJC_ASSOCIATION_RETAIN);
	});
}
@end
