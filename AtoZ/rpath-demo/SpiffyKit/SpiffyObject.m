//
//  SpiffyObject.m
//  SpiffyKit
//
//  Created by Dave Dribin on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SpiffyObject.h"
#import "SpiffyKit.h"

@implementation SpiffyObject


+ (CALayer*) makeLayer;
{

//	NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
//	NSLog(@"%@",nanoStore );
	CALayer *poop = [[CALayer alloc]init];
	poop.backgroundColor = [[NSColor redColor]CGColor];
	return poop;
}

+ (void)doSomething;
{
	NSLog(@"SpiffyKit: doSomething");
}

@end
