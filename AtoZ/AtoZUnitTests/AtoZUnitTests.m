

@interface NSAlpha : AtoZ
@end
@interface NSBravo : AtoZ
@end
@interface NSCharlie : NSBravo
@end

@interface AtoZTestCase : XCTestCase
- (void)runTests;
@end

@interface AtoZTest : XCTestCase
- (NSString *)stringFromClass;
@end

@implementation AtoZTestCase

- (void)runTests	{
    unsigned int count;
    Method *methods 		= class_copyMethodList([self class], &count);
    for ( int i = 0;  i < count; i++ )	{
        
		  SEL selector = method_getName( (Method) methods[i] );
        NSString *name = NSStringFromSelector(selector);
        if ([name hasPrefix:@"test"])	 //avoid arc warning by using c runtime
            objc_msgSend(self, selector);
        NSLog(@"Test '%@' completed successfuly", [name substringFromIndex:4]);
    }
}

- (void)testStringFromClass	{
	XCTAssertEqualObjects([[[NSObject alloc] init] stringFromClass], @"NSObject");

	// NSString deploys a class clustering architecture. The actual class is an
	// implementation-specific sub-class or compatible class, depending on what
	// kind of string, and presumably what version of Cocoa and on what platform
	// since the exact underlying class might change. Be prepared for test
	// breakage.
	XCTAssertEqualObjects([@"" stringFromClass], @"__NSCFConstantString");

	// This is freaky. You would not expect this to work. But it does; classes
	// are also objects. Invoking an instance method on a class: it compiles and
	// runs! You would expect the compiler to baulk, but no.
	XCTAssertEqualObjects([NSObject stringFromClass], @"NSObject");
}
- (void)setUp						{
	[super setUp];
	id a,b,c,d;
	a = [AtoZ sharedInstance];
	b = [AtoZ instanceWithObject:self];
	c = [AtoZ instance];
	d = (AtoZ*)a;
	NSLog(@"%d=%d=%d", a=[AtoZ sharedInstance], 	[AtoZ sharedInstance], [AtoZ instanceWithObject:self]  );
	NSLog(@"%d=%d=%d", b=[NSAlpha sharedInstance],	 [NSAlpha instance],	 [NSAlpha instance]);
	NSLog(@"%d=%d=%d", c=[NSBravo instance],	 [NSBravo sharedInstance],	 [NSBravo sharedInstance]);
	NSLog(@"%d=%d=%d", d=[NSCharlie instance],   [NSCharlie instanceWithObject:@"wghay6e"],   [NSCharlie sharedInstance]);
	NSLog(@"%d != %d != %d != %d", a, b, c, d);
	// Set-up code here.
}
- (void)tearDown		{	[super tearDown]; 	}
- (void)testExample	{		XCTFail(@"Unit tests are not implemented yet in AtoZTests");	}
@end

@implementation NSAlpha
@end
@implementation NSBravo
@end
@implementation NSCharlie
@end


@interface NSObject (UnitTests)
//+ (void) runInstanceTests;
//+ (void) runClassTests;
- (NSArray*) tests;
@end

@interface AtoZUnitTests : NSObject

@end


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
