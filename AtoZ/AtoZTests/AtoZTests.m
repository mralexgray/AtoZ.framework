//
//  AtoZTests.m
//  AtoZTests
//
//  Created by Alex Gray on 6/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZTests.h"
#import <GHUnit/GHUnit.h>

@implementation AtoZTests

- (void)testStringFromClass
{
	STAssertEqualObjects([[[NSObject alloc] init] stringFromClass], @"NSObject", nil);

	// NSString deploys a class clustering architecture. The actual class is an
	// implementation-specific sub-class or compatible class, depending on what
	// kind of string, and presumably what version of Cocoa and on what platform
	// since the exact underlying class might change. Be prepared for test
	// breakage.
	STAssertEqualObjects([@"" stringFromClass], @"__NSCFConstantString", nil);

	// This is freaky. You would not expect this to work. But it does; classes
	// are also objects. Invoking an instance method on a class: it compiles and
	// runs! You would expect the compiler to baulk, but no.
	STAssertEqualObjects([NSObject stringFromClass], @"NSObject", nil);
}


- (void)setUp
{
    [super setUp];
    

//	id a,b,c,d;
//	a = [AtoZ sharedInstance];
//	b = [AtoZ instanceWithObject:self];
//	c = [AtoZ instance];
//	d = (AtoZ*)a;
//	
////	NSLog(@"%d=%d=%d", a=[AtoZ sharedInstance], [AtoZ sharedInstance], [AtoZ instanceWithObject:self]  );
//	NSLog(@"%d=%d=%d", b=[NSAlpha sharedInstance],     [NSAlpha instance],     [NSAlpha instance]);
////	NSLog(@"%d=%d=%d", c=[NSBravo instance],     [NSBravo sharedInstance],     [NSBravo sharedInstance]);
////	NSLog(@"%d=%d=%d", d=[NSCharlie instance],   [NSCharlie instanceWithObject:@"wghay6e"],   [NSCharlie sharedInstance]);
//	NSLog(@"%d != %d != %d != %d", a, b, c, d);
//
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in AtoZTests");
}
@end
//
//-(void) testColorConversion {
//
//sta
//}
@implementation NSAlpha
@end
@implementation NSBravo
@end
@implementation NSCharlie
@end



