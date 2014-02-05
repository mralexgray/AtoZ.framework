//
//  methodlogging.m
//  AtoZ
//
//  Created by Alex Gray on 7/8/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <AtoZ/AtoZ.h>

@interface SomeClass :NSObject											@end
@implementation SomeClass
- (void)methodA {		// imagine some meaningful actions here
	NSLog(@"Doing important methodA stuff");	}
- (int)methodB {	// imagine some meaningful actions here
	NSLog(@"Doing important methodB stuff");	return 42;}
- (void)methodCWithInt:(int)i {	// imagine some meaningful actions here
	NSLog(@"Doing important methodC stuff");}										@end
@interface LoggingInterceptor :NSObject 								@end
@implementation LoggingInterceptor

static IMP origMethAImp, origMethBImp, origMethCImp;

void methodAIntercept(id self,SEL _cmd) { NSLog(@"Before methodA"); origMethAImp(self, _cmd);	NSLog(@"After methodA");	}
int methodBIntercept	(id self,SEL _cmd) { NSLog(@"Before methodB"); int result=((int(*)(id,SEL))origMethBImp)(self,_cmd); return NSLog(@"After methodB"), result; }
void methodCIntercept(id self,SEL _cmd, int i) { NSLog(@"Before methodC");	origMethCImp(self, _cmd, i);	NSLog(@"After methodC");	}

+ (void)injectInterceptors {
	Method methodA = class_getInstanceMethod([SomeClass class], @selector(methodA));
	Method methodB = class_getInstanceMethod([SomeClass class], @selector(methodB));
	Method methodC = class_getInstanceMethod([SomeClass class], @selector(methodCWithInt:));
	origMethAImp = method_getImplementation(methodA);
	origMethBImp = method_getImplementation(methodB);
	origMethCImp = method_getImplementation(methodC);
	method_setImplementation(methodA, (IMP)methodAIntercept);
	method_setImplementation(methodB, (IMP)methodBIntercept);
	method_setImplementation(methodC, (IMP)methodCIntercept);
}
/*
Before methodA
Doing important methodA stuff
After methodA
Before methodB
Doing important methodB stuff
After methodB
Before methodC
Doing important methodC stuff
After methodC
*/

@end

@interface Driver:NSObject															@end
@implementation Driver
+ (void)performActions {
	SomeClass *someClass = SomeClass.new;
	[[someClass	instanceMethodNames]log];
	[SomeClass addMethodForSelector:@selector(iFarted) typed:"@@:" implementation:^id(id self, SEL _cmd) {
			return NSS.randomDicksonism;
	}];
	[[someClass	instanceMethodNames]log];
	// Now call methods A, B and C
	[someClass methodA];
	int result = [someClass methodB];
	[someClass methodCWithInt:(result * 2)];
}
@end


int main(int argc, char const *argv[])
{
	@autoreleasepool {
		int res;
		setenv("XCODE_COLORS", "NO", &res);
		[Driver performActions];
		[LoggingInterceptor injectInterceptors];

		[Driver performActions];

	}

/* code */
	return 0;
}