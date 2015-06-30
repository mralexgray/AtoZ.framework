



@interface AZLogTests : XCTestCase
@end

@implementation AZLogTests

- (void) testrgbColorValues {

	id color = NSColor.blueColor,		 colorRGB = [AZLog rgbColorValues:color],
		string = @"blue",							stringRGB = [AZLog rgbColorValues:string],
		   rgb = @[@0, @0, @255],				   rgbRGB = [AZLog rgbColorValues:rgb];

	XCTAssert([colorRGB isEqualToArray:stringRGB],	@"colorrgb:%@ should equal stringRGB:%@", colorRGB,	 stringRGB);
	XCTAssert([stringRGB isEqualToArray:rgbRGB],			@"colorrgb:%@ should equal rgbRGB:%@",		stringRGB, rgbRGB);
}
- (void) testLogEnv	{		setenv("XCODE_COLORS", "YES", 0);

	XCTAssertEqual(AZLOGSHARED.logEnv, LogEnvXcodeColor,
	@"Xcode should return true, with colors... got %@", LogEnv2Text(AZLOGSHARED.logEnv));
//	setenv("XCODE_COLORS", "NO", 0);
//	XCTAssertEqual(AZLOGSHARED.logEnv, LogEnvXcodeNOColor,
//	@"Xcode with XcodeCOlors off should return LogEnvXcodeNOColor ... got %@", LogEnv2Text(AZLOGSHARED.logEnv)]);

}

- (void) testColorizetring{

	NSA *colorized = [AZLog colorizeAndReturn:@[@"A", @"B", @"C"], RANDOMPAL, nil];
	XCTAssertEqual(colorized.count, 3, @"should return [A,B,C] .. got %@", colorized);

}
@end
