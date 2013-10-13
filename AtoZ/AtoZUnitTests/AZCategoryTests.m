

#import <XCTest/XCTest.h>

@interface AZCategoryTests : XCTestCase

@end

@implementation AZCategoryTests


- (void) someTest {

	[NSS randomUrabanDBlock:^(AZDefinition *d) {

		[AZTalker say:[d.word withString:d.definition]];
		XX(d.word);
		XX(d.definition);
		XX(d.propertyNamesAndTypes);
	 	[AZGoogleImages searchGoogleImages:d.word withBlock:^(NSA*imageURLs){
			[imageURLs each:^(id u) { 		[[NSImage imageFromURL:u] openInPreview];			}];
			[AZSHAREDAPP performSelector:@selector(terminate:) withObject:nil afterDelay:6];
		}];
	}];
}
@end
