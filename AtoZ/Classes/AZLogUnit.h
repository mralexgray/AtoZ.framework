
#import "AtoZ.h"
#import <SenTestingKit/SenTestingKit.h>
#import "GDataXMLNode.h"

@interface AZLogUnit : NSObject

@property (strong) GDataXMLDocument *document;
@property (strong) GDataXMLElement 	*suitesElement,
												*currentSuiteElement,
												*currentCaseElement;
- (void)writeResultFile;

@end
