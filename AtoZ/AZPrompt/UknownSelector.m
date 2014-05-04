#include <Foundation/Foundation.h>
 
// The methods need to be declared somewhere
@interface Dummy : NSObject	- (void) rill;	- (void) ing:(NSString *)s;	@end
 
@interface Example : NSObject	- (void) oo;	- (void) ar;						@end
 
@implementation Example
- (void) oo {  NSLog(@"this is foo");	}
- (void) ar {  NSLog(@"this is bar");	}

- (void) orwardInvocation:(NSInvocation*)inv {

  NSLog(@"tried to handle unknown method %@", NSStringFromSelector([inv selector]));
  NSUInteger n = inv.methodSignature.numberOfArguments;

  for (int i = 0; i < n - 2; i++) {   // first two arguments are the object and selector
    id __unsafe_unretained arg; // we assume that all arguments are objects
    [inv getArgument:&arg atIndex: i + 2];
    NSLog(@"argument #%u: %@", i, arg);
  }
}
// forwardInvocation: does not work without methodSignatureForSelector:
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

  NSUInteger numArgs = [NSStringFromSelector(aSelector) componentsSeparatedByString:@":"].count - 1;
  // we assume that all arguments are objects The type encoding is "v@:@@@...", where "v" is the return type, void
  // "@" is the receiver, object type; ":" is the selector of the current method; and each "@" after corresponds to an object argument
  return [NSMethodSignature signatureWithObjCTypes:
          [[@"v@:" stringByPaddingToLength:numArgs+3 withString:@"@" startingAtIndex:0] UTF8String]];
}
@end

//id dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"John", @"name",  [NSNumber numberWithInt:47], @"age",  nil]; 
//... that you can get and set on with valueForKey: and setValue:forKey:. As it's a bit verbose, let's use forward invocation to masquerade accessors :

// Call non existent getter - (id)age NSLog(@"age=%@", [dict age]); // Set a new age using a non existent setter - (void) setAge:(id)newAge [dict setAge:[NSNumber numberWithInt:48]]; 
//To accomplish this, we'll add forward invocation to NSDictionary to redirect zero parameter calls to call valueForKey: and one parameter calls (starting with set) to setValue:forKey:.

@implementation NSDictionary (ForwardInvocation)
// Determine if we can handle the unknown selector sel
- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel {

	id	stringSelector = NSStringFromSelector(sel);
	NSUInteger	parameterCount = [[stringSelector componentsSeparatedByString:@":"] count] - 1;

	if (parameterCount == 0) 	// Zero argument, forward to valueForKey:
		return [super methodSignatureForSelector:@selector(valueForKey:)];

	if (parameterCount == 1 && [stringSelector hasPrefix:@"set"]) // 1 arg starting with set, forward to sV:fK:
		return [super methodSignatureForSelector:@selector(setValue:forKey:)];

	return nil;// Discard the call
}

- (void) orwardInvocation:(NSInvocation *)invocation {   // Call valueForKey: and setValue:forKey:

	id	stringSelector = NSStringFromSelector([invocation selector]);
	NSUInteger	parameterCount = [[stringSelector componentsSeparatedByString:@":"] count]-1;

	if (parameterCount == 0) {   	// Forwarding to valueForKey:
		id value = [self valueForKey:NSStringFromSelector([invocation selector])];
		[invocation setReturnValue:&value];
	}
	if (parameterCount == 1) { id value;// Forwarding to setValue:forKey:
	// The first parameter to an ObjC method is the third argument
	// ObjC methods are C functions taking instance and selector as their first two arguments

	[invocation getArgument:&value atIndex:2];

	// Get key name by converting setMyValue: to myValue
	id key = [NSString stringWithFormat:@"%@%@",  [[stringSelector substringWithRange:NSMakeRange(3, 1)] lowercaseString], [stringSelector substringWithRange:NSMakeRange(4, [stringSelector length]-5)]];
	// Set
		[self setValue:value forKey:key];
	}


}
@end
#import <AtoZ/AtoZ.h>
AZINTERFACE(NSO,DYObj)
SYNTHESIZE_ASC_OBJ_LAZY_BLOCK(<#getterName#>, <#class#>, <#block#>)
AZPROPERTY(NSMA,STR,*sexy);
@end
@implementation DYObj

@end
#include <Foundation/Foundation.h>

#define PERFORM(x) performSelector:NSSelectorFromString(@#x)

int main(int argc, char *argv[], char**argp ){	@autoreleasepool {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

	NSMutableDictionary *d = @{@"apple":@"bottomJeans"}.mutableCopy;

	NSLog(@"%@", [d PERFORM(apple)]);

    id example = Example.new;
 
    [example fo 8888o];          // prints "this is foo"
    [example bar];          // prints "this is bar"
    [example grill];        // prints "tried to handle unknown method grill"
    [example ding:@"dong"]; // prints "tried to handle unknown method ding:"
                            // prints "argument #0: dong"
	 [example performSelector:NSSelectorFromString(@"ding:") withObject:@"donkeycocngcock"];
	id x = [example performSelector:NSSelectorFromString(@"hugeVageen")];
	NSLog(@"x = %@", x);
#pragma clang diagnostic pop
}	return EXIT_SUCCESS;	}


