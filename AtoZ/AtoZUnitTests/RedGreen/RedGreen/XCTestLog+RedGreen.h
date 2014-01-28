
/**  XCTestLog+RedGreen.h  *//* © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

#import <XCTest/XCTest.h>

#define SHOW_SECONDS 0
#define PRINT_START_FINISH_NOISE 0

@interface XCTestLog (RedGreen)

- (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end
