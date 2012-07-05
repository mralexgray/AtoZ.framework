//
//  main.m
//  AtoZCLI
//
//  Created by Alex Gray on 7/5/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
		NSLog(@"%@", [[AtoZ sharedInstance].dock.randomElement propertiesPlease]);
		//	AZFile *f = [AZFile instanceWithPath:@"/Applications/Safari.app"];
		//	NSLog(@"%@", f);
	    
	}
    return 0;
}

