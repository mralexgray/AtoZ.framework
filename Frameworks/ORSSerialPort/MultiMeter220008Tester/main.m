//
//  main.m
//  MultiMeter220008Tester
//
//  Created by Alex Gray on 3/13/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

@import AppKit;

#import <ORSSerial/ORSSerial.h>
static MM2200087 *_m;
static USBWatcher *_u;

int main(int argc, const char * argv[]) {
	@autoreleasepool {

	[SERIALPORTS log];

//	_u = [USBWatcher.alloc onRemove];


	[_u = USBWatcher.new observeProperty:@"arrangedObjects" withBlock:^(id self, id oldValue, id newValue) {

			NSLog(@"new val:%@", newValue);
	}];

//	[_u startHIDNotification];
//	_m = [MM2200087.alloc initOnPort:SERIALPORTS[0] onChange: ^(id<MultiMeter> thing){
//
//		id x = [thing display][kLCD];
//
//		NSLog(@"%@", x);
////		[_guage stringByEvaluatingJavaScriptFromString:
////			[NSString stringWithFormat:@"gauge.setValue(%f);",[x floatValue]]];
//
//	}];
	dispatch_main();

	}
    return 0;
}
