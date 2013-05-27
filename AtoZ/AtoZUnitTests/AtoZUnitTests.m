//
//  AtoZUnitTests.m
//  AtoZUnitTests
//
//  Created by Alex Gray on 4/17/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUnitTests.h"
#import <AtoZ/AtoZ.h>

@implementation AtoZUnitTests
/*
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in AtoZUnitTests");
}

- (void)testTestFramework
{
	NSString *string1 = @"test";
	NSString *string2 = @"test";
	STAssertEquals(string1,
						string2,
						@"FAILURE");
	NSUInteger uint_1 = 4;
	NSUInteger uint_2 = 4;
	STAssertEquals(uint_1,
						uint_2,
						@"FAILURE");
}

- (void) rgbColorValues {

	NSS	*stringColor 	= @"red";
//	NSA	*stringResult 	= rgbColorValues(stringColor);
	NSC	*colorColor	 	= RED;
//	NSA	*colorResult	= rgbColorValues(colorColor);
	NSA	*arrayColor 	= @[@1,@0, @0];
//	NSA	*arrayResult 	= rgbColorValues(arrayColor);
//	NSLog(@"rgbColorValues:  string: %@   color: %@  array:  %@", stringResult, colorResult, arrayResult);
}
*/
@end

/*
typedef void (^methodLoop)(id);
methodLoop test = ^(id victim) {

	unsigned int count, i = 0;
	NSString *selString; SEL aSel; __block NSMutableDictionary *results = NSMutableDictionary.new; 
	BOOL isMeta = strcmp("#",@encode(typeof(victim)));
	Method *methods;
	if (isMeta) methods = class_copyMethodList([victim class], &count);
	else methods =class_copyMethodList(objc_getMetaClass(NSStringFromClass([victim class]).UTF8String), &count);	
	for (i;i<count;i++) 
		[selString = NSStringFromSelector(aSel = method_getName(methods[i])) hasPrefix:@"test"] || [selString hasSuffix:@"Test"] ? ^{
			
   		if (!isMeta) {
				NSMethodSignature *sig = [[victim class] instanceMethodSignatureForSelector:aSel];
				const char* c = [sig returnTypeForSelector:aSel];
				if (SameChar(c, "@")) results[selString] = objc_msgSend(victim, aSel);//avoid arc warning by using c runtime
				else objc_msgSend(victim, aSel);//avoid arc warning by using c runtime
			}
			else [@"a".classProxy vFK:NSStringFromClass([victim class])]performString:<#(NSString *)#>
	}() : nil;  
};
*/

@implementation NSObject (UnitTests)

- (NSArray*) tests  { 
	BOOL isMeta = strcmp("#",@encode(typeof(self)));
	NSArray* methods = isMeta ? ((Class)self).classMethods : self.instanceMethodNames;
	return [methods filter:^BOOL(id object) {	return [object hasPrefix:@"test"] || [object hasSuffix:@"Test"];	}];
}


//
//
//   
//	NSString *selString; SEL aSel; __block NSMutableDictionary *results = NSMutableDictionary.new; 
//	for (i;i<count;i++) [selString = NSStringFromSelector(aSel = method_getName(methods[i])) hasPrefix:@"test"] || [selString hasSuffix:@"Test"] ? ^{
//				          
//   			NSMethodSignature *sig = [self instanceMethodSignatureForSelector:aSel];
//				const char* c = [sig returnTypeForSelector:aSel];
//				if (SameChar(c, "@")) results[selString] = objc_msgSend(self, aSel);//avoid arc warning by using c runtime
//				else objc_msgSend(self, aSel);//avoid arc warning by using c runtime
//	}() : nil;  
//	NSLog(@"Test '%@' completed successfuly", results);//[name substringFromIndex:4]);
//}
//
//+ (void)runClassTests;	{
//   unsigned int count, i = 0;
//	Method *methods = 
//	NSString *selString; SEL aSel; __block NSMutableDictionary *results = NSMutableDictionary.new; 
//
//	for (i;i<count;i++) [selString = NSStringFromSelector(aSel = method_getName(methods[i])) hasPrefix:@"test"] || [selString hasSuffix:@"Test"] ? ^{
//				          
//   			NSMethodSignature *sig = [self instanceMethodSignatureForSelector:aSel];
//				const char* c = [sig returnTypeForSelector:aSel];
//				if (SameChar(c, "@")) results[selString] = objc_msgSend(self, aSel);//avoid arc warning by using c runtime
//				else objc_msgSend(self, aSel);//avoid arc warning by using c runtime
//	}() : nil;  
//	NSLog(@"Test '%@' completed successfuly", results);//[name substringFromIndex:4]);
//}
@end