
//  AZTalker.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.



#import "AZTalker.h"

@implementation AZTalker

//NSSpeechSynthesizer *talker;


//- (id)init
//{
//    self = [super init];
//    if (self) {
//
//	}
//    return self;
//}

- (void) setUp {

	self.talker = [NSSpeechSynthesizer new];
	self.talker.delegate = self;
//}
}

+(void)say:(NSString*)thing
{
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[thing]];
}

-(void) say:(NSString *)thing {

	[NSSpeechSynthesizer isAnyApplicationSpeaking] == NO
	? [_talker startSpeakingString:thing]
	: [[NSThread mainThread] performBlock:^{
		[self say:thing];
	} waitUntilDone:YES];// performSelector:@selector(say:) withObject:thing afterDelay:1];

}



@end
