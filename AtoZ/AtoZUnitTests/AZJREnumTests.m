//
//  JREnumTests.m
//  AtoZ
//
//  Created by Alex Gray on 2/19/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AtoZ/AtoZ.h>

JREnumDeclare(SplitEnumWith1ConstantSansExplicitValues, SplitEnumWith1ConstantSansExplicitValues_Constant1);
JREnumDeclare(SplitEnumWith1ConstantWithExplicitValues, SplitEnumWith1ConstantWithExplicitValues_Constant1 = 42);
JREnumDeclare(TestClassState,   TestClassState_Closed,
                                TestClassState_Opening,
                                TestClassState_Open,
                                TestClassState_Closing  );


JREnumDefine(SplitEnumWith1ConstantSansExplicitValues);
JREnumDefine(SplitEnumWith1ConstantWithExplicitValues);
JREnumDefine(TestClassState);

JREnum(EnumWith1ConstantSansExplicitValues, EnumWith1ConstantSansExplicitValues_Constant1);
JREnum(EnumWith1ConstantWithExplicitValues, EnumWith1ConstantWithExplicitValues_Constant1 = 42);

AZTESTCASE(AZJREnumTests)  {    EnumWith1ConstantSansExplicitValues       a;
                              SplitEnumWith1ConstantSansExplicitValues  b;
                              SplitEnumWith1ConstantWithExplicitValues  c; }

- (void) setUp { [super setUp]; a = 0; b = 0; c = 42; }

- (void) testExample {

  XCTAssertTrue(EnumWith1ConstantSansExplicitValuesByLabel().count == 1, @"");
  XCTAssertEqualObjects([EnumWith1ConstantSansExplicitValuesByLabel() objectForKey:@"EnumWith1ConstantSansExplicitValues_Constant1"], @0, @"");

  XCTAssertTrue(EnumWith1ConstantSansExplicitValuesByValue().count == 1, @"");
  XCTAssertEqualObjects(EnumWith1ConstantSansExplicitValuesByValue()[@0], @"EnumWith1ConstantSansExplicitValues_Constant1", @"");


  XCTAssertTrue(EnumWith1ConstantSansExplicitValues_Constant1 == a, @"");
  XCTAssertTrue( [@"EnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)], @"");
  XCTAssertTrue( EnumWith1ConstantSansExplicitValuesFromString(EnumWith1ConstantSansExplicitValuesToString(EnumWith1ConstantSansExplicitValues_Constant1), &a), @"");
  XCTAssertTrue(EnumWith1ConstantSansExplicitValues_Constant1 == a, @"");

  a++;
  XCTAssertTrue([@"<unknown EnumWith1ConstantSansExplicitValues: 1>" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)], @"");
  XCTAssertTrue(!EnumWith1ConstantSansExplicitValuesFromString(@"foo", &a), @"");

}
- (void) splitEnumTests {

  XCTAssertTrue(SplitEnumWith1ConstantSansExplicitValues_Constant1 == b, @"");
  XCTAssertTrue([@"SplitEnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(b)], @"");
  XCTAssertTrue(SplitEnumWith1ConstantSansExplicitValuesFromString(SplitEnumWith1ConstantSansExplicitValuesToString(SplitEnumWith1ConstantSansExplicitValues_Constant1), &b), @"");
  XCTAssertTrue(SplitEnumWith1ConstantSansExplicitValues_Constant1 == b, @"");
  b++;
  XCTAssertTrue([@"<unknown SplitEnumWith1ConstantSansExplicitValues: 1>" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(b)], @"");
  XCTAssertTrue(!SplitEnumWith1ConstantSansExplicitValuesFromString(@"foo", &b), @"");
}
- (void) testExplicit {

  XCTAssertTrue(SplitEnumWith1ConstantWithExplicitValues_Constant1 == c, @"");
  XCTAssertTrue([@"SplitEnumWith1ConstantWithExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(c)], @"");
  XCTAssertTrue(SplitEnumWith1ConstantWithExplicitValuesFromString(SplitEnumWith1ConstantWithExplicitValuesToString(SplitEnumWith1ConstantWithExplicitValues_Constant1), &c), @"");
  XCTAssertTrue(SplitEnumWith1ConstantWithExplicitValues_Constant1 == c, @"");
  c++;
  XCTAssertTrue([@"<unknown SplitEnumWith1ConstantWithExplicitValues: 43>" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(c)], @"");;
  XCTAssertTrue(!SplitEnumWith1ConstantWithExplicitValuesFromString(@"foo", &c), @"");
}


/* reference 

JREnumDeclare( AZAlign, AZAlignUnset     		= 0x00000000,
                        AZAlignLeft         = 0x00000001,
                        AZAlignRight      	= 0x00000010,
                        AZAlignTop	        = 0x00000100,
                        AZAlignBottom       = 0x00001000,
                        AZAlignTopLeft      = 0x00000101,
                        AZAlignBottomLeft		= 0x00001001,
                        AZAlignTopRight   	= 0x00000110,
                        AZAlignBottomRight  = 0x00001010,
                        AZAlignCenter    		= 0x11110000,
                        AZAlignOutside  		= 0x00001111,
                        AZAlignAutomatic		= 0x11111111, );

*/

- (void) testOptions { AZA unset;

  XCTAssertEqual( unset, AZUnset,                  @"uninitialized Alignments should be Unset!");
  XCTAssertEqual( unset,  (AZA)NO,                  @"aka NO");
  XCTAssertEqual( AZAlignByValue().count, (NSUI)15, @"Should be 12 positions");
  XCTAssertTrue  ( AZAlignTop | AZAlignLeft                                == AZAlignTopLeft,    @"Combining Bitmasks works");
  XCTAssertTrue  ( AZAlignTop | AZAlignLeft | AZAlignRight | AZAlignBottom == AZAlignCenter,     @"Allsides totals center");
  
//  AZAlignByValue().allKeys.nextObject
  XCTAssertFalse ( AZAlignOutside & (AZAlignTop|AZAlignLeft|AZAlignRight|AZAlignBottom),  @"No sides is outside  ");
  XCTAssertTrue  ( AZAlignTop&AZAlignCenter,   @"Align Cneter includes top");

}
//- (void) testDecoding { AZA zTop = AZTop;
//
//  STAssertTrue( AZAIsVertical ), <#description, ...#>
//
//}

@end
