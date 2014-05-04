
#import <SenTestingKit/SenTestingKit.h>
#import <AtoZ/BaseModel.h>
#import <AtoZ/BaseModel+AtoZ.h>

@interface TestModel : BaseModel
@end
@implementation TestModel
@end


@interface AZBaseModelTests : SenTestCase {
@private
	TestModel *sharedOne, 	*sharedTwo;
	TestModel *one, 			*two;
}
@end
@implementation AZBaseModelTests

- (void) testNothing {
}

- (void) setUp
{
	[super setUp];
	sharedOne = TestModel.sharedInstance;
}

- (void) testSharedSingletonness
{
	sharedTwo = TestModel.sharedInstance;
	STAssertTrue (sharedOne == sharedTwo, @"setting a different instance %@ as the prvious sharedInstance %@ should point to itself", sharedTwo, sharedOne);
}

//- (void) tearDown
//{
    // Put teardown code here; it will be run once, after the last test case.

//	[NSThread sleepForTimeInterval:1.0];
//[super tearDown];
//}

//- (void) testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
