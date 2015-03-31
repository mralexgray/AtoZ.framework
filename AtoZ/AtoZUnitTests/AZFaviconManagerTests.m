

@interface AZFaviconManagerTests : XCTestCase
@end

@implementation AZFaviconManagerTests


- (void) testiconForURL
{

	NSA* urls = NSS.testDomains;
	[urls each:^(id obj) {

		__block NSIMG* testIMG = nil;
		NSS* stopwatchString = $(@"favicon test for:%@", [obj stringValue]);
		[AZStopwatch start:stopwatchString];
		[AZFavIconManager iconForURL:obj downloadHandler:^(NSImage *icon) {

			testIMG = icon;
			XCTAssertNotNil(testIMG, @"should be a valid Image");
			[AZStopwatch stop:stopwatchString];

		}];
	}];
}

@end
