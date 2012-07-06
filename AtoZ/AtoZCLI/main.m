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

	NSLog(@"%@", [NSColor fengshui]);
	
	NSArray *h = [AtoZ dock];
//	[AZStopwatch stop:@"b"];
//	NSLog(@"They are the same %i", ([[AtoZ dock] isEqual: [AtoZ sharedInstance].dock]));
}
@end


int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
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
    return 0;
}

