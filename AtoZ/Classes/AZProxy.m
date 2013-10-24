//
//  AZProxy.m
//  AtoZ
//
//  Created by Alex Gray on 10/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZProxy.h"

@implementation AZProxy

-           (NSArray*) objects 																{ return objc_getAssociatedObject(self, _cmd); }
+       (instancetype) proxyForObjects:(NSArray*)objs 								{ AZProxy *p = [super alloc];
	
	return objc_setAssociatedObject(p,@selector(objects),objs,OBJC_ASSOCIATION_RETAIN_NONATOMIC), DEBUGLOG(@"%@",p.objects), p;
}
- (NSMethodSignature*) methodSignatureForSelectorFromObjectArray:(SEL)sel 		{ NSMethodSignature *sig = nil;

	for (id x in self.objects)  if ((sig = [x methodSignatureForSelector:sel])) return sig; return nil;
}
- (void)forwardInvocationToObjectArray:(NSInvocation*)inv 							{ // Invoke the invocation on whichever real object had a signature for it.

	[inv invokeWithTarget:[self objectForMethodSignature:[self methodSignatureForSelectorFromObjectArray:inv.selector] forSelector:inv.selector]];
}
- (id) objectForMethodSignature:(NSMethodSignature*)sig forSelector:(SEL)sel 	{ 

	DEBUGBUFFER(@"looking for sig:%s SEL:%@", sig.methodReturnType,NSStringFromSelector(sel));
	for (id x in self.objects) if (sig == [x methodSignatureForSelector:sel]) return DEBUGLOG(@"found a responder.. a:%@",NSStringFromClass([x class])), x; return nil;
}
- (BOOL)objectsRespondToSelector:(SEL)sel {  

	for (id x in self.objects) if ([[x class] instancesRespondToSelector:sel]) 
			return DEBUGLOG(@"%@ responds to:%@", x, NSStringFromSelector(sel)), YES;	
	return NO; 
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
/*
	The compiler knows the types at the call site but unfortunately doesn't leave them around for us to use, so we must poke around and find the types so that the invocation can be initialized from the stack frame.
	Here, we ask the two real objects, realObject1 first, for their method signatures, since we'll be forwarding the message to one or the other of them in -forwardInvocation:.  If realObject1 returns a non-nil method signature, we use that, so in effect it has priority. 
*/
	return  [self methodSignatureForSelectorFromObjectArray:sel];
}
- (void)forwardInvocation:(NSInvocation *)inv { 	// Invoke the invocation on whichever real object had a signature for it.

	[self forwardInvocationToObjectArray:inv];
}

- (BOOL)respondsToSelector:(SEL)sel {	// Override some of NSProxy's implementations to forward them...

	return [self objectsRespondToSelector:sel];
}

@end
