//
//  main.m
//  AtoZCLI
//
//  Created by Alex Gray on 7/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>


@interface AtoZCLI : NSObject
@end

@implementation AtoZCLI
- (void) testMethods {
//	NSLog(@"%@", [NSColor fengshui]);
//	NSArray *h = [AtoZ dock];
//	[AZStopwatch stop:@"b"];
//	NSLog(@"They are the same %i", ([[AtoZ dock] isEqual: [AtoZ sharedInstance].dock]));
}

- (void) enumerateDockColors {
	[[[AtoZ dockSorted] valueForKeyPath:@"color"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSColor *c = obj;
		NSLog(@"Color:%@     \t \t Hue: %f\t  Sat: %f\t Lum: %f\t  Brt: %f", 
			  c.nameOfColor,
			  c.hueComponent, 
			  c.saturationComponent, 
			  c.luminance, 
			  c.brightnessComponent);
	}];
}

- (void) sizer {

	AZSizer *r = [AZSizer forQuantity:12 inRect:NSMakeRect(0,0,24,24)];
	NSLog   (@"%@", r.propertiesPlease);
}

- (void) listAppsPrivately {

	NSLog(@"%@", [AZApplePrivate registeredApps]);
}
@end


int main(int argc, const char * argv[])
{

	@autoreleasepool {

		AtoZCLI *c = [AtoZCLI new];
		NSArray *a = [[NSNumber numberWithInt:9] to:[NSNumber numberWithInt: 33]];
		NSLog(@"%@", a);

//		[c sizer];
//		[c listAppsPrivately];	
//		AZSimpleView *u = [[AZSimpleView alloc]initWithFrame:NSZeroRect];
	}
    return 0;
}

