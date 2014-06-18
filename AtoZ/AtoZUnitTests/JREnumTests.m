//
//  JREnumTests.m
//  AtoZ
//
//  Created by Alex Gray on 2/19/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
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

AZTESTCASE(JREnumTests)  {    EnumWith1ConstantSansExplicitValues       a;
                              SplitEnumWith1ConstantSansExplicitValues  b;
                              SplitEnumWith1ConstantWithExplicitValues  c; }

- (void) setUp { [super setUp]; a = 0; b = 0; c = 42; }

- (void) testExample {

  STAssertTrue(EnumWith1ConstantSansExplicitValuesByLabel().count == 1, @"");
  STAssertEqualObjects([EnumWith1ConstantSansExplicitValuesByLabel() objectForKey:@"EnumWith1ConstantSansExplicitValues_Constant1"], @0, @"");

  STAssertTrue(EnumWith1ConstantSansExplicitValuesByValue().count == 1, @"");
  STAssertEqualObjects(EnumWith1ConstantSansExplicitValuesByValue()[@0], @"EnumWith1ConstantSansExplicitValues_Constant1", @"");


  STAssertTrue(EnumWith1ConstantSansExplicitValues_Constant1 == a, @"");
  STAssertTrue( [@"EnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)], @"");
  STAssertTrue( EnumWith1ConstantSansExplicitValuesFromString(EnumWith1ConstantSansExplicitValuesToString(EnumWith1ConstantSansExplicitValues_Constant1), &a), @"");
  STAssertTrue(EnumWith1ConstantSansExplicitValues_Constant1 == a, @"");

  a++;
  STAssertTrue([@"<unknown EnumWith1ConstantSansExplicitValues: 1>" isEqualToString:EnumWith1ConstantSansExplicitValuesToString(a)], @"");
  STAssertTrue(!EnumWith1ConstantSansExplicitValuesFromString(@"foo", &a), @"");

}
- (void) splitEnumTests {

  STAssertTrue(SplitEnumWith1ConstantSansExplicitValues_Constant1 == b, @"");
  STAssertTrue([@"SplitEnumWith1ConstantSansExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(b)], @"");
  STAssertTrue(SplitEnumWith1ConstantSansExplicitValuesFromString(SplitEnumWith1ConstantSansExplicitValuesToString(SplitEnumWith1ConstantSansExplicitValues_Constant1), &b), @"");
  STAssertTrue(SplitEnumWith1ConstantSansExplicitValues_Constant1 == b, @"");
  b++;
  STAssertTrue([@"<unknown SplitEnumWith1ConstantSansExplicitValues: 1>" isEqualToString:SplitEnumWith1ConstantSansExplicitValuesToString(b)], @"");
  STAssertTrue(!SplitEnumWith1ConstantSansExplicitValuesFromString(@"foo", &b), @"");
}
- (void) testExplicit {

  STAssertTrue(SplitEnumWith1ConstantWithExplicitValues_Constant1 == c, @"");
  STAssertTrue([@"SplitEnumWith1ConstantWithExplicitValues_Constant1" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(c)], @"");
  STAssertTrue(SplitEnumWith1ConstantWithExplicitValuesFromString(SplitEnumWith1ConstantWithExplicitValuesToString(SplitEnumWith1ConstantWithExplicitValues_Constant1), &c), @"");
  STAssertTrue(SplitEnumWith1ConstantWithExplicitValues_Constant1 == c, @"");
  c++;
  STAssertTrue([@"<unknown SplitEnumWith1ConstantWithExplicitValues: 43>" isEqualToString:SplitEnumWith1ConstantWithExplicitValuesToString(c)], @"");;
  STAssertTrue(!SplitEnumWith1ConstantWithExplicitValuesFromString(@"foo", &c), @"");
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

  STAssertEquals( unset, AZUnset,                  @"uninitialized Alignments should be Unset!");
  STAssertEquals( unset,  (AZA)NO,                  @"aka NO");
  STAssertEquals( AZAlignByValue().count, (NSUI)15, @"Should be 12 positions");
  STAssertTrue  ( AZAlignTop | AZAlignLeft                                == AZAlignTopLeft,    @"Combining Bitmasks works");
  STAssertTrue  ( AZAlignTop | AZAlignLeft | AZAlignRight | AZAlignBottom == AZAlignCenter,     @"Allsides totals center");
  
//  AZAlignByValue().allKeys.nextObject
  STAssertFalse ( AZAlignOutside & (AZAlignTop|AZAlignLeft|AZAlignRight|AZAlignBottom),  @"No sides is outside  ");
  STAssertTrue  ( AZAlignTop&AZAlignCenter,   @"Align Cneter includes top");

}
//- (void) testDecoding { AZA zTop = AZTop;
//
//  STAssertTrue( AZAIsVertical ), <#description, ...#>
//
//}

@end
