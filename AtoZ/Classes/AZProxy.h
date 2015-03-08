


#define NSMSIG	NSMethodSignature
#define NSINV		NSInvocation


// "Weak proxy" to avoid retain loops.
// Adapted from http://stackoverflow.com/a/13921278/1525473
// Adapted from "Pijecta" neat js canvas app.

@interface	AZNonRetainingProxy : NSObject

@property (weak)						 id   target;

+ (INST) proxyWithTarget:(id)target;				@end


@interface							AZProxy : NSProxy

+ (INST) proxyForObjects:(NSA*)objs;				@end



