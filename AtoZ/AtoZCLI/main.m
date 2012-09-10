//
//  main.m
//  AtoZCLI
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

void quantize() {
	[AZStopwatch start:@"quantize"];
	@autoreleasepool {
		[[NSImage systemImages] eachConcurrentlyWithBlock:^(NSInteger index, id objI, BOOL *stop) {
	   		[[[AZColor sharedInstance] colorsForImage:objI] each:^(id obj, NSUInteger index, BOOL *stop) {
				NSLog(@"Hello, World!  %@", [obj propertiesPlease]);
			}];
		}];
	}
	[AZStopwatch stop:@"quantize"];

}

const NSImage*paddy = [[NSImage alloc]initWithContentsOfFile:@"/Library/Desktop Pictures/Rice Paddy.jpg"];

int main(int argc, const char * argv[])
{

		[paddy quantize];
				//		[[AZColor sharedInstance] colorsForImage:[NSImage imageInFrameworkWithFileName:@"mrgray.logo.png"]]);
	
    return 0;
}

