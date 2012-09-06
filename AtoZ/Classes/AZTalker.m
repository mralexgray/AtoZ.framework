
//  AZTalker.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.



#import "AZTalker.h"

@implementation AZTalker

//NSSpeechSynthesizer *talker;


- (id)init
{
    self = [super init];
    if (self) {
		


//- (void) setUp {

	self.talker = [[NSSpeechSynthesizer alloc]init];
	self.talker.delegate = self;
//}
	}
    return self;
}


-(void) say:(NSString *)thing {

	if ( [NSSpeechSynthesizer isAnyApplicationSpeaking] == NO){
		[self.talker startSpeakingString:thing];
	} else {

		[self performSelector:@selector(say:) withObject:thing afterDelay:1];
	}
}



@end
