
#import "AtoZ.h"
#import <XCTest/XCTest.h>

@class GDataXMLDocument;
@interface AZLogUnit : NSObject

@property (strong) GDataXMLDocument *document;
@property (strong) GDataXMLElement 	*suitesElement,
												*currentSuiteElement,
												*currentCaseElement;
- (void) riteResultFile;

@end
