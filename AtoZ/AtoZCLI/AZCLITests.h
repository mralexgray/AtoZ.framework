//
//  AZCLITests.h
//  AtoZ
//
//  Created by Alex Gray on 4/17/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

JREnumDeclare(AZTestCase, AZTestFailed, AZTestPassed, AZTestUnset, AZTestNoFailures);

typedef  void (^AZCLITest)(void);
@interface AZTestNode : BaseModel
//+(NSA*) tests;
//+(NSA*) results;
@end

@interface AZSizerTests : AZTestNode
@end
@interface AZGeometryTests : AZTestNode
@end
@interface AZFavIconTests : AZTestNode
@end
@interface NSImageTests :AZTestNode
@end
