//
//  main.m
//  SpiffyCLI
//
//  Created by Alex Gray on 10/15/12.
//
//

#import <Foundation/Foundation.h>
#import <SpiffyKit/SpiffyKit.h>

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
	    // insert code here...
	    NSLog(@"%@", [VageenFactory vageen]);
		NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];
	    
	}
    return 0;
}

