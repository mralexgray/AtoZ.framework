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

@interface AZCLITests : BaseModel
@property (STRNG,NATOM) NSA* tests, *results;

@end
