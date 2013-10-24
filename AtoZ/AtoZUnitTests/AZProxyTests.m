
#import <XCTest/XCTest.h>
#import <AtoZ/AtoZ.h>

@interface AZProxyTests : XCTestCase
@property id proxy;
@end

@implementation AZProxyTests

- (void)setUp { [super setUp];

	// Create an empty mutable string, which will be one of the real objects for the proxy. Create an empty mutable array, which will be the other real object for the proxy. Create a proxy to wrap the real objects.  This is rather artificial for the purposes of this example -- you'd rarely have a single proxy covering two objects.  But it is possible.  Note that we can't use appendFormat:, because vararg methods cannot be forwarded!

	_proxy = [AZProxy proxyForObjects:@[NSMutableArray.new,NSMutableString.new]];
	XCTAssertNotNil(_proxy, @"Shouldn't be nil");
   [_proxy appendString:@"This "];
	[_proxy appendString:@"is "];
	[_proxy addObject:@[@"This is a test!"]];
	[_proxy appendString:@"a "];
	[_proxy appendString:@"test!"];
}
- (void) tearDown { [super tearDown]; _proxy = nil; }

- (void) testCorrectMethodsGetCalled	{

	XCTAssert(1 == [_proxy count], @"count should be 1, it is: %lu", [_proxy count]);
	XCTAssertEqualObjects(_proxy[0][0], @"This is a test!", @"Appending failed, got: '%@'", _proxy);
	//	NSLog(@"Appending successful. Proxy:%@", _proxy);
	
}
- (void)testExample
{
	XCTFail(@"Unit tests are not implemented yet in AtoZUnitTests");
}

@end
