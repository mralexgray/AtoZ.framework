
//  AZTalker.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.



#import "AZTalker.h"

@implementation AZTalker {

NSSpeechSynthesizer *talker;
}

- (id)init
{
    self = [super init];
    if (self) {
		
		talker = [[NSSpeechSynthesizer alloc]init];    
		[talker setDelegate:self];	
	}
    return self;
}

-(void) say:(NSString *)thing {
	
	[talker startSpeakingString:thing];
}

@end
