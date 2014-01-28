//
//  AZProxy.m
//  AtoZ
//
//  Created by Alex Gray on 10/22/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZProxy.h"

@implementation																						 AZNonRetainingProxy
+    (INST) proxyWithTarget:						 (id)tgt { id proxy = [self.alloc init]; [proxy setTarget:tgt]; return proxy; }
- (NSMSIG*) methodSignatureForSelector: (SEL)sel { return [_target methodSignatureForSelector:sel]; }
-    (BOOL) respondsToSelector:					(SEL)sel { return [_target respondsToSelector:sel] || [super respondsToSelector:sel];	}
-      (id) forwardingTargetForSelector:(SEL)sel { return _target;	}
-    (void) forwardInvocation:			 (NSINV*)inv { [_target respondsToSelector:inv.selector] ? [inv invokeWithTarget:_target] :	[super forwardInvocation:inv]; }										@end


@implementation																												 AZProxy
-    (NSA*) objects																							{ return objc_getAssociatedObject(self, _cmd); }
+    (INST) proxyForObjects:(NSArray*)objs											{ AZProxy *p = [super alloc];
	
	objc_setAssociatedObject(p,@selector(objects),objs,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	NSLog(@"%@",p.objects);
	return p;
}
-		 (void) forwardInvocationToObjectArray:(NSINV*)inv					{ // Invoke the invocation on whichever real object had a signature for it.

	[inv invokeWithTarget:[self objectForMethodSignature:[self methodSignatureForSelectorFromObjectArray:inv.selector] forSelector:inv.selector]];
}
-    (void) forwardInvocation:						 (NSINV*)inv					{ 	// Invoke the invocation on whichever real object had a signature for it.

	[self forwardInvocationToObjectArray:inv];
}
-		   (id) objectForMethodSignature:(NSMSIG*)sig
												 forSelector:(SEL)sel										{
	NSLog(@"looking for sig:%s SEL:%@", sig.methodReturnType,NSStringFromSelector(sel));
	for (id x in self.objects) if (sig == [x methodSignatureForSelector:sel]) return NSLog(@"found a responder.. a:%@",NSStringFromClass([x class])), x; return nil;
}
-    (BOOL) objectsRespondToSelector:									(SEL)sel	{

	for (id x in self.objects) if ([[x class] instancesRespondToSelector:sel]) 
			return NSLog(@"%@ responds to:%@", x, NSStringFromSelector(sel)), YES;
	return NO; 
}
- (NSMSIG*) methodSignatureForSelector:								(SEL)sel	{
/*
	The compiler knows the types at the call site but unfortunately doesn't leave them around for us to use, so we must poke around and find the types so that the invocation can be initialized from the stack frame.
	Here, we ask the two real objects, realObject1 first, for their method signatures, since we'll be forwarding the message to one or the other of them in -forwardInvocation:.  If realObject1 returns a non-nil method signature, we use that, so in effect it has priority. 
*/
	return  [self methodSignatureForSelectorFromObjectArray:sel];
}
- (NSMSIG*) methodSignatureForSelectorFromObjectArray:(SEL)sel	{ NSMethodSignature *sig = nil;

	for (id x in self.objects)  if ((sig = [x methodSignatureForSelector:sel])) return sig; return nil;
}
-    (BOOL) respondsToSelector:(SEL)sel													{	// Override some of NSProxy's implementations to forward them...

	return [self objectsRespondToSelector:sel];
}			@end

